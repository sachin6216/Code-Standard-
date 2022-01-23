//
//  CropperExtensionViewController.swift
//  FreeStyleCropper
//
//  Created by Gurpal Rajput on 31/07/21.
//  Copyright © 2021 Gurpal Rajput. All rights reserved.
//
// Notes:- Please replace this code in DDPerspectiveTransformViewController
/*open var image: UIImage? {
 set {
     guard let image = newValue else {
         return
     }
     perspectiveImageView = DDPerspectiveTransformImageView(image: image, aSuperView: view)
     if let perspectiveImageView = perspectiveImageView {
         for view in view.subviews {
             if view is UIImageView {
                view.removeFromSuperview()
            }
         }
         view.addSubview(perspectiveImageView)
         view.layer.addSublayer(rectangleLayer)
     }
     reset()
 }
 get {
     return perspectiveImageView?.image
 }
}
// Notes: - Please replace this code in DDPerspectiveTransformImageView
 center = CGPoint.init(x: 190, y: 260)
 */
import UIKit
import DDPerspectiveTransform

class CropperExtensionViewController: DDPerspectiveTransformViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTheme()
    }
    @IBAction func rotateAction(_ sender: Any) {
        let img = image?.rotate(radians: .pi/2)
       image = img
        
    }
    @IBAction func cropAction(_ sender: Any) {
        cancelAction()
    }
    @IBAction func cancelAction(_ sender: Any) {
        cropAction()
    }
    private func setTheme() {
        let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow"), style: .done, target: self, action: #selector(leftBtnAction))
        self.setNavThemeOrignal(title: "Adjust Image Size".localize(), leftBtns: [leftBtn], rightBtns: nil, hideShadow: false)
    }
    @objc func leftBtnAction() {
        self.pop()
    }
}
