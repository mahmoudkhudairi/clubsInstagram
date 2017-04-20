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
    var content : String!
    var userName : String!
    var postId : String!
    var key : String!
    var userImageUrl : String
    
    
    
    init(content : String, userName : String, postId : String, userImageUrl : String) {
        self.content = content
        self.userName = userName
        self.postId = postId
        self.userImageUrl = userImageUrl
    }

    
    init(snapshot: FIRDataSnapshot) {
        
        
        self.userName = snapshot.value(forKey: "userName") as! String
        self.content = snapshot.value(forKey: "content") as! String
        self.userName = snapshot.value(forKey: "postId") as! String
        self.userImageUrl = snapshot.value(forKey: "userImageUrl") as! String
        self.key = snapshot.key
        
        
        
        }
    
    func toPost() -> [String : Any] {
        return["userName" : userName, "content" : content, "postId" : postId, "userImageUrl" : userImageUrl]
    }
    
}
