//
//  LaunchScreenController.swift
//  Course2FinalTask
//
//  Created by Игорь on 16/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class LaunchScreenController: UIViewController {
    
    private let navigationBarView: UINavigationBar = {
        let nav = UINavigationBar(frame: .zero)
        // Configure navigation bar...
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 187/255, green: 42/255, blue: 97/255, alpha: 100)
        
        // Assign your delegate object
        self.navigationBarView.delegate = self
        
        let navBar = navigationBarView
        view.addSubview(navBar)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        // Any other view needs
    }
}

extension LaunchScreenController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}
