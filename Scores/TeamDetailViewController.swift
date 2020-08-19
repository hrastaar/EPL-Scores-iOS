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
import SafariServices

enum PageStatus {
    case TEAM_NEWS
    case TEAM_MATCHES
}

class TeamDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    
    var teamInfo: TeamRecord?
    var tableView = UITableView()
    var teamMatches: [JSON] = []
    var newsArticles: [News] = []
    var pickerData: [String] = ["Matches Played", "Team News"]
    var currentView: PageStatus = .TEAM_MATCHES
    var seasonMatchData: [MatchData] = []
    
    struct Cells {
        static let matchCell = "MatchCell"
        static let newsCell = "NewsCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = teamInfo!.team
        if teamInfo!.team == "Wolverhampton Wanderers" {
            self.navigationItem.title = "Wolves"
        }
        self.navigationController!.navigationBar.largeContentTitle = teamInfo!.team
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
        // gatherTeamNews(teamName: teamInfo!.team)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        if currentView == .TEAM_MATCHES {
            tableView.rowHeight = 100
            tableView.register(MatchCell.self, forCellReuseIdentifier: Cells.matchCell)
        } else {
            tableView.rowHeight = 125
            tableView.register(NewsCell.self, forCellReuseIdentifier: Cells.newsCell)
        }
        
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

extension TeamDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentView == .TEAM_MATCHES {
            return teamMatches.count
        } else {
            return newsArticles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentView == .TEAM_MATCHES {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.matchCell) as! MatchCell
            let match = teamMatches[indexPath.row]
            cell.set(matchInfo: match)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.newsCell) as! NewsCell
            let article = newsArticles[indexPath.row]
            cell.set(newsArticle: article)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentView == .TEAM_MATCHES {
            let matchDetailsViewController = MatchDetailsViewController()
            matchDetailsViewController.basicMatchInfo = teamMatches[indexPath.row]
            matchDetailsViewController.updateUI()
            show(matchDetailsViewController, sender: self)
        } else {
            if let url = URL(string: newsArticles[indexPath.row].articleURL) {
                let vc = SFSafariViewController(url: url)
                vc.delegate = self
                self.present(vc, animated: true)
            }
        }
    }
    
}

extension TeamDetailViewController {
    
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
        print(request)
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
    
    func gatherTeamNews(teamName: String) {
        let API_KEY = "0472e96928694078ad0d3c39a540341f"
        let newsURL =  "http://newsapi.org/v2/everything?q=\(teamName.replacingOccurrences(of: " ", with: "%20"))%20english&from=2020-07-18&sortBy=publishedAt&apiKey=" + API_KEY
        print(newsURL)
        let url = URL(string: newsURL)
        let request = NSMutableURLRequest(url: url!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                if let data = data {
                    do {
                        let jsonData = try JSON(data: data)
                        print(jsonData)
                        if jsonData["status"].stringValue == "ok" {
                            print("Status for news api was successfull")
                            if let articles = jsonData["articles"].array {
                                for article in articles {
                                    var dateInfo = article["publishedAt"].stringValue
                                    dateInfo = String(dateInfo.split(separator: "T")[0])
                                    let newsObject = News(date: dateInfo, source: article["source"]["name"].stringValue, imageURL: article["urlToImage"].stringValue, title: article["title"].stringValue, articleURL: article["url"].stringValue)
                                    self.newsArticles.append(newsObject)
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Caught an exception")
                    }
                    semaphore.signal()
                }
            }
        })
        dataTask.resume()
        _ = semaphore.wait(timeout: .distantFuture)
    }
}

extension UIToolbar {
    func setBackgroundColor(image: UIImage) {
        setBackgroundImage(image, forToolbarPosition: .any, barMetrics: .default)
    }
}
