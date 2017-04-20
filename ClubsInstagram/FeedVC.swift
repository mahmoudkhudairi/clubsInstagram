//
//  FeedVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class FeedVC: UIViewController {
    //var uid = FIRAuth.auth()?.currentUser?.uid
    var posts = [Post]()
    var following = [String]()
    var postsUsersIds = [String]()
    @IBOutlet weak var postsTableView: UITableView!{
        didSet{
            postsTableView.register(PostCell.cellNib, forCellReuseIdentifier: PostCell.cellIdentifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        self.posts.removeAll()
        
        fetchUsers()
        fetchPost()
        
        
        postsTableView.reloadData()
        
        
        
    }
    
    
    
    func fetchUsers() {
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("following").observe(.childAdded, with: { (snapshot) in
            guard snapshot.exists() else { return }
            
            let allId = snapshot.key
            self.following.append(allId)
            print("I am following",allId)
            
            
            
            
            DispatchQueue.main.async(execute: {
                self.postsTableView.reloadData()
            })
            
        }, withCancel: nil)
        
        //self.filterPost()
    }
    
    /*func filterPost() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post(dictionary: dictionary)
                post.id = snapshot.key
                let userID = dictionary["userId"] as? String
                
                //print("Id of postID", userID ?? "lol")
                
                
                for each in self.following {
                    if userID == each {
                        let caption = dictionary["caption"] as? String
                        let postImageUrl = dictionary["postImageUrl"] as? String
                        let userName = dictionary["userName"] as? String
                        let userProfileImageURL = dictionary["userProfileImageURL"] as? String
                        
                        
                        
                        
                        let postByFollowed = Post(userName: userName!, caption: caption!, postImageUrl: postImageUrl!, userProfileImageURL: userProfileImageURL!, id: post.id!)
                        
                        self.posts.append(postByFollowed)
                        
                    }
                }
                
                
                
                DispatchQueue.main.async(execute: {
                    self.postsTableView.reloadData()
                })
                
            }
            
        }, withCancel: nil)
    } */
    
    
    func fetchPost() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post(dictionary: dictionary)
                post.id = snapshot.key
                
                
                self.posts.append(post)
                self.postsUsersIds.append(post.userId!)
                print("postUserIdsArray: ",self.postsUsersIds)
                
                
                
                
                
                DispatchQueue.main.async(execute: {
                    self.postsTableView.reloadData()
                })
                
            }
            
        }, withCancel: nil)
    }
    
}

extension FeedVC: UITableViewDelegate,UITableViewDataSource{
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.cellIdentifier, for: indexPath) as? PostCell else {  return UITableViewCell()}
        
        let post = posts[indexPath.row]
        
        cell.userNameLabel.text = post.userName
        if let userProfileImageUrl = post.userProfileImageUrl {
            cell.userProfileImageView.loadImageUsingCacheWithUrlString(userProfileImageUrl)
        }
        
        if let postImageUrl = post.postImageUrl {
            cell.postImage.loadImageUsingCacheWithUrlString(postImageUrl)
        }
        cell.userProfileImageView.layer.cornerRadius = 15
        cell.userProfileImageView.layer.borderWidth = 1.0
        cell.userProfileImageView.layer.borderColor = UIColor.yellow.cgColor
        cell.captionTextView.text = post.caption
        cell.callTapGesture()
        cell.postIdentifier = post.id
        cell.checkLiked(postID: post.id!)
        cell.fetchComentsCount()
        
        
        //        cell.observeLikesOnPost(post.id!)
        //
        
        //3 conform
        cell.delegate = self
        //cell.updatepostLikesNumber(post.id!)
        return cell
    }
    internal func likeImageIstapped() -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.postsTableView.deselectRow(at: indexPath, animated: true)
    }
}


extension FeedVC : PostCellDelegate {
    func goToCommentVC(withID: String?) {
        guard let navController = storyboard?.instantiateViewController(withIdentifier: "CommentVCNAV") as? UINavigationController else { return }
        let commentVCController = navController.childViewControllers.first as? CommentsVC
        commentVCController?.currentPostID = withID!
        present(navController, animated: true, completion: nil)
    }
}

