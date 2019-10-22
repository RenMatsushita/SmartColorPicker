//
//  ColorPickerViewController+UITextField.swift
//  ColorPicker
//
//  Created by Ren Matsushita on 2019/10/22.
//  Copyright © 2019 Ren Matsushita. All rights reserved.
//

import UIKit

extension ColorPickerViewController: UITextFieldDelegate {
    
    /// textfieldのkeyboard以外をタップするとkeyboardが閉じる処理
    /// - Parameter touches: touches
    /// - Parameter event: event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if textfield.isFirstResponder {
            textfield.resignFirstResponder()
        }
    }
    
    /// textfieldにtoolbarを追加
    /// - Parameter textField: toolbarを追加するtextfield
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = "FF3B51".hexToColor()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    /// toolbarのdoneボタン押下時の処理
    @objc func donePressed() {
        view.endEditing(true)
    }
}
