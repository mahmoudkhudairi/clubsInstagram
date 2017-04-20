//
//  ExpCollectionViewCell.swift
//  
//
//  Created by Kemuel Clyde Belderol on 21/04/2017.
//
//

import UIKit

class ExpCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
