//
//  PostDetailsViewController.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 28/02/1444 AH.
//

import UIKit
import NVActivityIndicatorView

class PostDetailsViewController: UIViewController {

    // MARK: OUTLETS

    @IBOutlet weak var commentTextView: UITextField!
    @IBOutlet weak var deletaButton: UIButton!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var backButton: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var NewCommentStackView: UIStackView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.layer.shadowColor = UIColor.gray.cgColor
            // contol or selected clear color of shadow
            backView.layer.shadowOpacity = 0.3
            backView.layer.shadowRadius = 20
            backView.layer.cornerRadius = 7
            backView.layer.shadowOffset = CGSize(width: 0, height: 10)
        }
    }
    
    //MARK: VARIABLE
    var post:Post!
    var loggedInUser:User?
    var comment : [Comment] = []
    var user = ""
    
    // MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

       
        if UserManager.loggedInUser == nil{
            NewCommentStackView.isHidden = true
            backButton.isHidden = true
        }
        
        if UserManager.loggedInUser?.id != user{
            backButton.isHidden = true
        }
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        guard let imageUserString = post.owner.picture else { return }
        imageUser.setImageFromStringURL(stringURL: imageUserString)
        imageUser.layer.cornerRadius = imageUser.frame.width/2
        
        if post.image == ""{
            post.image = "https://biz-deal.net/public/storage/DefaultImage.jpg"
        }
        
        let imagePostString = post.image
        postImage.setImageFromStringURL(stringURL: imagePostString )
        
        postLabel.text = post.text
        nameUserLabel.text = post.owner.firstName+" "+post.owner.lastName
        likesLabel.text = String(post.likes)
        
        // getting the comments of the post from the API
        loaderView.startAnimating()
        getPostComments()
    }
    //MARK: FUNCTIONS
    func getPostComments(){
        
        PostAPI.getAllComments(id: post.id) { commentResponse in
            self.comment = commentResponse
            self.commentTableView.reloadData()
            self.loaderView.stopAnimating()
        }
    }
    
    // MARK: ACTIONS
    
    @IBAction func deleteButton(_ sender: Any) {

        if UserManager.loggedInUser?.id == user{
            
            loaderView.startAnimating()
            PostAPI.deletePost(postId: post.id) {
                
                var deletePost = [self.post]
                deletePost.removeAll()
                
                self.loaderView.stopAnimating()
                
                let alert = UIAlertController.init(title: "Success", message: "success delete post", preferredStyle: UIAlertController.Style.alert)
                    
                let OKAction = UIAlertAction(title: "OK", style: .default){_ in 
                    self.dismiss(animated: false)
                }
                alert.addAction(OKAction)
                self.present(alert, animated: true)
                
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func sendButton(_ sender: Any) {
        
        if let user = UserManager.loggedInUser{
            loaderView.startAnimating()
            PostAPI.createComment(postId: post.id, userId: user.id, message: commentTextView.text!) {
                self.getPostComments()
                self.commentTextView.text = ""
            }
        }
    }
    
}
//MARK: EXTENTION
extension PostDetailsViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommentTableViewCell
        let comments = comment[indexPath.row]
        
        cell.commentLabel.text = comments.message
        cell.userNameLabel.text = comments.owner.firstName+" "+comments.owner.lastName
        
        if let userImage = comments.owner.picture{
            //let imageUserString = comments.owner.picture
            cell.userImage.setImageFromStringURL(stringURL: userImage)
        }
        
        cell.userImage.layer.cornerRadius = cell.userImage.frame.width/2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
