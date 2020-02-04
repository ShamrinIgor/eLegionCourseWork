//import DataProvider
import Foundation
import UIKit

class FilterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    var imageIndex: Int? 
    var image: UIImage?
    var imageForFilter: UIImage?
//    let imageArray = DataProviders.shared.photoProvider.photos()
    let listOfFilters = ["CIColorInvert", "CIPhotoEffectNoir", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectChrome", "CIVignetteEffect"]
    let listOfFiltersNames = ["ColorInvert", "Noir", "EffectInstant", "Mono", "Chrome", "Vignette"]
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        imageView.image = self.image
//        imageForFilter = DataProviders.shared.photoProvider.thumbnailPhotos()[imageIndex!]
        imageForFilter = image?.resized(toWidth: 70.0)
        
        loadingSpinner.style = .whiteLarge
        loadingSpinner.backgroundColor = (UIColor (white: 0.3, alpha: 0.8))
        loadingSpinner.layer.cornerRadius = 10
        loadingSpinner.frame = CGRect(x: 0.0, y: 0.0, width: 60, height: 60)
        loadingSpinner.center = (self.navigationController?.view.center)!
        loadingSpinner.isHidden = true
    }
    
    private func applyFilter(name: String, params: [String: Any]) -> UIImage? {
        // 5
        let context = CIContext()
        guard let filter = CIFilter(name: name, parameters: params),
//        guard let filter = CIFilter(name: name),

        let outputImage = filter.outputImage,
        // 7
        let cgiimage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        // 8
        return UIImage(cgImage: cgiimage)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterViewCell
        cell.imageView.image = imageForFilter
        cell.filterNameLabel.text = "Bidlo"
        
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "applyFilter")
        var filteredImage: UIImage?
        group.enter()
        queue.async {
            let ciimage = CIImage(image: self.imageForFilter!)
            filteredImage = self.applyFilter(name: self.listOfFilters[indexPath.row], params: [kCIInputImageKey: ciimage!])
            group.leave()
        }

        group.notify(queue: .main) {
            cell.imageView.image = filteredImage
            cell.filterNameLabel.text = self.listOfFiltersNames[indexPath.row]
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimating()
        let queue = DispatchQueue(label: "apllyFilterToMainImage")
        let group = DispatchGroup()
        var filteredImage: UIImage?
        group.enter()
        queue.async {
            let ciimage = CIImage(image: self.image!)
            filteredImage = self.applyFilter(name: self.listOfFilters[indexPath.row], params: [kCIInputImageKey: ciimage!])
            group.leave()
        }
        group.notify(queue: .main) {
            self.imageView.image = filteredImage
            self.loadingSpinner.isHidden = true
        }
    }
    
    
    @IBAction func NextButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toShareScreen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ShareViewController {
            destination.imageToShare = self.imageView.image
        }
    }
    
    
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
