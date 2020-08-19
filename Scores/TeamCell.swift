//
//  TeamCell.swift
//  Scores
//
//  Created by Rastaar Haghi on 7/31/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit
import SkeletonView

class TeamCell: UITableViewCell {

    var teamImageView = UIImageView()
    var teamTitleLabel = UILabel()
    var teamPointsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(teamImageView)
        addSubview(teamTitleLabel)
        addSubview(teamPointsLabel)
        configureImageView()
        configureTitleLabel()
        setImageConstraints()
        setTitleLabelConstraints()
        setPointsLabelConstraints()
        
        teamImageView.isSkeletonable = true
        teamTitleLabel.isSkeletonable = true
        teamPointsLabel.isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(teamInfo: TeamRecord) {
        teamImageView.image = UIImage(named: "AssetBundle.bundle/" + teamInfo.team + ".png")
        teamTitleLabel.text = teamInfo.team
        teamPointsLabel.text = (teamInfo.points as NSNumber).stringValue
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
        teamImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        teamImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        teamImageView.widthAnchor.constraint(equalTo: teamImageView.heightAnchor, multiplier: 1).isActive = true
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
    
}
