//
//  SignupViewController.swift
//  My EHR
//
//  Created by Dave on 2/26/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        // Go back
        //
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        CustomActivityIndicator.shared.showActivityIndicator(uiView: self.view)
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text,
        !password.isEmpty, let confirmPass = confirmPasswordTextField.text, !confirmPass.isEmpty, let name = nameTextField.text, !name.isEmpty else {
                // Alert the user there is a problem
                //
                CustomActivityIndicator.shared.hideActivityIndicator(uiView: self.view)
                showAlert(title: "Signup Error", message: "Please fill out all of the required fields.")
                return
        }
        
        if isValidName(name: name) && isValidEmail(email: email) && passwordsMatch(first: password, second: confirmPass) {
            // Create a new Firebase User
            //
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let err = error {
                    CustomActivityIndicator.shared.hideActivityIndicator(uiView: self.view)
                    self.showAlert(title: "Signup Error", message: err.localizedDescription)
                } else if let user = user {
                    // Have the users name as their display name
                    //
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    // UPDATE: needs error checking
                    changeRequest.commitChanges(completion: nil)
                    
                    //
                    DispatchQueue.main.async {
                        CustomActivityIndicator.shared.hideActivityIndicator(uiView: self.view)
                        // Segue to EHR viewController
                        //
                        self.navigationController?.popViewController(animated: true) // QWE
                    }
                }
            })
        }
    }
    
    
    func isValidName(name: String) -> Bool {
        // Function to deterime if the username has any charcters that are not allowed
        // in a Firebase path. If they are present we prompt the user the change their display name.
        // If this is not done then the app will crash when the invalid name is uploaded.
        //
        let notValidChars = CharacterSet(charactersIn: "(.#$[])")
        if name.rangeOfCharacter(from: notValidChars) != nil {
            return false
        } else {
            return true
        }
    }
    
    func passwordsMatch(first: String, second: String) -> Bool {
        if first == second {
            return true
        } else {
            return false
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
