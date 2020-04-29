//
//  HeaderCollectionView.swift
//  Course2FinalTask
//
//  Created by Игорь on 24/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
//import DataProvider
import Kingfisher

struct Const {
    static let elementOffset: CGFloat = 8.0
}

class HeaderCollectionView: UICollectionReusableView {
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var FollowButton: UIButton!
    
    
    func setHeader(_ userData: User) {

        avatarImage.kf.setImage(with: userData.avatar!)
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
        
        userNameLabel.text = userData.fullName
        userNameLabel.textColor = .black
        
        followersLabel.text = "Followers: " + String(userData.followedByCount!)
        
        followingLabel.text = "Following: " + String(userData.followsCount!)
        
        FollowButton.layer.cornerRadius = 7
    }
    
    func setEmptyHeader()  {
        userNameLabel.text = "username"
        userNameLabel.textColor = .black
        
        followersLabel.text = "Followers: 0"
        
        followingLabel.text = "Following: 0"
        
        FollowButton.layer.cornerRadius = 7
    }
}
