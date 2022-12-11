//
//  UserAccountViewController.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 11/04/1444 AH.
//

import UIKit
import NVActivityIndicatorView

class UserAccountViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var postsUserCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberAllPosts: UILabel!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    //MARK: VARIABLE
    var posts:[Post] = []
    var user:User!
    var total = 0
    var page = 0
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsUserCollectionView.reloadData()
        
        postsUserCollectionView.dataSource = self
        postsUserCollectionView.delegate = self
        
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        emailLabel.text = user.email
        genderLabel.text = user.gender
        registerLabel.text = user.registerDate
        phoneLabel.text = user.phone
        
        getSpacificePost()
        getSpacificeUser()

    }
    
    //MARK: ACTIONS
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false)
    }
    
    //MARK: FUNCTION
    func getSpacificePost(){
        
        loaderView.startAnimating()
        
        PostAPI.getSpasificPosts(page: page, id: user.id) { [self] responcePosts, total in
            self.total = total
            numberAllPosts.text = "\(total)"
            self.posts.append(contentsOf: responcePosts)
            
            userImage.setImageFromStringURL(stringURL: user.picture ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQp03ufSRfn7HaHhshFyqzmGCWQjh_LozvMRA&usqp=CAU" )
            userImage.setImageCircler(image: userImage)
            
            genderLabel.text = user.gender
            phoneLabel.text = user.phone
            emailLabel.text = user.email
            registerLabel.text = user.registerDate
                        
            self.postsUserCollectionView.reloadData()
            self.loaderView.stopAnimating()
        }
    }
    
    func getSpacificeUser(){
        
        loaderView.startAnimating()
        
        UserAPI.getSpacifiseUser(id: user.id) { response in
            self.user = response
            self.loaderView.stopAnimating()
        }
    }

}

//MARK: EXTENTION
extension UserAccountViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserAccountCollectionViewCell", for: indexPath) as! UserAccountCollectionViewCell
        
        var data = posts[indexPath.row]
        
        if data.image == ""{
            data.image = "https://biz-deal.net/public/storage/DefaultImage.jpg"
        }
        
        cell.userPostImage.setImageFromStringURL(stringURL: data.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedPost = posts[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        vc.post = selectedPost
        vc.user = user.id
        present(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == posts.count-1 && posts.count<total{
            page = page + 1
            getSpacificePost()
        }
    }
}
