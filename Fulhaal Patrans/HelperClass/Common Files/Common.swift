import UIKit
@available(iOS 13.0, *)
let appDelegate = UIApplication.shared.delegate as? AppDelegate
let standard = UserDefaults.standard
// MARK: - Device Details 
let iOSplatform = "1"
var notificationId = "1111"
let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
var fcmTokenString = standard.string(forKey: "fcmToken") ?? "xxxx"
// Google Keys
let googleMapKey = "AIzaSyC9wLE72cZehgh9AewDF67ZdkgZRUtr6QE"
// Cheack wether user is login or not
var loginToken: String {
    get {
        return standard.string(forKey: "token") ?? ""
    }
    set {
        standard.setValue(newValue, forKey: "token")
    }
}
// Headers
func createHeaders() -> [String: String] {
    return ["token": "\(loginToken)"]
}
func  isUserLogin() -> Bool {
    return standard.value(forKey: "isUserLogin") as? Bool ?? false
}
// get Symbol For Currency code
func getSymbolForCurrencyCode(code: String) -> String? {
    let locale = NSLocale(localeIdentifier: code)
    return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
}
enum AppStoryboard: String {
    case profile = "Profile"
    case tabBar = "TabBar"
    case auth = "Authentication"
    case home = "Home"
    case sideMenu = "SideMenu"
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}
