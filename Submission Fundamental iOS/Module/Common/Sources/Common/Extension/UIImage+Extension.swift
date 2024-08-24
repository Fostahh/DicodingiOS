//
//  File.swift
//  
//
//  Created by Mohammaad Azri Khairuddin on 24/08/24.
//

import UIKit

public extension UIImage {
    
    static func loadImageFromAsset(
        _ imageName: String,
        class: AnyClass,
        module: String,
        renderingMode: RenderingMode? = nil
    ) -> UIImage? {
        let image = UIImage(named: imageName, in: .resourceBundle(for: `class`.self, moduleName: module), compatibleWith: nil)
        if let renderingMode {
            image?.withRenderingMode(renderingMode)
        }
        
        return image
    }
    
}
