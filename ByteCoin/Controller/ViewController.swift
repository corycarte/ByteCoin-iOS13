//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    var selectedCurrency: String = "USD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
    
}

//MARK: - UIPickerViewDataSource
extension ViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate
extension ViewController {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: self.selectedCurrency)
    }
}

//MARK: - CoinManagerDelegate
extension ViewController {
    func failedWithError(_ error: Error) {
        print(error)
    }
    
    func didUpdateRate(_ rate: Double) {
        print("Updating rate UI to \(rate)")
        DispatchQueue.main.async {
            self.currencyLabel.text = self.selectedCurrency
            self.bitcoinLabel.text = String(format: "%.2f", rate)
        }
    }
}
