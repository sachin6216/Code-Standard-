//
//  DashboardModel.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 05/07/21.
//

import Foundation
class DashboardModel {
    var driverId: String?
    var lat: String?
    var long: String?
    var driverData: GetProfileData?
}

// MARK: - GetProfile
struct GetProfile: Codable {
    let status: Bool?
    let message: String?
    let data: [GetProfileData]?
}

// MARK: - Datum
struct GetProfileData: Codable {
    let id, dname, phone, currentTrip: String?
    let dimage: String?
    let email, address: String?
}
