//
//  ViewController.swift
//  CBFlashyTabBarController
//
//  Created by askopin@gmail.com on 11/29/2018.
//  Copyright (c) 2018 askopin@gmail.com. All rights reserved.
//

import UIKit
import CBTabBarController

extension String: CBTabMenuItem {
    public var title: String? { return self }
    public var attributedTitle: NSAttributedString? { return nil }
}

class SampleTabItem: UITabBarItem, CBExtendedTabItem {
    public var attributedTitle: NSAttributedString? {
        guard let title = title else { return nil }
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red,
                                                              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func createSampleTabController() -> CBTabBarController {
        let eventsVC = CBSampleViewController()
        eventsVC.tabBarItem = UITabBarItem(title: "Events", image: #imageLiteral(resourceName: "Events"), tag: 0)
        let searchVC = CBSampleViewController()
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "Search"), tag: 0)
        let activityVC = CBSampleViewController()
        
        let activityNVC = UINavigationController(rootViewController: activityVC)
        activityNVC.tabBarItem = UITabBarItem(title: "Activity", image: #imageLiteral(resourceName: "Highlights"), tag: 0)
        let settingsVC = CBSampleViewController()
        
        settingsVC.tabBarItem = SampleTabItem(title: "Settings", image: #imageLiteral(resourceName: "Settings"), tag: 0)
        settingsVC.tabBarItem?.badgeColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            settingsVC.tabBarItem?.badgeValue = "20"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            settingsVC.tabBarItem?.badgeValue = "200"
        }
        settingsVC.tabBarItem?.badgeValue = "1"
        settingsVC.inverseColor()
        
        let tabBarController = CBTabBarController()
        tabBarController.tabBar.unselectedItemTintColor = .brown
        tabBarController.tabBar.tintColor = .red
        tabBarController.viewControllers = [eventsVC, searchVC, activityNVC, settingsVC]
        
        return tabBarController
    }
    
    @IBAction func btnFlashyPressed(_ sender: AnyObject) {
        let tabBarController = createSampleTabController()
        tabBarController.style = .flashy(config: nil)
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    @IBAction func btnGooeyPressed(_ sender: AnyObject) {
        let tabBarController = createSampleTabController()
        let menuEntries = ["Reminder", "Camera", "Attachment", "Text Note"]
        let menu = CBTabMenu(menuButtonIndex: 2,
                             menuColor: #colorLiteral(red: 0.368781209, green: 0.6813176274, blue: 1, alpha: 1),
                             items: menuEntries,
                             icon: nil,
                             callback: { controller, item in
                                controller.dismiss(animated: true, completion: {
                                    print("\(item) selected")
                                })
        })
        tabBarController.style = .gooey(menu: menu)
            
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
