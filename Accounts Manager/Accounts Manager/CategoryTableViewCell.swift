//
//  CategoryTableViewCell.swift
//  Accounts Manager
//
//  Created by Родион Сприкут on 20.12.2020.
//

import UIKit

protocol DeletingCellDelegate: AnyObject {
    func cellDeleted(at index: Int, with name: String)
}


class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryNameLabelWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var categoryDeleteButton: UIButton!
    
    weak var delegate: DeletingCellDelegate?
    
    var cellIndex: Int = 0
    
    @IBAction func categoryDeleteButton(_ sender: Any) {
        delegate?.cellDeleted(at: cellIndex, with: categoryNameLabel.text ?? "")
    }
    
    
    func setLabelWidth(labelWidth: CGFloat) {
        categoryNameLabelWidthConstraint.constant = labelWidth
    }
    
    func setLabelText(labelText: String) {
        categoryNameLabel.text = labelText
    }
    
    func getCellIndex(index: Int) {
        cellIndex = index
    }
}
