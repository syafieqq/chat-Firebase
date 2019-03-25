//
//  ChannelListViewController.swift
//  GoChat
//
//  Created by Muhammad Iqbal on 19/02/2018.
//  Copyright © 2018 Muhammad Iqbal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

enum Section: Int {
    case createNewChannelSection = 0
    case currentChannelsSection
}


class ChannelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var newChannelTextField: UITextField? 
    var ref:DatabaseReference!,
    posts = [eventStruct]()
    
    @IBOutlet weak var tableViewChannel: UITableView!

    
    
    struct eventStruct {
        let name: String!
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         loadNews()
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .createNewChannelSection:
                return 1
            case .currentChannelsSection:
                return posts.count
            }
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "CurrentChannel"
        let cell = tableViewChannel.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue {
            if let createNewChannelCell = cell as? NewChannelTableViewCell {
                newChannelTextField = createNewChannelCell.newChannelTextField
            }
        } else if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
            cell.textLabel?.text = posts[(indexPath as NSIndexPath).row].name
        }
        
        return cell


    }

    func loadNews() {
        ref = Database.database().reference()
        ref.child("channels").queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            
            if let valueDictionary = snapshot.value as? [AnyHashable:String]
            {
                let name = valueDictionary["group1"]
                
                
                self.posts.insert(eventStruct(name: name), at: 0)
                //Reload your tableView
                self.tableViewChannel.reloadData()
            }
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
