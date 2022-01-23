//
//  SelectDate.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 24/06/21.
//

import UIKit
class SelectDate: UIView {
    // MARK: - Properties
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var txtFieldDate: UITextField!
    // MARK: - Variables
    let datePicker = UIDatePicker()
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: - Extra functions
    private  func commonInit() {
        Bundle.main.loadNibNamed("SelectDate", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        datePicker.datePickerMode = .date
        self.txtFieldDate.inputView = datePicker
        self.txtFieldDate.delegate = self
    }
    // MARK: - IBActions
    @IBAction func btnDoneAct(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    @IBAction func btnCrossAct(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
extension SelectDate: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.txtFieldDate.text = datePicker.date.convertDateToString(date: datePicker.date, outputFormat: "MMM, dd, yyyy")
    }
}
// MARK: - Extension UI
