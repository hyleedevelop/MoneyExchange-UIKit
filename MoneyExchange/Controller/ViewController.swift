//
//  ViewController.swift
//  MoneyExchange
//
//  Created by Eric on 2022/11/06.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currencyDate: UITextField!
    @IBOutlet weak var currency1Type: UITextField!
    @IBOutlet weak var currency2Type: UITextField!
    @IBOutlet weak var currency1Price: UITextField!
    @IBOutlet weak var currency2Price: UITextField!
    
    let currencyDatePicker: UIDatePicker! = UIDatePicker()
    let currency1Picker: UIPickerView! = UIPickerView()
    let currency2Picker: UIPickerView! = UIPickerView()
    let toolbar: UIToolbar! = UIToolbar()
    let toolbarCloseButton = UIBarButtonItem(
        barButtonSystemItem: .close, target: nil, action: #selector(pickerClose))
    let toolbarDoneButton = UIBarButtonItem(
        barButtonSystemItem: .done, target: nil, action: #selector(pickerDone))
    let toolbarFlexibleSpace = UIBarButtonItem(
        barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    var exchangeManager = ExchangeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currency1Picker.delegate = self
        currency2Picker.delegate = self
        currency1Picker.dataSource = self
        currency2Picker.dataSource = self
        
        currencyDate.inputView = currencyDatePicker
        currency1Type.inputView = currency1Picker
        currency2Type.inputView = currency2Picker
     
        toolbar.sizeToFit()
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        toolbar.setItems([toolbarCloseButton, toolbarFlexibleSpace, toolbarDoneButton], animated: true)
        
        currencyDate.inputAccessoryView = toolbar
        currencyDatePicker.datePickerMode = .date
        currencyDatePicker.preferredDatePickerStyle = .wheels
        currencyDatePicker.addTarget(self, action: #selector(datePickerDone(_:)), for: .valueChanged)
        
        currency1Type.inputAccessoryView = toolbar
        currency2Type.inputAccessoryView = toolbar

        // default: 1번은 달러, 2번은 원
        currency1Picker.selectRow(22, inComponent: 0, animated: true)
        currency2Picker.selectRow(13, inComponent: 0, animated: true)
    }
    
    @objc func pickerClose() {
        self.view.endEditing(true)
    }
    
    @objc func pickerDone() {
        
        self.view.endEditing(true)
    }
    
    @objc func datePickerDone(_ sender: UIDatePicker) {
        let nowDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = dateFormatter.string(from: nowDate)
        currencyDate.text = dateString
//        self.view.endEditing(true)
    }
    
    @IBAction func currency1PricePressed(_ sender: UITextField) {
        currency1Picker.isHidden = true
        currency2Picker.isHidden = true
    }
    
    @IBAction func currency2PricePressed(_ sender: UITextField) {
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
//            currency1Picker.isHidden = true
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
            currency1Type.text = selectedCurrency
        } else if pickerView == currency2Picker {
            currency2Type.text = selectedCurrency
        }

    }

}
