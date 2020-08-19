//
//  MatchCell.swift
//  Scores
//
//  Created by Rastaar Haghi on 8/3/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class MatchCell: UITableViewCell {

    var team1ImageView = UIImageView()
    var team1TitleLabel = UILabel()
    var team1Score = UILabel()

    var team2ImageView = UIImageView()
    var team2TitleLabel = UILabel()
    var team2Score = UILabel()
    
    var dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(team1ImageView)
        addSubview(team2ImageView)
        
        addSubview(team1TitleLabel)
        addSubview(team2TitleLabel)
        
        addSubview(team1Score)
        addSubview(team2Score)
        addSubview(dateLabel)
        
        // configure images
        configureImageView(imageView: team1ImageView)
        configureImageView(imageView: team2ImageView)
        
        // configure labels
        configureTitleLabel(label: team1TitleLabel)
        configureTitleLabel(label: team2TitleLabel)
        configureTitleLabel(label: team1Score)
        configureTitleLabel(label: team2Score)
        configureTitleLabel(label: dateLabel)

        setTitleLabelConstraints()
        setImageConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(matchInfo: JSON) {
        team1ImageView.image = UIImage(named: "AssetBundle.bundle/" + matchInfo["team2"]["teamName"].stringValue + ".png")
        team1TitleLabel.text = matchInfo["team2"]["teamName"].stringValue
        if matchInfo["team2"]["teamName"].stringValue == "Wolverhampton Wanderers" {
            team1TitleLabel.text = "Wolves"
        }
        team1TitleLabel.font = UIFont.regularFont(size: 16)
        
        team2ImageView.image = UIImage(named: "AssetBundle.bundle/" + matchInfo["team1"]["teamName"].stringValue + ".png")
        team2TitleLabel.text = matchInfo["team1"]["teamName"].stringValue
        if matchInfo["team1"]["teamName"].stringValue == "Wolverhampton Wanderers" {
            team2TitleLabel.text = "Wolves"
        }
        team2TitleLabel.font = UIFont.regularFont(size: 16)

        team1Score.text = matchInfo["team2"]["teamScore"].stringValue
        team2Score.text = matchInfo["team1"]["teamScore"].stringValue

        team1Score.font = UIFont.regularFont(size: 24)
        team2Score.font = UIFont.regularFont(size: 24)
        
        // example data string: "Saturday, Nov 30 2019 12:30"
        let dateData = matchInfo["when"].stringValue
        let dateWords = dateData.split(separator: " ")
        
        var dateString = ""
        for word in dateWords {
            dateString += (word + " ")
        }
        dateLabel.text = dateString
        dateLabel.font = UIFont.regularFont(size: 10)
    }
    
    func configureImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
    }
    
    func configureTitleLabel(label: UILabel) {
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
    }
    
    func setImageConstraints() {
        team1ImageView.translatesAutoresizingMaskIntoConstraints = false
        team1ImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        team1ImageView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -55).isActive = true
        team1ImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        team1ImageView.widthAnchor.constraint(equalTo: team1ImageView.heightAnchor, multiplier: 1).isActive = true
        
        team2ImageView.translatesAutoresizingMaskIntoConstraints = false
        team2ImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        team2ImageView.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 55).isActive = true
        team2ImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        team2ImageView.widthAnchor.constraint(equalTo: team2ImageView.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setTitleLabelConstraints() {
        team1TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        team1TitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        team1TitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        team1TitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        team1TitleLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - 120).isActive = true
        
        team2TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        team2TitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        team2TitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        team2TitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        team2TitleLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 2) - 120).isActive = true
        
        team1Score.translatesAutoresizingMaskIntoConstraints = false
        team1Score.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        team1Score.heightAnchor.constraint(equalToConstant: 50).isActive = true
        team1Score.widthAnchor.constraint(equalToConstant: 50).isActive = true
        team1Score.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -5).isActive = true
        
        team2Score.translatesAutoresizingMaskIntoConstraints = false
        team2Score.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        team2Score.heightAnchor.constraint(equalToConstant: 50).isActive = true
        team2Score.widthAnchor.constraint(equalToConstant: 50).isActive = true
        team2Score.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 5).isActive = true
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leadingAnchor.constraint(equalTo: team1TitleLabel.leadingAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    
}
