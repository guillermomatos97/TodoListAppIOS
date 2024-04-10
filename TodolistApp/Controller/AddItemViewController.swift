//
//  AddItemViewController.swift
//  TodolistApp
//
//  Created by Gullermo Antonio Matos Uc on 09/04/24.
//

import UIKit

class AddItemViewController: UIViewController {
    
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var editLbl: UILabel!
    
    var localData: UserDefaultsHelper = UserDefaultsHelper()
    var itemsSaved:[Item] = [Item]()
    
    var indexPath:IndexPath? = nil
    var itemEdit:Item? = Item()

    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()

    }
    
    func setupUI(){
        if indexPath != nil {
            itemTextField.text = itemEdit?.text
            editLbl.isHidden = false
        } else {
            editLbl.isHidden = true
        }
        navigationController?.isNavigationBarHidden = false
        itemTextField.delegate = self
    }

    @IBAction func addItemAction(_ sender: UIButton) {
        if let text = itemTextField.text {
            if let index = indexPath {
                let editedItem = Item(text: text, checkState: itemEdit?.checkState)
                if let items = localData.get(type: [Item].self, for: "itemsSaved"){
                    itemsSaved = items
                }
                itemsSaved.remove(at: index.row)
                itemsSaved.insert(editedItem, at: index.row)
                localData.save(customObject: itemsSaved, for: "itemsSaved")
            } else {
                let newItem = Item(text: text, checkState: false)
                if let items = localData.get(type: [Item].self, for: "itemsSaved"){
                    itemsSaved = items
                }
                itemsSaved.append(newItem)
                localData.save(customObject: itemsSaved, for: "itemsSaved")
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
