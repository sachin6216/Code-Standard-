//
//  AuthEndPoint.swift
//  MedoPlus Facility
//
//  Created by Relinns Technologies  on 04/03/21.
//
import Foundation
import UIKit
import Alamofire
enum AuthEndPoint: TargetType {
    case login(phoneNo: String, dcode: String)
    case driverProfile
    case logout
    var data: [String: Any] {
        switch self {
        case .login(phoneNo: let phoneNo, dcode: let dcode):
            return ["phone": phoneNo, "dcode": dcode]
        default:
            return ["": ""]
        }
    }
    var service: String {
        switch self {
        case .login: return ApisURL.ServiceUrls.login.rawValue
        case .driverProfile: return ApisURL.ServiceUrls.driverProfile.rawValue
        case .logout: return ApisURL.ServiceUrls.logout.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .driverProfile:
            return .get
        case .login, .logout:
            return .post
        }
    }
    
    var isJSONRequest: Bool {
        switch self {
        case .login:
            return true
        case .driverProfile, .logout:
            return false
        }
    }
    var multipartBody: MulitPartParam? {
        switch self {
        default:
            return nil
        }
    }
    var headers: [String: String] {
        return createHeaders()
    }
    var instance: ApiManager {
        return .init(targetData: self)
    }
}
