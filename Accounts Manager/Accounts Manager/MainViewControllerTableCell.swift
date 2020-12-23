//
//  MainViewControllerTableCell.swift
//  Accounts Manager
//
//  Created by Родион Сприкут on 22.12.2020.
//

import UIKit

class MainViewControllerTableCell: UITableViewCell {

    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var spendingsLabel: UILabel!
    @IBOutlet weak var receivingsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabels(cellName: String, spendings: String, receivings: String) {
        cellNameLabel.text = cellName
        spendingsLabel.text = spendings
        receivingsLabel.text = receivings
    }
}
