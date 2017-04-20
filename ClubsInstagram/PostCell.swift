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
    func likeImageTapped(withID : String)
    func goToCommentVC(withID : String?)
}
class PostCell: UITableViewCell {

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
    
    var numberOflikes = Int()
    var likeIsTapped  = false
    static let cellIdentifier = "PostCell"
    static let cellNib = UINib(nibName: PostCell.cellIdentifier, bundle: Bundle.main)
    override func awakeFromNib() {
        super.awakeFromNib()
//        var like = likeImageIstapped()
      
         
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
 
    
     func observeLikesOnPost(_ postID: String) {
        //FIRDatabase.database().reference().child("posts").child(postID).child("numberOfLikes").observe(.value, with: { (snapshot) in
        
       
            print("hi From DelegateCell")
       // })
     }
     func callTapGesture(){
     
        //numberOflikes += 1
     let tapLike = UITapGestureRecognizer(target: self, action: #selector(self.handleLike))
     tapLike.numberOfTapsRequired = 2
     likeImage.addGestureRecognizer(tapLike)
     likeImage.isUserInteractionEnabled = true
        let tapComment = UITapGestureRecognizer(target: self, action: #selector(self.handleComment))
       
        commentImage.addGestureRecognizer(tapComment)
        commentImage.isUserInteractionEnabled = true
     }

    func handleComment(){
        delegate?.goToCommentVC(withID: postIdentifier)
//        let commentVCController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentVC")
//         present(commentVCController, animated: true, completion: nil)
       
    }
     func handleLike (){
        print("hi from handleLike")
//      numberOflikes += 1
  //  likeImage.image = UIImage(named: "filled-heart")
//        
        if let postIdentifier = postIdentifier{
            delegate?.likeImageTapped(withID: postIdentifier)
        }
        
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
         })
         ref.removeAllObservers()
         
         }
    //checking already liked
    func checkLiked(postID:String, indexpath:IndexPath) {
       // let cell = self.postsTableView.cellForRow(at: indexpath) as! PostCell
        
        let uid = FIRAuth.auth()!.currentUser!.uid
        var isLiked = false
        let ref = FIRDatabase.database().reference()
        
        ref.child("posts").child(postID).child("likes").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount)
           
            if let likes = snapshot.value as? [String : AnyObject] {
                for (ke, _) in likes {
                    if ke  == uid {
                        isLiked = true
                        self.likeImage.image = UIImage(named: "filled-heart")
                        
                        
                    }
                }
            }
            if !isLiked{
                //change empty
                self.likeImage.image = UIImage(named: "empty-heart")
            }
           
               self.numberOfLikesLabel.text = String(snapshot.childrenCount)
        
            
           
        })
        
   
    }

    
      
       
     }
    
    
    
    
    

