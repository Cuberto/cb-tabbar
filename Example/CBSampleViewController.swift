//
//  CBSampleViewController.swift
//  CBFlashyTabBarController_Example
//
//  Created by Anton Skopin on 03/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class CBSampleViewController: UIViewController {

    var lblTitle: UILabel = {
        var label = UILabel()
        label.textColor = #colorLiteral(red: 0.1579992771, green: 0.1818160117, blue: 0.5072338581, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 55.0, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var btnClose: UIButton = {
        var btn = UIButton()
        btn.tintColor = #colorLiteral(red: 0.1579992771, green: 0.1818160117, blue: 0.5072338581, alpha: 1)
        btn.setImage(#imageLiteral(resourceName: "btnClose").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        lblTitle.text = tabBarItem.title
        view.addSubview(lblTitle)
        
        view.addSubview(btnClose)
        btnClose.widthAnchor.constraint(equalToConstant: 45).isActive = true
        btnClose.heightAnchor.constraint(equalToConstant: 45).isActive = true
        let guide = view.layoutMarginsGuide
        btnClose.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0).isActive = true
        btnClose.trailingAnchor.constraint(equalToSystemSpacingAfter: guide.trailingAnchor, multiplier: 1.0).isActive = true
        btnClose.addTarget(self, action: #selector(btnClosePressed), for: .touchUpInside)

        lblTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.setNeedsLayout()

    }

    func inverseColor() {
        view.backgroundColor = lblTitle.textColor
        lblTitle.textColor = UIColor.white
        btnClose.tintColor = .white
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return view.backgroundColor == UIColor.white ? .default : .lightContent
    }
    
    @objc func btnClosePressed() {
        navigationController?.popToRootViewController(animated: true)
    }
}
