//
//  TeamDetailViewController.swift
//  Scores
//
//  Created by Rastaar Haghi on 8/1/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit
import Hex
import SwiftyJSON

class TeamMatchesViewController: UIViewController {
    
    var teamInfo: TeamRecord?
    var tableView = UITableView()
    var teamMatches: [JSON] = []
    var newsArticles: [News] = []
    var pickerData: [String] = ["Matches Played", "Team News"]
    var seasonMatchData: [MatchData] = []
    
    struct Cells {
        static let matchCell = "MatchCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = teamInfo!.team
        self.parent?.title = teamInfo!.team
        if teamInfo!.team == "Wolverhampton Wanderers" {
            self.navigationItem.title = "Wolves"
        }
        self.navigationController?.navigationBar.largeContentTitle = teamInfo!.team
        if let currTeamColor = teamColors[teamInfo!.team] {
            view.tintColor = UIColor(hex: currTeamColor[0])
            tableView.separatorColor = UIColor(hex: currTeamColor[0])
            navigationController?.navigationBar.tintColor = UIColor(hex: currTeamColor[0])
        } else {
            view.tintColor = UIColor(hex: "2A2B2E")
            tableView.separatorColor = UIColor(hex: "2A2B2E")
            navigationController?.navigationBar.tintColor = UIColor(hex: "2A2B2E")
        }
        self.configureTableView()
        gatherSeasonMatches(teamName: teamInfo!.team)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.register(MatchCell.self, forCellReuseIdentifier: Cells.matchCell)
        tableView.pin(to: view)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension TeamMatchesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.matchCell) as! MatchCell
        let match = teamMatches[indexPath.row]
        cell.set(matchInfo: match)
        cell.currTeam = teamInfo!.team
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let matchDetailsViewController = MatchDetailsViewController()
//        matchDetailsViewController.basicMatchInfo = teamMatches[indexPath.row]
//        matchDetailsViewController.updateUI()
//        show(matchDetailsViewController, sender: self)
//    }
    
}

extension TeamMatchesViewController {
    
    func gatherSeasonMatches(teamName: String) {
        print("Looking for match data for \(teamName)")
        seasonMatchData.removeAll()
        for i in stride(from: 38, to: 0, by: -1) {
            gatherWeekMatches(weekNumber: i, teamName: teamName)
        }
    }
    
    func gatherWeekMatches(weekNumber: Int, teamName: String) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://hrastaar.com/api/premierleague/19-20/week/\(weekNumber)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                if let data = data {
                    do {
                        let jsonData = try JSON(data: data)
                        if let matches = jsonData["matches"].array {
                            for match in matches {
                                if(match["team1"]["teamName"].stringValue == teamName || match["team2"]["teamName"].stringValue == teamName) {
                                    self.teamMatches.append(match)
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                    break;
                                }
                            }
                        }
                    } catch {
                        print("Caught an exception")
                    }
                }
            }
        })
        dataTask.resume()
    }
    
}

extension UIToolbar {
    func setBackgroundColor(image: UIImage) {
        setBackgroundImage(image, forToolbarPosition: .any, barMetrics: .default)
    }
}
