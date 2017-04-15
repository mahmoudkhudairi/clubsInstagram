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
    var posts = [Post]()
    
    @IBOutlet weak var postsTableView: UITableView!{
         didSet{
         postsTableView.register(PostCell.cellNib, forCellReuseIdentifier: PostCell.cellIdentifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.delegate = self
        postsTableView.dataSource = self
        checkIfUserIsLoggedIn()
        fetchPost()
        
    }

    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else
        {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                if let dictionary = snapshot.value as? [String: Any]
                {
                    self.navigationItem.title = dictionary["name"] as? String
                }
                
            })
        }
        
    }
    
   
    func handleLogout() {
        
//        let fireLogOut = AuthController()
//        
//        fireLogOut.logout()
//        
        guard let loginController = storyboard?.instantiateViewController(withIdentifier: "LoginVC")else{return}
        
        present(loginController, animated: true, completion: nil)
        
      
    }
    
    func fetchPost() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let post = Post(dictionary: dictionary)
                post.id = snapshot.key
                
                self.posts.append(post)
                
                
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
        cell.userNameLabel.text = "username"
        // cell.userProfileImageView =
        
        if let postImageUrl = post.postImageUrl {
            cell.postImage.loadImageUsingCacheWithUrlString(postImageUrl)
        }
         cell.captionTextView.text = post.caption
        return cell
    }
    
    
    
}
