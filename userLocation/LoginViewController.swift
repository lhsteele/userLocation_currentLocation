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
    var userPassword = String()
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    var isSignIn: Bool = true

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        emailTextField.delegate = self
        //emailTextField.tag = 0
        emailTextField.returnKeyType = UIReturnKeyType.done
        
        passwordTextField.delegate = self
        //passwordTextField.tag = 1
        passwordTextField.returnKeyType = UIReturnKeyType.done
        
        usernameTextField.delegate = self
        //usernameTextField.tag = 2
        usernameTextField.returnKeyType = UIReturnKeyType.done
        
        view.backgroundColor = FlatNavyBlue
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
            validateFormForSignIn()
        } else {
                // Register the user with Firebase
            validateFormForRegistration()
        }
        
        getUserInfo()
              
    }
    
    func validateFormForSignIn() {
        if let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text {
            if !email.isEmpty && !password.isEmpty && !username.isEmpty {
                userLogin()
            } else {
                displayAlertMessage(messageToDisplay: "All text fields are required.")
            }
        }
    }
    
    
    func validateFormForRegistration() {
        if let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text {
            if !email.isEmpty && !password.isEmpty && !username.isEmpty {
                let emailIsValid = isEmailValid(emailAddressString: emailTextField.text!)
                if emailIsValid {
                    createAccount(email: email, password: password)
                } else {
                    print("email not valid")
                    displayAlertMessage(messageToDisplay: "This email address is invalid.")
                }
            } else {
                print("all text fields required")
                displayAlertMessage(messageToDisplay: "All text fields are required.")
            }
        }
    }
    
    func createAccount(email: String, password: String) {
        
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.displayAlertMessage(messageToDisplay: "This email address is invalid or already in use.")
            } else {
                self.userLogin()
                self.getUserInfo()
                self.saveEmail()
                self.saveUsername()
                self.performSegue(withIdentifier: "FavoriteLocationsTableSegue", sender: self.submitButton)
            }
            
            let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
            let values = ["Email": self.emailTextField.text, "Username": self.usernameTextField.text]
            //Don't need to update passwords, keeps it from being printed in database
            if let userID = FIRAuth.auth()?.currentUser?.uid {
                ref.child("Users").child(userID).updateChildValues(values as Any as! [AnyHashable : Any]) { (err, ref) in
                
                    if err != nil {
                        return
                    }
                }
            }
            
        })
        
    }
    
    func userLogin() {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                self.signInLabel.text = "There has been an error. Please try again."
            } else {
                self.getUserInfo()
                self.performSegue(withIdentifier: "FavoriteLocationsTableSegue", sender: self.submitButton)
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
            
        } catch _ as NSError {
            //print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Error", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in

        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FavoriteLocationsTableSegue") {
            
            let pointer = segue.destination as! FavoriteLocationsTableViewController
           
            pointer.fireUserID = self.fireUserID
            pointer.userEmail = self.userEmail
            pointer.userPassword = self.userPassword
        }
    }
    
    func getUserInfo() {
        let user = FIRAuth.auth()?.currentUser
        if let user = user {
            let uid =  user.uid
            let email = user.email!
            fireUserID = uid
            userEmail = email
            username = usernameTextField.text!
            userPassword = passwordTextField.text!
            
        }
    }
    
    func saveEmail() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        //print ("saveEmailRun")
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            //print (userID)
            let value = [userID : userEmail]
            //print (value)
            ref.child("Emails").updateChildValues(value) { (err, ref) in
                
                if err != nil {
                    return
                }
            }
        }
    }
    
    func saveUsername() {
        let ref = FIRDatabase.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            print (username)
            let value = [userID : username]
            ref.child("Usernames").updateChildValues(value) { (err, ref) in
                
                if err != nil {
                    return
                }
            }
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
    
}
