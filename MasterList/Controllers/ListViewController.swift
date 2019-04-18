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
    
    private var myUser: MyUser!
    private var tasksRef: DatabaseReference!
    private var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configNavController()
        addlistTableView()
        addConstraints()
        registerCell()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        navigationItem.title = "zzzzzz"
        
        guard let currentUser = Auth.auth().currentUser else { return } //TODO: - fix
        myUser = MyUser(user: currentUser)
        tasksRef = Database.database().reference(withPath: "users").child(myUser.uid).child("tasks")
//        navigationItem.title = myUser.email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let _ = Auth.auth().currentUser else { return } //TODO: - fix
        
        tasksRef.observe(.value) { [weak self] (snapshot) in
            
            var localTasks = [Task]()
            for item in snapshot.children {
                let localTask = Task(snapshot: item as! DataSnapshot)
                localTasks.append(localTask)
            }
            
            self?.tasks = localTasks
            self?.listTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tasksRef.removeAllObservers()
    }
    
    private func addlistTableView() {
        listTableView = UITableView()
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listTableView)
    }
    
    private func registerCell() {
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func configNavController() {
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButton))
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(signOutButton))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc
    private func signOutButton() {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch {
            print("error = \(error.localizedDescription)")
        }
    }
    
    @objc
    private func addTaskButton() {
        
        let alertController = UIAlertController(title: "New Task", message: "enter new task name", preferredStyle: .alert)
        alertController.addTextField()
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }
            guard let textField = alertController.textFields?.first, let text = textField.text, text != "" else { return }
            let task = Task(title: text)
            let taskRef = strongSelf.tasksRef.child(task.title.lowercased())
            taskRef.setValue(["title": task.title, "completed": task.completed])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func addConstraints() {
        
//        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
//        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        listTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        listTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        listTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        cell.accessoryType = isCompleted ? .checkmark : .none
        task.ref?.updateChildValues(["completed": isCompleted])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
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
}
