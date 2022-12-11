//
//  User.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 27/02/1444 AH.
//

import Foundation
import UIKit

struct User : Decodable{
    var id : String
    var firstName : String
    var lastName : String
    var picture : String?
    var title : String?
    var gender : String?
    var email : String?
    var phone : String?
    var registerDate : String?
    var updatedDate : String?
    var location : Location?
}
