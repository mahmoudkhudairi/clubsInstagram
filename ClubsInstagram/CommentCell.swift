//
//  CommentCell.swift
//  ClubsInstagram
//
//  Created by mahmoud khudairi on 4/20/17.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
 
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    static let cellIdentifier = "CommentCell"
    static let cellNib = UINib(nibName: CommentCell.cellIdentifier, bundle: Bundle.main)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
