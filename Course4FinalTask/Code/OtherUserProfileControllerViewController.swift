//
//  OtherUserProfileControllerViewController.swift
//  Course2FinalTask
//
//  Created by Игорь on 27/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
//import DataProvider


class OtherUserProfileControllerViewController: CollectionViewController {

    var user: User?
    var userID: Int?
    var userPosts: Posts?
//    var token: String?
    
    override func viewDidLoad() {
        myCollectionView.register(UINib(nibName: String(describing: CollectionViewCell.self), bundle: nil),  forCellWithReuseIdentifier: "kekCell")
        myCollectionView.register(UINib(nibName: String(describing: HeaderCollectionView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdent)
        
        navigationBar.title = user?.fullName
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        let group = DispatchGroup()
        DispatchQueue.global().async(group: group) {
            group.enter()
            print("bidlo")
            getUser(withId: self.userID!, token: token) {
                    result in

                    switch result {
                    case .success(let passedUser):
                        self.user = passedUser
                    case .fail(let error):
                        print(error)
                    case .badResponse(let res):
                        print(res)
                    }
                    group.leave()
                }
        }
        group.wait()
        
        DispatchQueue.global().async(group: group) {
        group.enter()
            getPosts(ofUserWithId: self.userID!, token: token) {
                result in

                switch result {
                case .success(let posts):
                    self.userPosts = posts
                case .fail(let error):
                    print(error)
                case .badResponse(let res):
                    print(res)
                }
                group.leave()
            }
        }
        group.wait()
    
        super.view.addSubview(myCollectionView)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPosts!.posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var photos: [URL] = []
        for post in userPosts!.posts {
            photos.append(post.image!)
        }

        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentefier, for: indexPath) as! CollectionViewCell
        cell.setImage(photos[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = myCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdent, for: indexPath) as! HeaderCollectionView
        view.setHeader(user!)
        view.frame.size.height = 86
        view.FollowButton.addTarget(self, action: #selector(FollowButtonPressed(sender:)), for: .touchUpInside)
        
        if user!.currentUserFollowsThisUser! {
            view.FollowButton.setTitle("Unfollow", for: .normal)
        }
        
        return view
    }
    
    @objc
    func FollowButtonPressed(sender: UIButton!) {
        
        if (sender.titleLabel?.text == "Follow") {
            followUser(withID: userID!, token: token) { result in
                switch result {
                case .success(let user):
                    self.user = user
                    DispatchQueue.main.async {
                        sender.setTitle("Unfollow", for: .normal)
                    }
                case .fail(let error):
                    print(error)
                case .badResponse(let res):
                    print(res)
                    DispatchQueue.main.async {
                        Alert.showBasic(title: "Error!", message:  "Попытка подписаться на самого себя", vc: self)
                    }
                }
            }
        }
        else {
            unfollowUser(withID: userID!, token: token) { result in
                switch result {
                case .success(let user):
                    self.user = user
                    DispatchQueue.main.async {
                        sender.setTitle("Follow", for: .normal)
                    }
                case .fail(let error):
                    print(error)
                case .badResponse(let res):
                    print(res)
                    DispatchQueue.main.async {
                        Alert.showBasic(title: "Error!", message:  "Попытка отписаться от самого себя", vc: self)
                    }
                }
            }
        }
    }
}
