//
//  NecAccountViewController.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 08/03/1444 AH.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: OUTLETS
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTextField.delegate = self
        lastNameField.delegate = self
        
        circleView.layer.cornerRadius = circleView.frame.width/2
        view1.layer.cornerRadius =
        view1.frame.width/2
        
        view2.layer.cornerRadius =
        view2.frame.width/2
        
        view3.layer.cornerRadius =
        view3.frame.width/2


    }
    
    // MARK: ACTIONS

    @IBAction func hereButton(_ sender: Any) {
       
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! CreateNewAccountViewController
        
        present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        UserAPI.signIn(firstName: firstNameTextField.text!, lastName: lastNameField.text!) { user, errorMessage in
            if let message = errorMessage{
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let actionAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(actionAlert)
                self.present(alert, animated: true, completion: nil)
            }else{
                if let LoggedInUser = user {

                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                    UserManager.loggedInUser = LoggedInUser
                    
                    self.present(vc!, animated: false, completion: nil)
                }
            }
        }
    }
}
//MARK: EXTENTION
extension SignInViewController : UITextFieldDelegate{
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField{
            lastNameField.becomeFirstResponder()
        }else{
            view.endEditing(true)
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
