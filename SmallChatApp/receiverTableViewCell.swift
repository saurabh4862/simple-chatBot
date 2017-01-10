//
//  receiverTableViewCell.swift
//  SmallChatApp
//
//  Created by Adarsh Kolluru on 11/12/16.
//  Copyright © 2016 Saurabh. All rights reserved.
//

import UIKit

class receiverTableViewCell: UITableViewCell {

    @IBOutlet weak var recieverView: UIView!
    @IBOutlet weak var delivery: UILabel!
    @IBOutlet weak var chat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
