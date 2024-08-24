//
//  Common.swift
//
//
//  Created by Mohammaad Azri Khairuddin on 24/08/24.
//

import Foundation

public typealias CommonImage = CommonConstants.Asset

public struct CommonConstants {
    
    public enum Asset: String {
        case author = "img-azri"
        
        public var image: String {
            return rawValue
        }
    }
    
    public static var module: String {
        guard let moduleName = Bundle.module.infoDictionary?["CFBundleName"] as? String else {
            return ""
        }
        return moduleName
    }
    
}
