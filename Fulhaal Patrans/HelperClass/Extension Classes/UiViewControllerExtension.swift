
import Foundation
import UIKit
// MARK: UIViewController
extension UIViewController {
    func setUpGradient() {
        let gradientLayer = CAGradientLayer()
        guard let navBar = self.navigationController else {
            return
        }
        var updatedFrame = navBar.navigationBar.bounds
        updatedFrame.size.height += 100
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [UIColor.init(hex: Theme.Colors.primaryColor.rawValue).cgColor, UIColor.init(hex: Theme.Colors.primaryColor.rawValue).cgColor, UIColor.init(hex: Theme.Colors.primaryColor.rawValue).cgColor] // start color and end color
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // Horizontal gradient start
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0) // Horizontal gradient end
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        navBar.navigationBar.barTintColor = UIColor.init(patternImage: image ?? UIImage())
        if  #available(iOS 13, *) {
            navBar.navigationBar.shadowColor = nil
        } else {
            navBar.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navBar.navigationBar.shadowImage = UIImage()
        }
    }
  
    func createGradient(view: UIView) {
        let gradientLayer = CAGradientLayer()
        var updatedFrame = view.bounds
        updatedFrame.size.height += 100
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [UIColor.init(hex: "#FF9A9E" ).cgColor, UIColor.init(hex: "#FF9A9E" ).cgColor, UIColor.init(hex: Theme.Colors.lightsecondary.rawValue).cgColor] // start color and end color
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // Horizontal gradient start
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0) // Horizontal gradient end
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor.init(patternImage: (image ?? UIImage()).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch))
        
    }
    var topViewController: UIViewController {
        switch self {
        case is UINavigationController:
            return (self as! UINavigationController).visibleViewController?.topViewController ?? self
        case is UITabBarController:
            return (self as! UITabBarController).selectedViewController?.topViewController ?? self
        default:
            return presentedViewController?.topViewController ?? self
        }
    }
    func titleAttributeForEmptyState(message: String) -> NSAttributedString {
        let quote = message
        let font = UIFont.systemFont(ofSize: 20)
        let attributes = [NSAttributedString.Key.font: font]
        return NSAttributedString(string: quote, attributes: attributes)
    }
    
    func showalertViewcontroller(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.view.tintColor = Theme.Colors.primaryColor.instance
        self.present(alert, animated: true, completion: nil)
    }
    
    func showalertview(messagestring: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: messagestring, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showalertview(messagestring: String, buttonmessage: String, handler:@escaping () -> Void ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: messagestring, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            alert.view.tintColor = Theme.Colors.primaryColor.instance
            alert.addAction(UIAlertAction(title: buttonmessage, style: UIAlertAction.Style.default, handler: { _  in
                DispatchQueue.main.async {
                    handler()
                }
                
            }))
            alert.view.tintColor = Theme.Colors.primaryColor.instance
            self.present(alert, animated: true, completion: nil)
        }
    }
    func showalertviewWithCancel(messagestring: String, buttonmessage: String, handler:@escaping () -> Void, cancelHandler:@escaping () -> Void ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: messagestring, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _  in
                DispatchQueue.main.async {
                    cancelHandler()
                }
                
            }))
            alert.view.tintColor = Theme.Colors.primaryColor.instance
            alert.addAction(UIAlertAction(title: buttonmessage, style: UIAlertAction.Style.default, handler: { _  in
                DispatchQueue.main.async {
                    handler()
                }
                
            }))
            alert.view.tintColor = Theme.Colors.primaryColor.instance
            self.present(alert, animated: true, completion: nil)
        }
    }
    func shareAction(content: [Any], sender: UIView) {
        let activityViewController = UIActivityViewController(
            activityItems: content,
            applicationActivities: nil)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = sender as UIView
            popoverController.sourceRect = sender.bounds
        }
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    func showActionSheetWithArray(success:@escaping (String) -> Void, title: String, arrayValue: [String]) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        }
        alertController.addAction(cancelAction)
        for curValue in arrayValue {
            let sheet = UIAlertAction(title: curValue, style: .default) { (_) in
                success(curValue)
            }
            alertController.addAction(sheet)
        }
        alertController.popoverPresentationController?.sourceView = self.view
        self.present(alertController, animated: true) {
        }
    }
    
    func showAlert(message: String, title: String, actionTitle: String, ok: @escaping ()-> (), cancel: @escaping ()->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: { _ in
                ok()
            }))
            alert.addAction(UIAlertAction(title: "Cancel" ,
                                          style: UIAlertAction.Style.destructive,
                                          handler: {(_: UIAlertAction!) in
                                            cancel()
            }))
            self.present(alert, animated: true, completion: nil)
            
        }}    
    func setNavThemeOrignal(title: String, leftBtns: [UIBarButtonItem]?, rightBtns: [UIBarButtonItem]?, hideShadow: Bool) {
        var textColor = Theme.Colors.white.instance
        if Theme.Colors.primaryColor.instance.isLight() ?? true {
            textColor = Theme.Colors.white.instance
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if hideShadow {
            self.navigationController?.navigationBar.shadowImage = UIImage()}
        self.navigationController?.navigationBar.tintColor = textColor
        self.navigationController?.navigationBar.barTintColor = Theme.Colors.primaryColor.instance
        
        self.navigationItem.title = title
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .default
        
        let font = UIFont.init(name: Theme.FontStyle.medium.rawValue, size: CGFloat(Theme.FontSize.large.rawValue))
        let attributesNormal: [NSAttributedString.Key: Any] = [.foregroundColor: textColor, .font: font ?? UIFont.systemFontSize]
        self.navigationController?.navigationBar.titleTextAttributes = attributesNormal
        
        if (leftBtns?.count ?? 0) > 0 {
            self.navigationItem.leftBarButtonItems = leftBtns
            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font ?? UIFont.systemFontSize], for: UIControl.State.normal)
        } else {
            self.navigationItem.leftBarButtonItems = nil
        }
        
        if (rightBtns?.count ?? 0) > 0 {
            self.navigationItem.rightBarButtonItems = rightBtns
            self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColor, NSAttributedString.Key.font: font ?? UIFont.systemFontSize], for: UIControl.State.normal)
        } else {
            self.navigationItem.rightBarButtonItems = nil
        }
    }
    
    
    // Set switch control
    func setSwitchControl(leftSwitch: UISwitch, titleLabel: UILabel ) -> UIView {
        let leftButtonView = UIView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        leftSwitch.onTintColor = Theme.Colors.purple.instance
        leftSwitch.tintColor = Theme.Colors.purple.instance
        leftSwitch.frame = CGRect(x: 50, y: 5, width: 40, height: 20)
        leftSwitch.autoresizesSubviews = true
        leftSwitch.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        Theme.standard.setLabels(with: .fontBalck, fontsize: .mini, fontstyle: .medium, labels: [titleLabel])
        leftSwitch.setOn(true, animated: true)
        titleLabel.frame = CGRect(x: 0, y: 0, width: 45, height: 50)
        titleLabel.textAlignment = .right
        titleLabel.autoresizesSubviews = true
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        leftButtonView.addSubview(titleLabel)
        leftButtonView.addSubview(leftSwitch)
        return leftButtonView
    }
    // set rightBar button with badge
    func setNavBadge(label: UILabel, button: UIButton) {
        // Add right bar button with badge
        label.frame = CGRect(x: -4, y: 0, width: 13, height: 13)
        label.backgroundColor = Theme.Colors.fontBalck.instance
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.layer.borderColor = Theme.Colors.lightgray.instance.cgColor
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "0"
        Theme.standard.setLabels(with: .white, fontsize: .nano, fontstyle: .bold, labels: [label])
        // button
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.setBackgroundImage(#imageLiteral(resourceName: "38 copy"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addSubview(label)
    }
    
    // set rightBar button with badge
    func setNavTitleView(title: String, btn: UIButton) -> UIView {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 70, height: 25))
        label.text = title
        label.textAlignment = .right
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        let imgview = UIImageView.init(frame: CGRect(x: 75, y: 5, width: 15, height: 15))
        imgview.image = #imageLiteral(resourceName: "arrow")
        imgview.contentMode = .scaleAspectFit
        Theme.standard.setLabels(with: .white, fontsize: .macro, fontstyle: .bold, labels: [label])
        Theme.standard.setImgTheme(with: .fontBalck, images: [imgview])
        btn.backgroundColor = .clear
        btn.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        view.addSubview(btn)
        view.addSubview(label)
        view.addSubview(imgview)
        return view
    }
    func showalertViewWithoutCancel(messagestring: String, buttonMessage: String, handler: @escaping () -> Void ) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: messagestring, preferredStyle: .alert)
            alert.view.tintColor = Theme.Colors.primaryColor.instance
            alert.addAction(UIAlertAction(title: buttonMessage, style: UIAlertAction.Style.default, handler: { _  in
                DispatchQueue.main.async {
                    handler()
                }
                
            }))
            alert.view.tintColor = Theme.Colors.primaryColor.instance
            self.present(alert, animated: true, completion: nil)
        }
    }
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: UINavigationController
extension UINavigationController {

    func backButton(_ image: String, navController: UINavigationController?) {
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: image), for: .normal)
        backbutton.setTitle("", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal) // You can change the TitleColor
        backbutton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        navController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }

    @objc func backAction(_ controller: UINavigationController?) {
        controller?.popViewController(animated: true)
    }
}
