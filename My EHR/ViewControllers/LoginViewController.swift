//
//  LoginViewController.swift
//  My EHR
//
//  Created by Dave on 2/26/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide navigation bar
        //
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 8
//        loginButton.layer.borderWidth = 1
//        loginButton.layer.borderColor = UIColor.white.cgColor
//        
        signupButton.layer.cornerRadius = 8
//        signupButton.layer.borderWidth = 1
//        signupButton.layer.borderColor = UIColor.white.cgColor
        
        passwordTextField.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        login()
    }
    @IBAction func skipLoginPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "NewRecord", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "NewRecordViewController") as? NewRecordViewController {
            // SetViewControllers so there isn't a back button
            //
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            // Move the user to the password textField
            //
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            login()
        }
        return true
    }
    
    private func login() {
        guard emailTextField.text != "" && passwordTextField.text != "" else {
            showAlert(title: "Error", message: "Please enter email and password!")
            return
        }
        
        CustomActivityIndicator.shared.showActivityIndicator(uiView: self.view)
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            
            if let error = error {
                CustomActivityIndicator.shared.hideActivityIndicator(uiView: self.view)
                self.showAlert(title: "Login Error", message: error.localizedDescription)
            } else if let user = user {
                print("user: \(user)")
                // Segue to a new storyboard
                //
                let storyboard = UIStoryboard(name: "MainScreen", bundle: nil)
                if let vc = storyboard.instantiateViewController(withIdentifier: "MainScreenViewController") as? MainScreenViewController {
                    // SetViewControllers so there isn't a back button
                    //
                    self.navigationController?.setViewControllers([vc], animated: true)
                }
            }
        })
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        // Segue to Signup Storyboard
        //
        let storyboard = UIStoryboard(name: "Signup", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
