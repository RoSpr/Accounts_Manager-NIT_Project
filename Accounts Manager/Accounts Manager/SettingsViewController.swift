//
//  SettingsViewController.swift
//  Accounts Manager
//
//  Created by Родион Сприкут on 20.12.2020.
//

import UIKit
import RealmSwift


class SettingsViewController: UIViewController{
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var heightCategoryViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var categoryAddedLabel: UILabel!
    @IBOutlet weak var categoryTextfield: UITextField!
    @IBOutlet weak var addCategoryButton: UIButton!
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    let realm = try! Realm()
    
    var categoryViewIsHidden = true
    var categories: [CategoryExample] = [] {
        didSet {
            categoryTableView.reloadData()
        }
    }
    
    //MARK: - Кнопка для добавления категории и записи их в Realm
    //MARK: - Также реагирует на успешное/неуспешное добавление категории показом соответствующих сообщений в лейбле
    @IBAction func addCategoryButton(_ sender: Any) {
        var categoryNamesArray: [String] = []
        for category in categories {
            categoryNamesArray.append(category.name)
        }
        
        if categoryNamesArray.contains(categoryTextfield.text!) {
            animateCategoryAddedLabel(with: "Название категории уже занято")
            
            self.categoryTextfield.text = ""
            
        } else if categoryTextfield.text != "" {
            let newCategory = CategoryExample()
            newCategory.name = categoryTextfield.text!
            categories.append(newCategory)
            
            do {
                try realm.write {
                    realm.add(newCategory)
                }
            } catch let error as NSError {
                print("An error occured: \(error.localizedDescription)")
            }
            
            animateCategoryAddedLabel(with: "Категория добавлена")
            self.categoryTextfield.text = ""
            
        } else {
            animateCategoryAddedLabel(with: "Введите название категории")
            
        }
    }
    
    //MARK: - Функция для анимирования лейбла
    func animateCategoryAddedLabel(with text: String) {
        UIView.animate(withDuration: 1.5, delay: 0, options: .autoreverse, animations: {
            self.categoryAddedLabel.text = text
            self.categoryAddedLabel.alpha = 1
        }, completion: { _ in
            self.categoryAddedLabel.alpha = 0
        })
    }
    
    //MARK: - Обработчик нажатий пользователя. Скрывает/раскрывает зелёную вью с возможностью добавления категорий, расположенную вверху экрана
    @IBAction func unrollCategoryAddingByTapRecognizer(_ sender: Any) {
        if categoryViewIsHidden {
            UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                self.heightCategoryViewConstraint.constant = 180
                self.addCategoryButton.alpha = 1
                self.categoryTextfield.alpha = 1
                
                self.view.layoutIfNeeded()
            }, completion: {_ in
                self.categoryViewIsHidden.toggle()
            })
        } else {
            UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                self.heightCategoryViewConstraint.constant = 65
                self.addCategoryButton.alpha = 0
                self.categoryTextfield.alpha = 0
                
                self.view.layoutIfNeeded()
            }, completion: {_ in
                self.categoryViewIsHidden.toggle()
            })
        }
    }
    
    //MARK: - Получение категорий из Realm, обновление таблицы с ними, если они есть, и сокрытие некоторых лейблов на вью с добавлением категорий, а также её сворачивание
    override func viewDidLoad() {
        super.viewDidLoad()
        let storedCategories = realm.objects(CategoryExample.self)
        if storedCategories.count != 0 {
            categories.append(contentsOf: storedCategories)
        }
        
        categoryView.alpha = 0.7
        categoryAddedLabel.alpha = 0
        addCategoryButton.alpha = 0
        categoryTextfield.alpha = 0
        categoryTextfield.backgroundColor = .white
        categoryTextfield.textColor = .black
        heightCategoryViewConstraint.constant = 65
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        categoryTableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        
        cell.setLabelWidth(labelWidth: self.view.frame.width - cell.categoryDeleteButton.frame.width - 30)
        cell.setLabelText(labelText: categories[indexPath.row].name)
        cell.getCellIndex(index: indexPath.row)
        cell.delegate = self
        
        return cell
    }
    
    
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! CategoryTableViewCell
        let cellName = cell.categoryNameLabel.text
        
        let controller = self.storyboard!.instantiateViewController(identifier: "CellVC") as! CellViewController
        
        present(controller, animated: true, completion: nil)
        controller.setCellNameAndInitDates(name: cellName ?? "")
    }
}


//MARK: - Делегат строки таблицы для обработки её удаления как из таблицы, так и из Realm
extension SettingsViewController: DeletingCellDelegate {
    func cellDeleted(at index: Int, with name: String) {
        categories.remove(at: index)

        let dataToDelete = realm.objects(AccountChange.self).filter("cellOwner == %@", name)
        let categoryToDelete = realm.objects(CategoryExample.self).filter("name == %@", name)
        do {
            try realm.write {
                realm.delete(dataToDelete)
                realm.delete(categoryToDelete)
            }
        } catch let error as NSError {
            print("An error occured: \(error.localizedDescription)")
        }
    }
}
