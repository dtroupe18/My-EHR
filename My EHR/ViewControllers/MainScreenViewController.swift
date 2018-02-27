//
//  MainScreenViewController.swift
//  My EHR
//
//  Created by Dave on 2/27/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainScreenViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    
    let choices = ["View my EHR", "Update my EHR", "Permission Requests"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        dropDown.dataSource = self
        dropDown.delegate = self
        
        if let name = Auth.auth().currentUser?.displayName {
            greetingLabel.text = "Hi \(name),"
        } else {
//            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//            changeRequest?.displayName = "Dave Troupe"
//            changeRequest?.commitChanges(completion: nil)
        }
    }
    
    // Marker: UIPickerView Delegate
    //
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: choices[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = choices[row]
        dropDown.isHidden = true
        
        if choices[row] == "Update my EHR" {
            // Segue to create EHR viewController
            //
//            let storyboard = UIStoryboard(name: "CreateEHR", bundle: nil)
//            if let vc = storyboard.instantiateViewController(withIdentifier: "CreateEHRViewController") as? CreateEHRViewController {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    }
    
    // Marker: TextView Delegate
    //
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textField {
            // Display the drop down because the user touched the textView
            //
            self.dropDown.isHidden = false
            textField.endEditing(true)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
