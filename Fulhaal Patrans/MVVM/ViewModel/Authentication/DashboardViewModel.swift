//
//  DashboardViewModel.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 05/07/21.
//

import Foundation
import RxSwift

class DashboardViewModel {
    var model = DashboardModel()
    var validationSubject = PublishSubject<ValidationResponseModel>()
    var validationObserver: Observable<ValidationResponseModel> {
        return validationSubject.asObserver()
    }
    var logoutSubject = PublishSubject<ValidationResponseModel>()
    var logoutObserver: Observable<ValidationResponseModel> {
        return logoutSubject.asObserver()
    }
    /// Get profile
    func driverProfile() {
        AuthEndPoint.driverProfile.instance.executeQuery { (response: GetProfile) in
            if response.status == true {
                guard let responseData = response.data?.first else { return }
                self.model.driverData = responseData
                self.model.driverId = responseData.id
                standard.setValue(responseData.currentTrip, forKey: "currentTrip")
                self.validationSubject.onNext(ValidationResponseModel(valid: response.status, errMsg: response.message ?? ""))
            } else {
                self.validationSubject.onNext(ValidationResponseModel(valid: response.status, errMsg: response.message ?? ""))
            }
        } error: { (errorMsg) in
            self.validationSubject.onNext(ValidationResponseModel(valid: false, errMsg: errorMsg ?? ""))
        }
    }
    /// Logout
    func logout() {
        AuthEndPoint.logout.instance.executeQuery { (response: LoginData) in
            if response.status == true {
                loginToken = ""
                standard.setValue(false, forKey: "isUserLogin")
                self.logoutSubject.onNext(ValidationResponseModel(valid: response.status, errMsg: response.message ?? ""))
            } else {
                self.validationSubject.onNext(ValidationResponseModel(valid: response.status, errMsg: response.message ?? ""))
            }
        } error: { (errorMsg) in
            self.validationSubject.onNext(ValidationResponseModel(valid: false, errMsg: errorMsg ?? ""))
        }
    }
    /// updateLocation
    func updateLocation() {
        HomeEndPoints.updateLocation(id: self.model.driverId ?? "", lat: self.model.lat ?? "", log: self.model.long ?? "").instance.executeQuery { (response: ShiftData) in
            if response.status == true {
                
            } else {
            }
        } error: { (_) in
        }
    }
}
