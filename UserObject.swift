//
//  User.swift
//  TravellerStop
//
//  Created by HilalOruc on 14.09.2021.
//

import Foundation

 class UserObject {
    var email : String
    var bio : String
    var imgUrl : String
    var id: String
    var fullName : String
    
    init(email: String, bio : String , imgUrl : String, id : String , fullName : String) {
        self.email = email
        self.bio = bio
        self.imgUrl = imgUrl
        self.id = id
        self.fullName = fullName
    }
}
