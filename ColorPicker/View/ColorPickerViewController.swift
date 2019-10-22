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

final class ColorPickerViewController: UIViewController {

    @IBOutlet private weak var redSlider: UISlider!
    @IBOutlet private weak var greenSlider: UISlider!
    @IBOutlet private weak var blueSlider: UISlider!
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet private weak var textfieldHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var mainColorLabel: UILabel!
    
    @IBOutlet private weak var colorLabelStackView: UIStackView!
    @IBOutlet private weak var reverseColorLabel: UILabel!
    @IBOutlet private weak var complementaryColorLabel: UILabel!
    
    private let model = ColorPickerModel()
    
    private let disposeBag = DisposeBag()
    private let notification: NotificationCenter = NotificationCenter.default
    private let pasteBoard = UIPasteboard.general
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redSlider.rx.value
            .bind(to: model.redValue)
            .disposed(by: disposeBag)
                
        greenSlider.rx.value
            .bind(to: model.greenValue)
            .disposed(by: disposeBag)
        
        blueSlider.rx.value
            .bind(to: model.blueValue)
            .disposed(by: disposeBag)
        
        textfield.rx.text
            .filterNil()
            .filter { Validator.isHexadecimalText($0) }
            .subscribe({ hex in
                guard let color = hex.element?.hexToColor() else { return }
                self.updateUserInterface(color: color)
                self.updateSliderValue(color: color)
                self.model.controlTextColor()
            })
            .disposed(by: disposeBag)
        
        notification.rx.notification(.changeColor)
            .subscribe(onNext: { notification in
                if let userInfo = notification.userInfo {
                    guard let color = userInfo["color"] as? UIColor else { return }
                    self.updateUserInterface(color: color)
                    self.textfield.text = color.colorToHex()
                }
            })
            .disposed(by: disposeBag)
        
        notification.rx.notification(.shouldChangeTextColorWhite)
            .subscribe(onNext: { _ in
                self.mainColorLabel.textColor = .white
                self.textfield.textColor = .white
                self.textfield.layer.borderColor = UIColor.white.cgColor
                self.reverseColorLabel.textColor = .black
                self.complementaryColorLabel.textColor = .white
            })
            .disposed(by: disposeBag)
        
        notification.rx.notification(.shouldChangeTextColorDark)
            .subscribe(onNext: { _ in
                self.mainColorLabel.textColor = .black
                self.textfield.textColor = .black
                self.textfield.layer.borderColor = UIColor.black.cgColor
                self.reverseColorLabel.textColor = .white
                self.complementaryColorLabel.textColor = .black
            })
            .disposed(by: disposeBag)
        
        notification.rx.notification(.longPressMainColorLabel)
            .subscribe(onNext: { _ in
                self.pasteBoard.string = self.mainColorLabel.text
                self.generateAlert(title: "完了", message: "背景色をコピーしました")
            })
            .disposed(by: disposeBag)
        
        notification.rx.notification(.longPressReverseColorLabel)
            .subscribe(onNext: { _ in
                self.pasteBoard.string = self.reverseColorLabel.text
                self.generateAlert(title: "完了", message: "反転色をコピーしました")
            })
            .disposed(by: disposeBag)
        
        notification.rx.notification(.longPressComplementaryColorLabel)
            .subscribe(onNext: { _ in
                self.pasteBoard.string = self.complementaryColorLabel.text
                self.generateAlert(title: "完了", message: "補色をコピーしました")
            })
            .disposed(by: disposeBag)
        
        mainColorLabelConfigure()
        reverseColorLabelConfigure()
        complementaryColorLabelConfigure()
        textFieldConfigure()
    }
    
    ///   引数の新しい引数をもとにUIを更新する
    /// - Parameter color: 新しいmaincolor
    private func updateUserInterface(color: UIColor) {
        self.view.backgroundColor = color
        self.mainColorLabel.text = color.colorToHex()
        self.reverseColorLabel.backgroundColor = color.reverseColor()
        self.reverseColorLabel.text = color.reverseColor().colorToHex()
        self.complementaryColorLabel.backgroundColor = color.complementaryColor()
        self.complementaryColorLabel.text = color.complementaryColor().colorToHex()
    }
    
    /// Sliderの値を最新にする
    /// - Parameter color: 新しいmainColor
    private func updateSliderValue(color: UIColor) {
        let rgbValue = color.colorToRGBValue()
        redSlider.value = rgbValue.redValue
        model.redValue.accept(rgbValue.redValue)
        greenSlider.value = rgbValue.greenValue
        model.greenValue.accept(rgbValue.greenValue)
        blueSlider.value = rgbValue.blueValue
        model.blueValue.accept(rgbValue.blueValue)
    }
    
    private func generateAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        
        mainColorLabel.isUserInteractionEnabled = true
        mainColorLabel.tag = 1
        let longPressColorLabel = UILongPressGestureRecognizer()
        longPressColorLabel.rx.event
            .subscribe(onNext: { longPressGesture in
                longPressGesture.minimumPressDuration = 0.5
                self.notification.post(name: .longPressMainColorLabel, object: nil)
            })
            .disposed(by: disposeBag)
        mainColorLabel.addGestureRecognizer(longPressColorLabel)
    }
    
    /// reverseColorLabelの初期設定
    private func reverseColorLabelConfigure() {
        reverseColorLabel.layer.cornerRadius = 20
        reverseColorLabel.clipsToBounds = true
        reverseColorLabel.isUserInteractionEnabled = true
        let tapReverseColorLabel = UITapGestureRecognizer()
        tapReverseColorLabel.rx.event
            .subscribe(onNext: { _ in
                self.notification.post(name: .tapReverseColorLabel, object: nil)
            })
            .disposed(by: disposeBag)
        reverseColorLabel.addGestureRecognizer(tapReverseColorLabel)
        let longPressReverseColorLabel = UILongPressGestureRecognizer()
        longPressReverseColorLabel.rx.event
            .subscribe(onNext: { event in
                event.minimumPressDuration = 0.5
                self.notification.post(name: .longPressReverseColorLabel, object: nil)
            })
            .disposed(by: disposeBag)
        reverseColorLabel.addGestureRecognizer(longPressReverseColorLabel)
    }
    
    /// complementaryColorLabelの初期設定
    private func complementaryColorLabelConfigure() {
        complementaryColorLabel.layer.cornerRadius = 20
        complementaryColorLabel.clipsToBounds = true
        complementaryColorLabel.isUserInteractionEnabled = true
        let tapComplementaryColorLabel = UITapGestureRecognizer()
        tapComplementaryColorLabel.rx.event
            .subscribe(onNext: { _ in
                self.notification.post(name: .tapComplementaryColorLabel, object: nil)
            })
            .disposed(by: disposeBag)
        complementaryColorLabel.addGestureRecognizer(tapComplementaryColorLabel)
        let longPresscomplementaryColorLabel = UILongPressGestureRecognizer()
        longPresscomplementaryColorLabel.rx.event
            .subscribe(onNext: { event in
                event.minimumPressDuration = 0.5
                self.notification.post(name: .longPressComplementaryColorLabel, object: nil)
            })
            .disposed(by: disposeBag)
        complementaryColorLabel.addGestureRecognizer(longPresscomplementaryColorLabel)
    }
    
    /// textFieldの初期設定
    private func textFieldConfigure() {
        textfield.delegate = self
        textfield.keyboardType = .alphabet
        addToolBar(textField: textfield)
    }
}
