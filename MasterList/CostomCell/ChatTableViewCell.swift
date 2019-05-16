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
    
    var messTextLabel: UILabel!
    var messTimeLabel: UILabel!
    
    var messText: String = ""
    var messTime: TimeInterval = 0
    var messTextColor: UIColor = .black
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        messTextLabel.text = messText
        messTextLabel.textColor = messTextColor
        messTimeLabel.text = dateToString(format: "dd:MM:yy HH:mm:ss", timeInterval: messTime)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        print(#function)
        backgroundColor = .white
        addMainView()
        addMessTextLabel()
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
    
    private func addMessTextLabel() {
        messTextLabel = UILabel()
        messTextLabel.textColor = .black
        messTextLabel.numberOfLines = 0
        messTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        messTextLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(messTextLabel)
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
        
        messTextLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 5).isActive = true
        messTextLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 5).isActive = true
        messTextLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -5).isActive = true
        messTextLabel.sizeToFit()
        
        messTimeLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10).isActive = true
        messTimeLabel.topAnchor.constraint(equalTo: messTextLabel.bottomAnchor, constant: 5).isActive = true
    }
}
