
import Foundation
import UIKit
// MARK: String

extension String {

    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: self.index(startIndex, offsetBy: count))
    }

    func chopSuffix(_ count: Int = 1) -> String {

        return substring(to: self.index(endIndex, offsetBy: -count))
    }

    func getContentHeight() -> CGFloat {
        let lable = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: 100, height: 40))
        Theme.standard.setLabels(with: .fontBalck, fontsize: .large, fontstyle: .bold, labels: [lable])
        lable.text = self
        lable.numberOfLines = 0
        lable.sizeToFit()
        return lable.frame.height
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }

    func base64Conv() -> String {

        let longstring = self
        let data = (longstring).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64

    }

    func base64Decoded() -> String? {

        var base64Encoded = self

        if base64Encoded.last == "\n" || base64Encoded.last == " " {
            base64Encoded.removeLast()
        }

        if Data(base64Encoded: base64Encoded) == nil {

            return self

        } else {

            let decodedData = Data(base64Encoded: base64Encoded)!

            if String(data: decodedData, encoding: .utf8) == nil {
                return self
            }

            let decodedString = String(data: decodedData, encoding: .utf8)!

            return decodedString
        }

    }

    func isValidateEmail() -> Bool {

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

    func isValidatePassword() -> Bool {

        let passwordRegex = "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,15}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }

    func isValidateMobile() -> Bool {

        let mobileRegex = "^\\d{9,25}$"
        return NSPredicate(format: "SELF MATCHES %@", mobileRegex).evaluate(with: self)
    }

    func isMedPassword1() -> Bool {

        let passwordRegex = "(?=.*[A-Z])(?=.*\\d).{6,15}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }

    func isMedPassword2() -> Bool {

        let passwordRegex = "(?=.*[a-z])(?=.*\\d).{6,15}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
    func isStrongPassword() -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\dd]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    func isValidName() -> Bool {
        let passwordRegex = "[a-zA-Z]{1,20}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
//    func isVaildUPIId() -> Bool {
//        let passwordRegex = "VPA\s([\w.-]*[@][\w]*)"
//        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
//    }
    
     func getChatDate() -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
           dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
           let date = dateFormatter.date(from: self)
           dateFormatter.dateFormat = "dd-MMM-yy"
           dateFormatter.timeZone = NSTimeZone.local
           var timestamp = ""
           if let date = date {
               timestamp = dateFormatter.string(from: date)
           }
           return timestamp
       }
    
    func getDateObject() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        guard let date = dateFormatter.date(from: self) else { return Date()}
        return date
    }
    
    func getEventDate() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
          dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
          let date = dateFormatter.date(from: self)
          dateFormatter.dateFormat = "dd-MMM-yyyy"
          dateFormatter.timeZone = NSTimeZone.local
          var timestamp = ""
          if let date = date {
              timestamp = dateFormatter.string(from: date)
          }
          return timestamp 
      }
    func getBirthdayDate() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
          dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
          let date = dateFormatter.date(from: self)
          dateFormatter.dateFormat = "dd-MMM"
          dateFormatter.timeZone = NSTimeZone.local
          var timestamp = ""
          if let date = date {
              timestamp = dateFormatter.string(from: date)
          }
         let currentYear = Calendar.current.component(.year, from: Date())
          return timestamp + "-" + String(currentYear)
      }
    func convertDateFormat(date: String, outputFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        let convertedDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = outputFormat
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: convertedDate ?? Date())
        return timeStamp
    }
    func convertLocalToUTC(inputFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        formatter.timeZone = TimeZone.current
        let oldDate = formatter.date(from: self)
        let formatter2 = DateFormatter()
        formatter2.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone?
        formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if oldDate != nil {
            return formatter2.string(from: oldDate!)
        }
        return self
    }
    func convertISTToLocalDate(inputFormat: String, outputFormat: String) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        formatter.timeZone = TimeZone(abbreviation: "IST")

        let oldDate = formatter.date(from: self)

        let formatter2 = DateFormatter()
        formatter2.timeZone = TimeZone.current

        formatter2.dateFormat = outputFormat
        // formatter2.locale = Locale.init(identifier: currentLanguage)

        if oldDate != nil {
            return formatter2.string(from: oldDate!)
        }

        return self
    }

    func convertToLocalDate(inputFormat: String, outputFormat: String) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let oldDate = formatter.date(from: inputFormat)

        formatter.dateFormat = outputFormat

        formatter.timeZone = TimeZone.current

        // formatter.locale = Locale.init(identifier: currentLanguage)
        if oldDate != nil {
            return formatter.string(from: oldDate!)
        }

        return self
    }

    func convertToLocalTime(inputFormat: String, outputFormat: String) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = inputFormat
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let oldDate = formatter.date(from: self)

        formatter.dateFormat = outputFormat

        formatter.timeZone = TimeZone.current
        // formatter.locale = Locale.init(identifier: currentLanguage)

        if oldDate != nil {
            return formatter.string(from: oldDate!)
        }

        return self
    }

    func localize() -> String {
        return NSLocalizedString(self, comment: self)
    }

    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailFormat).evaluate(with: self)
    }

    func validateEmail(_ emailStr: String?) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: emailStr)

    }
    
    func validate() -> Bool {
        let phoneRegex = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        let result =  phoneTest.evaluate(with: self)
        return result

    }

    func checkCapital() -> Bool {

        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: self)
        return capitalresult

    }

    func passwordValidation() -> Bool {
        let password = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{4,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", password)
        let result =  passwordTest.evaluate(with: self)
        return result

    }

    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }

    func removeCommas() -> String {
        return self.replacingOccurrences(of: ",", with: "")
    }
    func convertHtml() -> NSAttributedString {
          guard let data = data(using: .utf8) else { return NSAttributedString() }
          do {
              return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
          } catch {
              return NSAttributedString()
          }
      }
    /// Apply strike font on text
    func strikeThrough() -> NSAttributedString {
      let attributeString = NSMutableAttributedString(string: self)
      attributeString.addAttribute(
        NSAttributedString.Key.strikethroughStyle,
        value: 1,
        range: NSRange(location: 0, length: attributeString.length))

        return attributeString
       }
    func isStringContainsOnlyNumbers() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil || self.rangeOfCharacter(from: CharacterSet.symbols) != nil
    }
    func isStringContainsSymbols() -> Bool {
            return self.rangeOfCharacter(from: CharacterSet.symbols) != nil
        }
}
