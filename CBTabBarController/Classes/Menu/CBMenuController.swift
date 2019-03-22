//
//  CBMenuController.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 21/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

private class CBMenuListButton: UIButton {
    var menuItem: CBTabMenuItem? {
        didSet {
            if let attributedTitle = menuItem?.attributedTitle {
                setAttributedTitle(attributedTitle, for: .normal)
            } else if let title = menuItem?.title {
                setAttributedTitle(nil, for: .normal)
                setTitle(title, for: .normal)
            } else {
                setAttributedTitle(nil, for: .normal)
                setTitle(nil, for: .normal)
            }
        }
    }
}

public class CBMenuController: UIViewController {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet private weak var menuStack: UIStackView!
    var menu: CBTabMenu? {
        didSet {
            loadMenu()
        }
    }
    
    @IBAction func btnDismissPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        loadMenu()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dismissButton.layer.cornerRadius = min(dismissButton.frame.height/2.0, dismissButton.frame.width/2.0)
    }
    
    private func loadMenu() {
        guard let menu = menu, isViewLoaded else { return }
        view.backgroundColor = menu.menuColor
        let dismissImage = UIImage(named: "btnClose",
                                   in: Bundle.resourseBundle,
                                   compatibleWith: nil)
        dismissButton.backgroundColor = .white
        dismissButton.tintColor = menu.menuColor
        dismissButton.setImage(dismissImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        for menuItem in menu.items {
            let button = CBMenuListButton(type: .custom)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.setTitleColor(.white, for: .normal)
            button.menuItem = menuItem
            menuStack.addArrangedSubview(button)
            button.addTarget(self, action: #selector(btnMenuPressed), for: .touchUpInside)
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true
        }
    }
    
     @objc private func btnMenuPressed(sender: CBMenuListButton) {
        if let item = sender.menuItem {
            menu?.callback(self, item)
        }
    }
}
