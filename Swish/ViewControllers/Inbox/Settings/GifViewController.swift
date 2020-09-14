//
//  GiphyViewController.swift
//  Pidgin
//
//  Created by Atemnkeng Fontem on 3/3/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import CollectionViewWaterfallLayout
import DeepDiff
import Kingfisher
protocol GifDelegate {
    func didSelectItem(gif : URL, vc : GifViewController)
}

class GifViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate, UISearchBarDelegate {

    
    let cache = NSCache<NSString, NSURL>()

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let g = GiphyHelper(apiKey: "ycVkW6EycoaGG7YTEFCmIYFwpbEaOSHA")
    
    var gifs : [GiphyHelper.Gif] = [GiphyHelper.Gif]()
    
    var gifDeleagte : GifDelegate?
    
    var offset : UInt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        
        getGifs(removeAll: false)
        
        setUpCollectionView()
        
        searchBar.searchTextField.addDoneButtonOnKeyboard()
        
        let backButton = UIBarButtonItem()
        backButton.title = " " //in your case it will be empty or you can put the title of your choice
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        navigationItem.title = "Select GIF"
        
        
        self.searchBar.searchTextField.layer.cornerRadius = searchBar.searchTextField.frame.height * 0.35
        self.searchBar.searchTextField.font = AppHelper.shared.mediumFont(of: 17)
        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        offset = nil
        getGifs(removeAll: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        offset = nil
        getGifs(removeAll: true)
    }
    
    func getGifs(removeAll : Bool){
        if searchBar.text?.isEmpty ?? true{
        g.trending(20, offset: offset, rating: nil) { gifs, pagination, err in
            if let array = gifs{
                
                self.offset = (self.offset ?? 0) + UInt((pagination?.count ?? 0))
                self.reload(updates: array, removeAll: removeAll)
  
            }
            if let error = err{
                print(error.localizedDescription)
            }
        }
        }else{
            
        _ = g.search(searchBar.text!, limit: 20, offset: offset, rating: nil) { (gifs, pagination, err) in
                if let array = gifs{
                              
                    self.offset = (self.offset ?? 0) + UInt((pagination?.count ?? 0))
                    self.reload(updates: array, removeAll: removeAll)
                
                }
                if let error = err{
                              print(error.localizedDescription)
                          }
            }
            
        }
    }
    
    func reload(updates : [GiphyHelper.Gif], removeAll : Bool){
        
        let old = self.gifs
        var new = self.gifs
        if removeAll{
            new.removeAll()
        }
        new.append(contentsOf: updates)
    
        let changes = diff(old: old, new: new)
        DispatchQueue.main.async {
            self.collectionView.reload(changes: changes, section: 0, updateData: {
                self.gifs = new
            })
        }
    }
    
    func setUpCollectionView(){
        let layout = CollectionViewWaterfallLayout()
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            layout.columnCount = 2
        case .pad:
            // It's an iPad (or macOS Catalyst)
            layout.columnCount = 3
        default:
            // Uh, oh! What could it be?
            layout.columnCount = 2
        }
        
        layout.minimumColumnSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        collectionView.collectionViewLayout = layout
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "giphyCell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! AnimatedImageView
        let gif = gifs[indexPath.row]
        
        let id = gif.id
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        
        if let nsUrl = cache.object(forKey: id as NSString), let url = nsUrl.absoluteURL {
            // use the cached version
            DispatchQueue.main.async {
                    imageView.kf.setImage(with: url, placeholder: UIImage()) { (result) in
                    }
            }
        }
         else {
            let data = gif.gifMetadataForType(.FixedWidth, still: false)
            let url = data.URL
            self.cache.setObject(url as NSURL, forKey: id as NSString)
            imageView.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = gifs[indexPath.row]
        let data = gif.gifMetadataForType(.FixedWidth, still: false)
        let url = data.URL
        self.gifDeleagte?.didSelectItem(gif: url, vc: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row + 1 == gifs.count{
            getGifs(removeAll: false)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let gif = gifs[indexPath.row]
        let data = gif.gifMetadataForType(.FixedWidthDownsampled, still: true)
        
        return CGSize(width: data.width, height: data.height)
    }

}
