//
//  TripHistoryModel.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 11/07/21.
//

import Foundation
class TripHistoryModel {
    var driverId: String?
    var type: String?
    var startDate: String?
    var endDate: String?
    var tripId: String?
    var notes: String?
    enum CurrentScreenUse {
        case futureTrip
        case todayTrip
        case previousTrip
    }
    var currentScreenUse: CurrentScreenUse = .todayTrip
    var currentPage = 1
    var apiHit = Bool()
    var tripHistories = [TripHistoryDataResponse]()

}
// MARK: - TripHistoryData
struct TripHistoryData: Codable {
    let status: Bool?
    let message: String?
    let data: [TripHistoryDataResponse]?
}

// MARK: - DataClass
struct TripHistoryDataResponse: Codable {
    let id, pudate, ptime, plocation, dodate, dtime, dlocation, status, driver_status, trip: String?
    enum CodingKeys: String, CodingKey {
        case id, pudate, ptime, plocation, dodate, dtime, dlocation, status, driver_status, trip
    }
}
