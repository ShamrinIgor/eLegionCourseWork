//
//  CollectionViewCell.swift
//  Course2FinalTask
//
//  Created by Игорь on 24/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    func setImage(_ image: URL){
        imageView.kf.setImage(with: image)
    }
    
    func setImageFromAsset(_ image: UIImage){
        
        imageView.image = image
    }
}
