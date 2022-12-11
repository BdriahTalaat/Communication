//
//  NewPostViewController.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 08/04/1444 AH.
//

import UIKit
import  NVActivityIndicatorView

class NewPostViewController: UIViewController {

    //MARK: OUTLETS
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var LoaderView: NVActivityIndicatorView!
    @IBOutlet weak var PostImageTextField: UITextField!
    @IBOutlet weak var postTextTextField: UITextField!
   
    //MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: ACTIONS
    
    @IBAction func addButton(_ sender: Any) {
        if let user = UserManager.loggedInUser{
            LoaderView.startAnimating()
            addButton.setTitle("", for: .normal)
            
            PostAPI.createPost(image: PostImageTextField.text!, text: postTextTextField.text!, userId: user.id) { post in
                
                NotificationCenter.default.post(name: NSNotification.Name("NewPostAdd"), object: nil)
                
                self.LoaderView.stopAnimating()
                self.addButton.setTitle("Add", for: .normal)
                self.dismiss(animated: false)
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: false)
    }
}
