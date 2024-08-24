//
//  String+Extension.swift
//
//
//  Created by Mohammaad Azri Khairuddin on 24/08/24.
//

import Foundation

public extension String {
    
    func localized(_ comment: String = "") -> String {
        let title = NSLocalizedString(self, bundle: .module, comment: comment)
        return title
    }
    
}
