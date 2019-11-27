//
//  RGB.swift
//  ColorPicker
//
//  Created by Ren Matsushita on 2019/11/27.
//  Copyright © 2019 Ren Matsushita. All rights reserved.
//

struct RGB {
    var redValue: Float = 255
    var greenValue: Float = 255
    var blueValue: Float = 255
    
    func sum() -> Float {
        return redValue + greenValue + blueValue
    }
}
