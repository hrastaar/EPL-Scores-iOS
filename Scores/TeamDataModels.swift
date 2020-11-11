//
//  TeamDataModels.swift
//  Scores
//
//  Created by Rastaar Haghi on 7/31/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit
import CoreData

struct BasicTeamInfo {
    let teamCrest: UIImage
    let teamName: String
}

struct TeamData: Codable {
    let team: String
    let played: Int
    let win: Int
    let draw: Int
    let loss: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let points: Int
    
    enum CodingKeys: String, CodingKey {
        case team = "team"
        case played = "played"
        case win = "win"
        case draw = "draw"
        case loss = "loss"
        case goalsFor = "goalsFor"
        case goalsAgainst = "goalsAgainst"
        case points = "points"
    }
}

let teamColors: [String : [String]] = [
    "Bournemouth" : ["E62333", "000000"],
    "Arsenal" : ["EF2D56", "023474", "9C824A"],
    "Brighton" : ["0055a9", "F8BC1B"],
    "Burnley" : ["8CCCE5", "53162F", "F9EC34"],
    "Chelsea" : ["034694", "DBA111", "ED1C24"],
    "Crystal Palace" : ["1B458F", "C4122E", "A7A5A6"],
    "Everton" : ["274488"],
    "Huddersfield Town" : ["0073d2"],
    "Leicester" : ["034694", "0053A0"],
    "Liverpool" : ["00A398", "D00027", "FEF667"],
    "Manchester City" : ["98c5e9", "00285e", "f4bc46"],
    "Manchester United" : ["EF2D56", "FFE500", "000000"],
    "Newcastle United" : ["241f20", "00B8F4", "c3a572"],
    "Southampton" : ["ED1A3B", "211E1F", "FFC20E"],
    "Stoke City" : ["E03A3E", "1B449C"],
    "Swansea City" : ["E03A3E", "1B449C"],
    "Tottenham" : ["001C58"],
    "Watford" : ["FFB86F", "ED2127", "000000"],
    "West Bromwich Albion" : ["091453"],
    "West Ham" : ["60223B", "F7C240", "5299C6"],
    "Wolverhampton Wanderers" : ["2A2B2E"],
    "Aston Villa" : ["AB2346"],
    "Norwich" : ["0CF574"],
    "Sheffield United" : ["EF2D56"],
    "Leeds" : ["034694"],
    "Fulham" : ["EF2D56"]
]

let teamNames = ["Bournemouth", "Arsenal", "Brighton", "Burnley", "Chelsea", "Crystal Palace",
             "Everton", "Huddersfield Town", "Leicester", "Liverpool", "Manchester City",
             "Manchester United", "Newcastle United", "Southampton", "Stoke City", "Swansea City",
             "Tottenham", "Watford", "West Bromwich Albion", "West Ham", "Wolverhampton Wanderers",
    "Aston Villa", "Norwich", "Sheffield United", "Fulham", "Leeds"].sorted()

// Helper functions to gather Core Data elements
func fetchUsername() -> String? {
    guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            return nil
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
    do {
        let savedInfo = try managedContext.fetch(fetchRequest)
        if savedInfo.count > 0 {
            let currentUser: NSManagedObject = savedInfo[savedInfo.count - 1]
            return currentUser.value(forKey: "username") as? String
        }
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
}

func fetchPreferredTeam() -> String? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "User")
    do {
        let savedInfo = try managedContext.fetch(fetchRequest)
        if savedInfo.count > 0 {
            let currentUser: NSManagedObject = savedInfo[savedInfo.count - 1]
            return currentUser.value(forKey: "favoriteTeam") as? String
        }
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    return nil
}
