//
//  TodoListViewController.swift
//  TodolistApp
//
//  Created by Gullermo Antonio Matos Uc on 09/04/24.
//

import UIKit

class TodoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var items:[Item] = [Item]()
    var localData: UserDefaultsHelper = UserDefaultsHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadItems()
    }
    
    func loadItems(){
        if let itemsSaved = localData.get(type: [Item].self, for: "itemsSaved") {
            items = itemsSaved
        }
        tableView.reloadData()
    }
    
    func setupUI(){
        loadItems()
        tableView.register(UINib(nibName: ItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = false
        tableView.reloadData()
    }

    @IBAction func addItem(_ sender: Any) {
        self.navigationController?.pushViewController(AddItemViewController(), animated: true)
    }
    
    @IBAction func showCompleted(_ sender: UIButton) {
        loadItems()
        var completedTasks: [Item] = [Item]()
        for item in items {
            if item.checkState ?? false {
                completedTasks.append(item)
            }
        }
        items = completedTasks
        tableView.reloadData()
    }
    
    @IBAction func showUncompleted(_ sender: Any) {
        loadItems()
        var unompletedTasks: [Item] = [Item]()
        for item in items {
            if item.checkState == false {
                unompletedTasks.append(item)
            }
        }
        items = unompletedTasks
        tableView.reloadData()
    }
    
    @IBAction func showAll(_ sender: UIButton) {
        loadItems()
    }
    @IBAction func reOrderTasks(_ sender: UIButton) {
        tableView.isEditing = true
    }
    
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier) as? ItemTableViewCell {
            cell.configure(item: items[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ItemTableViewCell {
            items[indexPath.row].checkState = !(items[indexPath.row].checkState ?? false)
            localData.save(customObject: items, for: "itemsSaved")
            loadItems()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Editar") { _, _, _ in
            let editItemVC:AddItemViewController = AddItemViewController()
            editItemVC.indexPath = indexPath
            editItemVC.itemEdit = self.items[indexPath.row]
            self.navigationController?.pushViewController(editItemVC, animated: true)
        }
        
        let delete = UIContextualAction(style: .destructive, title: "Eliminar") { _, _, _ in
            self.items.remove(at: indexPath.row)
            self.localData.save(customObject: self.items, for: "itemsSaved")
            self.loadItems()
        }
        
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        return swipe
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedItem = items.remove(at: sourceIndexPath.row)
        items.insert(movedItem, at: destinationIndexPath.row)
        localData.save(customObject: self.items, for: "itemsSaved")
        tableView.isEditing = false
    }
    
}
