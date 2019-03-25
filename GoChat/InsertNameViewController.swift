//
//  InsertNameViewController.swift
//  GoChat
//
//  Created by Muhammad Iqbal on 18/02/2018.
//  Copyright © 2018 Muhammad Iqbal. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
class InsertNameViewController: UIViewController, UITextFieldDelegate  {
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(InsertNameViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(InsertNameViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginAnonymously(_ sender: Any) {
         
        let myString = "\(nameTextField.text!)"
        Helper.helper.loginAnonymously(name: myString as String)
    }
    @IBAction func back(_ sender: Any) {
        
        
    }
    
    @IBAction func backDidTapped(_ sender: Any) {
        Helper.helper.switchToViewController(Navigation: "LogInVC")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
}
