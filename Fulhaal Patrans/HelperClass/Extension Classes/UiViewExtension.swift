
import Foundation
import UIKit
// MARK: UIiew
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func showErrorPopup(msg: String) {
        // let vc = popupView.init(frame: self.frame, text: msg)
        // self.addSubview(vc)
    }
    
    func showSuccessPopup(msg: String) {
        // let vc = successView.init(frame: self.frame, text: msg)
        // self.addSubview(vc)
    }
    
    func circularShadow(rad: CGFloat) {
        
        // add the shadow to the base view
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 2.0
        self.layoutIfNeeded()
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: rad).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    func addShadowsToImage() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 1
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        self.layer.shadowOpacity = 1
    }
    
    func addShadows() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1
        self.layer.cornerRadius = 1
    }
    
    func addShadowsRadius(rad: CGFloat, shadowRad: CGFloat) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = Theme.Colors.lightgray.instance.cgColor
        self.layer.shadowRadius = shadowRad
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 1.5
        self.layer.cornerRadius = rad
    }
    func addBorderColor(rad: CGFloat) {
        self.layer.borderWidth = 1
        self.layer.cornerRadius = rad
        
    }
    
    func startProgresshud() {
        DispatchQueue.main.async {
            
            if let _ = self.viewWithTag(40) {
                // View is already locked
            } else {
                self.isUserInteractionEnabled = false
                let lockView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width / 4, height: self.frame.size.width / 4))
                lockView.layer.cornerRadius = 10
                lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
                lockView.tag = 40
                lockView.alpha = 0.0
                let activity = UIActivityIndicatorView()
                activity.style = .whiteLarge
                activity.center = lockView.center
                activity.startAnimating()
                lockView.addSubview(activity)
                
                self.addSubview(lockView)
                
                UIView.animate(withDuration: 0.2) {
                    lockView.alpha = 1.0
                }
                lockView.center = self.center
            }
        }
    }
    
    func stopProgressHud() {
        DispatchQueue.main.async {
            self.isUserInteractionEnabled = true
            if let lockView = self.viewWithTag(40) {
                UIView.animate(withDuration: 0.2, animations: {
                    lockView.alpha = 0.0
                }, completion: { _ in
                    lockView.removeFromSuperview()
                })
            }
        }
    }
    
    func setTop(topAnchor: NSLayoutConstraint) {
        topAnchor.constant = 30
    }
    
    func dashedBorderLayerWithColor(color: CGColor, view: UIView) -> CAShapeLayer {
        
        let  borderLayer = CAShapeLayer()
        borderLayer.name  = "borderLayer"
        let frameSize = view.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        borderLayer.bounds=shapeRect
        borderLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth = 0.5
        borderLayer.lineJoin=CAShapeLayerLineJoin.round
        borderLayer.lineDashPattern = [2, 2]
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint.init(x: view.frame.width / 2, y: 0))
        path.addLine(to: CGPoint.init(x: view.frame.width / 2, y: view.frame.height))
        
        borderLayer.path = path.cgPath
        
        return borderLayer
    }
    func createDottedLine(width: CGFloat, color: CGColor) {
               let caShapeLayer = CAShapeLayer()
               caShapeLayer.strokeColor = color
               caShapeLayer.lineWidth = width
               caShapeLayer.lineDashPattern = [2, 2]
               let cgPath = CGMutablePath()
               let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: 0)]
               cgPath.addLines(between: cgPoint)
               caShapeLayer.path = cgPath
               layer.addSublayer(caShapeLayer)
            }
            
    func createGradient(view: UIView, bounds: CGSize) {
        let gradientLayer = CAGradientLayer()
        var updatedFrame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: bounds)
        updatedFrame.size.height += 100
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [UIColor.init(hex: Theme.Colors.white.rawValue).cgColor, UIColor.init(hex: Theme.Colors.primaryColor.rawValue).cgColor] // start color and end color
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // vertical gradient start
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0) // vertical gradient end
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        // gradientLayer.render(in: UIGraphicsGetCurrentContext() ?? UIGraphicsGetCurrentContext())
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor.init(patternImage: (image ?? UIImage()).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch))
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
    
    func createGradientForCard(view: UIView) {
        let gradientLayer = CAGradientLayer()
        var updatedFrame = view.bounds
        updatedFrame.size.height += 100
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [UIColor.init(hex: "#A18CD1" ).cgColor, UIColor.init(hex: "#FBC2EB" ).cgColor, UIColor.init(hex: Theme.Colors.lightsecondary.rawValue).cgColor] // start color and end color
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // Horizontal gradient start
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0) // Horizontal gradient end
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor.init(patternImage: (image ?? UIImage()).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch))
    }
    
    func createGradientHorizontal(view: UIView) {
        let colorTop =  UIColor.init(hex: Theme.Colors.white.rawValue).withAlphaComponent(0.2).cgColor
        let colorBottom = UIColor.init(hex: Theme.Colors.primaryColor.rawValue).withAlphaComponent(1).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.0)
        gradientLayer.colors = [colorTop, colorBottom, colorBottom]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func createGradientSideBar(view: UIView, bounds: CGSize) {
        let gradientLayer = CAGradientLayer()
        var updatedFrame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: bounds)
        updatedFrame.size.height += 100
        gradientLayer.frame = updatedFrame
        gradientLayer.colors = [UIColor.init(hex: Theme.Colors.primaryColor.rawValue).cgColor, UIColor.init(hex: Theme.Colors.primaryColor.rawValue).cgColor, UIColor.init(hex: Theme.Colors.primaryColor.rawValue).cgColor] // start color and end color
        gradientLayer.locations = [0.0, 0.6, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // Horizontal gradient start
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0) // Horizontal gradient end
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        // gradientLayer.render(in: UIGraphicsGetCurrentContext() ?? UIGraphicsGetCurrentContext())
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor.init(patternImage: (image ?? UIImage()).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), resizingMode: .stretch))
    }
        
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func fadeIn(duration: TimeInterval = 0.7, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(_: Bool) -> Void in }) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(_: Bool) -> Void in }) {
      UIView.animate(withDuration: duration,
                     delay: delay,
                     options: UIView.AnimationOptions.curveEaseIn,
                     animations: {
        self.alpha = 0.0
      }, completion: completion)
    }
    
}
