//
//  Comment.swift
//  Final_Project
//
//  Created by Bdriah Talaat on 29/02/1444 AH.
//

import Foundation

struct Comment : Decodable {
    var id : String
    var message : String
    var owner : User
}
