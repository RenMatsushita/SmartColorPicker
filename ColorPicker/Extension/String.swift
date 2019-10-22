//
//  String.swift
//  ColorPicker
//
//  Created by Ren Matsushita on 2019/10/22.
//  Copyright © 2019 Ren Matsushita. All rights reserved.
//

import UIKit

extension String {
    
    /// selfの先頭を0埋め
    /// - Parameter digit: 返す文字列の字数
    func zfill(_ digit: Int) -> String {
        guard !(self.count >= digit) else { return self}
        var resultString = self
        while resultString.count != digit {
            resultString = "0" + resultString
        }
        return resultString
    }
    
    /// hex値から色を作り、返す
    func hexToColor() -> UIColor {
        let hex = self
        guard Validator.isHexadecimalText(hex) else { return .white }
        let v = hex.map { String($0) } + Array(repeating: "0", count: max(6 - hex.count, 0))
        let r = CGFloat(Int(v[0] + v[1], radix: 16) ?? 0) / 255.0
        let g = CGFloat(Int(v[2] + v[3], radix: 16) ?? 0) / 255.0
        let b = CGFloat(Int(v[4] + v[5], radix: 16) ?? 0) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
