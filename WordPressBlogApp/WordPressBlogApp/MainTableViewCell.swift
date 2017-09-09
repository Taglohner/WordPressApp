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
    @IBOutlet weak var postTitle: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCellLayout(post: Post) {
        
        postTitle.text = post.title
        postTitle.font = UIFont(name: "Oxygen-Regular", size: 16)
        postTitle.isEditable = false
        postTitle.isSelectable = false
        postTitle.isScrollEnabled = false
        postTitle.isPagingEnabled = false
        postTitle.textAlignment = .natural
        postTitle.backgroundColor = .white
        
        self.selectionStyle = .none
        self.mainLayout.layer.cornerRadius = 8
        self.mainLayout.layer.masksToBounds = false
        self.shadowLayout.layer.cornerRadius = 8
        self.shadowLayout.layer.masksToBounds = false
        
        postImage.clipsToBounds = true
        postImage.contentMode = .scaleAspectFill
        postImage.layer.cornerRadius = 8
    }
}
