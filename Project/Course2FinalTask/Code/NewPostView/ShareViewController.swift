import UIKit
//import DataProvider
import Foundation


class ShareViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var imageToShare: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = imageToShare
        
    }
    
    @IBAction func ShareButtonPressed(_ sender: Any) {
        
        if isOfflineMode {
            Alert.showBasic(title: "Error!", message: "You can't share photo in offline mode", vc: self)
        } else {
            createPost(token: token, image: self.imageView.image!, description: descriptionTextField.text!) { result  in
                switch result {
                    
                case .success(let post):
                    print(post)
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                case .fail(let error):
                    print(error)
                    
                case .badResponse(let res):
                    print(res)
                }
            }
        }
    }
}
