//
//  TagViewController.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 23/03/1444 AH.
//

import UIKit
import NVActivityIndicatorView
import SwiftyJSON
import Alamofire

class TagViewController: UIViewController {

    var tags:[String?] = []
    // MARK: OUTLET
   
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    // MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
       loaderView.startAnimating()
       PostAPI.getAllTag { tags in
            
            self.tags = tags
            self.tagCollectionView.reloadData()
            self.loaderView.stopAnimating()
        }
    }
    

}// MARK: EXTENSION

extension TagViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
       
        let currenTag = tags[indexPath.row]
        cell.tagNameLabel.text = currenTag
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedTag = tags[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        vc.tag = selectedTag
        
        self.present(vc, animated: false, completion: nil)
    }
    
}
