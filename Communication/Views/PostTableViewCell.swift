//
//  PostTableViewCell.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 26/02/1444 AH.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: OUTLETS
    @IBOutlet weak var tagPostCollectionView: UICollectionView!{
        didSet{
            tagPostCollectionView.delegate = self
            tagPostCollectionView.dataSource = self
        }
    }
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
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var PostLabel: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var numberLikesLabel: UILabel!
    @IBOutlet weak var nameUserLabel: UILabel!
    @IBOutlet weak var userStackView: UIStackView!{
        didSet{
            userStackView.addGestureRecognizer(UITapGestureRecognizer(
                target: self, action: #selector(userStackViewTapped)))
        }
    }
    // MARK: VARABLE
    
    var tagPost:[String] = []
    
    // MARK: LIVE CYCLE
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    // MARK: ACTIONS
    
    @objc func userStackViewTapped (){
        NotificationCenter.default.post(name: NSNotification.Name("userStackViewTapped"), object: nil, userInfo: ["cell":self])
    }
}
extension PostTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagPost.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagPostCollectionViewCell", for: indexPath) as! TagPostCollectionViewCell
        cell.nameTageLabel.text = tagPost[indexPath.row]
       
        return cell
    }
    
    
}
