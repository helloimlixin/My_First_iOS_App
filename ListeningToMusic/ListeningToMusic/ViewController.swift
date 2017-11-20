//
//  ViewController.swift
//  ListeningToMusic
//
//  Created by Xin Li on 11/17/17.
//  Copyright © 2017 Xin Li. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    var isSignIn:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        
        // Flip the boolean for the Sign In Selector
        isSignIn = !isSignIn
        
        // Check the bool and set the button and the labels
        if isSignIn {
            signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
        }
        else {
            signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    
    @IBAction func signInButtonTaped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let pass = passwordTextField.text {
            
            // Check if it's sign in or register
            if isSignIn {
                // Sign in the user with Firebase
                Auth.auth().signIn(withEmail: email, password: pass, completion: { (user, error) in
                    
                    // Check that user isn't nil
                    if let u = user {
                        // User is found
                        self.performSegue(withIdentifier: "redirect", sender: self)
                    }
                    else {
                        // Error: check error and show message
                        
                    }
                })
            }
            else {
                // Register the user with Firebase
                
                Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                    
                    if let u = user {
                        // User is found
                        self.performSegue(withIdentifier: "redirect", sender: self)
                    }
                    else {
                        // Error: check error and show message
                    }
                })
            }
        }
        

        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard when the view is tapped on
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

