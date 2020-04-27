//
//  AlertForOfflineMode.swift
//  Course2FinalTask
//
//  Created by Игорь on 25.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

class AlertForOfflineMode {
    
    class func showBasic(title: String, message: String, vc: UIViewController, buttonHandler: @escaping (UIAlertAction) -> Void) {
        
        let alert = UIAlertController(title: "Connection error", message: "The server is not responding", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Go offline", style: .default, handler: buttonHandler))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
}
