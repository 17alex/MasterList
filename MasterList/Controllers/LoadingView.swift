//
//  LoadingView.swift
//  MasterList
//
//  Created by Admin on 06/05/2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    private var loadingText: String = "Loading..."
    private var loadingTextLabel: UILabel!
    private var spinner: UIActivityIndicatorView!
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        print(#function)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        print(#function)
        
        frame = CGRect(x: 0, y: 0, width: 180, height: 50)
        backgroundColor = .lightGray
        layer.cornerRadius = 15
        addLoadingTextLabel()
        addSpinner()
        addConstraints()
    }
    
    private func addLoadingTextLabel() {
        loadingTextLabel = UILabel()
        loadingTextLabel.text = loadingText
        loadingTextLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        loadingTextLabel.textColor = .white
        loadingTextLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingTextLabel)
    }
    
    private func addSpinner() {
        spinner = UIActivityIndicatorView(style: .white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.isHidden = false
        addSubview(spinner)
    }
    
    private func addConstraints() {
        loadingTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 20).isActive = true
        loadingTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        spinner.rightAnchor.constraint(equalTo: loadingTextLabel.leftAnchor, constant: -10).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

}
