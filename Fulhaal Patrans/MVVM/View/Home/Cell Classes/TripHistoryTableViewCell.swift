//
//  TripHistoryTableViewCell.swift
//  Fulhaal Patrans
//
//  Created by Sachin on 09/05/21.
//

import UIKit
class TripHistoryTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var btnYearly: UIButton!
    @IBOutlet weak var btnMonthly: UIButton!
    @IBOutlet weak var btnWeekly: UIButton!
    @IBOutlet weak var lblTripNo: UILabel!
    @IBOutlet weak var lblPickLoc: UILabel!
    @IBOutlet weak var lblPickTime: UILabel!
    @IBOutlet weak var lblDropLoc: UILabel!
    @IBOutlet weak var lblDropTime: UILabel!
    @IBOutlet weak var lblPickTimeFut: UILabel!
    @IBOutlet weak var lblPickDateFut: UILabel!
    @IBOutlet weak var lblDropTimeFut: UILabel!
    @IBOutlet weak var lblDropDateFut: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
