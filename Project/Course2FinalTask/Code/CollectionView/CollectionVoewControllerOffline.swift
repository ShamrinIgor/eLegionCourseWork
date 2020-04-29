//
//  CollectionVoewControllerOffline.swift
//  Course2FinalTask
//
//  Created by Игорь on 25.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewControllerOffline: CollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.register(UINib(nibName: String(describing: CollectionViewCell.self), bundle: nil),  forCellWithReuseIdentifier: "kekCell")
        myCollectionView.register(UINib(nibName: String(describing: HeaderCollectionView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdent)
        
//        getPostsForCollectionView()
        self.currentUserPosts = Posts()
        
        myCollectionView.refreshControl = refreshControll
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        super.view.addSubview(myCollectionView)
        
        
        navigationBar.title = currentUser!.fullName
        navigationBar.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonPressed))
    }
}
