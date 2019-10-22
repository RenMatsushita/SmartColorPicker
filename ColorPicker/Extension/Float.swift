//
//  Float.swift
//  ColorPicker
//
//  Created by Ren Matsushita on 2019/10/22.
//  Copyright © 2019 Ren Matsushita. All rights reserved.
//

import Foundation

extension Float {
    /// Float値を反転地にして返す
    func reverseValue() -> Float {
        return 255 - self
    }
    
    /// Float値を補色値にして返す
    /// - Parameter initial: 基準(引かれる)数
    func complementaryValue(_ initial: Float) -> Float {
        return initial - self
    }
}

