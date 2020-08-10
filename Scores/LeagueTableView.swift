//
//  VideoListViewController.swift
//  Scores
//
//  Created by Rastaar Haghi on 7/31/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit
import SwiftyJSON

class LeagueTableView: UIViewController {

    var tableView = UITableView()
    var teamRecords: [TeamRecord] = []
    
    struct Cells {
        static let teamCell = "TeamCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Premier League Table"
        configureTableView()
        teamRecords = fetchTeamData()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.register(TeamCell.self, forCellReuseIdentifier: Cells.teamCell)
        tableView.pin(to: view)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension LeagueTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.teamCell) as! TeamCell
        let team = teamRecords[indexPath.row]
        cell.set(teamInfo: team)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = TeamDetailViewController()
        detailViewController.teamInfo = teamRecords[indexPath.row]
        detailViewController.title = teamRecords[indexPath.row].team
        show(detailViewController, sender: self)
    }
    
}

extension LeagueTableView {
    func fetchTeamData() -> [TeamRecord] {
        let headers = [
            "x-rapidapi-host": "heisenbug-premier-league-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "2a743ed42dmshab0f2395283c970p139087jsn76d4a045b547"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://heisenbug-premier-league-live-scores-v1.p.rapidapi.com/api/premierleague/table")! as URL,
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
                        if let teams = jsonData["records"].array {
                            for team in teams {
                                let teamRecord = TeamRecord(team: team["team"].string!, played: team["played"].int!, win: team["win"].int!, draw: team["draw"].int!, loss: team["loss"].int!, goalsFor: team["goalsFor"].int!, goalsAgainst: team["goalsAgainst"].int!, points: team["points"].int!)
                                self.teamRecords.append(teamRecord)
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print("Caught an exception")
                    }
                }
            }
        })

        dataTask.resume()
        return teamRecords
    }
}

extension UIFont {
    class func regularFont( size:CGFloat ) -> UIFont{
        return  UIFont(name: "D-DIN", size: size)!
    }
}
