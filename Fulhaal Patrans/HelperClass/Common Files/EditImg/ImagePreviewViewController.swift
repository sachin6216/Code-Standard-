//
//  ImagePreviewViewController.swift
//  FreeStyleCropper
//
//  Created by Gurpal Rajput on 31/07/21.
//  Copyright © 2021 Gurpal Rajput. All rights reserved.
//

import UIKit
import Foundation
protocol ImagePreviewViewDelegate: class {
    func didImgEditingFinish(img: UIImage, imgURL: URL)
}
class ImagePreviewViewController: UIViewController {
    var cropperdImage:UIImage?
    var noirImage:UIImage?
    var isGrayScalOn = true
    
    weak var delegate: ImagePreviewViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        imgVieww.image = cropperdImage ?? UIImage()
        self.setTheme()
    }
    @IBOutlet weak var imgVieww: UIImageView!
    @IBAction func turnGrayScale(_ sender: UIButton) {
        if isGrayScalOn {
            noirImage = cropperdImage?.getScannedImage()
            imgVieww.image = noirImage
            sender.setTitle("Remove GrayScale", for: .normal)
            self.isGrayScalOn = false
        } else {
            sender.setTitle("Apply GrayScale", for: .normal)
            imgVieww.image = cropperdImage
            noirImage = nil
            self.isGrayScalOn = true
        }
    }
    @IBAction func undoGrayScale(_ sender: Any) {
        for controller in (self.navigationController?.viewControllers ?? [UIViewController()]) {
            if controller.isKind(of: FuleViewController.self) || controller.isKind(of: TripDetailsViewController.self){
                self.navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
        self.delegate?.didImgEditingFinish(img: self.imgVieww.image ?? #imageLiteral(resourceName: "Group 2"), imgURL: self.saveImageDocumentDirectory(image: self.imgVieww.image ?? #imageLiteral(resourceName: "Group 2")))
    }
    private func setTheme() {
        let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow"), style: .done, target: self, action: #selector(leftBtnAction))
        self.setNavThemeOrignal(title: "Edit Image Colour".localize(), leftBtns: [leftBtn], rightBtns: nil, hideShadow: false)
    }
    @objc func leftBtnAction() {
        self.pop()
    }
    func saveImageDocumentDirectory(image: UIImage) -> URL {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("PATransImage\(Int.random(in: 1..<9999)).jpeg")
        print(paths)
        let imageData = image.jpegData(compressionQuality: 1)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        return .init(fileURLWithPath: paths)
    }
}
extension UIImage {
    var noir: UIImage {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")!
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        let output = currentFilter.outputImage!
        let cgImage = context.createCGImage(output, from: output.extent)!
        let processedImage = UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        return processedImage
    }
    func getScannedImage() -> UIImage? {
        let openGLContext = EAGLContext(api: .openGLES2)
        let context = CIContext(eaglContext: openGLContext!)
        guard let coreImage = CIImage(image: self) else { return #imageLiteral(resourceName: "Group 2")}
        guard let outImg = CIFilter.colorControls(inputImage: coreImage, inputSaturation: 0, inputBrightness: 0.1, inputContrast: 1.6)?.outputImage else {
            return #imageLiteral(resourceName: "Group 2")
        }
        let output = context.createCGImage(outImg, from: outImg.extent)
        return UIImage(cgImage: output!)
    }
}
