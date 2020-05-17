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

struct ColorPickerViewModelInput {
    let hexText: Observable<String?>
    let mainColorLabelLongPressed: Observable<UILongPressGestureRecognizer>
    let reverseColorLabelTapped: Observable<UITapGestureRecognizer>
    let reverseColorLabelLongPressed: Observable<UILongPressGestureRecognizer>
    let complementaryColorLabelTapped: Observable<UITapGestureRecognizer>
    let complementaryColorLabelLongPressed: Observable<UILongPressGestureRecognizer>
    let redValue: Observable<Float>
    let greenValue: Observable<Float>
    let blueValue: Observable<Float>
}

final class ColorPickerViewModel {
    
    private let mainColorRelay = BehaviorRelay<UIColor>(value: .white)
    var mainColor: Observable<UIColor> {
        return mainColorRelay.asObservable()
    }
    
    private let textColorRelay = BehaviorRelay<TextColor>(value: .darkGray)
    var textColor: Observable<TextColor> {
        textColorRelay.asObservable()
    }
    
    private let alertSubject = PublishSubject<Alert>()
    var alert: Observable<Alert> {
        return alertSubject.asObservable()
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let model = ColorPickerModel()
    
    init(_ input: ColorPickerViewModelInput, model: ColorPickerModelProtocol = ColorPickerModel()) {
        
        _ = Observable
            .combineLatest(input.redValue, input.greenValue, input.blueValue)
            .subscribe(onNext: { redValue, greenValue, blueValue in
                self.mainColorRelay.accept(UIColor.rgb(RGB(redValue: redValue, greenValue: greenValue, blueValue: blueValue)))
            })
            .disposed(by: disposeBag)
        
        mainColorRelay
            .subscribe({ value in
                guard let color = value.element else { return }
                self.textColorRelay.accept(model.calculateMatchingTextColor(color: color))
            })
            .disposed(by: disposeBag)
        
        input.hexText
            .filterNil()
            .filter { model.isHexadecimalText($0) }
            .subscribe(onNext: { hexText in
                self.mainColorRelay.accept(hexText.hexToColor())
            })
            .disposed(by: disposeBag)
        
        input.mainColorLabelLongPressed
            .subscribe { _ in
                UIPasteboard.general.string = self.mainColorRelay.value.toHex()
                self.alertSubject.onNext(Alert(title: "完了", message: "背景色をコピーしました"))
            }
            .disposed(by: disposeBag)
        
        input.reverseColorLabelTapped
            .subscribe { _ in
                self.mainColorRelay.accept(self.mainColorRelay.value.reverse())
            }
            .disposed(by: disposeBag)
        
        input.reverseColorLabelLongPressed
            .subscribe { _ in
                UIPasteboard.general.string = self.mainColorRelay.value.reverse().toHex()
                self.alertSubject.onNext(Alert(title: "完了", message: "反転色をコピーしました"))
            }
            .disposed(by: disposeBag)
        
        input.complementaryColorLabelTapped
            .subscribe { _ in
                self.mainColorRelay.accept(self.mainColorRelay.value.complementaryColor())
            }
            .disposed(by: disposeBag)
        
        input.complementaryColorLabelLongPressed
            .subscribe { _ in
                UIPasteboard.general.string = self.mainColorRelay.value.complementaryColor().toHex()
                self.alertSubject.onNext(Alert(title: "完了", message: "補色をコピーしました"))
            }
            .disposed(by: disposeBag)
    }
}
