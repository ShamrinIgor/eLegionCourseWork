//
//  CollectionViewController.swift
//  Course2FinalTask
//
//  Created by Игорь on 24/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    
    var currentUser: User?
    var currentUserPosts: Posts?
    let reuseIdentefier = "kekCell"
    let reuseHeaderIdent = "kekHeader"
    
    var refreshControll: UIRefreshControl = {
         let rfControll = UIRefreshControl()
         rfControll.addTarget(self, action: #selector(refresh(sender:)),for: .valueChanged)
         return rfControll
     }()
    
    @objc private func refresh(sender: UIRefreshControl) {
           getPostsForCollectionView()
           myCollectionView.reloadData()
           sender.endRefreshing()
       }
    
    var currentUserPhotosURLs: [URL] {
        get {
            var URLs: [URL] = []
            if let posts = currentUserPosts?.posts {
                for post in posts {
                    URLs.append(post.image!)
                }
            }
            return URLs
        }
    }
    
    func getPostsForCollectionView() {
        let group = DispatchGroup()
        DispatchQueue.global().async(group: group) {
            group.enter()
            getUserMe(token: token) {
                result in
                switch result {
                case .success(let user):
                    self.currentUser = user
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
            getPosts(ofUserWithId: self.currentUser!.id!, token: token) {
                result in
                switch result {
                case .success(let posts):
                    self.currentUserPosts = posts
                    self.currentUserPosts!.posts = self.currentUserPosts!.posts.reversed()
                case .fail(let error):
                    print(error)
                case .badResponse(let res):
                    print(res)
                }
                group.leave()
            }
        }
        group.wait()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollectionView.register(UINib(nibName: String(describing: CollectionViewCell.self), bundle: nil),  forCellWithReuseIdentifier: "kekCell")
        myCollectionView.register(UINib(nibName: String(describing: HeaderCollectionView.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdent)
        
        getPostsForCollectionView()
        
        myCollectionView.refreshControl = refreshControll
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        super.view.addSubview(myCollectionView)
        
        
        navigationBar.title = currentUser!.fullName
        navigationBar.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutButtonPressed))
    }
    
    @objc func logOutButtonPressed(sender: Any) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginScreenViewController")
        
        window.rootViewController = vc

        var options: UIView.AnimationOptions = .transitionFlipFromTop
        options.insert(.curveEaseOut)
        
        let duration: TimeInterval = 0.5

        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentUserPosts!.posts.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentefier, for: indexPath) as! CollectionViewCell
        cell.setImage(currentUserPhotosURLs[indexPath.item])
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        let view = myCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdent, for: indexPath) as! HeaderCollectionView
        view.setHeader(currentUser!)
        view.frame.size.height = 86
        view.FollowButton.isHidden = true
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 86.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = UIScreen.main.bounds.width/3
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0,
                            left: 0.0,
                            bottom: 0.0,
                            right: 0.0)
    }
    
}
