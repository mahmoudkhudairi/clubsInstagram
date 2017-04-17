//
//  SearchVC.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit
import Firebase
class SearchVC: UIViewController,UISearchBarDelegate {
    var users = [User]()
    var filterdUsers = [User]()
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    @IBOutlet weak var friendsTableView: UITableView!{
        didSet{
         friendsTableView.register(FriendCell.cellNib, forCellReuseIdentifier: FriendCell.cellIdentifier)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
    
        friendsTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        
      
        setupSearchBar()
    }
    func setupSearchBar() {
        let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:70))
        searchBar.delegate = self
        self.friendsTableView.tableHeaderView = searchBar
    }
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filterdUsers = users
            self.friendsTableView.reloadData()
        }else {
            filterTableView(text: searchText)
        }
    }
    
    func filterTableView(text:String) {
        
            //fix of not searching when backspacing
            filterdUsers = users.filter({ (user) -> Bool in
                return (user.name?.lowercased().contains(text.lowercased()))!
            })
            self.friendsTableView.reloadData()
      
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                if(user.id == FIRAuth.auth()?.currentUser?.uid)
                {
                    
                }else{
                self.users.append(user)
                  self.filterdUsers = self.users
            }
                DispatchQueue.main.async(execute: {
                    self.friendsTableView.reloadData()
                })
                
            }
            
        }, withCancel: nil)
    }


}
extension SearchVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return filterdUsers.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendCell.cellIdentifier, for: indexPath) as? FriendCell else {  return UITableViewCell()}
       
        let user = filterdUsers[indexPath.row]
        cell.userNameLabel.text = user.name
        
        if let profileImageUrl = user.profileImageUrl {
         print("userImage: ",user.profileImageUrl ?? "")
 
            cell.userImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            cell.userImageView.circlerImage()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let desController = FriendProfileVC()
       let selectedUser = users[indexPath.row]
        
     //desController.currentUserID = selectedUser.id!
        
        guard let friendVCController = storyboard?.instantiateViewController(withIdentifier: "FriendProfileVC") as? FriendProfileVC else { return }
        friendVCController.currentUserID = selectedUser.id!
        
      present(friendVCController, animated: true, completion: nil)
        
       
        
    }
        
   
    
}
