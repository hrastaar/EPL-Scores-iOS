//
//  SeasonMatchData.swift
//  Scores
//
//  Created by Rastaar Haghi on 8/2/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import Foundation
import SwiftyJSON

var seasonMatchData: [JSON] = []

func gatherSeasonMatches(teamName: String) {
    print("Looking for match data for \(teamName)")
    seasonMatchData.removeAll()
    for i in 1...38 {
        gatherWeekMatches(weekNumber: i, teamName: teamName)
    }
}

func gatherWeekMatches(weekNumber: Int, teamName: String) {
    let headers = [
        "x-rapidapi-host": "heisenbug-premier-league-live-scores-v1.p.rapidapi.com",
        "x-rapidapi-key": "2a743ed42dmshab0f2395283c970p139087jsn76d4a045b547"
    ]

    let request = NSMutableURLRequest(url: NSURL(string: "https://heisenbug-premier-league-live-scores-v1.p.rapidapi.com/api/premierleague?matchday=\(weekNumber)")! as URL,
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
                    if let matches = jsonData["matches"].array {
                        for match in matches {
                            if(match["team1"]["teamName"].stringValue == teamName || match["team2"]["teamName"].stringValue == teamName) {
                                print("Found \(teamName) match: \(match)")
                                seasonMatchData.append(match)
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
