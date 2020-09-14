//
//  ViewInboxItemViewController.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/3/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit
import VerticalCardSwiper
import SCSDKCreativeKit
import Kingfisher
import SVProgressHUD
import FirebaseFirestore
import StoreKit

class ViewInboxItemViewController: UIViewController {
    
    @IBOutlet weak var cardSwiper: VerticalCardSwiper!
    
    var inboxItem : InboxItem!
    
    @IBOutlet weak var shareOnSnapButton: BasicButton!
    @IBOutlet weak var snapchatImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardSwiper.delegate = self
        cardSwiper.datasource = self
        
        shareOnSnapButton.addShadows()
        snapchatImageView.layer.cornerRadius = snapchatImageView.frame.height/2
        
        navigationItem.largeTitleDisplayMode = .never
        configureForGender()
        cardSwiper.register(nib: UINib(nibName: "GameCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
        markItemAsReadIfNeeded()
        
        SKStoreReviewController.requestReview()
        // Do any additional setup after loading the view.
    }
    
    func markItemAsReadIfNeeded(){
        if !inboxItem.hasBeenOpened{
            let docRef = db.collection("users").document(User.shared!.uid).collection("inbox").document(inboxItem.documentID)
        
            docRef.setData(["hasBeenOpened" : true], merge: true)
            
        }
    }
    
    func configureForGender(){
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let downloadButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down", withConfiguration: config), style: .plain, target: self, action: #selector(downloadButtonPressed))
        if inboxItem.gender == .male{
            navigationItem.title = "From a guy"
            downloadButton.tintColor = .systemTeal
        }else if inboxItem.gender == .female{
            navigationItem.title = "From a girl"
            downloadButton.tintColor = .systemPink
        }else{
            navigationItem.title = "From someone"
            downloadButton.tintColor = .label
        }
        self.navigationItem.rightBarButtonItem  = downloadButton
    }
    
    func getCardImage(completion : @escaping (UIImage) -> Void){
        let resource = ImageResource(downloadURL: inboxItem.question.photoURL)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                SVProgressHUD.dismiss()
                let gif = value.image
                guard let focusedCardIndex = self.cardSwiper.focussedCardIndex else { return }
                guard let cell = self.cardSwiper.datasource?.cardForItemAt(verticalCardSwiperView: self.cardSwiper.verticalCardSwiperView, cardForItemAt: focusedCardIndex) as? GameCardCell else { return }
                cell.imageView.image = gif
                let image = cell.asImage()
                completion(image)
            case .failure( _):
                SVProgressHUD.showError(withStatus: "Error")
                
            }
        }
    }
    
    @objc func downloadButtonPressed(){
            saveCardToPhotoAlbum()
    }
    
    func saveCardToPhotoAlbum(){
        self.getCardImage { (image) in
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }

    @IBAction func shareOnSnapchatPressed(_ sender: Any) {
        self.getCardImage { (image) in
            SnapchatHelper.prepareSnap(stickerImage: image)
        }
    }
}


extension ViewInboxItemViewController : VerticalCardSwiperDelegate, VerticalCardSwiperDatasource{
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        return 1
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: index) as! GameCardCell
        
        cardCell.setUp(poll: inboxItem.question)
        
        return cardCell
    }
    
    
}

