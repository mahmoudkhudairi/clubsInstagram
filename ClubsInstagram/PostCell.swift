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
    func likeImageTapped(withID : String, withNum : Int)
}
class PostCell: UITableViewCell {

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
    
 
     
//     func observeLikesOnPost(_ postID: String) {
//        FIRDatabase.database().reference().child("posts").child(postID).child("numberOfLikes").observe(.value, with: { (snapshot) in
//            
//            
//            print("postLikes",snapshot)
//        })
//     }
     func callTapGesture(){
     
        //numberOflikes += 1
     let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleLike))
     tap.numberOfTapsRequired = 1
     self.addGestureRecognizer(tap)
     self.isUserInteractionEnabled = true
     }
//
     func handleLike (){
      numberOflikes += 1
    likeImage.image = UIImage(named: "filled-heart")
        
        if let postIdentifier = postIdentifier{
            delegate?.likeImageTapped(withID: postIdentifier, withNum: numberOflikes)
        }
     
     }
    
    
    
    
    


    
    
}
