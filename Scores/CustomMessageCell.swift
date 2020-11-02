//
//  CustomMessageCell.swift
//  Scores
//
//  Created by Rastaar Haghi on 10/24/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
