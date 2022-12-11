//
//  ProfilViewController.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 02/03/1444 AH.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ProfilViewController: UIViewController {

    // MARK: OUTLTES
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var viewLoader: NVActivityIndicatorView!
    
    //MARK:  VARIBLE
    var user:User!
    
    //MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUser()
        viewLoader.startAnimating()
        UserAPI.getSpacifiseUser(id: user.id) { userResponse in
            self.user = userResponse
            self.setupUser()
            print(self.user)
            self.viewLoader.stopAnimating()
        }
        
    }
    
    // MARK: FUNCTIONS
    
    func setupUser(){
       
        nameLabel.text = user.firstName+" "+user.lastName

        userImage.layer.cornerRadius = userImage.frame.width/2
        titleLabel.text = user.title
        genderLabel.text = user.gender
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        registerLabel.text = user.registerDate
        updateLabel.text = user.updatedDate
        
        
        if let image = user.picture{
            userImage.setImageFromStringURL(stringURL:image)
        }
    }
    

}
