//
//  CommentsVC.swift
//  ClubsInstagram
//
//  Created by Kemuel Clyde Belderol on 19/04/2017.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController,UITextFieldDelegate {
    var currentPostID = ""
     var commentId :Int = 0
       let uid = FIRAuth.auth()!.currentUser!.uid
    var comments = [Comment]()
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
        fetchComments()
        postButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        self.commentTextField.text = ""
    }
   
    
    func handleSend() {
        ref.child("users").child(uid).observe(.value, with: { (snapshot) in
            guard let dict = snapshot.value as? NSDictionary
                else{return}
            let userName = dict["name"] as? String
            let userProfileImageUrl = dict["profileImageUrl"] as? String
            
        let refrence = FIRDatabase.database().reference().child("posts").child("\(self.currentPostID)").child("comments")
        let childRef = refrence.childByAutoId()
        let values: [String: Any] = ["content": self.commentTextField.text!,
        "userId": self.uid ,"userName": userName,"userImageUrl" :userProfileImageUrl]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
        }
            self.commentTextField.text = ""
              })
        self.commentsTableView.reloadData()
         
    }
    



    func fetchComments() {
        FIRDatabase.database().reference().child("posts").child(self.currentPostID).child("comments").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as?  [String: Any] {
             let comment = Comment(dictionary: dictionary)

                   self.comments.append(comment)
                
                DispatchQueue.main.async(execute: {
                    self.commentsTableView.reloadData()
                })
                
            }
            
        }, withCancel: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textField: commentTextField, moveDistance: -250, up: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField: commentTextField, moveDistance: -250, up: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
}
 

extension CommentsVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.cellIdentifier, for: indexPath) as? CommentCell else {  return UITableViewCell()}
        let comment = comments[indexPath.row]
        cell.userNameLabel.text = comment.userName
        cell.commentLabel.text = comment.content
        if let profileImageUrl = comment.userImageUrl {
            cell.userProfilePicture.loadImageUsingCacheWithUrlString(profileImageUrl)
            cell.userProfilePicture.circlerImage()
           
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
