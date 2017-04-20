//
//  UserCollectionViewCell.swift
//  
//
//  Created by Kemuel Clyde Belderol on 20/04/2017.
//
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    
}
