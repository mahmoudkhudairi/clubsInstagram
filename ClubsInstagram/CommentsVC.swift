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
    var currentPostID = ""
       let uid = FIRAuth.auth()!.currentUser!.uid
    var users = [User]()
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentsTableView: UITableView!{
        
        didSet{
            commentsTableView.register(CommentCell.cellNib, forCellReuseIdentifier: CommentCell.cellIdentifier)
        }
    }
    var ref : FIRDatabaseReference = FIRDatabase.database().reference()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        print("currentPostId:", currentPostID)
        fetchUser()
        postButton.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
    }
    func handlePost(){
     
        ref.child("posts").child(currentPostID).child("comments").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
//             let comment = ["likes/\(uid)" : true ]
//                ref.child("posts").child(self.postIdentifier!).updateChildValues(likes)
//                self.likeImage.image = UIImage(named: "filled-heart")
//            }
//        })
//        ref.removeAllObservers()
//        
//    }
//                
//     
//    }
   
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                
                    self.users.append(user)
                
                DispatchQueue.main.async(execute: {
                    self.commentsTableView.reloadData()
                })
                
            }
            
        }, withCancel: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
}
 

extension CommentsVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.cellIdentifier, for: indexPath) as? CommentCell else {  return UITableViewCell()}
        let user = users[indexPath.row]
        cell.userNameLabel.text = user.name
        cell.commentLabel.text = "this is test "
        if let profileImageUrl = user.profileImageUrl {
            cell.userProfilePicture.loadImageUsingCacheWithUrlString(profileImageUrl)
            cell.userProfilePicture.circlerImage()
           
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
