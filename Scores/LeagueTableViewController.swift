//
//  VideoListViewController.swift
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
    var teamRecords: [TeamRecord] = []
    
    struct Cells {
        static let teamCell = "TeamCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "User")
        //3
        do {
            let savedInfo = try managedContext.fetch(fetchRequest)
            let currentUser: NSManagedObject = savedInfo[savedInfo.count - 1]
            let welcomeViewController = WelcomeBackViewController()
            welcomeViewController.username = currentUser.value(forKey: "username") as? String
            welcomeViewController.favoriteTeam = currentUser.value(forKey: "favoriteTeam") as? String
            present(welcomeViewController, animated: true, completion: nil)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
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

extension LeagueTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.teamCell) as! TeamCell
        let team = teamRecords[indexPath.row]
        cell.set(teamInfo: team, position: indexPath.row + 1)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teamMatchBarItem = UITabBarItem()
        teamMatchBarItem.title = "Scores"
        
        let teamMatchesVC = TeamMatchesViewController()
        teamMatchesVC.teamInfo = teamRecords[indexPath.row]
        teamMatchesVC.title = teamRecords[indexPath.row].team
        teamMatchesVC.tabBarItem = teamMatchBarItem
        
        let teamNewsBarItem = UITabBarItem()
        teamNewsBarItem.title = "News"
        
        let teamNewsVC = TeamNewsViewController()
        teamNewsVC.teamInfo = teamRecords[indexPath.row]
        teamNewsVC.title = teamRecords[indexPath.row].team
        teamNewsVC.tabBarItem = teamNewsBarItem
        
        let userBarItem = UITabBarItem()
        userBarItem.title = "Update Profile"

        let createUserVC = CreateUserViewController()
        createUserVC.tabBarItem = userBarItem
        
        let teamTabBarViewController = UITabBarController()
        teamTabBarViewController.viewControllers = [teamMatchesVC, teamNewsVC, createUserVC]
        
        
        show(teamTabBarViewController, sender: self)
    }
    
}

extension LeagueTableViewController {
    func fetchTeamData() -> [TeamRecord] {
        let request = NSMutableURLRequest(url: NSURL(string: "http://hrastaar.com/api/premierleague/19-20/standings")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
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
                                let teamRecord = TeamRecord(team: team["team"].string!, played: team["played"].int!, win: team["win"].int!, draw: team["draw"].int!, loss: team["loss"].int!, goalsFor: team["goalsFor"].int!, goalsAgainst: team["goalsAgainst"].int!, points: team["points"].int!)
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

extension UIFont {
    class func regularFont( size:CGFloat ) -> UIFont{
        return  UIFont(name: "D-DIN", size: size)!
    }
}
