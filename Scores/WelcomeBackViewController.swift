//
//  WelcomeBackViewController.swift
//  Scores
//
//  Created by Rastaar Haghi on 9/6/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit
import LBConfettiView

class WelcomeBackViewController: UIViewController {

    var username: String?
    var favoriteTeam: String?
    
    var welcomeLabel: UILabel!
    var teamIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel = UILabel(frame: CGRect(x: 100, y: 25, width: UIScreen.main.bounds.width - 200, height: 200))
        welcomeLabel.text = "Welcome back, \(username!)"
        welcomeLabel.textAlignment = .center
        welcomeLabel.numberOfLines = 0
        welcomeLabel.font = UIFont.regularFont(size: 36)
        welcomeLabel.textColor = .white
        teamIcon = UIImageView()
        view.addSubview(welcomeLabel)
        
        if let teamColors = teamColors[favoriteTeam!] {
            view.backgroundColor = UIColor(hex: teamColors[0])
            teamIcon = UIImageView(image: UIImage(named: "AssetBundle.bundle/" + favoriteTeam! + ".png"))
            teamIcon.frame = CGRect(x: UIScreen.main.bounds.midX - 150, y: 200, width: 300, height: 300)
            view.addSubview(teamIcon)
            
            let confettiView = ConfettiView(frame: self.view.bounds)
            self.view.addSubview(confettiView)
            confettiView.start()
            
        }
        // Do any additional setup after loading the view.
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
