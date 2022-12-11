//
//  Post.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 26/02/1444 AH.
//

import Foundation
import UIKit

struct Post : Decodable {
    var id : String
    var image : String
    var likes : Int
    var text : String
    var owner : User
    var tags : [String]?
    
}
