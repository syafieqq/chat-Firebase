//
//  Helper.swift
//  GoChat
//
//  Created by Muhammad Iqbal on 15/02/2018.
//  Copyright © 2018 Muhammad Iqbal. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import UIKit
import GoogleSignIn
import FirebaseStorage
import FirebaseDatabase

class Helper {
    static let helper = Helper()
    
    func loginAnonymously(name: String) {
        print("login anonymously did tapped")
        // Anonymously log users in
        // switch view by setting navigation controller as root view controller
        
        Auth.auth().signInAnonymously(completion: { (anonymousUser: User?, error: Error?) in
            if error == nil {
                print("UserId: \(anonymousUser!.uid)")
                
                let newUser = Database.database().reference().child("users").child(anonymousUser!.uid)
                newUser.setValue(["displayname" : "\(name)", "id" : "\(anonymousUser!.uid)",
                    "profileUrl": ""])
                
                if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavigationVC") as? UINavigationController,
                    let yourViewController = controller.viewControllers.first as? NewChatViewController {
                    yourViewController.myString = name
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = controller  // if presented from AppDelegate
                    // present(controller, animated: true, completion: nil) // if presented from ViewController
                }
                
            } else {
                print(error!.localizedDescription)
                return
            }
        })
        
        
        
    }
    
    func anonymousNameField() {
        print("login anonymously did tapped")

                self.switchToNavigationViewController(Navigation: "NavigationName")
        
    }
    
    
    func logInWithGoogle(_ authentication: GIDAuthentication) {
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        
        Auth.auth().signIn(with: credential, completion: { (user: User?, error: Error?) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }else {
                print(user?.email as Any)
                print(user?.displayName as Any)
                print(user?.photoURL as Any)
                
                let newUser = Database.database().reference().child("users").child(user!.uid)
                newUser.setValue(["displayname" : "\(user!.displayName!)", "id" : "\(user!.uid)",
                    "profileUrl": "\(user!.photoURL!)"])
                
                
                self.switchToNavigationViewController(Navigation: "NavigationVC")

                            
            }
        })
}

    func switchToViewController(Navigation : String ) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let naviVC = storyboard.instantiateViewController(withIdentifier: Navigation)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
        
    }
    
    func switchToNavigationViewController(Navigation : String) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let naviVC = storyboard.instantiateViewController(withIdentifier: Navigation) as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
        
    }
    
}
