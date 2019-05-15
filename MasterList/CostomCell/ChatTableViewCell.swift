//
//  ChatTableViewCell.swift
//  MasterList
//
//  Created by Admin on 30/04/2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    var mainView: UIView!
    var messView: UIView!
    
    var messTextView: UITextView!
    var messTimeLabel: UILabel!
    
    var messText: String = ""
    var messTime: TimeInterval = 0
    var messTextColor: UIColor = .black
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        messTextView.text = messText
        messTextView.textColor = messTextColor
        messTimeLabel.text = dateToString(format: "dd:MM:yy HH:mm:ss", timeInterval: messTime)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        print(#function)
        backgroundColor = .orange
        addMainView()
        addMessTextView()
        addMessTimeLabel()
        addConstraints()
    }
    
    private func addMainView() {
        mainView = UIView()
        mainView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        mainView.layer.cornerRadius = 5
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor.darkGray.cgColor
        mainView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainView)
    }
    
    private func addMessTextView() {
        messTextView = UITextView()
        messTextView.backgroundColor = .clear
        messTextView.textColor = .black
        messTextView.isScrollEnabled = false
        messTextView.isEditable = false
        messTextView.isSelectable = false
        messTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        messTextView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(messTextView)
    }
    
    private func addMessTimeLabel() {
        messTimeLabel = UILabel()
        messTimeLabel.textColor = .darkGray
        messTimeLabel.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        messTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(messTimeLabel)
    }
    
    private func addConstraints() {
        mainView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        mainView.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        mainView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        mainView.bottomAnchor.constraint(equalTo: messTimeLabel.bottomAnchor, constant: 2).isActive = true
        
        messTextView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 5).isActive = true
        messTextView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 1).isActive = true
        messTextView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -5).isActive = true
        messTextView.sizeToFit()
        
        messTimeLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10).isActive = true
        messTimeLabel.topAnchor.constraint(equalTo: messTextView.bottomAnchor, constant: 1).isActive = true
    }
}
