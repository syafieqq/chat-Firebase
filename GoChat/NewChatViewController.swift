//
//  NewChatViewController.swift
//  GoChat
//
//  Created by Muhammad Iqbal on 21/02/2018.
//  Copyright © 2018 Muhammad Iqbal. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImage
import AVFoundation
import UITableView_Cache
import IQKeyboardManagerSwift


class NewChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    var chatList = [ChatModel]()
    var placeholderLabel : UILabel!
    let imagePickerController = UIImagePickerController()
    var myString = ""
    var senderId = ""
    var senderName = ""
    var newtimestamp = String()
    var newdatestamp = String()
    let currentUser = Auth.auth().currentUser
    var refChat : DatabaseReference!
    var test = ""
    
    //  var arrayNum = [1,1,1,2,3,4,4,5]
    @IBOutlet weak var tableViewChat: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var purpleView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        let myString = self.myString
        
        if let currentUser = Auth.auth().currentUser
        {
            senderId = currentUser.uid
            
            if currentUser.isAnonymous == true
            {
                senderName = "\(myString)"
            } else
            {
                senderName = "\(currentUser.displayName!)"
            }
            
        }
        
        placeholder()
        reffereceChat()
        
        
        // below code for auto sizing viewcell
        tableViewChat.estimatedRowHeight = UITableViewAutomaticDimension
        tableViewChat.rowHeight = UITableViewAutomaticDimension
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
            case 1334:
                print("iPhone 6/6S/7/8")
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X")
                purpleView.isHidden = false
            default:
                print("unknown")
            }
        }
        //   scrollToBottom()
    }
    func reffereceChat() {
        refChat = Database.database().reference().child("messages")
        refChat.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.chatList.removeAll()
                
                //iterating through all the values
                for chats in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let chatObject = chats.value as? [String: AnyObject]
                    let senderName  = chatObject?["senderName"]
                    let senderId  = chatObject?["senderId"]
                    let text = chatObject?["text"]
                    let time = chatObject?["time"]
                    let date = chatObject?["date"]
                    let mediaType = chatObject?["MediaType"] as! String
                    //creating chat object with model and fetched values
                    let chat = ChatModel(senderId: senderId as! String?, senderName: senderName as! String?, text: text as! String?, mediaType: mediaType as String?, time: time as! String?, date: date as! String?)
                    //appending it to list
                    self.chatList.append(chat)
                }
                
                //reloading the tableview
                self.tableViewChat.reloadData()
            }
        })
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return chatList.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didTapMessageAtIndexPath: \(indexPath.item)")
        
        let chat: ChatModel
        chat = chatList[indexPath.row]
        
        switch chat.mediaType! {
            
        case "TEXT":
            print ("text Clicked")
            
        case "PHOTO":
            print ("image Clicked")
        case "VIDEO":
            
            let fileUrl = chat.text!
            let videoUrl:URL? = URL(string: fileUrl)
            let player = AVPlayer(url: videoUrl!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true, completion: nil)
            
        default:
            print("unknown data type")
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let chat: ChatModel
        chat = chatList[indexPath.row]
        
        let id = chat.senderId!
        
        var cellIdentifier : String {
            switch chat.mediaType {
            case "TEXT"?:
                return "Message"
                
            default:
                return "Picture"
            }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ChatTableViewCell
        
        switch chat.mediaType! {
            
        case "TEXT":
            
            cell?.messageChat.text! = chat.text!
            
        case "PHOTO":
            
            
            let fileUrl = chat.text!
            let imageUrl:URL? = URL(string: fileUrl)
            if let url = imageUrl {
                cell?.pictureChat.sd_setImage(with: url)
            }
            
        case "VIDEO":
            
            
            let yourVideo: UIImage = UIImage(named: "video")!
            cell?.pictureChat.image? = yourVideo
            
        default:
            print("unknown data type")
            
        }
        //  cellTwo?.dateChat.text! = chat.date!
        
        if test == chat.date!{
            
            cell?.dateChat.text! = ""
        } else {
            
            cell?.dateChat.text! = chat.date!
            test = chat.date!
        }
        
        cell?.nameChat.text! = chat.senderName!
        cell?.timeChat.text! = chat.time!
        Database.database().reference().child("users").child(id).observe(.value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: AnyObject]
            {
                let avatarUrl = dict["profileUrl"] as! String
                
                if avatarUrl != "" {
                    let fileUrl = URL(string: avatarUrl)
                    let data = try? Data(contentsOf: fileUrl!)
                    let image = UIImage(data: data!)
                    cell?.imageChat.image! = image!
                    
                } else {
                    let yourImage: UIImage = UIImage(named: "profileImage")!
                    cell?.imageChat.image! = yourImage
                }
                
            }
        }
        )
        return cell!
        
    }
    
    
    @IBAction func attachmentTapped(_ sender: Any) {
        print("attachment tapped")
        
        let sheet = UIAlertController(title: "Media Messages", message: "Please select a media", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alert:UIAlertAction) in
            
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default) { (alert: UIAlertAction) in
            self.getMediaFrom(kUTTypeImage)
        }
        
        let videoLibrary = UIAlertAction(title: "Video Library", style: UIAlertActionStyle.default) { (alert: UIAlertAction) in
            self.getMediaFrom(kUTTypeMovie)
            
        }
        
        
        sheet.addAction(photoLibrary)
        sheet.addAction(videoLibrary)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    func sendMedia(_ picture: UIImage?, video: URL?) {
        print(picture as Any)
        print(Storage.storage().reference())
        if let picture = picture {
            let filePath = "\(String(describing: Auth.auth().currentUser))/\(Date.timeIntervalSinceReferenceDate)"
            print(filePath)
            let data = UIImageJPEGRepresentation(picture, 0.1)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            Storage.storage().reference().child(filePath).putData(data!, metadata: metadata) { (metadata, error)
                in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                let fileUrl = metadata!.downloadURLs![0].absoluteString
                
                let newMessage = self.refChat.childByAutoId()
                self.printTimestamp()
                self.printDate()
                let messageData = ["text": fileUrl, "senderId": self.senderId, "senderName": self.senderName, "MediaType": "PHOTO", "time": self.newtimestamp, "date": self.newdatestamp]
                newMessage.setValue(messageData)
                
            }
            
        } else if let video = video {
            let filePath = "\(String(describing: Auth.auth().currentUser))/\(Date.timeIntervalSinceReferenceDate)"
            print(filePath)
            let data = try? Data(contentsOf: video)
            let metadata = StorageMetadata()
            
            metadata.contentType = "video/mp4"
            Storage.storage().reference().child(filePath).putData(data!, metadata: metadata) { (metadata, error)
                in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                let fileUrl = metadata!.downloadURLs![0].absoluteString
                self.printTimestamp()
                self.printDate()
                let newMessage = self.refChat.childByAutoId()
                let messageData = ["text": fileUrl, "senderId": self.senderId, "senderName": self.senderName, "MediaType": "VIDEO", "time": self.newtimestamp, "date": self.newdatestamp]
                newMessage.setValue(messageData)
                
            }
        }
    }
    
    
    func printTimestamp() {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        newtimestamp = "\(timestamp)"
    }
    
    func printDate(){
        let datestamp = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        newdatestamp = "\(datestamp)"
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        printTimestamp()
        printDate()
        
        print("send tapped")
        let newMessage = refChat.childByAutoId()
        let messageData = ["text": textView.text!, "senderId": senderId, "senderName": senderName, "MediaType": "TEXT", "time": newtimestamp, "date": newdatestamp]
        newMessage.setValue(messageData)
        textView.text = ""
        tableViewChat.reloadData()
        scrollToBottom()
    }
    func getMediaFrom(_ type: CFString) {
        print(type)
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.mediaTypes = [type as String]
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        
        //create a main storyboard instance
        let storyboard = UIStoryboard (name: "Main", bundle: nil )
        //from main storyboard instantiate a view controller
        let logInVC = storyboard.instantiateViewController(withIdentifier: "LogInVC")as! LoginViewController
        //get the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //set navigation controller as login viewController
        appDelegate.window?.rootViewController = logInVC
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chatList.count-1, section: 0)
            self.tableViewChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func placeholder() {
        self.textView.delegate = self
        self.textView.layer.cornerRadius = 8.0
        placeholderLabel = UILabel()
        placeholderLabel.text = "Enter some text..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
}

extension NewChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did finish picking")
        // get the image
        print(info)
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            sendMedia(picture, video: nil)
            
        }
        else if let video = info[UIImagePickerControllerMediaURL] as? URL {
            sendMedia(nil, video: video)
            
        }
        
        dismiss(animated: true, completion: nil)
        tableViewChat.reloadData()
        
    }
}

extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
        
        
    }
}
extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}

