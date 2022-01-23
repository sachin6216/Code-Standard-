//
//  PickerViewCustomDataSource.swift
//  EcommRider
//
//  Created by Relinns Technologies  on 16/10/20.
//

import Foundation
import UIKit

typealias  SelectedRowBlock = (_ selectedRow: Int, _ item: Any) -> Void
class PickerViewCustomDataSource: NSObject {

    var picker: UIPickerView?
    var pickerData: [Any]?
    var aSelectedBlock: SelectedRowBlock?
    var columns: Int?
    let toolBar = UIToolbar()

    init(picker: UIPickerView?, items: [Any]?, columns: Int?, aSelectedStringBlock: SelectedRowBlock?, isSeletedFirstRow: Bool) {
        super.init()
        self.picker = picker
        self.aSelectedBlock = aSelectedStringBlock
        self.picker?.delegate = self
        self.picker?.dataSource = self
        guard let pickerData = items else { return }
        self.pickerData = pickerData
        if isSeletedFirstRow && pickerData.count != 0 {
        self.pickerView(self.picker ?? UIPickerView(), didSelectRow: 0, inComponent: 0)
        }
        self.columns = columns
    }

    override init() {
        super.init()
    }
}

extension PickerViewCustomDataSource: UIPickerViewDelegate, UIPickerViewDataSource {
    @available(iOS 10.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return columns ?? 0
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return columns ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return pickerData?.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

      if self.pickerData is [String] {

            guard let safeData = self.pickerData?[row] as? String else {return "tt"}
            return safeData

        } else { fatalError("data nil")}

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let block = self.aSelectedBlock {
            if pickerData?.count != 0 {
                block( row, pickerData?[row]  as Any )
            }
        }
    }
}
