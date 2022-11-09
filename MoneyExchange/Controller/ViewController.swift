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
    let toolbarDoneButton = UIBarButtonItem(
        barButtonSystemItem: .done, target: nil, action: #selector(pickerDone))
    let toolbarFlexibleSpace = UIBarButtonItem(
        barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    var exchangeRateManager = ExchangeRateManager(rowNum: 22)
    
    var selectedRowNum: Int = 0
    var dateString: String = ""
    var currency1TypeString: String = ""
    var currency2TypeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currency1Picker.delegate = self
        currency2Picker.delegate = self
        currency1Picker.dataSource = self
        currency2Picker.dataSource = self
        exchangeRateManager.delegate = self
        
        currencyDate.inputView = currencyDatePicker
        currency1Type.inputView = currency1Picker
        currency2Type.inputView = currency2Picker
     
        toolbar.sizeToFit()
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        toolbar.setItems([toolbarFlexibleSpace, toolbarDoneButton], animated: true)
        
        currency1Price.inputAccessoryView = toolbar
        currency2Price.inputAccessoryView = toolbar
        currencyDate.inputAccessoryView = toolbar
        currencyDatePicker.datePickerMode = .date
        currencyDatePicker.preferredDatePickerStyle = .wheels
        currencyDatePicker.addTarget(self, action: #selector(datePickerDone(_:)), for: .valueChanged)
        currencyDatePicker.locale = Locale(identifier: "ko_KR")
        currency1Type.inputAccessoryView = toolbar
        currency2Type.inputAccessoryView = toolbar

        // textfield 및 picker의 기본값 설정: 통화 1번은 달러, 2번은 원
        let todayDateFormatter = DateFormatter()
        todayDateFormatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        todayDateFormatter.locale = Locale(identifier: "ko_KR")
        currencyDate.text = todayDateFormatter.string(from: Date())
        //currency1Type.text = exchangeRateManager.currencyArray[22]
        currency1Type.text = "통화 선택"
        currency2Type.text = exchangeRateManager.currencyArray[13]
        currency1Picker.selectRow(22, inComponent: 0, animated: true)
        currency2Picker.selectRow(13, inComponent: 0, animated: true)
        //print(currency1Picker.selectedRow(inComponent: 0))
    }
    
    // 통화 및 날짜 선택 picker의 키보드 Close 버튼
    @objc func pickerClose() {
        self.view.endEditing(true)
    }
    
    // 통화 선택 picker의 키보드 Done 버튼
    @objc func pickerDone() {
        self.view.endEditing(true)
    }
    
    // 날짜 선택 picker의 키보드 Done 버튼
    @objc func datePickerDone(_ sender: UIDatePicker) {
        let pickedDate = sender.date

        let pickedDateFormatter1 = DateFormatter()
        pickedDateFormatter1.dateFormat = "yyyy년 MM월 dd일 (E)"
        pickedDateFormatter1.locale = Locale(identifier: "ko_KR")
        currencyDate.text = pickedDateFormatter1.string(from: pickedDate)

        let pickedDateFormatter2 = DateFormatter()
        pickedDateFormatter2.dateFormat = "yyyyMMdd"
        self.dateString = pickedDateFormatter2.string(from: pickedDate)
    }
    
    @IBAction func tapBackgroundView(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func currency1TypePressed(_ sender: UITextField) {
    }
    
    @IBAction func currency2TypePressed(_ sender: UITextField) {
        currency2Type.endEditing(true)
    }
    
    @IBAction func currency1PricePressed(_ sender: UITextField) {
    }
    
    @IBAction func currency2PricePressed(_ sender: UITextField) {
        currency2Price.endEditing(true)
    }
    
    // 조회하기 버튼 클릭 시
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        if currency1Type.text != "" && currency2Type.text != "" &&
           currency1Price.text != "" {
            exchangeRateManager.getExchangeRate(dateForAPI: self.dateString)
        } else {
            print("ERROR: 통화1, 금액1, 통화2를 모두 입력해주세요")
        }
    }
    
}


//MARK: - ExchangeManagerDelegate
extension ViewController: ExchangeManagerDelegate {
    func didUpdateCurrency(price: String) {
        DispatchQueue.main.async {
            print(price)  // 1392.43
            let result = Double(price)! * Double(self.currency1Price.text!)!
            print(result)
            self.currency2Price.text = String(format: "%.2f", result)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
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
        return exchangeRateManager.currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return exchangeRateManager.currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRowNum = row
        let selectedCurrency = exchangeRateManager.currencyArray[row]
        
        if pickerView == currency1Picker {
            currency1Type.text = selectedCurrency
            self.currency1TypeString = selectedCurrency
        } else if pickerView == currency2Picker {
            currency2Type.text = selectedCurrency
            self.currency2TypeString = selectedCurrency
        }

    }

}
