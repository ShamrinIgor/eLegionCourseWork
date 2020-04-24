import Foundation
import UIKit
//import DataProvider

class NewpostViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    let reuseIdentefier = "kekCell"
    let reuseHeaderIdent = "kekHeader"
    var userGallery: [UIImage] = []
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
    
        myCollectionView.register(UINib(nibName: String(describing: CollectionViewCell.self), bundle: nil),  forCellWithReuseIdentifier: "kekCell")
            
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        super.view.addSubview(myCollectionView)
        
//        userGallery = DataProviders.shared.photoProvider.photos()
        for i in 1...8 {
            userGallery.append(UIImage(named: "new" + String(i))!)
            print(i)
        }
        print(userGallery)
        
        navigationBar.title = "New Post"
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(userGallery.count)
        return userGallery.count

    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentefier, for: indexPath) as! CollectionViewCell
        cell.setImageFromAsset(userGallery[indexPath.item])
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FilterViewController {

            let passedImage = userGallery[selectedIndex]
            destination.image = passedImage
            destination.imageIndex = selectedIndex
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myCollectionView.deselectItem(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        print(selectedIndex)
        performSegue(withIdentifier: "toFilterList", sender: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = UIScreen.main.bounds.width/3
        return CGSize(width: itemWidth, height: itemWidth)
    }


}

