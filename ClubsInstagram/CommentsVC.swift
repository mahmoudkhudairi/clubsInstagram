//
//  CommentsVC.swift
//  ClubsInstagram
//
//  Created by Kemuel Clyde Belderol on 19/04/2017.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController {
    
    var ref : FIRDatabaseReference = FIRDatabase.database().reference()
    var comments = [Comment]()
    var selectedPost : Post?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    
    
//    func addCommentToPost() {
//        ref.child("posts").observe(.childAdded, with: { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                
//                let userName = dictionary["userName"] as? String
//                
//                let newComment = Comment(dictionary: dictionary)
//                    newComment.fromComment = snapshot.key
//                    //let comment = ["posts/\(newComment.fromComment!)" : ]
//                    
//                    FIRDatabase.database().reference().child("post").updateChildValues(comment)
//                
//                
//
//            }
//        })
//    }
    
    //ref.child("posts").setValue("comments")
    
}
