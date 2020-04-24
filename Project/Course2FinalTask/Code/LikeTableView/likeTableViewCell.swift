//
//  likeTableViewCell.swift
//  Course2FinalTask
//
//  Created by Игорь on 26/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class likeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(_ user: User) {
        
        avatarImage.kf.setImage(with: user.avatar!)
        
        userNameLabel.text = user.fullName

    }

}
