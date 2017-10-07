//
//  FeaturedPostTableViewCell.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 25/09/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit

class FeaturedPostTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var mainLayout: UIView!
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var excerptLabel: UILabel!
    let lightGrayColor = UIColor(r: 236, g: 236, b: 236, alpha: 1)

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellViewForFeaturedPost(cell: UITableViewCell) {
        
        self.selectionStyle = .none
        self.backgroundColor = lightGrayColor
        
        titleLabel.font = UIFont(name: "Oxygen-Bold", size: 16)
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .natural
        
        excerptLabel.numberOfLines = 3
        excerptLabel.textAlignment = .natural
        excerptLabel.font = UIFont(name: "Oxygen-Light", size: 14)
        
        mainLayout.layer.cornerRadius = 10
        mainLayout.layer.masksToBounds = false
        
        featuredImage.clipsToBounds = true
        featuredImage.contentMode = .scaleAspectFill
        featuredImage.layer.cornerRadius = 10
        featuredImage.layer.borderColor = lightGrayColor.cgColor
        featuredImage.layer.borderWidth = 0.3
    }
}
