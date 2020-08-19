//
//  MatchDetailsViewController.swift
//  Scores
//
//  Created by Rastaar Haghi on 8/9/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit
import SwiftyJSON
import PieCharts

class MatchDetailsViewController: UIViewController {
    
    var basicMatchInfo: JSON?
    var team1: String?
    var team2: String?
    var team1MatchData: MatchData?
    var team2MatchData: MatchData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateUI() {
        team1 = basicMatchInfo!["team1"]["teamName"].stringValue
        team2 = basicMatchInfo!["team2"]["teamName"].stringValue
        self.navigationItem.title = team2! + " @ " + team1!
        self.navigationController?.navigationBar.largeContentTitle = team2! + " @ " + team1!
        gatherMatchDetails(team1: team1!, team2: team2!)
    }
}

extension MatchDetailsViewController {
    func gatherMatchDetails(team1: String, team2: String) {
        let headers = [
            "x-rapidapi-host": "heisenbug-premier-league-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": ""
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://heisenbug-premier-league-live-scores-v1.p.rapidapi.com/api/premierleague/match/stats?team1=" + (team1.replacingOccurrences(of: " ", with: "%20")) + "&team2=" + (team2.replacingOccurrences(of: " ", with: "%20")) )! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                print("Successfully made API call")
                if let data = data {
                    do {
                        let jsonData = try JSON(data: data)
                        var teamData = jsonData["team1"]
                        var teamName = teamData["teamName"].stringValue
                        var corners = teamData["teamStats"]["cornersTotal"].numberValue.intValue
                        var fouls = teamData["teamStats"]["foulsCommitted"].numberValue.intValue
                        var tackles = teamData["teamStats"]["tackleSuccessful"].numberValue.intValue
                        var passes = teamData["teamStats"]["passesTotal"].numberValue.intValue
                        var offsides = teamData["teamStats"]["offsidesCaught"].numberValue.intValue
                        var shotsOnTarget = teamData["teamStats"]["shotsOnTarget"].numberValue.intValue
                        var shotsOffTarget = teamData["teamStats"]["shotsOffTarget"].numberValue.intValue
                        var touches = teamData["teamStats"]["touches"].numberValue.intValue
                        
                        self.team1MatchData = MatchData(teamName: teamName, cornersTotal: corners, fouls: fouls, tackles: tackles, passes: passes, offsides: offsides, shotsOnTarget: shotsOnTarget, shotsTotal: shotsOnTarget+shotsOffTarget, touches: touches)
                        
                        teamData = jsonData["team2"]
                        teamName = teamData["teamName"].stringValue
                        corners = teamData["teamStats"]["cornersTotal"].numberValue.intValue
                        fouls = teamData["teamStats"]["foulsCommitted"].numberValue.intValue
                        tackles = teamData["teamStats"]["tackleSuccessful"].numberValue.intValue
                        passes = teamData["teamStats"]["passesTotal"].numberValue.intValue
                        offsides = teamData["teamStats"]["offsidesCaught"].numberValue.intValue
                        shotsOnTarget = teamData["teamStats"]["shotsOnTarget"].numberValue.intValue
                        shotsOffTarget = teamData["teamStats"]["shotsOffTarget"].numberValue.intValue
                        touches = teamData["teamStats"]["touches"].numberValue.intValue
                        
                        self.team2MatchData = MatchData(teamName: teamName, cornersTotal: corners, fouls: fouls, tackles: tackles, passes: passes, offsides: offsides, shotsOnTarget: shotsOnTarget, shotsTotal: shotsOnTarget+shotsOffTarget, touches: touches)
                        
                        print(self.team1MatchData!)
                        print(self.team2MatchData!)
                        self.createGraphics()
                    } catch {
                        print("Caught an exception")
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func createGraphics() {
        DispatchQueue.main.async {
            var graph = PieChart()
            graph.models = self.createModel(team1Stat: self.team1MatchData!.cornersTotal, team2Stat: self.team2MatchData!.cornersTotal)
            self.view.addSubview(graph)
        }
    }
    
    func createModel(team1Stat: Int, team2Stat: Int) -> [PieSliceModel] {
        let alpha: CGFloat = 0.9
        return [
            PieSliceModel(value: Double(team1Stat), color: UIColor(hex: teamColors[team1!]![0]).withAlphaComponent(alpha)),
            PieSliceModel(value: Double(team2Stat), color: UIColor(hex: teamColors[team2!]![0]).withAlphaComponent(alpha))
        ]
    }
    
    
}
