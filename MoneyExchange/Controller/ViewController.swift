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
    
    var exchangeRateManager = ExchangeRateManager(rowNum: 0)
    
    var dateString: String = ""
    var currency1TypeString: String = ""
    var currency2TypeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* ViewController에게 위임하기 */
        currency1Picker.delegate = self
        currency2Picker.delegate = self
        currency1Picker.dataSource = self
        currency2Picker.dataSource = self
        exchangeRateManager.delegate = self
        
        /* 각 textfield를 눌렀을 때 보여줄 picker 생성 */
        currencyDate.inputView = currencyDatePicker
        currency1Type.inputView = currency1Picker
        currency2Type.inputView = currency2Picker
     
        /* picker 위에 toolbar 추가 */
        toolbar.sizeToFit()
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        toolbar.setItems([toolbarFlexibleSpace, toolbarDoneButton], animated: true)
        currencyDate.inputAccessoryView = toolbar
        currency1Type.inputAccessoryView = toolbar
        currency2Type.inputAccessoryView = toolbar
        currency1Price.inputAccessoryView = toolbar
        currency2Price.inputAccessoryView = toolbar
        
        /* 날짜의 picker에 대한 설정 */
        currencyDatePicker.datePickerMode = .date
        currencyDatePicker.preferredDatePickerStyle = .wheels
        currencyDatePicker.addTarget(self, action: #selector(datePickerDone(_:)), for: .valueChanged)
        currencyDatePicker.locale = Locale(identifier: "ko_KR")

        /* 기본 설정값으로 셋팅 */
        makeDefaultSetting()
    }
        
    /* 기본 설정값으로 셋팅하는 함수 */
    func makeDefaultSetting() {
        /* 날짜의 textfield에 대한 형식 지정 및 기본값 설정 */
        let todayDateFormatter = DateFormatter()
        todayDateFormatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        todayDateFormatter.locale = Locale(identifier: "ko_KR")
        currencyDate.text = todayDateFormatter.string(from: Date())
        
        /* 통화 및 금액의 textfield에 대한 기본값 설정 */
        currency1Type.text = exchangeRateManager.currencyArray[22]  // 달러
        currency2Type.text = exchangeRateManager.currencyArray[13]  // 원
        currency1Price.text = ""
        currency2Price.text = "?"
        
        /* 통화의 picker에 대한 기본값 설정 */
        currency1Picker.selectRow(22, inComponent: 0, animated: true)  // 달러
        currency2Picker.selectRow(13, inComponent: 0, animated: true)  // 원
    }
    
    /* 팝업 메세지 만드는 함수 */
    func makePopUpMessage(msg: String) {
        /* 팝업으로 보여주고자 하는 메세지 설정 */
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        /* 현재 ViewController에서 팝업 실행 */
        self.present(alert, animated: true, completion: nil)
        
        /* 팝업이 withTimeInterval(초)만큼 유지되다가 사라짐 */
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false,
                             block: { _ in alert.dismiss(animated: true, completion: nil)})
    }
    
    /* 통화 및 날짜 선택 picker의 키보드 Close 버튼 */
    @objc func pickerClose() {
        self.view.endEditing(true)
    }
    
    /* 통화 선택 picker의 키보드 Done 버튼 */
    @objc func pickerDone() {
        self.view.endEditing(true)
    }
    
    /* 날짜 선택 picker의 키보드 Done 버튼 */
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
    
    /* background를 터치했을 때 */
    @IBAction func tapBackgroundView(_ sender: Any) {
        view.endEditing(true)  // 키보드 및 picker가 사라지도록 설정
    }
    
    /* 통화1 종류 textfield를 눌렀을 때 */
    @IBAction func currency1TypePressed(_ sender: UITextField) {
    }
    
    /* 통화2 종류 textfield를 눌렀을 때 */
    @IBAction func currency2TypePressed(_ sender: UITextField) {
        currency2Type.endEditing(true)  // 내용을 수정하지 못하도록 설정
    }
    
    /* 통화1 금액 textfield를 눌렀을 때 */
    @IBAction func currency1PricePressed(_ sender: UITextField) {
    }
    
    /* 통화2 금액 textfield를 눌렀을 때 */
    @IBAction func currency2PricePressed(_ sender: UITextField) {
        currency2Price.endEditing(true)  // 내용을 수정하지 못하도록 설정
    }
    
    /* 조회 버튼을 클릭했을 때 */
    @IBAction func fetchButtonPressed(_ sender: UIButton) {
        if currency1Type.text != "" && currency1Price.text != "" {
            exchangeRateManager.row = currency1Picker.selectedRow(inComponent: 0)
            exchangeRateManager.fetchExchangeRate(dateForAPI: self.dateString)
            makePopUpMessage(msg: "조회 완료")
        } else {
            print("ERROR: 통화를 선택하고 금액을 입력해주세요")
        }
    }
    
    /* 초기화 버튼을 클릭했을 때 */
    @IBAction func initializeButtonPressed(_ sender: UIButton) {
        makeDefaultSetting()
        makePopUpMessage(msg: "초기화 완료")
    }
    
}


//MARK: - ExchangeManagerDelegate
extension ViewController: ExchangeManagerDelegate {
    func didUpdateCurrency(price: String) {
        DispatchQueue.main.async {
            if price == "-1" {
                self.currency2Price.text = "환율 자료 없음"
            } else {
                let result = round(Double(price)! * Double(self.currency1Price.text!)!)
                self.currency2Price.text = String(Int(result))
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
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
