//
//  FlickrPhotosViewController.swift
//  Flickr Search
//
//  Created by neal on 2017/9/4.
//  Copyright © 2017年 neal. All rights reserved.
//

import UIKit


class FlickrPhotosViewController: UICollectionViewController {
    // MARK: - Properties

    fileprivate let reuseIdentifier = "FlickrCell"
    
    fileprivate let sectionInsets = UIEdgeInsetsMake(50.0, 20.0, 50.0, 20.0)
    
    fileprivate var searches = [FlickrSearchResults]()
    
    fileprivate let flickr = Flickr()
    
    let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

private extension FlickrPhotosViewController {
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as NSIndexPath).row]
    }
}

extension FlickrPhotosViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 1
        
        let  activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        flickr.searchFlickrForTerm(textField.text!) { (results, error) in
            activityIndicator.removeFromSuperview()
            
            if let error = error {
                // 2 
                print("Error searching: \(error)")
                return
            }
            
            if let results = results {
                // 3
                
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                
                self.searches.insert(results, at: 0)
                
                // 4
                self.collectionView?.reloadData()
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - UICollectionViewDataSource
extension FlickrPhotosViewController {
    // 1
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    // 2
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    // 3
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrPhotoCell
        
        // 2
        let flickrPhoto = photoForIndexPath(indexPath: indexPath)
        cell.backgroundColor = UIColor.white
        
        // 3
        cell.imageView.image = flickrPhoto.thumbnail
        
        return cell
    }
}

extension FlickrPhotosViewController : UICollectionViewDelegateFlowLayout {
    // 1
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let avaibleWidth = view.frame.width - paddingSpace
        let widthPerItem = avaibleWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
        
    }
    
    // 3 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}