//
//  DashBoardViewController.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 09/05/21.
//

import UIKit
import RxSwift
import SDWebImage
import CoreLocation
import Combine
class DashBoardViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var btnCurrentTrip: UIButton!
    @IBOutlet weak var btnTrip: UIButton!
    @IBOutlet weak var btnShift: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    // MARK: - Variables
    var viewModel = DashboardViewModel()
     private let disposeBag = DisposeBag()
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(Theme.standard.setBgimgView(contentView: self.view), at: 0)
        self.setTheme()
        self.rxSubscribers()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.view.startProgresshud()
        self.viewModel.driverProfile()
        /// Update location 
        LocationManager.sharedInstance.startUpdatingLocation()
        LocationManager.sharedInstance.delegate = self
    }
    // MARK: - IBActions
    @IBAction func btnTripsAct(_ sender: UIButton) {
        self.unselectedBtn(btns: [self.btnShift, self.btnCurrentTrip])
        self.selectedBtn(btns: btnTrip)
        guard let nextVc = AppStoryboard.home.instance.instantiateViewController(withIdentifier: "TripsViewController") as? TripsViewController else { return }
        nextVc.driverId = self.viewModel.model.driverId
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func btnShiftAct(_ sender: UIButton) {
        self.unselectedBtn(btns: [self.btnTrip, self.btnCurrentTrip])
        self.selectedBtn(btns: btnShift)
        guard let nextVc = AppStoryboard.home.instance.instantiateViewController(withIdentifier: "ShiftViewController") as? ShiftViewController else { return }
        nextVc.viewModel.model.driverId = self.viewModel.model.driverData?.id ??  self.viewModel.model.driverId
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
    @IBAction func btnCurrentTripAct(_ sender: UIButton) {
        self.unselectedBtn(btns: [self.btnShift, self.btnTrip])
        self.selectedBtn(btns: btnCurrentTrip)
        if (self.viewModel.model.driverData?.currentTrip?.isEmpty ?? false) || self.viewModel.model.driverData?.currentTrip == nil {
            self.showalertview(messagestring: "You don't have any current trips yet.")
        } else {
            guard let nextVc = AppStoryboard.home.instance.instantiateViewController(withIdentifier: "TripDetailsViewController") as? TripDetailsViewController else { return }
            nextVc.viewModel.model.driverID = self.viewModel.model.driverId
            nextVc.viewModel.model.tripId = self.viewModel.model.driverData?.currentTrip
            self.navigationController?.pushViewController(nextVc, animated: true)
        }       
    }
    // MARK: - Extra functions
    /// Set Theming and UI
    private func setTheme() {
        let leftBtn = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        let rightBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "logout"), style: .done, target: self, action: #selector(rightBtnAction))
        self.setNavThemeOrignal(title: "DASHBOARD".localize(), leftBtns: [leftBtn], rightBtns: [rightBtn], hideShadow: false)
        self.unselectedBtn(btns: [btnTrip, btnShift, btnCurrentTrip])
    }
    @objc func leftBtnAction() {
        self.pop()
    }
    @objc func rightBtnAction() {
        self.showalertview(messagestring: "Are you sure to be logged out from this app.", buttonmessage: "ok") {
            self.navigationController?.view.startProgresshud()
            self.viewModel.logout()
        }
    }
    func unselectedBtn(btns: [UIButton]) {
        for item in btns {
            item.backgroundColor = .white
            item.setTitleColor(Theme.Colors.primaryColor.instance, for: .normal)
        }
    }
    func selectedBtn(btns: UIButton) {
        btns.backgroundColor = Theme.Colors.primaryColor.instance
        btns.setTitleColor(.white, for: .normal)
    }
    // MARK: - APIs
    /// Rxswift subscribers
       func rxSubscribers() {
           self.viewModel.validationObserver.subscribe(onNext: { [weak self] response in
               self?.navigationController?.view.stopProgressHud()
               if response.valid ?? false {
                self?.lblName.text = self?.viewModel.model.driverData?.dname?.replacingOccurrences(of: "", with: "@") ?? ""
                self?.imgProfile.sd_setImage(with: URL.init(string: self?.viewModel.model.driverData?.dimage ?? ""), placeholderImage: #imageLiteral(resourceName: "Group 2"), options: [.progressiveLoad], context: nil)
               } else {
                   self?.showalertViewcontroller(message: response.errMsg ?? "")
               }
           }).disposed(by: disposeBag)
        self.viewModel.logoutObserver.subscribe(onNext: {  response in
            self.navigationController?.view.stopProgressHud()
            let controller = AppStoryboard.auth.instance.instantiateInitialViewController()
            if #available(iOS 13, *) {
                let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                sceneDelegate?.window?.rootViewController = controller
                sceneDelegate?.window?.makeKeyAndVisible()
            } else {
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.rootViewController = controller
                appDelegate?.window?.makeKeyAndVisible()
            }
        }).disposed(by: disposeBag)
       }
}
// MARK: - Extension UI
extension DashBoardViewController: LocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.viewModel.model.lat = "\(LocationManager.sharedInstance.coordinates?.latitude ?? 0.0)"
        self.viewModel.model.long = "\(LocationManager.sharedInstance.coordinates?.longitude ?? 0.0)"
        self.viewModel.updateLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.viewModel.model.lat = "\(LocationManager.sharedInstance.coordinates?.latitude ?? 0.0)"
        self.viewModel.model.long = "\(LocationManager.sharedInstance.coordinates?.longitude ?? 0.0)"
        self.viewModel.updateLocation()
    }
}
