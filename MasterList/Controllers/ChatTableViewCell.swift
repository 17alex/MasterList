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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        messTextLabel.text = messText
        messTimeLabel.text = dateToString(format: "dd:MM:yy HH:mm:ss", timeInterval: messTime)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        print(#function)
        
        addMainView(frame: self.frame)
        addMessTextLabel()
        addMessTimeLabel()
        addConstraints()
    }
    
    private func addMainView(frame: CGRect) {
        mainView = UIView(frame: CGRect(x: frame.origin.x + 8, y: frame.origin.y + 1, width: frame.width - 16, height: frame.height - 2))
        mainView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        mainView.layer.cornerRadius = 5
        mainView.layer.borderWidth = 1
        mainView.layer.borderColor = UIColor.darkGray.cgColor
        addSubview(mainView)
    }
    
    private func addMessTextLabel() {
        messTextLabel = UILabel()
        messTextLabel.textColor = .black
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
        messTextLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10).isActive = true
        messTextLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 5).isActive = true
        
        messTimeLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10).isActive = true
        messTimeLabel.topAnchor.constraint(equalTo: messTextLabel.bottomAnchor, constant: 5).isActive = true
    }
}
