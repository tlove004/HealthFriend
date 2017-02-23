//
//  UIFontSettings.swift
//  HealthFriend
//
//  Created by Tyson Loveless on 2/22/17.
//  Copyright © 2017 Tyson Loveless. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    var isItalic: Bool
    {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    func setItalic() -> UIFont
    {
        if fontDescriptor.symbolicTraits.contains(.traitItalic) {
            return self
        } else {
            var symTraits = fontDescriptor.symbolicTraits
            symTraits.insert([.traitItalic])
            let fontDescriptorVar = fontDescriptor.withSymbolicTraits(symTraits)
            return UIFont(descriptor: fontDescriptorVar!, size: 0)
        }
    }
}
