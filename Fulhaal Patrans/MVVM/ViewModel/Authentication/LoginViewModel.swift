//
//  LoginViewModel.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 05/07/21.
//

import Foundation
import RxSwift

class LoginViewModel {
    var model = LoginModel()
    var validationSubject = PublishSubject<ValidationResponseModel>()
    var validationObserver: Observable<ValidationResponseModel> {
        return validationSubject.asObserver()
    }
    /// login api call
    func loginApiCall() {
        AuthEndPoint.login(phoneNo: self.model.phone ?? "", dcode: self.model.driverCode?.uppercased() ?? "").instance.executeQuery { (response: LoginData) in
            if response.status == true {
                loginToken = response.data?.first?.token ?? ""
                standard.setValue(true, forKey: "isUserLogin")
                self.validationSubject.onNext(ValidationResponseModel(valid: response.status, errMsg: response.data?.first?.identity ?? ""))
            } else {
                self.validationSubject.onNext(ValidationResponseModel(valid: response.status, errMsg: response.message ?? ""))
            }
        } error: { (errorMsg) in
            self.validationSubject.onNext(ValidationResponseModel(valid: false, errMsg: errorMsg ?? ""))
        }
    }
    /// vaildation for inputs
    func checkValidInputs() {
        /// to bypass login
        if model.phone?.isEmpty ?? false {
            self.validationSubject.onNext(ValidationResponseModel(valid: false, errMsg: "Please Enter Phone Number"))
        } else if model.driverCode?.isEmpty ?? false {
            self.validationSubject.onNext(ValidationResponseModel(valid: false, errMsg: "Please enter Driver Code"))
        } else {
            self.loginApiCall()
        }
    }
}
