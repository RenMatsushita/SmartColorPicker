//
//  UIColor.swift
//  ColorPicker
//
//  Created by Ren Matsushita on 2019/10/22.
//  Copyright © 2019 Ren Matsushita. All rights reserved.
//

import UIKit

extension UIColor {
    
    open class var dark: UIColor {
        return UIColor.rgb(RGB(redValue: 51, greenValue: 51, blueValue: 51))
    }
    
    /// Float型のrgb値から色を作って返す
    /// - Parameter rgbValue: RGB値の構造体
    class func rgb(_ rgbValue: RGB) -> UIColor {
        return UIColor(red: CGFloat(rgbValue.redValue) / 255, green: CGFloat(rgbValue.greenValue) / 255, blue: CGFloat(rgbValue.blueValue) / 255, alpha: 1)
    }
    
    /// selfの反転色を返す
    func reverse() -> UIColor {
        guard let cgColorValues = self.cgColor.components else { return .white }
        return UIColor(red: 1 - cgColorValues[0], green: 1 - cgColorValues[1], blue: 1 - cgColorValues[2], alpha: 1)
    }
    
    /// selfの補色を返す
    func complementaryColor() -> UIColor {
        guard var cgColorValues = self.cgColor.components else { return .white }
        cgColorValues.removeLast()
        let initial = cgColorValues.max()! + cgColorValues.min()!
        return UIColor(red: initial - cgColorValues[0], green: initial - cgColorValues[1], blue: initial - cgColorValues[2], alpha: 1)
    }
    
    /// selfの16進数のカラーコードを返す
    func toHex() -> String {
        guard let cgColorValues = self.cgColor.components else { return String() }
        let redString = String(Int(round(cgColorValues[0] * 255)), radix: 16).zfill(2)
        let greenString = String(Int(round(cgColorValues[1] * 255)), radix: 16).zfill(2)
        let blueString = String(Int(round(cgColorValues[2] * 255)), radix: 16).zfill(2)
        return redString.uppercased() + greenString.uppercased() + blueString.uppercased()
    }
    
    /// selfの色からrgb値を抽出し返す
    func toRGBValue() -> RGB {
        guard let cgColorValues = self.cgColor.components else { return RGB() }
        let redValue = Float(round(cgColorValues[0] * 255))
        let greenValue = Float(round(cgColorValues[1] * 255))
        let blueValue = Float(round(cgColorValues[2] * 255))
        return RGB(redValue: redValue, greenValue: greenValue, blueValue: blueValue)
    }
}

