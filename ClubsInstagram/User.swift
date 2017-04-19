//
//  User.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/11/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class User {
    var id: String?
    var name: String?
    var email: String?
    var numberOfPosts: String?
    var profileImageUrl: String?
    var profileDesc : String?
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.profileDesc = dictionary["desc"] as? String
        //self.numberOfPosts = dictionary["numberOfPosts"] as? String
    }
}
