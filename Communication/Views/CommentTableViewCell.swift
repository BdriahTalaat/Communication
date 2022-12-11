//
//  CommentTableViewCell.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 29/02/1444 AH.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    // MARK: OUTLETS
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
