//
//  CustomImageFlowLayout.swift
//  ClubsInstagram
//
//  Created by Kemuel Clyde Belderol on 20/04/2017.
//  Copyright © 2017 mahmoud khudairi. All rights reserved.
//

import UIKit

class CustomImageFlowLayout: UICollectionViewFlowLayout {

    override init(){
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    
    }
    
    override var itemSize: CGSize{
        set {
        
        }
        get {
            let numberOfColumns: CGFloat = 3
            
            let itemWidth = (self.collectionView!.frame.width - (numberOfColumns - 1)) / numberOfColumns
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    func setupLayout(){
        
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    
}
