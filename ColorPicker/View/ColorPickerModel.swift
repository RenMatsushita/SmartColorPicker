//
//  ColorPickerModel.swift
//  ColorPicker
//
//  Created by Ren Matsushita on 2019/10/22.
//  Copyright © 2019 Ren Matsushita. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

protocol ColorPickerModelProtocol {
    var mainColor: UIColor { get }
    var redValue: BehaviorRelay<Float> { get }
    var greenValue: BehaviorRelay<Float> { get }
    var blueValue: BehaviorRelay<Float> { get }
}

final class ColorPickerModel: ColorPickerModelProtocol {
    
    var mainColor: UIColor {
        return UIColor.rgb(rgbValue: RGBValue(redValue: redValue.value, greenValue: greenValue.value, blueValue: blueValue.value))
    }
    
    var redValue = BehaviorRelay<Float>(value: 255)
    var greenValue = BehaviorRelay<Float>(value: 255)
    var blueValue = BehaviorRelay<Float>(value: 255)
    
    private let notification: NotificationCenter = NotificationCenter.default
    private let disposeBag = DisposeBag()
    
    init() {
        
        redValue
            .subscribe(onNext: { _ in
                self.notification.post(name: .changeColor, object: nil, userInfo: ["color": self.mainColor])
                self.controlTextColor()
            })
            .disposed(by: disposeBag)
        
        greenValue
            .subscribe(onNext: { _ in
                self.notification.post(name: .changeColor, object: nil, userInfo: ["color": self.mainColor])
                self.controlTextColor()
            })
            .disposed(by: disposeBag)
        
        blueValue
            .subscribe(onNext: { _ in
                self.notification.post(name: .changeColor, object: nil, userInfo: ["color": self.mainColor])
                self.controlTextColor()
            })
            .disposed(by: disposeBag)
        
        notification.rx.notification(.tapReverseColorLabel)
            .subscribe(onNext: { _ in
                self.redValue.accept(self.redValue.value.reverseValue())
                self.greenValue.accept(self.greenValue.value.reverseValue())
                self.blueValue.accept(self.blueValue.value.reverseValue())
            })
            .disposed(by: disposeBag)
        
        notification.rx.notification(.tapComplementaryColorLabel)
            .subscribe(onNext: { _ in
                let rgbValue = [self.redValue.value, self.greenValue.value, self.blueValue.value]
                guard let minValue = rgbValue.min() else { return }
                guard let maxValue = rgbValue.max() else { return }
                let initial = minValue + maxValue
                self.redValue.accept(self.redValue.value.complementaryValue(initial))
                self.greenValue.accept(self.greenValue.value.complementaryValue(initial))
                self.blueValue.accept(self.blueValue.value.complementaryValue(initial))
            })
            .disposed(by: disposeBag)
    }
    
    func controlTextColor() {
        let rgbValueSum = redValue.value + greenValue.value + blueValue.value
        if rgbValueSum < 400 {
            notification.post(name: .shouldChangeTextColorWhite, object: nil)
        } else {
            notification.post(name: .shouldChangeTextColorDark, object: nil)
        }
    }
}

struct RGBValue {
    var redValue: Float = 255
    var greenValue: Float = 255
    var blueValue: Float = 255
}

