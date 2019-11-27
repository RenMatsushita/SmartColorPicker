//
//  ColorPickerViewController.swift
//  ColorPicker
//
//  Created by Ren Matsushita on 2019/10/22.
//  Copyright © 2019 Ren Matsushita. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import RxGesture
import Alertift

final class ColorPickerViewController: UIViewController {
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet private weak var textfieldHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var mainColorLabel: UILabel!
    
    @IBOutlet private weak var colorLabelStackView: UIStackView!
    @IBOutlet private weak var reverseColorLabel: UILabel!
    @IBOutlet private weak var complementaryColorLabel: UILabel!
    
    @IBOutlet private weak var redSlider: UISlider!
    @IBOutlet private weak var greenSlider: UISlider!
    @IBOutlet private weak var blueSlider: UISlider!
    
    private lazy var viewModel = ColorPickerViewModel(
        ColorPickerViewModelInput(
            hexText: self.textfield.rx.text.asObservable(),
            mainColorLabelLongPressed: self.mainColorLabel.rx.longPressGesture().skip(1).asObservable(),
            reverseColorLabelTapped: self.reverseColorLabel.rx.tapGesture().skip(1).asObservable(),
            reverseColorLabelLongPressed: self.reverseColorLabel.rx.longPressGesture().skip(1).asObservable(),
            complementaryColorLabelTapped: self.complementaryColorLabel.rx.tapGesture().skip(1).asObservable(),
            complementaryColorLabelLongPressed: self.complementaryColorLabel.rx.longPressGesture().skip(1).asObservable(),
            redValue: self.redSlider.rx.value.asObservable(),
            greenValue: self.greenSlider.rx.value.asObservable(),
            blueValue: self.blueSlider.rx.value.asObservable()
        )
    )
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        viewModel.mainColor
            .bind(to: changeColor)
            .disposed(by: disposeBag)
        
        viewModel.textColor
            .bind(to: changeTextColor)
            .disposed(by: disposeBag)
        
        viewModel.alert
            .bind(to: showAlert)
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        mainColorLabelConfigure()
        reverseColorLabelConfigure()
        complementaryColorLabelConfigure()
        textFieldConfigure()
    }
    /// mainColorLabelの初期設定
    private func mainColorLabelConfigure() {
        if view.frame.height == 568 {
            mainColorLabel.font = .systemFont(ofSize: 62, weight: .bold)
            textfieldHeightConstraint.constant = 30
        }
        
        if view.frame.width == 414 {
            colorLabelStackView.spacing = 30
            mainColorLabel.font = .systemFont(ofSize: 75, weight: .bold)
        }
    }
    
    /// reverseColorLabelの初期設定
    private func reverseColorLabelConfigure() {
        reverseColorLabel.layer.cornerRadius = 20
        reverseColorLabel.clipsToBounds = true
    }
    
    /// complementaryColorLabelの初期設定
    private func complementaryColorLabelConfigure() {
        complementaryColorLabel.layer.cornerRadius = 20
        complementaryColorLabel.clipsToBounds = true
    }
    
    /// textFieldの初期設定
    private func textFieldConfigure() {
        textfield.delegate = self
        textfield.keyboardType = .alphabet
        addToolBar(textField: textfield)
    }
}

extension ColorPickerViewController {
    private var changeColor: Binder<UIColor> {
        return Binder(self) { me, newColor in
            me.view.backgroundColor = newColor
            me.mainColorLabel.text = newColor.toHex()
            me.textfield.text = newColor.toHex()
            me.reverseColorLabel.backgroundColor = newColor.reverse()
            me.reverseColorLabel.text = newColor.reverse().toHex()
            me.complementaryColorLabel.backgroundColor = newColor.complementaryColor()
            me.complementaryColorLabel.text = newColor.complementaryColor().toHex()
            me.redSlider.value = newColor.toRGBValue().redValue
            me.greenSlider.value = newColor.toRGBValue().greenValue
            me.blueSlider.value = newColor.toRGBValue().blueValue
        }
    }
    
    private var changeTextColor: Binder<TextColor> {
        return Binder(self) { me, textColor in
            switch textColor {
            case .white:
                me.mainColorLabel.textColor = .white
                me.textfield.textColor = .white
                me.textfield.backgroundColor = .dark
                me.reverseColorLabel.textColor = .dark
                me.complementaryColorLabel.textColor = .white
            case .darkGray:
                me.mainColorLabel.textColor = .dark
                me.textfield.textColor = .dark
                me.textfield.backgroundColor  = .white
                me.reverseColorLabel.textColor = .white
                me.complementaryColorLabel.textColor = .dark
            }
        }
    }
    
    private var showAlert: Binder<Alert> {
        return Binder(self) { me, alert in
            Alertift
                .alert(title: alert.title, message: alert.message)
                .action(.default("OK"))
                .show()
        }
    }
}
