//
//  ViewController.swift
//  To-Do Please
//
//  Created by Aditya  on 08/07/20.
//  Copyright © 2020 Aditya Vikram Godawat. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var toDo: [NSManagedObject] = []
    
    @IBAction func addToDo() {
        print("Added")
        let alert = UIAlertController(title: "New To-Do", message: "Add a To-Do", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let textField = alert.textFields?.first, let todoToSave = textField.text else { return }
            self.saveTheToDo(toDotitle: todoToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    //MARK: - View Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ToDo")
    
        do {
          toDo = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "To-Do Please"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    func saveTheToDo(toDotitle: String) {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
      let managedContext = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: managedContext)!
      let todo = NSManagedObject(entity: entity, insertInto: managedContext)
      
      todo.setValue(toDotitle, forKeyPath: "title")
      
      do {
        try managedContext.save()
        toDo.append(todo)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    
    //MARK: - Table Data Source and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UITableViewCell else { return UITableViewCell() }
        let aToDo = toDo[indexPath.row]
        cell.textLabel?.text = aToDo.value(forKeyPath: "title") as? String
        return cell
    }
}
