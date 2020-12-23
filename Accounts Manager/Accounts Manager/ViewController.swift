//
//  ViewController.swift
//  Accounts Manager
//
//  Created by Родион Сприкут on 20.12.2020.
//

import UIKit
import RealmSwift
import DropDown


class ViewController: UIViewController {

    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var converterViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var systemLabel: UILabel!
    @IBOutlet weak var rubLabel: UILabel!
    @IBOutlet weak var equalsLabel: UILabel!
    @IBOutlet weak var countButton: UIButton!
    @IBOutlet weak var roublesTextfield: UITextField!
    
    @IBOutlet weak var countedCyrrencyLabel: UILabel!
    @IBOutlet weak var chosenCurrencyLabel: UILabel!
    @IBOutlet weak var showDropDownButton: UIButton!
    @IBOutlet weak var chooseCurrencyView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var converterViewIsHidden = true
    
    let realm = try! Realm()
    var categories: [CategoryExample] = [] {
        didSet {
            categoriesTableView.reloadData()
        }
    }
    
    let dropDown = DropDown()
    
    var currenciesRatesArray = RatesExample(GBP: 0, USD: 0, EUR: 0, CAD: 0, PLN: 0, UAH: 0, JPY: 0)
    let currencyExamples = ["GBP", "USD", "EUR", "CAD", "PLN", "UAH", "JPY"]
    var chosenCurrencyRate = 1.0
    
    @IBAction func showDropDownButton(_ sender: Any) {
        getCurrencies()

        dropDown.dataSource = currencyExamples
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            chosenCurrencyLabel.text = item
    
            switch item {
            case "GBP": chosenCurrencyRate = currenciesRatesArray.GBP
            case "USD": chosenCurrencyRate = currenciesRatesArray.USD
            case "EUR": chosenCurrencyRate = currenciesRatesArray.EUR
            case "CAD": chosenCurrencyRate = currenciesRatesArray.CAD
            case "PLN": chosenCurrencyRate = currenciesRatesArray.PLN
            case "UAH": chosenCurrencyRate = currenciesRatesArray.UAH
            case "JPY": chosenCurrencyRate = currenciesRatesArray.JPY
            default: errorMessageLabel.text = "Выберите валюту"
            }
        }
    }
    
    @IBAction func countButton(_ sender: Any) {
        if chosenCurrencyRate == 1.0 {
            animateErrorMessageLabel(with: "Выберите валюту")
        } else {
            if roublesTextfield.text != "" {
                if self.roublesTextfield.text!.isNumeric {
                    let result = Double(self.roublesTextfield.text!)! / chosenCurrencyRate
                    self.countedCyrrencyLabel.text = String(format: "%.2f", result)
                } else {
                    animateErrorMessageLabel(with: "Введите количество валюты цифрами")
                }
            } else {
                animateErrorMessageLabel(with: "Введите количество валюты цифрами")
            }
        }
    }
    
    @IBAction func reloadCategoriesButton(_ sender: Any) {
        reloadCategories()
    }
    
    
    @IBAction func converterTapGestureRecognizer(_ sender: Any) {
        if converterViewIsHidden {
            UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                self.converterViewHeightConstraint.constant = 250
                self.updateLabelsAlpha(with: 1)
                
                self.view.layoutIfNeeded()
            }, completion: {_ in
                self.converterViewIsHidden.toggle()
            })
            
        } else {
            UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.65, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                self.converterViewHeightConstraint.constant = 65
                self.updateLabelsAlpha(with: 0)

                self.view.layoutIfNeeded()
            }, completion: {_ in
                self.converterViewIsHidden.toggle()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        converterViewHeightConstraint.constant = 65
        updateLabelsAlpha(with: 0)
        chosenCurrencyLabel.text = ""
        errorMessageLabel.text = ""
        countedCyrrencyLabel.text = ""
        
        roublesTextfield.backgroundColor = .white
        roublesTextfield.textColor = .black
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        categoriesTableView.register(UINib(nibName: "MainViewControllerTableCell", bundle: nil), forCellReuseIdentifier: "MainViewControllerTableCell")
        
        dropDown.anchorView = chooseCurrencyView
        reloadCategories()
    }
    
    func reloadCategories() {
        categories = []
        let categoriesFromRealm = realm.objects(CategoryExample.self)
        for category in categoriesFromRealm {
            categories.append(category)
        }
    }
    
    func getCurrencies() {
        guard let url = URL(string: "https://www.cbr-xml-daily.ru/latest.js") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if
                let data = data,
                let parsedCurrencies = try? JSONDecoder().decode(ParsedCurrencies.self, from: data)
            {
                self.currenciesRatesArray = parsedCurrencies.rates
            }
            
        }.resume()
    }
    
    func updateLabelsAlpha(with alpha: CGFloat) {
        systemLabel.alpha = alpha
        rubLabel.alpha = alpha
        equalsLabel.alpha = alpha
        countButton.alpha = alpha
        roublesTextfield.alpha = alpha
        countedCyrrencyLabel.alpha = alpha
        chooseCurrencyView.alpha = alpha
        showDropDownButton.alpha = alpha
        chosenCurrencyLabel.alpha = alpha
        errorMessageLabel.alpha = alpha
    }
    
    func animateErrorMessageLabel(with text: String) {
        UIView.animate(withDuration: 1.5, delay: 0, options: .autoreverse, animations: {
            self.errorMessageLabel.text = text
            self.errorMessageLabel.alpha = 1
        }, completion: { _ in
            self.errorMessageLabel.alpha = 0
        })
    }
    
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewControllerTableCell") as! MainViewControllerTableCell

        let cellName = categories[indexPath.row].name
        let categoryChanges = realm.objects(AccountChange.self).filter{ $0.cellOwner == cellName }
        var totalSpendings = 0
        var totalReceivings = 0

        for change in categoryChanges {
            totalSpendings += change.expense
            totalReceivings += change.receipt
        }

        cell.updateLabels(cellName: cellName, spendings: String(totalSpendings), receivings: String(totalReceivings))
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
