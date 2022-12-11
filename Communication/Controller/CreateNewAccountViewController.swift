//
//  LoginViewController.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 06/03/1444 AH.
//

import UIKit
import NVActivityIndicatorView
import SwiftEntryKit

class CreateNewAccountViewController: UIViewController {

    // MARK: OUTLETS
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!

    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    // MARK: LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view1.layer.cornerRadius = view1.frame.width/2
        view2.layer.cornerRadius = view2.frame.width/2
        view3.layer.cornerRadius = view3.frame.width/2
        view4.layer.cornerRadius = view4.frame.width/2
        
    }
    
    // MARK: ACTIONS

    @IBAction func submitButton(_ sender: Any) {
        
        UserAPI.createUser (firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, email: emailTextField.text!,title:titleTextField.text!,gender:genderTextField.text!,phoneNumber:phoneNumberTextField.text!){ user,errorMessage in
            
            if errorMessage != nil{
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Success", message: "User created \(self.firstNameTextField.text) \(self.lastNameTextField.text)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    
                alert.addAction(okAction)
                
               // let vc = storyboard?.instantiateViewController(withIdentifier: "PostViewController") as? PostViewController
                
                self.present(alert, animated: true, completion: nil)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
                self.present(vc, animated: false, completion: nil)

            }
            
        }
        
    }
    
    @IBAction func skipButton(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
        
        self.present(vc!, animated: false, completion: nil)
        
        
    }
    
    @IBAction func hereButton(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewAccountViewController") as! SignInViewController
        present(vc, animated: false, completion: nil)
    }
    
}

