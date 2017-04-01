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
    
    @IBOutlet var signInToggle: UISegmentedControl!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var submitButton: UIButton!
   
    
    
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
    
            // Check if it's sign in or register
        if isSignIn {
                // Sign in the user with Firebase
            userLogin()
        } else {
                // Register the user with Firebase
            createAccount()
        }
        
    }
    
    func createAccount() {
        
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                self.userLogin()
            } else {
                print ("User Created")
                self.userLogin()
            }
        })
        performSegue(withIdentifier: "saveOrCreateSegue", sender: self)
    }
    
    func userLogin() {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                print ("Incorrect")
            } else {
                self.performSegue(withIdentifier: "saveOrCreateSegue", sender: self)
            }
        })
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "saveOrCreateSegue") {
            _ = segue.destination as! SaveOrCreateViewController
        }
    }
    */
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //dismiss the keyboard when the view is tapped on.
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}
