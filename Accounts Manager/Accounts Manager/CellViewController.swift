//
//  CellViewController.swift
//  Accounts Manager
//
//  Created by Родион Сприкут on 21.12.2020.
//

import UIKit
import RealmSwift
import FSCalendar


class CellViewController: UIViewController {
    
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var gainedLabel: UILabel!
    
    @IBOutlet weak var calendarView: FSCalendar!
    
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var chosenDateLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    
    @IBOutlet weak var spendingsTextdield: UITextField!
    @IBOutlet weak var receiptsTextfield: UITextField!
    
    
    let realm = try! Realm()
    
    var calendarAlphaShow = false
    
    var chosenDate: String = ""
    var cellName: String = ""
    
    
    //MARK: - Показ выпадающего списка дат и запись в лейблы трат и доходов за выбранную дату
    @IBAction func unrollDatesButton(_ sender: Any) {
        animateCalendar()
    }
    
    //MARK: - Кнопка для записи введённых трат за выбранную дату в Realm
    @IBAction func saveSpendingsButton(_ sender: Any) {
        let currentCellChanges = realm.objects(AccountChange.self).filter("cellOwner == %@", self.cellName)//.filter{ $0.cellOwner == self.cellName }
        var changeIndex = -1

        if chosenDate != "" {
            if spendingsTextdield.text != "" {
                if spendingsTextdield.text!.isNumeric {
                
                    for (index, change) in currentCellChanges.enumerated() {
                        if change.date == chosenDate {
                            changeIndex = index
                        }
                    }
                    //MARK: - Выполняется, если в Realm содержится информация о тратах и доходах за выбранную дату
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
    
    //MARK: - Кнопка для записи введённых доходов за выбранную дату в Realm
    //MARK: - Логика такая же, как в кнопке для записи трат
    @IBAction func saveReceiptsButton(_ sender: Any) {
        let currentCellChanges = realm.objects(AccountChange.self).filter("cellOwner == %@", self.cellName)
        var changeIndex = -1
        
        if chosenDate != "" {
            if receiptsTextfield.text != "" {
                if receiptsTextfield.text!.isNumeric {
                
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
            } else { animateLabel(with: "Введите доходы цифрами") }
        } else { animateLabel(with: "Выберите дату") }
    }
    
    //MARK: - Анимирование появляющихся лейблов, обрабатывающих действия пользователя
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
    
    func animateCalendar() {
        if !calendarAlphaShow {
            UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                self.calendarView.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                self.calendarView.alpha = 0
            })
        }
        calendarAlphaShow.toggle()
        
        getDataFromRealm()
        
    }
    
    //MARK: - Получение сохранённой в Realm информации для выбранной категории
    func getDataFromRealm() {
        let currentCellChanges = realm.objects(AccountChange.self).filter("cellOwner == %@", self.cellName)

        var changeIndex = -1
        for (index, change) in currentCellChanges.enumerated() {
            if change.date == chosenDate {
                changeIndex = index
            }
        }

        //MARK: - Выполняется, если в Realm содержится информация о тратах и доходах за выбранную дату
        if changeIndex >= 0 {
            animateSpendingsLabel(label: self.spentLabel, with: String(currentCellChanges[changeIndex].expense))
            animateSpendingsLabel(label: self.gainedLabel, with: String(currentCellChanges[changeIndex].receipt))

        } else {
            animateSpendingsLabel(label: self.spentLabel, with: "0")
            animateSpendingsLabel(label: self.gainedLabel, with: "0")
        }
    }
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        saveLabel.alpha = 0
        spentLabel.alpha = 0
        gainedLabel.alpha = 0
        calendarView.alpha = 0
    }

    
    //MARK: - Запись названия категории в лейбл
    func setCellNameAndInitDates(name: String) {
        cellName = name
        cellNameLabel.text = "Категория '\(name)'"
    }

}

extension CellViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let chosenDate = dateFormatter.string(from: date)
        
        self.chosenDate = "\(chosenDate)"
        self.chosenDateLabel.text = "\(chosenDate)"
        
        animateCalendar()
    }
}
