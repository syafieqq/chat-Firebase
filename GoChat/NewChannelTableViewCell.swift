//
//  NewChannelTableViewCell.swift
//  GoChat
//
//  Created by Muhammad Iqbal on 20/02/2018.
//  Copyright © 2018 Muhammad Iqbal. All rights reserved.
//

import UIKit

class NewChannelTableViewCell: UITableViewCell {

    @IBOutlet weak var newChannelTextField: UITextField!
    @IBOutlet weak var addNewChannel: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
