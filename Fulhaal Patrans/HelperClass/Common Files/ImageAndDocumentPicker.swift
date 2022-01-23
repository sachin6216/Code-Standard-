//
//  ImageAndDocumentPicker.swift
//  MedoPlus
//
//  Created by Relinns Technologies on 24/03/21.
//
import Foundation
import UIKit
import MobileCoreServices
import DDPerspectiveTransform
@objc protocol didImageAndDocumentPickerActive: class {
    @objc optional func didImageSelected(image: UIImage, imgUrl: URL?, index: Int)
    @objc optional func didSelectImgFromTable(image: UIImage, index: Int)
    @objc optional func didDocumentSelected(file: URL, type: String)
    @objc optional func didSelectDocFromTable(file: URL, index: Int, type: String)
}
class ImageAndDocumentPicker: NSObject {
    static let sharedInstance = ImageAndDocumentPicker()
    weak var delegate: didImageAndDocumentPickerActive?
    var refrenceClass = UIViewController()
    var tableRowIndex: Int?
    var selectedImg: UIImage?
    
    func setImagePickerViewInTable(refrence: UIViewController, index: Int) {
        self.tableRowIndex = index
        self.setImagePickerView(refrence: refrence)
    }
    /// Show Action Sheet to select picker type
    func setImagePickerView(refrence: UIViewController) {
        self.refrenceClass = refrence
        refrenceClass.showActionSheetWithArray(success: { (retrun) in
            self.selectImageFrom(type: retrun)
        }, title: "Import file from".localize(), arrayValue: ["Camera".localize(), "Photo Gallery".localize(), "Documents".localize()])
    }
    /// Select Picker type and Set PickerView [Camera, Gallery and Documnet]
    func selectImageFrom(type: String) {
        let imagePicker = UIImagePickerController()
        if type == "Photo Gallery".localize() {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                imagePicker.delegate = self
                imagePicker.sourceType = .savedPhotosAlbum
                imagePicker.allowsEditing = false
                imagePicker.isEditing = false
                imagePicker.modalPresentationStyle = .overFullScreen
                refrenceClass.present(imagePicker, animated: true, completion: nil)
            }
        } else if type == "Documents".localize() {
            /* If required DOC, EXCEL andPDF then unccomment me
             let docMenu = UIDocumentMenuViewController(documentTypes: ["com.microsoft.word.doc",
             "org.openxmlformats.wordprocessingml.document",
             kUTTypeRTF as String,
             "com.microsoft.excel.xls",
             "org.openxmlformats.spreadsheetml.sheet",
             kUTTypePDF as String], in: .import)*/
            let docMenu = UIDocumentMenuViewController(documentTypes: [kUTTypePDF as String], in: .import)
            docMenu.delegate = self
            docMenu.modalPresentationStyle = .formSheet
            refrenceClass.present(docMenu, animated: true, completion: nil)
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.modalPresentationStyle = .overFullScreen
                refrenceClass.present(imagePicker, animated: true, completion: nil)
            } else {
                let message = UIAlertController(title: "Camera", message: "You don't have a camera", preferredStyle: .alert)
                let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
                message.addAction(dismiss)
                refrenceClass.present(message, animated: true)
            }
        }
    }
    func configureCropViewer(image:UIImage,pointsColor:UIColor,boxLineColor:UIColor,boxLineWidth:CGFloat,pointSize:CGSize){
        let cropViewController = CropperExtensionViewController()
        cropViewController.delegate = self
        cropViewController.image = image
        cropViewController.pointColor = pointsColor
        cropViewController.boxLineColor = boxLineColor
        cropViewController.boxLineWidth = boxLineWidth
        cropViewController.pointSize = pointSize
        self.refrenceClass.navigationController?.pushViewController(cropViewController, animated: true)
    }
    
    
}
extension ImageAndDocumentPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let imageURL = info[.imageURL] as? URL //here's your URL
        let data = img.compressImageToData()
        guard data?.count ?? 0 <= 10485760 else {
            refrenceClass.dismiss(animated: true, completion: nil)
            refrenceClass.showalertview(messagestring: "Image size is too big")
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if let index = self.tableRowIndex {
                self.selectedImg = img
                self.configureCropViewer(image: img, pointsColor: Theme.Colors.primaryColor.instance, boxLineColor: .black, boxLineWidth: 2.5, pointSize: CGSize.init(width: 50, height: 50))
            } else {
                self.configureCropViewer(image: img, pointsColor: Theme.Colors.primaryColor.instance, boxLineColor: .black, boxLineWidth: 2.5, pointSize: CGSize.init(width: 50, height: 50))
                //                self.delegate?.didImageSelected?(image: img, imgUrl: imageURL)
            }
        })
        refrenceClass.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        refrenceClass.dismiss(animated: true, completion: nil)
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
extension ImageAndDocumentPicker: UIDocumentMenuDelegate, UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        do {
            let data = try Data.init(contentsOf: myURL)
            guard data.count <= 10485760 else {
                refrenceClass.dismiss(animated: true, completion: nil)
                refrenceClass.showalertview(messagestring: "Image size is too big")
                return
            }
        } catch {
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if let index = self.tableRowIndex {
                self.delegate?.didSelectDocFromTable?(file: myURL, index: index, type: myURL.pathExtension.uppercased())
            } else {
                self.delegate?.didDocumentSelected?(file: myURL, type: myURL.pathExtension.uppercased())
            }
        })
    }
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        refrenceClass.present(documentPicker, animated: true, completion: nil)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        refrenceClass.dismiss(animated: true, completion: nil)
    }
}
extension ImageAndDocumentPicker: DDPerspectiveTransformProtocol, ImagePreviewViewDelegate {
    func perspectiveTransformingDidFinish(controller: DDPerspectiveTransformViewController, croppedImage: UIImage) {
        guard let nextVc = AppStoryboard.home.instance.instantiateViewController(withIdentifier: "ImagePreviewViewController") as? ImagePreviewViewController else { return }
        nextVc.cropperdImage = croppedImage
        nextVc.delegate = self
        self.refrenceClass.navigationController?.pushViewController(nextVc, animated: true)
    }
    
    func perspectiveTransformingDidCancel(controller: DDPerspectiveTransformViewController) {
        self.refrenceClass.pop()
//        self.delegate?.didImageSelected?(image: self.selectedImg ?? #imageLiteral(resourceName: "Group 2"), imgUrl: self.saveImageDocumentDirectory(image: self.selectedImg ?? #imageLiteral(resourceName: "Group 2")), index: 0)
    }
    
    func didImgEditingFinish(img: UIImage, imgURL: URL) {
        self.delegate?.didImageSelected?(image: img, imgUrl: imgURL, index: 0)
    }
}
