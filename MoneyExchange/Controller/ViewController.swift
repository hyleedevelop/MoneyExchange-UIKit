//
//  ViewController.swift
//  MoneyExchange
//
//  Created by Eric on 2022/11/06.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currency1Price: UITextField!
    @IBOutlet weak var currency2Price: UITextField!
    @IBOutlet weak var currency1Button: UIButton!
    @IBOutlet weak var currency2Button: UIButton!
    @IBOutlet weak var currency1Picker: UIPickerView!
    @IBOutlet weak var currency2Picker: UIPickerView!
    
    var exchangeManager = ExchangeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currency1Picker.delegate = self
        currency2Picker.delegate = self
        currency1Picker.dataSource = self
        currency2Picker.dataSource = self
        
        currency1Picker.isHidden = true
        currency2Picker.isHidden = true
        
        currency1Picker.selectRow(23, inComponent: 0, animated: true)
        currency2Picker.selectRow(14, inComponent: 0, animated: true)
        
        currency1Button.titleLabel?.text = exchangeManager.currencyArray[23]
        currency2Button.titleLabel?.text = exchangeManager.currencyArray[14]
        
    }

    @IBAction func currency1ButtonPressed(_ sender: UIButton) {
        currency1Price.endEditing(true)
        currency2Price.endEditing(true)
        currency1Picker.isHidden = false
        currency2Picker.isHidden = true
        currency1Button.titleLabel?.text = sender.currentTitle
        currency2Button.titleLabel?.text = sender.currentTitle
    }
    
    @IBAction func currency2ButtonPressed(_ sender: UIButton) {
        currency1Price.endEditing(true)
        currency2Price.endEditing(true)
        currency1Picker.isHidden = true
        currency2Picker.isHidden = false
    }
    
    
    @IBAction func currency1TextFieldPressed(_ sender: UITextField) {
        currency1Picker.isHidden = true
        currency2Picker.isHidden = true
    }
    
    @IBAction func currency2TextFieldPressed(_ sender: UITextField) {
        currency1Picker.isHidden = true
        currency2Picker.isHidden = true
    }
    
}


//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    // TextField에서 사용자가 키보드 상의 return을 눌렀을 때 구현할 내용
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currency1Price.endEditing(true)  // 입력이 끝났으니 키보드를 숨겨라
        return true
    }
    
    // TextField에서 사용자가 아무 입력도 하지 않고 키보드를 dismiss할 때 구현할 내용
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {  // 뭐라도 입력한게 있다면 OK
            return true
        } else {  // 아무것도 입력하지 않았다면
            currency1Price.placeholder = "여기에 금액을 입력해주세요"
            currency1Price.layer.borderColor = UIColor.red.cgColor
            currency1Picker.isHidden = true
            return false
        }
    }
    
    // TextField에서 사용자 입력이 끝나면 구현할 내용
    func textFieldDidEndEditing(_ textField: UITextField) {
        //exchangeManager.???
    }

}


//MARK: - UIPickerView Datasource & Delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exchangeManager.currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exchangeManager.currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = exchangeManager.currencyArray[row]
        
        if pickerView == currency1Picker {
            currency1Button.titleLabel?.text = selectedCurrency
            
        } else if pickerView == currency2Picker {
            currency2Button.titleLabel?.text = selectedCurrency
            
        }

    }

}
