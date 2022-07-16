//
//  ViewController.swift
//  ByteCoin_App
//
//  Created by admin on 14.07.2022.
//  Copyright © 2022 Sergey Lolaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var coinManager = CoinManager()
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var byteView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        byteView.layer.cornerRadius = 35
    }
}


//MARK: - UIPickerView
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        //полученная строка selectedCurrency и является входным параметром для функции getCoinPrice(), передадим значение
        coinManager.getCoinPriceFor(selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    func updateRate(_ rate: Double, for currency: String) {
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.bitcoinLabel.text = String(rate)
        }
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}
