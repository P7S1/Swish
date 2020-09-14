//
//  UIView.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 4/27/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import UIKit

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    private static let kRotationAnimationKey = "rotationanimationkey"

       func rotate(duration: Double = 1) {
           if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
               let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

               rotationAnimation.fromValue = 0.0
               rotationAnimation.toValue = Float.pi * -2.0
               rotationAnimation.duration = duration
               rotationAnimation.repeatCount = Float.infinity

               layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
           }
       }

       func stopRotating() {
           if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
               layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
           }
       }
}

extension UIView {

    // MARK: Activity Indicator

    func activityIndicator(show: Bool) {
        activityIndicator(show: show, style: .large)
    }

    func activityIndicator(show: Bool, style: UIActivityIndicatorView.Style) {
        var spinner: UIActivityIndicatorView? = viewWithTag(NSIntegerMax - 1) as? UIActivityIndicatorView

        if spinner != nil {
            spinner?.removeFromSuperview()
            spinner = nil
        }

        if spinner == nil && show {
            spinner = UIActivityIndicatorView.init(style: style)
            spinner?.translatesAutoresizingMaskIntoConstraints = false
            spinner?.hidesWhenStopped = true
            spinner?.tag = NSIntegerMax - 1

            if Thread.isMainThread {
                spinner?.startAnimating()
            } else {
                DispatchQueue.main.async {
                    spinner?.startAnimating()
                }
            }

            insertSubview((spinner)!, at: 0)

            NSLayoutConstraint.init(item: spinner!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
            NSLayoutConstraint.init(item: spinner!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true

            spinner?.isHidden = !show
        }
    }

}

extension UIView {
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIView{
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor){
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.locations = [0, 1]
            gradientLayer.frame = bounds

            layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
/*
//MARK: - Round corners
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
*/
