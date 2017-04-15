//
//  PostCell.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/14/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var likeNumbersLabel: UILabel!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    static let cellIdentifier = "PostCell"
    static let cellNib = UINib(nibName: PostCell.cellIdentifier, bundle: Bundle.main)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
