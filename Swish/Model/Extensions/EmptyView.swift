//
//  EmptyView.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/9/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

extension UITableView {
    
    func setEmptyView(title: String, message: String, messageImage: UIImage) {
        self.backgroundView = getEmptyView(title: title, message: message, messageImage: messageImage)
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
}

extension UICollectionView {
    
    func setEmptyView(title: String, message: String, messageImage: UIImage) {
        self.backgroundView = getEmptyView(title: title, message: message, messageImage: messageImage)
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
}

extension UIScrollView {
    func getEmptyView(title: String, message: String, messageImage: UIImage) -> UIView {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width-32, height: self.bounds.size.height))
        
        let messageImageView = UIImageView()
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        
        messageImageView.backgroundColor = .clear
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = UIColor.secondaryLabel
        titleLabel.font = AppHelper.shared.boldFont(of: 21)
        titleLabel.numberOfLines = 0
        
        messageLabel.textColor = UIColor.secondaryLabel
        messageLabel.font = AppHelper.shared.mediumFont(of: 17)
        titleLabel.numberOfLines = 0
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageImageView)
        emptyView.addSubview(messageLabel)
        
        messageImageView.contentMode = .scaleAspectFit
        messageImageView.tintColor = .secondaryLabel
        
        messageImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        messageImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        messageImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: messageImageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: emptyView.trailingAnchor, multiplier: 1).isActive = true
        messageLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: emptyView.leadingAnchor, multiplier: 1).isActive = true
        
        messageImageView.image = messageImage
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        UIView.animate(withDuration: 1, animations: {
            
            messageImageView.transform = CGAffineTransform(rotationAngle: .pi / 10)
        }, completion: { (finish) in
            UIView.animate(withDuration: 1, animations: {
                messageImageView.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 10))
            }, completion: { (finishh) in
                UIView.animate(withDuration: 1, animations: {
                    messageImageView.transform = CGAffineTransform.identity
                })
            })
            
        })
        
        return emptyView
    }
}
