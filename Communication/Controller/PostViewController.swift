//
//  ViewController.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 26/02/1444 AH.
//

import UIKit
import NVActivityIndicatorView

class PostViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var LogOutButton: UIButton!
    @IBOutlet weak var createPostButton: UIButton!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var postLebel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: VARIABLE
    var posts:[Post] = []
    var loggedInUser : User?
    var tag:String?
    var page = 0
    var total = 0
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        if UserManager.loggedInUser == nil {
            LogOutButton.titleLabel?.text = "Sign in"
            createPostButton.isHidden = true

        }
        else {
            LogOutButton.titleLabel?.text = "Log Out"
            print(UserManager.loggedInUser?.email)
        }
        
        if tag != nil{
            postLebel.text = "All Posts" + tag!
        }else{
            backButton.isHidden = true
        }
        
        postTableView.delegate = self
        postTableView.dataSource = self
        
        loaderView.startAnimating()
        
        getAllPost()
        
        // MARK: subsectibe NOTEFICATION
        
        NotificationCenter.default.addObserver(self, selector: #selector(userStackViewTapped), name: NSNotification.Name(rawValue : "userStackViewTapped"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewPost), name: NSNotification.Name(rawValue: "NewPostAdd"), object: nil)
        
        
    }
    
    //MARK: REQUEST METHOD
    func getAllPost(){
        PostAPI.getAllPosts(page: page, tag: tag) { postsResponse,total  in
            self.total = total
            self.posts.append(contentsOf: postsResponse)
            self.postTableView.reloadData()
            self.loaderView.stopAnimating()
        }
    }
    
    // MARK: FUNCTIONS
    @objc func userStackViewTapped(notefication : Notification){
        
        if let cell = notefication.userInfo?["cell"] as? UITableViewCell{
            if let indexPath = postTableView.indexPath(for: cell){
                let post = posts[indexPath.row]
                
                let vc = storyboard?.instantiateViewController(withIdentifier: "UserAccountViewController") as! UserAccountViewController
                
                vc.user = post.owner
                present(vc, animated: false, completion: nil)
                
            }
        }
    }

    
    @objc func AddNewPost(){
        self.page = 0
        self.posts = []
        getAllPost()
    }
 
    //MARK: ACTIONS
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func LogOutButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewAccountViewController") as! SignInViewController
        present(vc, animated: false, completion: nil)
        
        UserManager.loggedInUser = nil
    }
    
    @IBAction func createPostButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewPostViewController") as! NewPostViewController
        present(vc, animated: false)
    }
    
}

//MARK: EXTENION
extension PostViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post") as! PostTableViewCell
        
        var post = posts[indexPath.row]
        
        cell.PostLabel.text = post.text
       
        // the logic of filling the post image from the URL
        if post.image == ""{
            post.image = "https://biz-deal.net/public/storage/DefaultImage.jpg"
        }
        let imageString = post.image
       
        cell.postImage.setImageFromStringURL(stringURL: imageString)
        
        // filling the user data
        cell.nameUserLabel.text = post.owner.firstName+" "+post.owner.lastName
        
        
        // the logic of filling the user image from the URL
        let imageUserString = post.owner.picture
        cell.imageUser.layer.cornerRadius = cell.imageUser.frame.width/2
        
        if let image = imageUserString{
            cell.imageUser.setImageFromStringURL(stringURL: image)
        }
        // tages
        if let tags = post.tags{
            cell.tagPost = tags
        }else{
            cell.tagPost = []
        }
        // number likes
        cell.numberLikesLabel.text = String(post.likes)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selected = posts[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        vc.post = selected
        vc.loggedInUser = loggedInUser
        present(vc, animated: false, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == posts.count-1 && posts.count<total{
            page = page + 1
            getAllPost()
        }
        
    }
}

