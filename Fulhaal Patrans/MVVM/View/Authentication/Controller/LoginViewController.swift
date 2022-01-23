//
//  LoginViewController.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 08/05/21.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var txtFieldDriver: UITextField!
    @IBOutlet weak var txtFiledPhone: UITextField!
    // MARK: - Variables
    var viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFiledPhone.delegate = self
        self.view.insertSubview(Theme.standard.setBgimgView(contentView: self.view), at: 0)
        self.rxSubscribers()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    // MARK: - IBActions
    @IBAction func btnLogin(_ sender: UIButton) {
        self.viewModel.model.phone = self.txtFiledPhone.text ?? ""
        self.viewModel.model.driverCode = self.txtFieldDriver.text ?? ""
        self.navigationController?.view.startProgresshud()
        self.viewModel.checkValidInputs()
    }
    // MARK: - Extra functions
    // MARK: - APIs
    /// Rxswift subscribers
    func rxSubscribers() {
        self.viewModel.validationObserver.subscribe(onNext: { [weak self] response in
            self?.navigationController?.view.stopProgressHud()
            if response.valid ?? false {
                guard let nextVc = AppStoryboard.auth.instance.instantiateViewController(withIdentifier: "DashBoardViewController") as? DashBoardViewController else { return }
                nextVc.viewModel.model.driverId = response.errMsg
                self?.navigationController?.pushViewController(nextVc, animated: true)
            } else {
                self?.showalertViewcontroller(message: response.errMsg ?? "")
            }
        }).disposed(by: disposeBag)
    }
}
// MARK: - Extension UI
extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if textField == self.txtFiledPhone {
            return count <= 10
        } else {
            return true
        }
    }
}
