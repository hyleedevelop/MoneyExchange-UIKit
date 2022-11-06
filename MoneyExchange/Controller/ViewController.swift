//
//  ViewController.swift
//  MoneyExchange
//
//  Created by Eric on 2022/11/06.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fromPriceLabel: UILabel!
    @IBOutlet weak var fromCurrencyButton: UIButton!
    @IBOutlet weak var toPriceLabel: UILabel!
    @IBOutlet weak var toCurrencyButton: UIButton!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var exchangeManager = ExchangeManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func fromCurrencyButtonClicked(_ sender: UIButton) {
        fromPriceLabel.text = ???
    }
    
    @IBAction func toCurrencyButtonClicked(_ sender: UIButton) {
        toPriceLabel.text = ???
    }
    
    
    
}


//MARK: - UIPickerView Datasource & Delegate
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return coinManager.currencyArray.count
//    }

//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return coinManager.currencyArray[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let selectedCurrency = coinManager.currencyArray[row]
//        coinManager.getCoinPrice(for: selectedCurrency)
//
//    }
    
}
