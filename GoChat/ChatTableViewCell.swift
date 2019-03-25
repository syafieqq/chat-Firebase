//
//  ChatTableViewCell.swift
//  GoChat
//
//  Created by Muhammad Iqbal on 21/02/2018.
//  Copyright © 2018 Muhammad Iqbal. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

  
    @IBOutlet weak var messageChat: UILabel!
    @IBOutlet weak var timeChat: UILabel!
    @IBOutlet weak var nameChat: UILabel!
    @IBOutlet weak var imageChat: UIImageView!
    @IBOutlet weak var pictureChat: UIImageView!
    @IBOutlet weak var dateChat: UILabel!

    
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if (dateChat.text! == "") {
            
            dateChat.addBottomBorderWithColor(color: UIColor.lightGray, width: 0)
            
        } else {
            
           // dateChat.addBottomBorderWithColor(color: UIColor.lightGray, width: 2)
        }
        
        
        if (imageChat != nil) {
      imageChat.layer.borderWidth = 1
        imageChat.layer.masksToBounds = false
       imageChat.layer.borderColor = UIColor.black.cgColor
       imageChat.layer.cornerRadius = 4
            imageChat.clipsToBounds = true } else{}
        if (pictureChat != nil) {
    //        pictureChat.layer.borderWidth = 1
            pictureChat.layer.masksToBounds = false
    //        pictureChat.layer.borderColor = UIColor.black.cgColor
            pictureChat.layer.cornerRadius = 8
            pictureChat.clipsToBounds = true
        } else {
            
        }
       
        // Initialization code

    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

