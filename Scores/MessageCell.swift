//
//  CustomMessageCell.swift
//  Scores
//
//  Created by Rastaar Haghi on 10/24/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    var senderUsername = UILabel()
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var messageBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackground.layer.cornerRadius = 15
        avatarImageView.backgroundColor = .clear
    }
}
