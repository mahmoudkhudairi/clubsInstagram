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
    @IBOutlet weak var friendsTableView: UITableView!
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
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell", for: indexPath)
        print("Im here")
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        
        if let profileImageUrl = user.profileImageUrl {
          // cell.imageView?.image = UIImage(named: "uploadImage") //this was for testing it work
            cell.imageView?.loadImageUsingCacheWithUrlString(profileImageUrl)//this is not showing images!!
        }
        
        return cell
    }
    
}
