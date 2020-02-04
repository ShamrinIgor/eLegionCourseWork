//
//  likeTableViewController.swift
//  Course2FinalTask
//
//  Created by Игорь on 26/09/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit
//import DataProvider

class likeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    public var usersLikeThisPost: Users?
    public var postID: Int?
//    public var postID: Int?
    
    var selectedIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let group = DispatchGroup()
        DispatchQueue.global().async(group: group) {
            group.enter()
            getUserLikedPost(withId: self.postID!, token: token) { result in
                switch result {
                case .success(let users):
                    self.usersLikeThisPost = users
                    print("Uraaa", users)
                case .fail(let error):
                    print("NEUraaa", error)
                case .badResponse(let res):
                    print(res)
                }
                group.leave()
            }
        }
        group.wait()
        
        view.bringSubviewToFront(loadingSpinner)
        loadingSpinner.style = .whiteLarge
        loadingSpinner.backgroundColor = (UIColor (white: 0.3, alpha: 0.8))
        loadingSpinner.layer.cornerRadius = 10
        loadingSpinner.frame = CGRect(x: 0.0, y: 0.0, width: 60, height: 60)
        loadingSpinner.center = (self.navigationController?.view.center)!
        loadingSpinner.isHidden = true
        
        tableView.reloadData()
        tableView.setNeedsLayout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersLikeThisPost!.users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: "kekLikeCell")) as! likeTableViewCell
        cell.frame.size.height = 45
        cell.setCell(usersLikeThisPost!.users[indexPath.row])
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? OtherUserProfileControllerViewController {
            let passedUserID = usersLikeThisPost!.users[selectedIndex].id
            destination.userID = passedUserID
            loadingSpinner.isHidden = true
        }
    }
    
    
    @IBAction func cellPressed(_ sender: Any) {
        let buttonPosition = (sender as AnyObject).convert(CGPoint(), to:tableView)
        let indexPath = tableView.indexPathForRow(at:buttonPosition)
        selectedIndex = indexPath?.row ?? 0
        print("You selected cell #\(selectedIndex)!")
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            self.loadingSpinner.isHidden = false
            self.loadingSpinner.startAnimating()
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.performSegue(withIdentifier: "fromLikeTableToProfile", sender: nil)
        }
        
    }
    

}
