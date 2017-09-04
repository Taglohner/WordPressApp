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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCellLayout() {
        
        self.mainLayout.layer.cornerRadius = 8
        self.mainLayout.layer.masksToBounds = false
        self.shadowLayout.layer.cornerRadius = 8
        self.shadowLayout.layer.masksToBounds = false
    }
}

