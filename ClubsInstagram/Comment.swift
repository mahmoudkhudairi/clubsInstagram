//
//  Comment.swift
//  
//
//  Created by Kemuel Clyde Belderol on 19/04/2017.
//
//

import Foundation
import UIKit
import Firebase



class Comment {
    var content : String?
    var userId : String?
    var userName : String?
    var userImageUrl : String?
    
   
    init(dictionary: [String: Any]) {
        self.content = dictionary["content"] as? String
        self.userName = dictionary["userName"] as? String
        self.userImageUrl = dictionary["userImageUrl"] as? String
        self.userId = dictionary["userId"] as? String
        
    }
    
}
