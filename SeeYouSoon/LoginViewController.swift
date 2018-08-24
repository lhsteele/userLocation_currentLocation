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
import FirebaseDatabase



class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var signInToggle: UISegmentedControl!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var usernameTextField: UITextField!
    
    @IBOutlet var submitButton: UIButton!
   
    @IBOutlet var signInLabel: UILabel!
    
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    
    
    var fireUserID = String()
    var userEmail = String()
    var username = String()
    var userPassword = String()
    var handle: AuthStateDidChangeListenerHandle?
    
    var isSignIn: Bool = true

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        emailTextField.returnKeyType = UIReturnKeyType.done
        emailTextField.delegate = self
        
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = UIReturnKeyType.done
        
        usernameTextField.delegate = self
        usernameTextField.returnKeyType = UIReturnKeyType.done
        
        view.backgroundColor = UIColor(red: 0.23, green: 0.44, blue: 0.51, alpha: 1.0)
        signInToggle.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        submitButton.tintColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        submitButton.layer.borderColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0).cgColor
        submitButton.layer.borderWidth = 1
        submitButton.layer.cornerRadius = 10
        signInLabel.textColor = UIColor(red: 0.93, green: 0.95, blue: 0.95, alpha: 1.0)
        signInLabel.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signInToggleChanged(_ sender: UISegmentedControl) {
        
        isSignIn = !isSignIn
        
        if isSignIn {
            signInLabel.text = "Register"
            submitButton.setTitle ("Register", for: .normal)
            usernameTextField.isHidden = false
            confirmPasswordTextField.isHidden = false
        } else {
            signInLabel.text = "Sign In"
            submitButton.setTitle ("Sign In", for: .normal)
            usernameTextField.isHidden = true
            confirmPasswordTextField.isHidden = true

        }
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if !isSignIn {
            validateFormForSignIn()
        } else {
            validateFormForRegistration()
        }
        getUserInfo()
    }
    
    func validateFormForSignIn() {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if !email.isEmpty && !password.isEmpty {
                userLogin()
            } else {
                displayAlertMessage(messageToDisplay: "All text fields are required.")
            }
        }
    }
    
    
    func validateFormForRegistration() {
        if let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text, let confirm = confirmPasswordTextField.text {
            if !email.isEmpty && !password.isEmpty && !username.isEmpty && !confirm.isEmpty {
                let emailIsValid = isEmailValid(emailAddressString: emailTextField.text!)
                if emailIsValid {
                    if password == confirm {
                        createAccount(email: email, password: password)
                    } else {
                        displayAlertMessage(messageToDisplay: "Your passwords do not match. Please try again.")
                    }
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
        
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.displayAlertMessage(messageToDisplay: "This email address is invalid or already in use.")
            } else {
                self.userLogin()
                self.getUserInfo()
                self.saveEmail()
                self.saveUsername()
            }
            let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
            let values = ["Email": self.emailTextField.text, "Username": self.usernameTextField.text]
            if let userID = Auth.auth().currentUser?.uid {
                ref.child("Users").child(userID).updateChildValues(values as Any as! [AnyHashable : Any]) { (err, ref) in
                
                    if err != nil {
                        return
                    }
                }
            }
            
        })
        
    }
    
    func userLogin() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                self.displayAlertMessage(messageToDisplay: "There has been an error. Please try again.")
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
        let user = Auth.auth().currentUser
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
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        if let userID = Auth.auth().currentUser?.uid {
            let value = [userID : userEmail]
            ref.child("Emails").updateChildValues(value) { (err, ref) in
                if err != nil {
                    return
                }
            }
        }
    }
    
    func saveUsername() {
        let ref = Database.database().reference(fromURL: "https://userlocation-aba20.firebaseio.com/")
        if let userID = Auth.auth().currentUser?.uid {
            print (username)
            let value = [userID : username]
            ref.child("Usernames").updateChildValues(value) { (err, ref) in
                
                if err != nil {
                    return
                }
            }
        }
    }
   
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
        try! Auth.auth().signOut()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener() { (auth, user) in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
}
