//
//  LinkTableViewCell.swift
//  SmallChatApp
//
//  Created by Adarsh Kolluru on 1/5/17.
//  Copyright © 2017 Saurabh. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell {

    @IBOutlet weak var linkerView: UIView!
    @IBOutlet weak var linktext: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
