//
//  LoginViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 3/31/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signInToggle: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    var isSignIn: Bool = true

    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInToggleChanged(_ sender: UISegmentedControl) {
        //Flip the boolean
        isSignIn = !isSignIn
        
        //Check the bool and set the button text
        if isSignIn {
            submitButton.setTitle ("Sign In", for: .normal)
        
        } else {
            submitButton.setTitle ("Register", for: .normal)
            
        }
        
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        // TODO: Do some form validation on the email and password
        
        if let email = emailTextField.text, let pass = passwordTextField.text {
            
            // Check if it's sign in or register
            if isSignIn {
                // Sign in the user with Firebase
                FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
                    
                    // Check that user isn't nil
                    if let u = user {
                        // User is found, go to home screen
                        self.performSegue(withIdentifier: "saveOrCreateSegue", sender: self)
                    }
                    else {
                        // Error: check error and show message
                    }
                    
                })
                
            }
            else {
                // Register the user with Firebase
                
                FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                    
                    // Check that user isn't nil
                    if let u = user {
                        // User is found, go to home screen
                        self.performSegue(withIdentifier: "saveOrCreateSegue", sender: self)
                    }
                    else {
                        // Error: check error and show message
                    }
                })
                
            }
            
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveOrCreateSegue" {
            let destinationViewController = segue.destination as! SaveOrCreateViewController
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //dismiss the keyboard when the view is tapped on.
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}
