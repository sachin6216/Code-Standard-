//
//  HelperClass.swift
//  MedoPlus
//
//  Created by Relinns Technologies on 25/03/21.
//

import Foundation
import Alamofire
import QuickLook
class HelperClass: NSObject {
    var refrenceController = UIViewController()
    var previewItem = NSURL()
    static let sharedInstance = HelperClass()
    func downloadFile(controller: UIViewController, url: String, completion: @escaping (_ success: Bool, _ fileLocation: URL?) -> Void) {
        let myUrl: URL! = URL(string: url)
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(myUrl.lastPathComponent)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        controller.navigationController?.view.startProgresshud()
        AF.download(url, to: destination).response { response in
            controller.navigationController?.view.stopProgressHud()
            if response.error == nil {
                completion(true, response.fileURL)
            } else {
                completion(false, response.fileURL)
            }
        }
    }
     func presentPreViewController(controller: UIViewController, previewUrl: String?) {
        // Preview file
        self.refrenceController = controller
        if previewUrl?.contains("file:") ?? false {
            guard FileManager.default.contents(atPath: previewUrl ?? "") != nil else {return}
            self.previewItem = .init(fileURLWithPath: previewUrl ?? "", isDirectory: true)
            // Display file
            let previewController = QLPreviewController()
            previewController.dataSource = self
            previewController.modalPresentationStyle = .formSheet
            self.refrenceController.navigationController?.present(previewController, animated: true, completion: nil)
        } else {
            self.downloadFile(controller: controller, url: previewUrl ?? "") { (succees, fileLocationURL) in
                if succees {
                    guard let fileLoc = fileLocationURL else {
                        debugPrint("invalid file")
                        return
                    }
                    self.previewItem = fileLoc as NSURL
                    // Display file
                    let previewController = QLPreviewController()
                    previewController.dataSource = self
                    previewController.modalPresentationStyle = .formSheet
                    self.refrenceController.navigationController?.present(previewController, animated: true, completion: nil)
                } else {
                    debugPrint("File can't be downloaded")
                }
            }
        }
            
    }
}
extension HelperClass: QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem as QLPreviewItem
    }
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        
    }
}
