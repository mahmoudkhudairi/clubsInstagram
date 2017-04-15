//
//  SearchVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class SearchVC: UIViewController {
var users = [User]()
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    @IBOutlet weak var friendsTableView: UITableView!{
        didSet{
         friendsTableView.register(FriendCell.cellNib, forCellReuseIdentifier: FriendCell.cellIdentifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
fetchUser()
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        
    }
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                
                self.users.append(user)
                
               
                DispatchQueue.main.async(execute: {
                    self.friendsTableView.reloadData()
                })
                
            }
            
        }, withCancel: nil)
    }


}
extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return users.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.cellIdentifier, for: indexPath) as? FriendCell else {  return UITableViewCell()}
       
        let user = users[indexPath.row]
        cell.userNameLabel.text = user.name
        
        if let profileImageUrl = user.profileImageUrl {
         print("userImage: ",user.profileImageUrl ?? "")
 
            cell.userImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            cell.userImageView.circlerImage()
        }
        
        return cell
    }
        
   
    
}
