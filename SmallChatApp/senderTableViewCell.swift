//
//  senderTableViewCell.swift
//  SmallChatApp
//
//  Created by Adarsh Kolluru on 11/12/16.
//  Copyright © 2016 Saurabh. All rights reserved.
//

import UIKit

class senderTableViewCell: UITableViewCell {

    @IBOutlet weak var getChat: UILabel!
   
    @IBOutlet weak var senderView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
