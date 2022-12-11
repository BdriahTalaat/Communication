//
//  MyProfileViewController.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 08/04/1444 AH.
//

import UIKit
import NVActivityIndicatorView


class MyProfileViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var imageURLTextField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var numberPostsLabel: UILabel!
    @IBOutlet weak var redisterLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var stackDerails: UIStackView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var stackPost: UIStackView!
    
    //MARK: VARIABLE
    var posts:[Post] = []
    var loggedInUser : User?
    var total = 0
    var page = 0
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        postsCollectionView.dataSource = self
        postsCollectionView.delegate = self
        
        setupUI()
      
    }
    
    //MARK: FUNCTIONS
    func setupUI(){
        if let user = UserManager.loggedInUser{
            if let image = user.picture{
                userImageView.setImageFromStringURL(stringURL: image)
            }
            
            noteLabel.isHidden = true
            userImageView.setImageCircler(image: userImageView)
            nameLabel.text = ("\(user.firstName) \(user.lastName)")
            
            imageURLTextField.text = user.picture
            
            // get posts and user
            
            getSpacificePost(user: user)
            getSpacificeUser()
            
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
            
            vc.LogOutButton.titleLabel?.text = "Sign in"
            
            postsCollectionView.isHidden = true
            userImageView.isHidden = true
            noteLabel.isHidden = false
            numberPostsLabel.isHidden = true
            stackDerails.isHidden = true
            stackPost.isHidden = true
            postLabel.isHidden = true
            redisterLabel.isHidden = true
            phoneLabel.isHidden = true
            genderLabel.isHidden = true
            imageLabel.isHidden = true
            imageURLTextField.isHidden = true
            
        }
    }
    
    // get spacifice post
    func getSpacificePost(user:User){
        
        loaderView.startAnimating()
        
        PostAPI.getSpasificPosts(page: page, id: UserManager.loggedInUser!.id) { [self] responcePosts, total in
            self.total = total
            numberPostsLabel.text = "\(total)"
            self.posts.append(contentsOf: responcePosts)
            
            userImageView.setImageFromStringURL(stringURL: user.picture ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQp03ufSRfn7HaHhshFyqzmGCWQjh_LozvMRA&usqp=CAU" )
            userImageView.setImageCircler(image: userImageView)
                        
            self.postsCollectionView.reloadData()
            self.loaderView.stopAnimating()
        }
        
    }
    
    // get spacifice user
    func getSpacificeUser(){
        
        loaderView.startAnimating()
        
        UserAPI.getSpacifiseUser(id: UserManager.loggedInUser!.id) { [self] response in
            self.loggedInUser = response
            
            genderLabel.text = self.loggedInUser?.gender
            emailLabel.text = self.loggedInUser?.email
            phoneLabel.text = self.loggedInUser?.phone
            redisterLabel.text = self.loggedInUser?.registerDate
            
            self.loaderView.stopAnimating()
        }
    }
    
    
    //MARK: ACTIONS
    @IBAction func submitButton(_ sender: Any) {
        
        guard let loggedInUser = UserManager.loggedInUser else{return}
        
        loaderView.startAnimating()
       
        UserAPI.updateMyProfile(id: loggedInUser.id,image: imageURLTextField.text!) { user, message in
            
            if let responseUser = user{
                if let image = user?.picture{
                    self.userImageView.setImageFromStringURL(stringURL: image)
                }
            }

            self.loaderView.stopAnimating()
        }
    }
    
}

//MARK: EXTENTION
extension MyProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyProfileCollectionViewCell", for: indexPath) as! MyProfileCollectionViewCell
        
        var data = posts[indexPath.row]
        
        if data.image == ""{
            data.image = "https://biz-deal.net/public/storage/DefaultImage.jpg"
        }
        
        cell.postImage.setImageFromStringURL(stringURL: data.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        vc.post = selectedPost
        vc.user = loggedInUser!.id
        present(vc, animated: false)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width * 0.45, height: self.view.frame.width * 0.45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
}


