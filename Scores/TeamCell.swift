//
//  TeamCell.swift
//  Scores
//
//  Created by Rastaar Haghi on 7/31/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {

    var teamImageView = UIImageView()
    var teamTitleLabel = UILabel()
    var teamPointsLabel = UILabel()
    var teamRankLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(teamImageView)
        addSubview(teamTitleLabel)
        addSubview(teamPointsLabel)
        addSubview(teamRankLabel)
        configureImageView()
        configureTitleLabel()
        setImageConstraints()
        setTitleLabelConstraints()
        setPointsLabelConstraints()
        setTeamRankLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(teamInfo: TeamData, position: Int) {
        teamImageView.image = UIImage(named: "AssetBundle.bundle/" + teamInfo.team + ".png")
        if teamInfo.team == "Wolverhampton Wanderers" {
            teamTitleLabel.text = "Wolves"
        } else {
            teamTitleLabel.text = teamInfo.team
        }
        teamPointsLabel.text = String(teamInfo.points)
        teamRankLabel.text = String(position)
    }
    
    func set(opponent: String) {
        teamTitleLabel.text = opponent
    }
    
    func configureImageView() {
        teamImageView.layer.cornerRadius = 10
        teamImageView.clipsToBounds = true
    }
    
    func configureTitleLabel() {
        teamTitleLabel.numberOfLines = 0
        teamTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints() {
        teamImageView.translatesAutoresizingMaskIntoConstraints = false
        teamImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        teamImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        teamImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        teamImageView.widthAnchor.constraint(equalTo: teamImageView.heightAnchor, multiplier: 1).isActive = true
        teamImageView.contentMode = .scaleAspectFit
    }
    
    func setTitleLabelConstraints() {
        teamTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        teamTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        teamTitleLabel.leadingAnchor.constraint(equalTo: teamImageView.trailingAnchor, constant: 20).isActive = true
        teamTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        teamTitleLabel.font = UIFont.regularFont(size: 20)
    }
    
    func setPointsLabelConstraints() {
        teamPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        teamPointsLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        teamPointsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        teamPointsLabel.font = UIFont.regularFont(size: 24)
    }
    
    func setTeamRankLabelConstraints() {
        teamRankLabel.translatesAutoresizingMaskIntoConstraints = false
        teamRankLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6).isActive = true
        teamRankLabel.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
        teamRankLabel.font = UIFont.regularFont(size: 20)
    }
}

class ToggleCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let runkeeperSwitch = DGRunkeeperSwitch(titles: ["2019-2020", "2020-2021"])
        runkeeperSwitch.backgroundColor = UIColor(red: 229.0/255.0, green: 163.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        runkeeperSwitch.selectedBackgroundColor = .white
        runkeeperSwitch.titleColor = .white
        runkeeperSwitch.selectedTitleColor = UIColor(red: 255.0/255.0, green: 196.0/255.0, blue: 92.0/255.0, alpha: 1.0)
        runkeeperSwitch.titleFont = UIFont(name: "HelveticaNeue-Medium", size: 13.0)
        runkeeperSwitch.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
        self.addSubview(runkeeperSwitch)
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIFont {
    class func regularFont( size:CGFloat ) -> UIFont{
        return  UIFont(name: "D-DIN", size: size)!
    }
}
