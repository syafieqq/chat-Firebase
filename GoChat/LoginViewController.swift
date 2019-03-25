//
//  LoginViewController.swift
//  GoChat
//
//  Created by Muhammad Iqbal on 15/02/2018.
//  Copyright © 2018 Muhammad Iqbal. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        Helper.helper.logInWithGoogle(user.authentication)
        
    }
    
    @IBOutlet weak var anonymousButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().clientID = "244536669008-2f3pjk8vnh5nlrrs1eg9h074f1frldso.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func loginAnonymouslyDidTapped(_ sender: Any) {
        print("login Anonymously button tapped")
        Helper.helper.anonymousNameField()
    }
    
    @IBAction func googleLoginDidTapped(_ sender: Any) {
        print("login google button tapped")
        
        GIDSignIn.sharedInstance().signIn()


    }


}
