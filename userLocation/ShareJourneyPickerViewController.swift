//
//  ShareJourneyPickerViewController.swift
//  userLocation
//
//  Created by Lisa Steele on 5/12/17.
//  Copyright © 2017 Lisa Steele. All rights reserved.
//

import UIKit
import Firebase


class ShareJourneyPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var pickerLabel: UILabel!
    @IBOutlet var picker: UIPickerView!
    
    var journeyToStart = String()
    var arrayOfSubscribedUsers = [String]()
    var userArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        createSubscribedUsersArray()
        
    }
    
    func createSubscribedUsersArray() {
       let databaseRef = FIRDatabase.database().reference().child("SubscribedUsers").queryOrderedByKey()
        _ = databaseRef.queryEqual(toValue: journeyToStart).observe(.value, with: { (snapshot) in
            //print (snapshot)
            
            for item in snapshot.children {
                
                var user = String()
                
                if let userID = item as? FIRDataSnapshot {
                    //print (userID)
                    for item2 in userID.children {
                        if let pair = item2 as? FIRDataSnapshot {
                            if let userName = pair.key as? String {
                                //print (userName)
                                user = userName
                                self.userArray.append(user)
                            }
                            
                        }
                        self.populateArray()
                    }
                    
                }
            }
            
        })
    }
    
    func populateArray() {
        for item in userArray {
            print (item)
            arrayOfSubscribedUsers.append(item)
            print ("insideForLoop\(arrayOfSubscribedUsers)")
        }
        print (arrayOfSubscribedUsers)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfSubscribedUsers.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayOfSubscribedUsers[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerLabel.text = arrayOfSubscribedUsers[row]
    }
    
    
   
}
