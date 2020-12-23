//
//  CellViewController.swift
//  Accounts Manager
//
//  Created by Родион Сприкут on 21.12.2020.
//

import UIKit
import RealmSwift
import DropDown


class CellViewController: UIViewController {
    
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var gainedLabel: UILabel!
    

    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var chosenDateLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    
    @IBOutlet weak var spendingsTextdield: UITextField!
    @IBOutlet weak var receiptsTextfield: UITextField!
    
    
    let realm = try! Realm()
    let dropDown = DropDown()
    
    
    var dates: [String] = []
    var currentDate: String = ""
    var chosenDate: String = ""
    var cellName: String = ""
    
    
    
    @IBAction func unrollDatesButton(_ sender: Any) {
        dropDown.dataSource = dates
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            chosenDate = item
            chosenDateLabel.text = item
            
            let currentCellChanges = realm.objects(AccountChange.self).filter{ $0.cellOwner == self.cellName }
            var changeIndex = 0
            for (index, change) in currentCellChanges.enumerated() {
                if change.date == chosenDate {
                    changeIndex = index
                }
            }
            
            animateSpendingsLabel(label: self.spentLabel, with: String(currentCellChanges[changeIndex].expense) )
            animateSpendingsLabel(label: self.gainedLabel, with: String(currentCellChanges[changeIndex].receipt) )
        }
    }
    
    @IBAction func saveSpendingsButton(_ sender: Any) {
        let currentCellChanges = realm.objects(AccountChange.self).filter{ $0.cellOwner == self.cellName }
        var changeIndex = -1

        if chosenDate != "" {
            if spendingsTextdield.text != "" {
                if spendingsTextdield.text!.isNumeric {
                
                    for (index, change) in currentCellChanges.enumerated() {
                        if change.date == chosenDate {
                            changeIndex = index
                        }
                    }
                    
                    if changeIndex >= 0 {
                        do {
                            try realm.write {
                                currentCellChanges[changeIndex].expense = Int(spendingsTextdield.text!)!
                            }
                        } catch let error as NSError {
                            print("An error occured: \(error)")
                        }
                        animateSpendingsLabel(label: self.spentLabel, with: spendingsTextdield.text!)
                        animateLabel(with: "Траты сохранены успешно!")
                        spendingsTextdield.text = ""
                        
                    } else {
                        let newChange = AccountChange()
                        newChange.cellOwner = cellName
                        newChange.date = chosenDate
                        newChange.expense = Int(spendingsTextdield.text!)!
                        do {
                            try realm.write {
                                realm.add(newChange)
                            }
                        } catch let error as NSError {
                            print("An error occured: \(error)")
                        }
                        
                        animateSpendingsLabel(label: self.spentLabel, with: spendingsTextdield.text!)
                        animateLabel(with: "Траты сохранены успешно!")
                        spendingsTextdield.text = ""
                    }
                } else { animateLabel(with: "Введите траты цифрами") }
            } else { animateLabel(with: "Введите траты цифрами") }
        } else { animateLabel(with: "Выберите дату") }
    }
    
    @IBAction func saveReceiptsButton(_ sender: Any) {
        let currentCellChanges = realm.objects(AccountChange.self).filter{ $0.cellOwner == self.cellName }
        var changeIndex = -1
        
        if chosenDate != "" {
            if receiptsTextfield.text != "" && ((receiptsTextfield.text?.rangeOfCharacter(from: CharacterSet.decimalDigits)) != nil) {
                
                for (index, change) in currentCellChanges.enumerated() {
                    if change.date == chosenDate {
                        changeIndex = index
                    }
                }
                
                if changeIndex >= 0 {
                    do {
                        try realm.write {
                            currentCellChanges[changeIndex].receipt = Int(receiptsTextfield.text!)!
                        }
                    } catch let error as NSError {
                        print("An error occured: \(error)")
                    }
                    
                    animateSpendingsLabel(label: self.gainedLabel, with: receiptsTextfield.text!)
                    animateLabel(with: "Доходы сохранены успешно!")
                    receiptsTextfield.text = ""
                    
                } else {
                    let newChange = AccountChange()
                    newChange.cellOwner = cellName
                    newChange.date = chosenDate
                    newChange.receipt = Int(receiptsTextfield.text!)!
                    do {
                        try realm.write {
                            realm.add(newChange)
                        }
                    } catch let error as NSError {
                        print("An error occured: \(error)")
                    }
                    
                    animateSpendingsLabel(label: self.gainedLabel, with: receiptsTextfield.text!)
                    animateLabel(with: "Доходы сохранены успешно!")
                    receiptsTextfield.text = ""
                }
            } else { animateLabel(with: "Введите доходы цифрами") }
        } else { animateLabel(with: "Выберите дату") }
    }
    
    func animateLabel(with text: String) {
        UIView.animate(withDuration: 1.5, delay: 0, options: .autoreverse, animations: {
            self.saveLabel.text = text
            self.saveLabel.alpha = 1
        }, completion: { _ in
            self.saveLabel.alpha = 0
        })
    }
    
    func animateSpendingsLabel(label: UILabel, with text: String) {
        UIView.animate(withDuration: 1.5, animations: {
            label.text = text
            label.alpha = 1
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveLabel.alpha = 0
        spentLabel.alpha = 0
        gainedLabel.alpha = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        currentDate = dateFormatter.string(from: Date.init())
        
        dropDown.anchorView = dropDownView
    }

    
    func getLastThirtyDays() -> [String] {
        var dates: [String] = []
        
        let date = Date.init()
        let calendar = Calendar.current

        var year = calendar.component(.year, from: date)
        var month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        if day < 30 {
            var dateComponents = DateComponents()
            if month == 1 {
                dateComponents.year = year - 1
                year -= 1
                dateComponents.month = 12
                
            } else {
                dateComponents.year = year
                dateComponents.month = month - 1
                month -= 1
            }
            
            let previousMonthDate = calendar.date(from: dateComponents)
            let daysInPreviousMonth = calendar.range(of: .day, in: .month, for: previousMonthDate!)
            
            var startDay = daysInPreviousMonth!.count - (30 - day)
            
            for _ in 0..<30 {
                dates.append("\(year).\(month).\(startDay)")
                if startDay == daysInPreviousMonth!.count {
                    startDay = 1
                    
                    if month == 12 {
                        year += 1
                        month = 1
                        
                    } else {
                        month += 1
                    }
                    
                } else {
                    startDay += 1
                }
            }
        }
        dates.append(currentDate)
        return dates
    }
    
    
    func setCellNameAndInitDates(name: String) {
        cellName = name
        cellNameLabel.text = "Категория \(name)"
        dates = getLastThirtyDays()
    }

}
