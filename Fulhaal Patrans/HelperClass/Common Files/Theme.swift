import Foundation
import UIKit
class Theme: NSObject {
    static let standard = Theme()
    
    enum Colors: String {
        case primaryColor = "#C10C19"
        case secondry = "#DD4036"
        // black
        case fontBalck = "#000000"
        case gray = "#D4D4D4"
        case lightgray = "#E4E4E4"
        case lightsecondary = "#FAD0C4"
        case purple = "#262262"
        case red = "#E00000"
        case green = "#0DBF00"
        case blue = "#0008FF"
        case white = "#FFFFFF"
        case textpurple = "#0077FF"
        case textOrange = "#FFA800"
        case bgPurpleColor = "#F2EFFF"
        var instance: UIColor {
            return UIColor.init(hex: self.rawValue)
        }
    }
    enum FontSize: Float {
        case nano = 8
        case mini = 10
        case xss = 11
        case macro = 12
        case extraSmall = 13
        case small = 14
        case mediumSize = 15
        case normal = 16
        case large = 17
        case extraLarge = 18
        case xll = 19
        case xxl = 20
        case btnTitlesize = 25
        case headerExtraLarge = 30
    }
    
    enum FontStyle: String {
        case bold = "Montserrat-Bold"
        case light = "Montserrat-Light"
        case regular = "Montserrat-Regular"
        case medium = "Montserrat-SemiBold"
        case systemRegular = "System Font Regular"
    }
    func setLabels(with color: Colors, fontsize: FontSize, fontstyle: FontStyle, labels: [UILabel]) {
        for lbl in labels {
            lbl.font = UIFont(name: fontstyle.rawValue, size: CGFloat(fontsize.rawValue))
            lbl.textColor = UIColor.init(hex: color.rawValue)
        }
    }
    
    // Only work on PNG images
    func setImgTheme(with color: Colors, images: [UIImageView]) {
        for img in images {
            img.tintColor =  UIColor.init(hex: color.rawValue)
            img.image = img.image?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    func setButtonTheme(with color: Colors, fontcolor: Colors, fontsize: FontSize, fontstyle: FontStyle, buttons: [UIButton]) {
        for btn in buttons {
            btn.backgroundColor = UIColor.init(hex: color.rawValue)
            btn.setTitleColor(UIColor.init(hex: fontcolor.rawValue), for: .normal)
            btn.titleLabel?.font = UIFont(name: fontstyle.rawValue, size: CGFloat(fontsize.rawValue))
            btn.layer.cornerRadius = btn.frame.height / 8
        }
    }
    
    func setInvertButtonTheme(with color: Colors, fontcolor: Colors, fontsize: FontSize, fontstyle: FontStyle, buttons: [UIButton]) {
        for btn in buttons {
            btn.backgroundColor = UIColor.init(hex: color.rawValue)
            btn.titleLabel?.font = UIFont(name: fontstyle.rawValue, size: CGFloat(fontsize.rawValue))
            btn.setTitleColor(UIColor.init(hex: fontcolor.rawValue), for: .normal)
        }
    }
    
    // Button image theming
    func setButtonImage(name: String, button: UIButton, tintColor: Colors) {
        let origImage = UIImage(named: name)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor =  UIColor.init(hex: tintColor.rawValue)
    }
    
    // textFiled
    func setTextFiledTheme(textColor color: Colors, fontsize: FontSize, fontstyle: FontStyle, textFiled: [UITextField]) {
        for txtFiled in textFiled {
            txtFiled.textColor =  UIColor.init(hex: color.rawValue)
            txtFiled.font = UIFont(name: fontstyle.rawValue, size: CGFloat(fontsize.rawValue))
        }
    }
    func setTextViewTheme(textColor color: Colors, fontsize: FontSize, fontstyle: FontStyle, textView: [UITextView]) {
        for txtView in textView {
            txtView.textColor = UIColor(hex: color.rawValue)
            txtView.font = UIFont(name: fontstyle.rawValue, size: CGFloat(fontsize.rawValue))
        }
    }
    func setTextFiledWithoutCornorTheme(textColor color: Colors, fontsize: FontSize, fontstyle: FontStyle, textFiled: [UITextField]) {
        for txtFiled in textFiled {
            txtFiled.textColor =  UIColor.init(hex: color.rawValue)
            txtFiled.font = UIFont(name: fontstyle.rawValue, size: CGFloat(fontsize.rawValue))
        }
    }
    
    func convertToNsAttributedString(inputString text: String, textColor: Colors, textSize: FontSize, fontstyle: FontStyle) -> NSMutableAttributedString {
        let labelFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: textColor.rawValue), NSAttributedString.Key.font: UIFont(name: fontstyle.rawValue, size: CGFloat(textSize.rawValue))]
        
        let outputString = NSMutableAttributedString(string: text, attributes: labelFontAttributes as [NSAttributedString.Key: Any])
        
        return outputString
    }
    func convertToNsAttributedUnderlineString(inputString text: String, textColor: Colors, textSize: FontSize, fontstyle: FontStyle) -> NSMutableAttributedString {
        let labelFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: textColor.rawValue), NSAttributedString.Key.font: UIFont(name: fontstyle.rawValue, size: CGFloat(textSize.rawValue)
        )!, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key: Any]
        
        let outputString = NSMutableAttributedString(string: text, attributes: labelFontAttributes as [NSAttributedString.Key: Any])
        
        return outputString
    }
    func combinedNstring(inputStrings: [NSMutableAttributedString]) -> NSMutableAttributedString {
        let combinationPart = NSMutableAttributedString()
        for text in inputStrings {
            combinationPart.append(text)
        }
        return combinationPart
    }
    
    func viewShadowDesign(_ sView: [UIView?]) {
        for shadowView in sView {
            shadowView?.shadowColor = .black
            shadowView?.shadowRadius = 1
            shadowView?.shadowOpacity = 0.16
            shadowView?.shadowOffset = .init(width: 0, height: 1)
            shadowView?.cornerRadius = 8
        }
    }
    func cornerRadius(_ forView: [UIView]?, forlabel: [UILabel]?, fortextfield textField: [UITextField]?, forbutton: [UIButton]?, radiusValue: Int) {
        guard let forView = forView else { return  }
        for view in forView {
            view.clipsToBounds = true
            view.layer.cornerRadius = CGFloat(radiusValue)
        }
        guard let forlabel = forlabel else { return  }
        for label in forlabel {
            label.clipsToBounds = true
            label.layer.cornerRadius = CGFloat(radiusValue)
        }
        guard let textField = textField else { return  }
        for txtFiled in textField {
            txtFiled.clipsToBounds = true
            txtFiled.layer.cornerRadius = CGFloat(radiusValue)
        }
        guard let forbutton = forbutton else { return  }
        for button in forbutton {
            button.clipsToBounds = true
            button.layer.cornerRadius = CGFloat(radiusValue)
        }
    }
    func textfieldOutfocus(_ textField: [UITextField]) {
        for txtFiled in textField {
            txtFiled.leftViewMode = .always
            txtFiled.font = UIFont(name: Theme.FontStyle.regular.rawValue, size: 16)
            txtFiled.textColor = Colors.primaryColor.instance
            txtFiled.backgroundColor = UIColor.clear
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: (txtFiled.frame.size.height) - 1, width: txtFiled.frame.size.width, height: 1.0)
            bottomBorder.backgroundColor = UIColor.init(red: 200, green: 200, purple: 200).cgColor
            txtFiled.layer.addSublayer(bottomBorder)
        }
    }
    // Set BgImageView and image
    func setBgimgView(contentView: UIView) -> UIImageView {
        let imgView = UIImageView.init(frame: contentView.frame)
        imgView.image = #imageLiteral(resourceName: "Layer 1")
        return imgView
    }
    
}
