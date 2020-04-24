import UIKit
import Foundation


class FilterViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    func setImage(_ image: UIImage){
        
        imageView.image = image
    }
    
}
