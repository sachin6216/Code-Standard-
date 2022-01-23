//
//  TripHistoryViewController.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 09/05/21.
//

import UIKit
import RxSwift
import DZNEmptyDataSet

class TripHistoryViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
        }
    }
    // MARK: - Variables
    var viewModel = TripHistoryViewModel()
    private let disposeBag = DisposeBag()
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(Theme.standard.setBgimgView(contentView: self.view), at: 0)
        self.rxSubscribers()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setTheme()
        self.viewModel.model.currentPage = 1
        if self.viewModel.model.currentScreenUse == .todayTrip {
            self.viewModel.model.type = "today"
            self.viewModel.model.startDate = ""
            self.viewModel.model.endDate = ""
            self.navigationController?.view.startProgresshud()
            self.viewModel.getTripHistoryList()
        } else {
            self.btnWeekAct(UIButton())
        }
    }
    // MARK: - IBActions
    @IBAction func btnYearlyAct(_ sender: UIButton) {
        let datePopup = SelcetMultiDates.init(frame: CGRect( x: 0, y: 0, width: self.view.frame.width, height: UIScreen.main.bounds.height))
        datePopup.delegate = self
        self.navigationController?.view.addSubview(datePopup)
    }
    @objc func btnWeekAct(_ sender: UIButton) {
        let previousDate = Date()
        self.viewModel.model.endDate = previousDate.convertDateToString(date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), outputFormat: "yyyy-MM-dd")
        guard let previouYesterday = Calendar.current.date(byAdding: .weekdayOrdinal, value: -1, to: Date()) else {
            return
        }
        self.viewModel.model.startDate = previousDate.convertDateToString(date: previouYesterday, outputFormat: "yyyy-MM-dd")
        self.viewModel.model.type = "week"
        self.viewModel.model.currentPage = 1
        self.navigationController?.view.startProgresshud()
        self.viewModel.model.tripHistories.removeAll()
        self.viewModel.getTripHistoryList()
    }
    @objc func btnMonthAct(_ sender: UIButton) {
        let previousDate = Date()
        self.viewModel.model.endDate = previousDate.convertDateToString(date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(), outputFormat: "yyyy-MM-dd")
        guard let previouYesterday = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else {
            return
        }
        self.viewModel.model.startDate = previousDate.convertDateToString(date: previouYesterday, outputFormat: "yyyy-MM-dd")
        self.viewModel.model.type = "month"
        self.viewModel.model.currentPage = 1
        self.viewModel.model.tripHistories.removeAll()
        self.navigationController?.view.startProgresshud()
        self.viewModel.getTripHistoryList()
    }
    
    // MARK: - Extra functions
    private func setTheme() {
        let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow"), style: .done, target: self, action: #selector(leftBtnAction))
        self.setNavThemeOrignal(title: "TRIPS".localize(), leftBtns: [leftBtn], rightBtns: nil, hideShadow: false)
    }
    @objc func leftBtnAction() {
        self.pop()
    }
    
    // MARK: - APIs
    /// Rxswift subscribers
    func rxSubscribers() {
        self.viewModel.validationObserver.subscribe(onNext: { response in
            self.navigationController?.view.stopProgressHud()
            self.tableView.tableFooterView = UIView()
            if response.valid ?? false {
                self.tableView.reloadData()
            } else {
                self.showalertViewcontroller(message: response.errMsg ?? "")
            }
        }).disposed(by: disposeBag)
    }
    
}
// MARK: - Extension UI
extension TripHistoryViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate  {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.viewModel.model.tripHistories.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.viewModel.model.currentScreenUse == .futureTrip {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as? TripHistoryTableViewCell else { fatalError("") }
            if self.viewModel.model.type == "week" {
                cell.btnWeekly.backgroundColor = Theme.Colors.primaryColor.instance
                cell.btnWeekly.setTitleColor(.white, for: .normal)
                cell.btnMonthly.backgroundColor = .white
                cell.btnMonthly.setTitleColor(Theme.Colors.primaryColor.instance, for: .normal)
                cell.btnYearly.backgroundColor = .white
                cell.btnYearly.setTitleColor(Theme.Colors.primaryColor.instance, for: .normal)
            } else if self.viewModel.model.type == "month" {
                cell.btnMonthly.backgroundColor = Theme.Colors.primaryColor.instance
                cell.btnMonthly.setTitleColor(.white, for: .normal)
                cell.btnWeekly.backgroundColor = .white
                cell.btnWeekly.setTitleColor(Theme.Colors.primaryColor.instance, for: .normal)
                cell.btnYearly.backgroundColor = .white
                cell.btnYearly.setTitleColor(Theme.Colors.primaryColor.instance, for: .normal)
            } else if self.viewModel.model.type == "calendar" {
                cell.btnYearly.backgroundColor = Theme.Colors.primaryColor.instance
                cell.btnYearly.setTitleColor(.white, for: .normal)
                cell.btnMonthly.backgroundColor = .white
                cell.btnMonthly.setTitleColor(Theme.Colors.primaryColor.instance, for: .normal)
                cell.btnWeekly.backgroundColor = .white
                cell.btnWeekly.setTitleColor(Theme.Colors.primaryColor.instance, for: .normal)
            }
            cell.btnMonthly.addTarget(self, action: #selector(btnMonthAct(_:)), for: .touchUpInside)
            cell.btnWeekly.addTarget(self, action: #selector(btnWeekAct(_:)), for: .touchUpInside)
            return cell
        } else {
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.model.currentScreenUse == .futureTrip || self.viewModel.model.currentScreenUse == .previousTrip {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell") as? TripHistoryTableViewCell else { fatalError("") }
            (indexPath.row % 2 == 0) ? (cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) : (cell.backgroundColor = #colorLiteral(red: 0.9493296742, green: 0.9333279729, blue: 0.9330348372, alpha: 1))
            let dataResponse = self.viewModel.model.tripHistories[indexPath.row]
            cell.lblPickDateFut.text = dataResponse.ptime
            cell.lblPickTimeFut.text = dataResponse.pudate?.convertDateFormat(date: dataResponse.pudate ?? "", outputFormat: "MMM, dd, yyyy")
            cell.lblDropTimeFut.text = dataResponse.dtime
            cell.lblDropDateFut.text = dataResponse.dodate?.convertDateFormat(date: dataResponse.dodate ?? "", outputFormat: "MMM, dd, yyyy")
            cell.lblTripNo.text = dataResponse.trip
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell") as? TripHistoryTableViewCell else { fatalError("") }
            (indexPath.row % 2 == 0) ? (cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) : (cell.backgroundColor = #colorLiteral(red: 0.9493296742, green: 0.9333279729, blue: 0.9330348372, alpha: 1))
            let dataResponse = self.viewModel.model.tripHistories[indexPath.row]
            cell.lblPickLoc.text = dataResponse.plocation
            cell.lblPickTime.text = dataResponse.ptime
            cell.lblDropLoc.text = dataResponse.dlocation
            cell.lblDropTime.text = dataResponse.dtime
            cell.lblTripNo.text = dataResponse.trip
            cell.lblStatus.text = dataResponse.driver_status
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  self.viewModel.model.currentScreenUse == .futureTrip ? 50 : 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((standard.string(forKey: "currentTrip") ==  self.viewModel.model.tripHistories[indexPath.row].id || standard.string(forKey: "currentTrip")?.isEmpty ?? false) && self.viewModel.model.currentScreenUse == .todayTrip) || self.viewModel.model.currentScreenUse != .todayTrip {
            guard let nextVc = AppStoryboard.home.instance.instantiateViewController(withIdentifier: "TripDetailsViewController") as? TripDetailsViewController else { return }
            let dataResponse = self.viewModel.model.tripHistories[indexPath.row]
            nextVc.viewModel.model.tripId = dataResponse.id
            nextVc.viewModel.model.driverID = self.viewModel.model.driverId
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.viewModel.model.currentPage != 1 && !self.viewModel.model.apiHit && (self.viewModel.model.tripHistories.count) - 1 == indexPath.row {
            self.tableView.setBottomIndicator()
            self.viewModel.getTripHistoryList()
        }
    }
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        let attributStr = Theme.standard.convertToNsAttributedString(inputString: "No Data Found!", textColor: .fontBalck, textSize: .normal, fontstyle: .medium)
        return attributStr
    }
}
// MARK: - SelcetMultiDatesDelegate
extension TripHistoryViewController: SelcetMultiDatesDelegate {
    func didselectDate(dates: [Date]?) {
        self.viewModel.model.type = "calendar"
        self.navigationController?.view.startProgresshud()
        self.viewModel.model.startDate = dates?.first?.convertDateToString(date: dates?.first ?? Date(), outputFormat: "yyyy-MM-dd")
        self.viewModel.model.endDate = dates?.last?.convertDateToString(date: dates?.last ?? Date(), outputFormat: "yyyy-MM-dd")
        self.viewModel.model.currentPage = 1
        self.viewModel.model.tripHistories.removeAll()
        self.viewModel.getTripHistoryList()
    }
}
