
import Foundation
import UIKit
// MARK: UILable
extension UILabel {
    @objc  public var substituteFontName: String {
        get {
            return self.font.fontName
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased()
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
            self.font = UIFont(name: fontName, size: self.font.pointSize)
        }
    }

    func getContentHeight() -> CGFloat {
        let lable = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: self.frame.width, height: 40))
        Theme.standard.setLabels(with: .fontBalck, fontsize: .large, fontstyle: .medium, labels: [lable])
        lable.text = self.text!
        lable.numberOfLines = 0

        lable.sizeToFit()
        return lable.frame.height
    }

    func setHTMLFromString(htmlText: String) {
        let modifiedFont = String(format: "<span style=\"font-family: '-apple-system', 'system'; font-size: \(self.font!.pointSize)\">%@</span>", htmlText)
        
        //        //process collection values
        do {
            let attrStr =  try NSAttributedString(
                data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            self.attributedText = attrStr
        } catch let error1 as NSError {
            self.attributedText = NSMutableAttributedString(string: error1.localizedDescription)
        }
        
    }
    // Pass value for any one of both parameters and see result
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment =  NSTextAlignment.center
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
