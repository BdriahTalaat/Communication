//
//  AllUserViewController.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 10/04/1444 AH.
//

import UIKit
import NVActivityIndicatorView

class AllUserViewController: UIViewController {

    //MARK: OUTLETS
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var allUserTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: VARIABLE
    var allUser:[User] = []
    var page = 0
    var total = 0
    var filteredUser = [User]()
    var searching = false
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        allUserTableView.delegate = self
        allUserTableView.dataSource = self
        
        getAllUser()
  
    }
    
    //MARK: FUNCTION
    func getAllUser(){
        loaderView.startAnimating()
        UserAPI.getAllUser(page: page) { user,total  in
           
            self.total = total
            self.allUser.append(contentsOf: user)
            self.loaderView.stopAnimating()
            self.allUserTableView.reloadData()
            
        }
    }
    
    func alert(title:String , message:String , titleAction:String){
        
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OkAction = UIAlertAction(title: titleAction, style: .default, handler: nil)
        
        errorAlert.addAction(OkAction)
        self.present(errorAlert, animated: false)
    }
    
    //MARK: ACTIONS
    @IBAction func editButton(_ sender: Any) {
        allUserTableView.isEditing = !allUserTableView.isEditing
    }
    
}

//MARK: EXTENTION
extension AllUserViewController : UITableViewDelegate,UITableViewDataSource{
    
    // number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if searching{
            return filteredUser.count
        }else{
            return allUser.count
        }
    }
    
    //cell For Row At index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllUserTableViewCell", for: indexPath) as! AllUserTableViewCell
        let data = allUser[indexPath.row]
        
        if searching{
            if let image = cell.userImage{
            
                cell.userImage.setImageFromStringURL(stringURL: filteredUser[indexPath.row].picture ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQp03ufSRfn7HaHhshFyqzmGCWQjh_LozvMRA&usqp=CAU" )

            }
            
            cell.userImage.setImageCircler(image: cell.userImage)
            cell.userNameLabel.text = "\(filteredUser[indexPath.row].firstName) \(filteredUser[indexPath.row].lastName)"
            
            return cell
        }else{
            if let image = cell.userImage{
            
                cell.userImage.setImageFromStringURL(stringURL: data.picture ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQp03ufSRfn7HaHhshFyqzmGCWQjh_LozvMRA&usqp=CAU" )

            }
            cell.userImage.setImageCircler(image: cell.userImage)
            cell.userNameLabel.text = "\(data.firstName) \(data.lastName)"
            
            return cell
        }
    }
    
    //will Display index path
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == allUser.count-1 && allUser.count<total{
            page = page + 1
            getAllUser()
        }
    }
    
    // did Select Row At index path
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selected = allUser[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserAccountViewController") as! UserAccountViewController
        vc.user = selected
        present(vc, animated: false)
        
    }
    
    //railing Swipe Actions Configuration For Row At indexPath
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler)in
            let selected = self.allUser[indexPath.row]
            
            if let user = UserManager.loggedInUser{
                if user.id == "6367f6cee92a6cadb9092e9b"{
                    
                    let deleteAlert = UIAlertController(title: "Delete", message: "do you want delete \(selected.firstName) \(selected.lastName)", preferredStyle: .alert)
                
                    let yesAction = UIAlertAction(title: "Yes", style: .destructive) { UIAlertAction in
                        
                        self.loaderView.startAnimating()

                        UserAPI.deleteSpecificUser(id: selected.id) {
                            
                            self.allUser.remove(at: indexPath.row)
                            self.allUserTableView.reloadData()
                            self.loaderView.stopAnimating()
                            
                            self.allUserTableView.beginUpdates()
                            self.allUserTableView.deselectRow(at: indexPath, animated: false)
                            self.allUserTableView.endUpdates()
                        }
                        
                    }
                    
                    let noAction = UIAlertAction(title: "No", style: .default ,handler: nil)
                    
                    deleteAlert.addAction(yesAction)
                    deleteAlert.addAction(noAction)
                    
                    self.present(deleteAlert, animated: false)
                }
                
                self.alert(title: "Error", message: "sorry you don't allowed to delete any user", titleAction: "Ok")
            }
            else{
                self.alert(title: "Error", message: "sorry you must be sign in", titleAction: "Ok")
            }

        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
//MARK: EXTENTION
extension AllUserViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredUser = allUser.filter({$0.firstName.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        
        allUserTableView.reloadData()
    }
}
