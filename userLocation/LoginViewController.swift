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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var signInToggle: UISegmentedControl!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var submitButton: UIButton!
   
    @IBOutlet var signInLabel: UILabel!
    
    var fireUserID = String()
    var userEmail = String()
    var username = String()
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    var isSignIn: Bool = true

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        emailTextField.delegate = self
        emailTextField.tag = 0
        emailTextField.returnKeyType = UIReturnKeyType.done
        
        passwordTextField.delegate = self
        passwordTextField.tag = 1
        passwordTextField.returnKeyType = UIReturnKeyType.done
        
        usernameTextField.delegate = self
        usernameTextField.tag = 2
        usernameTextField.returnKeyType = UIReturnKeyType.done
        
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
            signInLabel.text = "Sign In"
            submitButton.setTitle ("Sign In", for: .normal)
        
        } else {
            signInLabel.text = "Register"
            submitButton.setTitle ("Register", for: .normal)
            
        }
        
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        // Check if it's sign in or register
        if isSignIn {
                // Sign in the user with Firebase
            userLogin()
        } else {
                // Register the user with Firebase
            createAccount()
        }
        
        getUserInfo()
        
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = tabBarController
        
        
        performSegue(withIdentifier: "FavoriteLocationsTableSegue", sender: submitButton)
        
    }
    
    func createAccount() {
        
        let validEmail = isEmailValid(emailAddressString: emailTextField.text!)
        
        
        if validEmail {
            //print ("Email address is valid")
        } else {
            //print ("Please enter a valid email address")
            displayAlertMessage(messageToDisplay: "Please enter a valid email address")
        }
        
        
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                self.displayAlertMessage(messageToDisplay: "Please enter a valid email address.")
            } else {
                self.userLogin()
            }
            
            let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
            let values = ["Email": self.emailTextField.text, "Username": self.usernameTextField.text]
            //Don't need to update passwords, keeps it from being printed in database
            if let userID = FIRAuth.auth()?.currentUser?.uid {
                ref.child("Users").child(userID).updateChildValues(values) { (err, ref) in
                
                    if err != nil {
                        //print ("Error saving user")
                        return
                    }
                    //print ("Saved user successfully")
                }
            }
            
        })
        
    }
    
    func userLogin() {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                self.signInLabel.text = "There has been an error. Please try again."
            } else {
                //self.performSegue(withIdentifier: "FavoriteLocationsTableSegue", sender: self)
            }
        })
        
    }
    
    func isEmailValid(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            //print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            //print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FavoriteLocationsTableSegue") {
            
            let tabCtrl = segue.destination as! UITabBarController
            let pointer = tabCtrl.viewControllers![0] as! FavoriteLocationsTableViewController
            
            //let pointer = segue.destination as! FavoriteLocationsTableViewController
           
            pointer.fireUserID = self.fireUserID
        }
    }
    
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //dismiss the keyboard when the view is tapped on.
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    */
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.emailTextField, textField == self.passwordTextField, textField == self.usernameTextField {
            self.emailTextField.text = textField.text!
            self.passwordTextField.text = textField.text!
            self.usernameTextField.text = textField.text!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        return true
    }
    
    
    func appDidEnterBackground(_application: UIApplication) {
        try! FIRAuth.auth()!.signOut()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }
    
    func getUserInfo() {
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            let uid =  user.uid
            let email = user.email!
            fireUserID = uid
            userEmail = email
            
            if let displayName = user.displayName {
                username = displayName
            }
            
        }
    }
}
