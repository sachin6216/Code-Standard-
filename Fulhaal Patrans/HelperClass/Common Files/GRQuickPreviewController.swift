//
//  JSQuickPreviewController.swift
//  USA2GEORGIA
//
//  Created by Gurpal Rajput on 21/04/21.
//  Copyright © 2021 USA2GEORGIA. All rights reserved.
//

import UIKit
import QuickLook

class GRQuickPreviewController: QLPreviewController, QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    
    var fileName: String = ""
    var url: URL?
    var extensions:String = ""
    
    private var previewItem : Preview!
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tintColor = .black
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self;
        self.delegate = self
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.title = fileName;
        self.downloadfile(fileName: fileName, itemUrl: url, extensions: extensions)
        self.hideErrorLabel();
    }
    
    @objc
    func hideErrorLabel() {
        
        var found = false
        for v in self.view.allViews.filter({ $0 is UILabel }) {
            v.isHidden = true
            found = true
        }
        
        if !found {
            self.perform(#selector(hideErrorLabel), with: nil, afterDelay: 0.1);
        }
        
    }
    
    private func downloadfile(fileName:String, itemUrl:URL?,extensions:String){
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileurlext = fileName
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(fileurlext)
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print(destinationUrl)
            self.previewItem = Preview(displayName: fileName, fileName: fileName, fileExtension: extensions, previewUrl: destinationUrl)
            self.loadFile()
        }
        else {
            DispatchQueue.main.async(execute: {
                if let itemUrl = itemUrl {
                    URLSession.shared.downloadTask(with: itemUrl, completionHandler: { (location, response, error) -> Void in
                        if error != nil {
                            for v in self.view.allViews.filter({ $0 is UILabel }) {
                                v.isHidden = false
                                (v as? UILabel)?.text = error?.localizedDescription
                            }
                        } else {
                            guard let tempLocation = location, error == nil else { return }
                            
                            
                            try? FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                            print(destinationUrl)
                            self.previewItem = Preview(displayName: "", fileName: fileName, fileExtension: extensions, previewUrl: destinationUrl)
                            self.loadFile()
                        }
                    }).resume()
                }
            })
        }
    }
    
    func loadFile() {
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.reloadData()
        }
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return previewItem == nil ? 0 : 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItem
    }
}

extension UIView {
    var allViews: [UIView] {
        var views = [self]
        subviews.forEach {
            views.append(contentsOf: $0.allViews)
        }
        return views
    }
}

class Preview: NSObject, QLPreviewItem {
    let displayName: String
    let fileName: String
    let fileExtension: String
    var previewItemURLS:URL
    var thumbnail: UIImage?
    
    init(displayName: String, fileName: String, fileExtension: String,previewUrl:URL) {
        self.displayName = displayName
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.previewItemURLS = previewUrl
        super.init()
    }
    
    var previewItemTitle: String? {
        return displayName
    }
    
    var formattedFileName: String {
        
        return "\(fileName)"
    }
    
    var previewItemURL: URL? {
        return  previewItemURLS
    }
}
