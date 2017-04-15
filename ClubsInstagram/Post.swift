//
//  Post.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/15/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class Post: NSObject {
    var id: String?
    var userId : String?
    var caption: String?
    var postImageUrl: String?
    init(dictionary: [String: AnyObject]) {
        
        self.id = dictionary["id"] as? String
        self.userId = dictionary["userId"] as? String
        self.caption = dictionary["caption"] as? String
        self.postImageUrl = dictionary["postImageUrl"] as? String
    }
}
