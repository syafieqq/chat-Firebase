//
//  ChatModel.swift
//  GoChat
//
//  Created by Muhammad Iqbal on 06/03/2018.
//  Copyright © 2018 Muhammad Iqbal. All rights reserved.
//

import Foundation

class ChatModel {
    
    var senderId: String?
    var senderName: String?
    var text: String?
    var time: String?
    var date: String?
    var mediaType: String?
   
    
    init(senderId: String?, senderName: String?, text: String?, mediaType: String?, time: String?, date: String?){
        self.senderId = senderId
        self.senderName = senderName
        self.text = text
        self.time = time
        self.date = date
        self.mediaType = mediaType
     
    }
}
