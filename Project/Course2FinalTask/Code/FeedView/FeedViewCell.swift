
import UIKit
//import DataProvider
import Kingfisher

class FeedViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
 
    @IBOutlet weak var postImage: UIImageView!

    @IBOutlet weak var likesCounterLabel: UILabel!
 
    @IBOutlet weak var likeBackgroundView: UIView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var likeImage: UIImageView!
    
    @IBOutlet weak var bigLikeImage: UIImageView!
    
    var post: Posts.Post?
    var postIndex: Int = 0
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(with post: Posts.Post, index: Int) {

        self.post = post
        self.postIndex = index
        
        avatarImage.kf.setImage(with: post.authorAvatar!)
//        avatarImage.image = post.authorAvatar
        
        userNameLabel.text = post.authorUsername
        
        let date = post.createdTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        let dateString = dateFormatter.string(from: date!)
        dateLabel.text = dateString
        
        postImage.kf.setImage(with: post.image!)
        likeImage.image =  UIImage(named: "like")
        likeImage.tintColor = .lightGray
        
        likesCounterLabel.text = "Likes: " + String(post.likedByCount!)
        
        descriptionLabel.text = post.description
        
        bigLikeImage.image = UIImage(named: "bigLike")
        bigLikeImage.alpha = 0
        
        let doubleTapGesRec = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureRecognizer(recognizer:)))
        doubleTapGesRec.numberOfTapsRequired = 2
        postImage.addGestureRecognizer(doubleTapGesRec)
        
        setNeedsLayout()
    }
    
    @objc
    func doubleTapGestureRecognizer(recognizer: UITapGestureRecognizer) {
        
        let likeAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
        likeAnimation.values = [0, 1, 1, 0]
        likeAnimation.keyTimes = [0, 0.1, 0.3, 1.2]
        likeAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear), CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut), CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut) ]
        bigLikeImage.layer.add(likeAnimation, forKey: "doubleTapLike")
 
        changeLikeButtonViewToRed()
        
        DispatchQueue.global().async {
            likePost(withID: self.post!.id!, token: token) { result in
                switch result {
                case .success(let post):
                    print(post)
                    posts?.posts[self.postIndex] = post
                    self.post = post
                case .fail(let error):
                    print(error)
                case .badResponse(let res):
                    print(res)
                }
            }
        }
        likesCounterLabel.text = "Likes: " + String(self.post!.likedByCount! + 1)
        
    }
    
    func changeLikeButtonViewToRed() {
        let likeButtonAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        likeButtonAnimation.fromValue = likeImage.tintColor
        likeButtonAnimation.toValue = UIColor.red
        likeButtonAnimation.duration = 0.5
        likeImage.layer.add(likeButtonAnimation, forKey: "lol")
        likeImage.tintColor = .red
    }
    
    func changeLikeButtonViewToGrey(){
        let likeButtonAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.backgroundColor))
        likeButtonAnimation.fromValue = likeImage.tintColor
        likeButtonAnimation.toValue = UIColor.red
        likeButtonAnimation.duration = 0.5
        likeImage.layer.add(likeButtonAnimation, forKey: "lol")
        likeImage.tintColor = .systemGray
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        if !post!.currentUserLikesThisPost! {
            changeLikeButtonViewToRed()
            DispatchQueue.global().async {
                likePost(withID: self.post!.id!, token: token) { result in
                    switch result {
                    case .success(let post):
                        print(post)
                        posts?.posts[self.postIndex] = post
                        self.post = post
                    case .fail(let error):
                        print(error)
                    case .badResponse(let res):
                        print(res)
                    }
                }
            }
        } else {
            changeLikeButtonViewToGrey()
            DispatchQueue.global().async {
                unlikePost(withID: self.post!.id!, token: token) { result in
                    switch result {
                    case .success(let post):
                        print(post)
                        posts?.posts[self.postIndex] = post
                        self.post = post
                    case .fail(let error):
                        print(error)
                    case .badResponse(let res):
                        print(res)
                    }
                }
            }
        }
    }
}
