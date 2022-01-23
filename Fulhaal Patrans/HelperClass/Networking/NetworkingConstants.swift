//
//  NetworkingConstants.swift
//  MedoPlus Facility
// 
//  Created by Relinns Technologies  on 04/03/21.
//

import Foundation
struct ApisURL {
    /// Base Url
    // MARK: - App URL's
    static let baseURl = "https://dispatch-demo.patransportca.com/Appapi/"
    enum ServiceUrls: String {
        // MARK: - Common URLs
        // Auth
       case login = "driverlogin"
        case driverProfile = "driverinfo"
        case logout = "driverlogout"
        // SETTINGS
        // Home Module
        case getDriverShiftStatus = "checkdrivershiftstatus"
        case changeShiftStatus = "drivershiftstartend"
        case getPreviousShifts = "previousshift"
        case getTripHistoryList = "triphistory"
        case getTripDetails = "tripinfo"
        case updateTripStatus = "tripinfoupdate"
        case updateTripDoc = "tripdocument"
        case addOtherServices = "addothers"
        case getVehicleList = "getvehicles"
        case updatePreviousShiftDetails = "previousshiftupdate"
        case getUoadtelost = "getupfatelist"
        case deleteDocument = "remove_document"
        case updateLocation = "livelatlog"
        }
}
