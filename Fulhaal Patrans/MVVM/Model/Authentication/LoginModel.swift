//
//  LoginModel.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 05/07/21.
//

import Foundation
class LoginModel {
    var phone: String?
    var driverCode: String?
    
}
// MARK: - LoginData
struct LoginData: Codable {
    let status: Bool?
    let message: String?
    let data: [LoginDataResponse]?
}

// MARK: - DataClass
struct LoginDataResponse: Codable {
    let identity, phone, dname, token: String?
    enum CodingKeys: String, CodingKey {
        case identity = "id"
        case phone, dname, token
    }
}
struct ValidationResponseModel {
    var valid: Bool?
    var errMsg: String?
}
