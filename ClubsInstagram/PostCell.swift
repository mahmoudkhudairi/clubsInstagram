//
//  PostCell.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
//1 declear
protocol PostCellDelegate: class {
    func goToCommentVC(withID : String?)
}
class PostCell: UITableViewCell {

    @IBOutlet weak var viewAllCommentsButton: UIButton!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var likeNumbersLabel: UILabel!
    @IBOutlet weak var captionTextView: UITextView!
   
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    //2 set
    
    weak var delegate : PostCellDelegate?
    var postIdentifier : String?
    static let cellIdentifier = "PostCell"
    static let cellNib = UINib(nibName: PostCell.cellIdentifier, bundle: Bundle.main)
    override func awakeFromNib() {
        super.awakeFromNib()
        viewAllCommentsButton.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        
    }
     func callTapGesture(){
     
        //numberOflikes += 1
     let tapLike = UITapGestureRecognizer(target: self, action: #selector(self.handleLike))
        let cellTapLike = UITapGestureRecognizer(target: self, action: #selector(self.handleLike))
     cellTapLike.numberOfTapsRequired = 2
        self.addGestureRecognizer(cellTapLike)
         self.isUserInteractionEnabled = true
     likeImage.addGestureRecognizer(tapLike)
     likeImage.isUserInteractionEnabled = true
        let tapComment = UITapGestureRecognizer(target: self, action: #selector(self.handleComment))
       
        commentImage.addGestureRecognizer(tapComment)
        commentImage.isUserInteractionEnabled = true
     }

    func handleComment(){
        delegate?.goToCommentVC(withID: postIdentifier)
    }
    func fetchComentsCount(){
        FIRDatabase.database().reference().child("posts").child(postIdentifier!).child("comments").observe(.value, with: { (snapshot) in
             self.viewAllCommentsButton.setTitle("View all \(snapshot.childrenCount) comments", for: .normal)
        })
    }
     func handleLike (){
         let uid = FIRAuth.auth()!.currentUser!.uid
         var isLiked = false
         let ref = FIRDatabase.database().reference()
         ref.child("posts").child(postIdentifier!).child("likes").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
         
         if let likes = snapshot.value as? [String : AnyObject] {
         for (ke, _) in likes {
         if ke  == FIRAuth.auth()?.currentUser?.uid {
         isLiked = true
         
         ref.child("posts").child(self.postIdentifier!).child("likes/\(ke)").removeValue()
         
         self.likeImage.image = UIImage(named: "empty-heart")
         
         }
         }
         }
         if !isLiked {
         let likes = ["likes/\(uid)" : true ]
         ref.child("posts").child(self.postIdentifier!).updateChildValues(likes)
         self.likeImage.image = UIImage(named: "filled-heart")
         
         }
            
            self.checkLiked(postID: self.postIdentifier!)
         })
         ref.removeAllObservers()
         
         }
    //checking already liked
    func checkLiked(postID:String) {
      
        let uid = FIRAuth.auth()!.currentUser!.uid
        var isLiked = false
        let ref = FIRDatabase.database().reference()
        
        ref.child("posts").child(postID).child("likes").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
           
            if let likes = snapshot.value as? [String : AnyObject] {
                for (ke, _) in likes {
                    if ke  == uid {
                        isLiked = true
                        self.likeImage.image = UIImage(named: "filled-heart")
                        
                        
                    }
                }
            }
            if !isLiked{
                self.likeImage.image = UIImage(named: "empty-heart")
            }
           
               let numberOfLikes = String(snapshot.childrenCount)
                self.numberOfLikesLabel.text = ("likes \(numberOfLikes)" )
        
            
           
        })
        
   
    }

    
      
       
     }
    
    
    
    
    

