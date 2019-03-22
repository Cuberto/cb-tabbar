
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
        return frameworkBundle
    }
}
