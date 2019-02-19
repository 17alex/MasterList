//
//  ListViewController.swift
//  MasterList
//
//  Created by Admin on 19.02.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    private var listTableView: UITableView!
    private var sendTextFeild: UITextField!
    private var sendButton: UIButton!
    private var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.568627451, blue: 1, alpha: 1)
        addNavBar()
        addlistTableView()
        addSendTextFeild()
        addSendButton()
        addConstraints()
    }
    
    private func addlistTableView() {
        listTableView = UITableView()
        listTableView.backgroundColor = .clear
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listTableView)
    }
    
    private func addSendTextFeild() {
        sendTextFeild = UITextField()
        sendTextFeild.borderStyle = .roundedRect
        sendTextFeild.backgroundColor = .clear
        sendTextFeild.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sendTextFeild.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        sendTextFeild.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendTextFeild)
    }
    
    private func addSendButton() {
        sendButton = UIButton()
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
    }
    
    private func addNavBar() {
        navBar = UINavigationBar()
        navBar.isTranslucent = false
        navBar.barTintColor = #colorLiteral(red: 0.4784313725, green: 0.568627451, blue: 1, alpha: 1)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let navItem = UINavigationItem()
        navItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logOutButton))
        navItem.title = "-- -- --"
        navItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navBar.items = [navItem]
        view.addSubview(navBar)
    }
    
    @objc
    private func logOutButton() {
        print("logOutButton")
    }
    
    private func addConstraints() {
        
        navBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        navBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        listTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        listTableView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        listTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        sendTextFeild.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        sendTextFeild.topAnchor.constraint(equalTo: listTableView.bottomAnchor, constant: 8).isActive = true
        sendTextFeild.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        sendTextFeild.heightAnchor.constraint(equalToConstant: 12)
        
        sendButton.leftAnchor.constraint(equalTo: sendTextFeild.rightAnchor, constant: 8).isActive = true
        sendButton.topAnchor.constraint(equalTo: sendTextFeild.topAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        //        sendButton.contentHuggingPriority(for: .horizontal) = 251
    }
    
}
