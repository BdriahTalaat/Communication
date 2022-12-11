//
//  AllUserTableViewCell.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 10/04/1444 AH.
//

import UIKit

class AllUserTableViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
