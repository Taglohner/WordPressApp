//
//  MainTableViewCell.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit


class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainLayout: UIView!
    @IBOutlet weak var shadowLayout: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var authorProfilePicture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var excerptLabel: UILabel!
    @IBOutlet weak var bookMark: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCellLayout(post: Post) {
        
        self.selectionStyle = .none
        
        titleLabel.text = post.title
        titleLabel.font = UIFont(name: "Oxygen-Bold", size: 16)
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .natural
        
        excerptLabel.text = post.excerpt
        excerptLabel.numberOfLines = 4
        excerptLabel.textAlignment = .natural
        excerptLabel.font = UIFont(name: "Oxygen-Light", size: 14)
        
        authorLabel.font = UIFont(name: "Oxygen-Bold", size: 8)
        authorLabel.textAlignment = .left

        mainLayout.layer.cornerRadius = 0
        mainLayout.layer.masksToBounds = false
        shadowLayout.layer.cornerRadius = 0
        shadowLayout.layer.masksToBounds = false
        
        postImage.clipsToBounds = true
        postImage.contentMode = .scaleAspectFill
        postImage.layer.cornerRadius = 4
        
        authorProfilePicture.layer.borderWidth = 0.5
        authorProfilePicture.layer.borderColor = UIColor.orange.cgColor
        authorProfilePicture.contentMode = .scaleAspectFill
        authorProfilePicture.makeRounded()
    }
}
