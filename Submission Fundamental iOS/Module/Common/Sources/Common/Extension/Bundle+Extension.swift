//
//  Bundle+Extension.swift
//
//
//  Created by Mohammaad Azri Khairuddin on 24/08/24.
//

import Foundation

extension Bundle {
    
    static func resourceBundle(for class: AnyClass, moduleName: String) -> Bundle {
        let bundle = Bundle(for: `class`)
        guard let url = bundle.url(forResource: moduleName, withExtension: "bundle") else {
            return bundle
        }
        return Bundle(url: url) ?? bundle
    }
    
}
