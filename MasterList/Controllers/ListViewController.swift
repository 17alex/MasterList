//
//  ListViewController.swift
//  MasterList
//
//  Created by Admin on 19.02.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController {
    
    private var listTableView: UITableView!
    private var navBar: UINavigationBar!
    private var navItem = UINavigationItem()
    
    private var user: MyUser!
    private var ref: DatabaseReference!
    private var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addNavBar()
        addlistTableView()
        addConstraints()
        registerCell()
        
        guard let currentUser = Auth.auth().currentUser else { return } //TODO: - fix
        user = MyUser(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(user.uid).child("tasks")
        navItem.title = user.email
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] (snapshot) in
            var tasks = [Task]()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                tasks.append(task)
            }
            
            self?.tasks = tasks
            self?.listTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
    }
    
    private func addlistTableView() {
        listTableView = UITableView()
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listTableView)
    }
    
    private func registerCell() {
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func addNavBar() {
        navBar = UINavigationBar()
        navBar.isTranslucent = false
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.7049999833, blue: 1, alpha: 1)]
//        navItem = UINavigationItem()
        navItem.title = "-- -- --"
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(signOutButton))
        navItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.7049999833, blue: 1, alpha: 1)
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButton))
        navItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0.7049999833, blue: 1, alpha: 1)
        navBar.items = [navItem]
        view.addSubview(navBar)
    }
    
    @objc
    private func signOutButton() {
        print("logOutButton")
        
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("error = \(error.localizedDescription)")
        }
    }
    
    @objc
    private func addTaskButton() {
        print("addTaskButton")
        
        let alertController = UIAlertController(title: "New Task", message: "enter new task name", preferredStyle: .alert)
        alertController.addTextField()
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            guard let textField = alertController.textFields?.first, let text = textField.text, text != "" else { return }
            let task = Task(title: text, userId: strongSelf.user.uid)
            let taskRef = strongSelf.ref.child(task.title.lowercased())
            taskRef.setValue(["title": task.title, "completed": task.completed])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func addConstraints() {
        
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        listTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        listTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        listTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ListViewController: UITableViewDelegate {
    
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.completed ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
//            task.ref?.removeValue()
            ref.child(task.title).removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        cell.accessoryType = isCompleted ? .checkmark : .none
        
//        task.ref?.updateChildValues(["completed": isCompleted])
        ref.child(task.title).updateChildValues(["completed": isCompleted])
    }
}
