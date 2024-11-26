//
//  CustomURLViewController+UIPicker.swift
//  GoShortApp
//
//  Created by Uriel C on 25/11/24.
//

import UIKit

extension CustomURLViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return availableDomains.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableDomains[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        domainPicker.text = availableDomains[row]
        domainPicker.resignFirstResponder()
    }
    
}
