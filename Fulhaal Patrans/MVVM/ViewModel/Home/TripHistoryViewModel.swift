//
//  TripHistoryViewModel.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 11/07/21.
//

import Foundation
import RxSwift
class TripHistoryViewModel {
    var model = TripHistoryModel()
    var validationSubject = PublishSubject<ValidationResponseModel>()
    var validationObserver: Observable<ValidationResponseModel> {
        return validationSubject.asObserver()
    }
    /// Get Trip History List
    func getTripHistoryList() {
        self.model.apiHit = true
        HomeEndPoints.getTripHistoryList(isDetails: false, driverId: self.model.driverId ?? "", pageNo: "\(self.model.currentPage)", type: self.model.type ?? "", startDate: self.model.startDate ?? "", endDate: self.model.endDate ?? "", tripId: self.model.tripId ?? "").instance.executeQuery { (response: TripHistoryData) in
            if response.status ?? false {
                guard let responseData = response.data else { return }
                if responseData.isEmpty {
                    if self.model.currentPage == 1 {
                        self.model.tripHistories.removeAll()
                    }
                    self.model.apiHit = true
                    self.model.currentPage = 1
                    self.validationSubject.onNext(ValidationResponseModel(valid: response.status, errMsg: response.message ?? ""))
                } else {
                    if self.model.currentPage == 1 {
                        self.model.tripHistories = responseData
                    } else {
                        self.model.tripHistories.append(contentsOf: responseData)
                    }
                    self.model.currentPage += 1
                    self.model.apiHit = false
                    self.validationSubject.onNext(ValidationResponseModel(valid: response.status, errMsg: response.message ?? ""))
                }
            } else {
                self.validationSubject.onNext(.init(valid: true, errMsg: response.message ?? ""))
            }
        } error: { (errorMsg) in
            self.validationSubject.onNext(ValidationResponseModel(valid: false, errMsg: errorMsg ?? ""))
        }
    }
}
