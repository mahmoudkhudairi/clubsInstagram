//
//  FriendCell.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/15/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
   
    static let cellIdentifier = "FriendCell"
    static let cellNib = UINib(nibName: FriendCell.cellIdentifier, bundle: Bundle.main)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
}
