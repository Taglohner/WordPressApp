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
    @IBOutlet weak var shadowLayout: ShadowView!
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var excerptLabel: UILabel!
    let lightGrayColor = UIColor(r: 184, g: 184, b: 184, alpha: 1)

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellViewForFeaturedPost(cell: UITableViewCell) {
        
        self.selectionStyle = .none
        
        titleLabel.font = UIFont(name: "Oxygen-Bold", size: 16)
        titleLabel.numberOfLines = 3
        titleLabel.textAlignment = .natural
        
        excerptLabel.numberOfLines = 3
        excerptLabel.textAlignment = .natural
        excerptLabel.font = UIFont(name: "Oxygen-Light", size: 14)
        
        mainLayout.layer.cornerRadius = 4
        mainLayout.layer.masksToBounds = false
        mainLayout.layer.borderWidth = 0.2
        mainLayout.layer.borderColor = lightGrayColor.cgColor
        shadowLayout.layer.cornerRadius = 4
        shadowLayout.layer.masksToBounds = false
        
        featuredImage.clipsToBounds = true
        featuredImage.contentMode = .scaleAspectFill
        featuredImage.layer.cornerRadius = 4
    }

}
