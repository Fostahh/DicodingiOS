//
//  Home.swift
//
//
//  Created by Mohammaad Azri Khairuddin on 24/08/24.
//

import Foundation

public struct HomeConstants {
    
    public static var module: String {
        guard let moduleName = Bundle.module.infoDictionary?["CFBundleName"] as? String else {
            return ""
        }
        return moduleName
    }
    
}
