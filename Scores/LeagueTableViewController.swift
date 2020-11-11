//
//  LeagueTableViewController.swift
//  Scores
//
//  Created by Rastaar Haghi on 7/31/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class LeagueTableViewController: UIViewController {

    var tableView = UITableView()
    var teamRecords: [TeamData] = []
    let currentSeason = "20-21"
    
    var username: String?
    var preferredClub: String?
    
    override func viewDidAppear(_ animated: Bool) {
        // present the appropriate tab bar when this view is on top
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username = fetchUsername()
        self.preferredClub = fetchPreferredTeam()
        
        self.title = "League Table"
        configureTableView()
        
        teamRecords = fetchTeamData()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.register(TeamCell.self, forCellReuseIdentifier: "TeamCell")
        tableView.pin(to: view)
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension LeagueTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell") as! TeamCell
        let team = teamRecords[indexPath.row]
        cell.set(teamInfo: team, position: indexPath.row + 1)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamMatchBarItem = UITabBarItem()
        teamMatchBarItem.title = "Scores"
        
        // Match View Controller
        let teamMatchesVC = TeamMatchesViewController()
        teamMatchesVC.season = self.currentSeason
        teamMatchesVC.teamInfo = teamRecords[indexPath.row]
        teamMatchesVC.title = teamRecords[indexPath.row].team
        teamMatchesVC.tabBarItem = teamMatchBarItem
        
        // News View Controller
        let teamNewsBarItem = UITabBarItem()
        teamNewsBarItem.title = "News"
        
        let teamNewsVC = TeamNewsViewController()
        teamNewsVC.teamInfo = teamRecords[indexPath.row]
        teamNewsVC.title = teamRecords[indexPath.row].team
        teamNewsVC.tabBarItem = teamNewsBarItem
        
        // Chat View Controller
        let chatBarItem = UITabBarItem()
        chatBarItem.title = "Chat"
        
        let teamChatVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatroomViewController") as! ChatViewController
        teamChatVC.teamInfo = teamRecords[indexPath.row]
        teamChatVC.title = teamRecords[indexPath.row].team
        teamChatVC.tabBarItem = chatBarItem
        
        let teamTabBarViewController = UITabBarController()
        teamTabBarViewController.viewControllers = [teamMatchesVC, teamNewsVC, teamChatVC]
        
        self.tabBarController?.tabBar.isHidden = true
        show(teamTabBarViewController, sender: self)
    }
    
}

extension LeagueTableViewController {
    func fetchTeamData() -> [TeamData] {
        let urlString = "http://hrastaar.com/api/premierleague/" + self.currentSeason + "/standings"
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
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
                                let teamRecord = TeamData(team: team["team"].string!, played: team["played"].int!, win: team["win"].int!, draw: team["draw"].int!, loss: team["loss"].int!, goalsFor: team["goalsFor"].int!, goalsAgainst: team["goalsAgainst"].int!, points: team["points"].int!)
                                self.teamRecords.append(teamRecord)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
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
        return teamRecords
    }
}

