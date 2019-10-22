//
//  NotificationName.swift
//  ColorPicker
//
//  Created by Ren Matsushita on 2019/10/22.
//  Copyright © 2019 Ren Matsushita. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let longPressMainColorLabel = Notification.Name("longPressMainColorLabel")
    
    static let tapReverseColorLabel = Notification.Name("tapReverseColorLabel")
    static let longPressReverseColorLabel = Notification.Name("longPressReverseColorLabel")
    
    static let tapComplementaryColorLabel = Notification.Name("tapComplementaryColorLabel")
    static let longPressComplementaryColorLabel = Notification.Name("longPressComplementaryColorLabel")
    
    static let changeColor = Notification.Name("changeColor")
    static let shouldChangeTextColorWhite = Notification.Name("shouldChangeTextColorWhite")
    static let shouldChangeTextColorDark = Notification.Name("shouldChangeTextColorDark")
}
