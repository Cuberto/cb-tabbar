
//
//  Bundle.swift
//  liquid-swipe
//
//  Created by Anton Skopin on 06/01/2019.
//
import Foundation

extension Bundle {
    static var resourseBundle: Bundle {
        let frameworkBundle = Bundle(for: CBTabBar.self)
        if let resourseBundlePath = frameworkBundle.path(forResource: "cb-tabbar", ofType: "bundle") {
            return Bundle(path: resourseBundlePath) ?? frameworkBundle
        }
        return frameworkBundle
    }
}
