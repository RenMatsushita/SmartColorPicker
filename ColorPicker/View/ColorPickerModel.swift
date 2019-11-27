//
//  ColorPickerModel.swift
//  ColorPicker
//
//  Created by Ren Matsushita on 2019/11/27.
//  Copyright © 2019 Ren Matsushita. All rights reserved.
//

import UIKit
import RxSwift

protocol ColorPickerModelProtocol {
    func isHexadecimalText(_ text: String) -> Bool
    func calculateMatchingTextColor(color: UIColor) -> TextColor
}

final class ColorPickerModel: ColorPickerModelProtocol {
    
    func isHexadecimalText(_ text: String) -> Bool {
        return Validator.isHexadecimalText(text)
    }
    
    func calculateMatchingTextColor(color: UIColor) -> TextColor {
        let rgbValueSum = color.toRGBValue().sum()
        if rgbValueSum < 400 {
            return .white
        } else {
            return .darkGray
        }
    }
}
