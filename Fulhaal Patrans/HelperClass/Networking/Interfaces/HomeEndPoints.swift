//
//  HomeEndPoints.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 07/07/21.
//
import Foundation
import UIKit
import Alamofire
enum HomeEndPoints: TargetType {
    case getDriverShiftStatus(driverId: String)
    case changeShiftStatus(isavailable: Bool, driverId: String, lat: Double, long: Double)
    case getPreviousShifts(date: String, driverId: String, pageno: Int)
    case getTripHistoryList(isDetails: Bool, driverId: String, pageNo: String, type: String, startDate: String, endDate: String, tripId: String)
    case getTripDetails(tripId: String, driverId: String)
    case updateTripStatus(details: [String: Any]?, imageToUpload: [UIImage]?, docFile: [URL]?)
    case updateTripDoc(tripId: String, imageToUpload: [UIImage]?, docFile: [URL]?)
    case addOtherServices(driverid: String, date: String, amount: String, truckid: String, document: String, type: String, notes: String, imageToUpload: [UIImage]?, docFile: [URL]?)
    case updatePreviousShiftDetails(shiftId: String, startShift: String, endShift: String, startShiftTime: String, endShiftTime: String)
    case getVehicleList
    case deleteDocument(type: String, id: String)
    case updateLocation(id: String, lat: String, log: String)
    var data: [String: Any] {
        switch self {
        case .changeShiftStatus(isavailable: let isavailable, driverId: let driverId, lat: let lat, long: let long):
            return ["id": driverId, "isavailable": isavailable, "lat": lat, "long": long]
        case .getPreviousShifts(date: let date, driverId: let driverId, pageno: let pageno):
            return ["date": date, "id": driverId, "pageno": pageno, "limit": 10]
        case .getTripHistoryList(isDetails: let isDetails, driverId: let driverId, pageNo: let pageNo, type: let type, startDate: let startDate, endDate: let endDate, tripId: let tripId):
        if isDetails {
            return ["driverid": driverId, "tripid": tripId, "pageno": pageNo, "limit": "10"]
        } else {
            return ["id": driverId, "type": type, "startdate": startDate, "enddate": endDate, "pageno": pageNo, "limit": "10"]
        }
        case .getTripDetails(tripId: let tripId, driverId: let driverId):
            return ["driverid": driverId, "tripid": tripId]
        case .updateTripStatus(details: let details, imageToUpload: _, docFile: _):
            return details ?? ["" : ""]
        case .updateTripDoc(tripId: let tripId, imageToUpload: _, docFile: _):
            return ["tripid": tripId]
        case .addOtherServices(driverid: let driverid, date: let date, amount: let amount, truckid: let truckid, document: _, type: let type, notes: let notes, imageToUpload: _, docFile: _):
            if type == "fuel" {
                return ["driverid": driverid, "date": date, "amount": amount, "truckid": truckid, "type": type]
            } else {
                return ["driverid": driverid, "date": date, "amount": amount, "truckid": truckid, "type": type, "notes": notes]
            }
        case .updatePreviousShiftDetails(shiftId: let shiftId, startShift: let startShift, endShift: let endShift, startShiftTime: let startShiftTime, endShiftTime: let endShiftTime):
            return ["shiftId": shiftId, "startDate": startShift, "endDate": endShift, "startTime": startShiftTime, "endTime": endShiftTime]
        case .deleteDocument(type: let type, id: let id):
            return ["type": type, "id": id]
        case .updateLocation(id: let id, lat: let lat, log: let log):
            return [  "id": id,
                      "lat": lat,
                      "log": log ]
        default:
            return ["": ""]
        }
    }
    var service: String {
        switch self {
        case .getDriverShiftStatus(driverId: let driverId): return "\(ApisURL.ServiceUrls.getDriverShiftStatus.rawValue)/\(driverId)"
        case .changeShiftStatus: return ApisURL.ServiceUrls.changeShiftStatus.rawValue
        case .getPreviousShifts: return ApisURL.ServiceUrls.getPreviousShifts.rawValue
        case .getTripHistoryList: return ApisURL.ServiceUrls.getTripHistoryList.rawValue
        case .getTripDetails: return ApisURL.ServiceUrls.getTripDetails.rawValue
        case .updateTripStatus: return ApisURL.ServiceUrls.updateTripStatus.rawValue
        case .updateTripDoc: return ApisURL.ServiceUrls.updateTripDoc.rawValue
        case .addOtherServices: return ApisURL.ServiceUrls.addOtherServices.rawValue
        case .getVehicleList: return ApisURL.ServiceUrls.getVehicleList.rawValue
        case .updatePreviousShiftDetails: return ApisURL.ServiceUrls.updatePreviousShiftDetails.rawValue
        case .deleteDocument: return ApisURL.ServiceUrls.deleteDocument.rawValue
        case .updateLocation: return ApisURL.ServiceUrls.updateLocation.rawValue
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getDriverShiftStatus, .getVehicleList:
            return .get
        case .changeShiftStatus, .updatePreviousShiftDetails:
            return .put
        case .getPreviousShifts, .getTripHistoryList, .updateTripStatus, .addOtherServices, .getTripDetails, .updateTripDoc, .updateLocation:
            return .post
        case .deleteDocument:
            return .delete
        }
    }
    
    var isJSONRequest: Bool {
        switch self {
        case .changeShiftStatus, .getPreviousShifts, .getTripHistoryList, .updateTripStatus, .addOtherServices, .getTripDetails, .updateTripDoc, .updatePreviousShiftDetails, .deleteDocument, .updateLocation:
            return true
        case .getDriverShiftStatus, .getVehicleList:
            return false
        }
    }
    var multipartBody: MulitPartParam? {
        switch self {
        case .addOtherServices(driverid: _, date: _, amount: _, truckid: _, document: _, type: _, notes: _, imageToUpload: let images, docFile: let docURL):
            return .init(imgArr: images, fileName: nil, docFile: docURL, mimeType: nil)
        case .updateTripStatus(details: _, imageToUpload: let images, docFile: let docURL):
        return .init(imgArr: images, fileName: nil, docFile: docURL, mimeType: nil)
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
