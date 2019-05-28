//
//  ChatTableViewCell.swift
//  MasterList
//
//  Created by Admin on 30/04/2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    private var mainView: UIView!
    private var messView: UIView!
    
    private var messTextLabel: UILabel!
    private var messTimeLabel: UILabel!
    
    private var leftConstrain: NSLayoutConstraint!
    private var rightConstrain: NSLayoutConstraint!
    
    var messText: String = ""
    var messTime: TimeInterval = 0
    var messIsMyText: Bool = false
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        messTextLabel.text = messText
        messTimeLabel.text = dateToString(format: "dd MMM yyyy  HH:mm", timeInterval: messTime)
        if messIsMyText {
            rightConstrain.constant = -8
            leftConstrain.constant = 88
            messTextLabel.textColor = .red
        } else {
            rightConstrain.constant = -88
            leftConstrain.constant = 8
            messTextLabel.textColor = .blue
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
//        print(#function)
        backgroundColor = .white
        addMainView()
        addMessTextLabel()
        addMessTimeLabel()
        addConstraints()
        selectionStyle = .none
    }
    
    private func addMainView() {
        mainView = UIView()
        mainView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        mainView.layer.cornerRadius = 10
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
        
        leftConstrain = mainView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8)
        leftConstrain.isActive = true
        
        rightConstrain = mainView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        rightConstrain.isActive = true
        
        mainView.topAnchor.constraint(equalTo: topAnchor, constant: 1).isActive = true
        mainView.bottomAnchor.constraint(equalTo: messTimeLabel.bottomAnchor, constant: 2).isActive = true
        
        messTextLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 5).isActive = true
        messTextLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 5).isActive = true
        messTextLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -5).isActive = true
        messTextLabel.sizeToFit()
        
        messTimeLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -10).isActive = true
        messTimeLabel.topAnchor.constraint(equalTo: messTextLabel.bottomAnchor, constant: 5).isActive = true
    }
}
