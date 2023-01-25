//
//  Post.swift
//  TravellerStop
//
//  Created by HilalOruc on 20.08.2021.
//

import Foundation

class Post {
    var email : String
    var aciklama : String
    var imgUrl : String
    var userIconURL : String
    var name : String
    
    init(email: String, aciklama : String , imgUrl : String, userIconURL : String, name : String ){
        self.email = email
        self.aciklama = aciklama
        self.imgUrl = imgUrl
        self.userIconURL = userIconURL
        self.name = name
    }
    
    
}
