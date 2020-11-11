//
//  NewsCell.swift
//  Scores
//
//  Created by Rastaar Haghi on 8/17/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import Foundation
import UIKit

class NewsCell: UITableViewCell {
    var articleImageView = UIImageView()
    var articleTitle = UILabel()
    var authorLabel = UILabel()
    var dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(articleImageView)
        addSubview(articleTitle)
        addSubview(authorLabel)
        addSubview(dateLabel)
        
        // configure images
        configureImageView(imageView: articleImageView)
        
        // configure labels
        configureTitleLabel(label: articleTitle)
        configureTitleLabel(label: authorLabel)
        configureTitleLabel(label: dateLabel)

        setImageConstraints()
        setTitleLabelConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(newsArticle: News) {
        if let imageInfo = URL(string: newsArticle.imageURL) {
            articleImageView.load(url: imageInfo)
        }
        
        articleTitle.text = newsArticle.title
        articleTitle.font = UIFont.regularFont(size: 16)

        authorLabel.text = newsArticle.source
        authorLabel.font = UIFont.regularFont(size: 16)
        
        dateLabel.text = newsArticle.date
        dateLabel.font = UIFont.regularFont(size: 14)
    }
    
    func configureImageView(imageView: UIImageView) {
        imageView.layer.cornerRadius = 1
        imageView.clipsToBounds = true
    }
    
    func configureTitleLabel(label: UILabel) {
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
    }
    
    func setImageConstraints() {
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        articleImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        articleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        articleImageView.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -55).isActive = true
        articleImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func setTitleLabelConstraints() {
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        articleTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        articleTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        articleTitle.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 10).isActive = true
        articleTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
    
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: articleImageView.topAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 7.5).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.topAnchor.constraint(equalTo: articleImageView.topAnchor).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
