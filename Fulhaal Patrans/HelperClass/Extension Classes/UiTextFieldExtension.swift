import Foundation
import UIKit
// MARK: - UITextField
extension UITextField {
    
//    // ⚠️ Prefer english keyboards
//    //
//    open override var textInputMode: UITextInputMode? {
//        let locale = Locale(identifier: "hi-IN") // your preferred locale
//
//        return
//            UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == locale.languageCode })
//            ??
//            super.textInputMode
//    }
    
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    @objc public var substituteFontName: String {
        get {
            return self.font?.fontName ?? ""
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? ""
            var fontName = newValue
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light"
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight"
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
    func leftview() {
        let viewC = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 44))
        
        self.leftView = viewC
        self.leftViewMode = .always
    }
    func rightVC() {
        let viewC = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        self.rightView = viewC
        self.rightViewMode = .always
    }
    func leftviewWithImage(image: UIImage) {
        let viewC = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 34))
        let btnLeft = UIButton(frame: CGRect(x: 15, y: 5, width: 18, height: 18))
        btnLeft.setImage(image, for: .normal)
        btnLeft.isUserInteractionEnabled = false
        viewC.addSubview(btnLeft)
        self.leftView = viewC
        self.leftViewMode = .always
    }
    func rightview(img: UIImage ) {
        let viewC = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 44))
        let btnLeft = UIButton(frame: CGRect(x: 0, y: 15, width: 14, height: 14))
        btnLeft.setImage(img, for: .normal)
        btnLeft.isUserInteractionEnabled = false
        viewC.addSubview(btnLeft)
        self.rightView = viewC
        self.rightViewMode = .always
    }
    func borderColor() {
        // self.layer.borderColor = txtBorder.cgColor
        self.layer.borderWidth = 1.0
    }
    @IBDesignable
    class UISwitchCustom: UISwitch {
        @IBInspectable var offTint: UIColor? {
            didSet {
                self.tintColor = offTint
                self.layer.cornerRadius = 16
                self.backgroundColor = offTint
            }
        }
    }
}
// MARK: UITextView
extension UITextView {
    @objc public var substituteFontName: String {
        get {
            return self.font?.fontName ?? ""
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? ""
            var fontName = newValue
            if fontNameToTest.range(of: "bold") != nil {
                fontName += "-Bold"
            } else if fontNameToTest.range(of: "medium") != nil {
                fontName += "-Medium"
            } else if fontNameToTest.range(of: "light") != nil {
                fontName += "-Light"
            } else if fontNameToTest.range(of: "ultralight") != nil {
                fontName += "-UltraLight"
            }
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }

    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format: "<span style=\"font-family: '-apple-system', 'system'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)
        // process collection values
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)

        self.attributedText = attrStr
    }

}
