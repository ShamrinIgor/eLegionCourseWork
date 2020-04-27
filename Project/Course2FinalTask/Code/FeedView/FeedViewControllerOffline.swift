//
//  FeedViewControllerOffline.swift
//  Course2FinalTask
//
//  Created by Игорь on 25.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class FeedViewControllerOffline: FeedTableViewController {
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        tableView.register(FeedViewCell.self, forCellReuseIdentifier: "kekCellid")
        
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControll
        
        tableView.delegate = self
        tableView.dataSource = self
            
        viewConfiger()
    }
    
    override func getPostsInTableViewController() {
        posts = Posts()
    }
}
