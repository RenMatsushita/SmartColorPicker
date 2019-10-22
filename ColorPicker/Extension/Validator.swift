//
//  Validator.swift
//  ColorPicker
//
//  Created by Ren Matsushita on 2019/10/22.
//  Copyright © 2019 Ren Matsushita. All rights reserved.
//

import Foundation

final class Validator {
    static func isHexadecimalText(_ text: String) -> Bool {
        if text.count != 6 { return false }
        if text.range(of: "^[A-Fa-f0-9]+$", options: .regularExpression) == nil { return false }
        return true
    }
}
