//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    func failedWithError(_ error: Error)
    func didUpdateRate(_ rate: Double)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8F54EB26-762D-4B30-AF68-BD07272C5B8E"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(self.baseURL)/\(currency)"
        performWebRequest(with: urlString)
    }
    
    func performWebRequest(with urlString: String) {
        // 0. Add API Key
        let urlString = "\(urlString)?apikey=\(self.apiKey)"
        // 1. Create URL
        if let url = URL(string: urlString) {
            
            // 2. Create URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            // completion handler is triggered by the task, The task will add
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.failedWithError(error!)
                    return
                }
                
                if let safeData = data {
                    // Call self within closure no longer required apparently
                    if let rate = parseJson(coinData: safeData) {
                        print("BTC: \(rate) retrieved, update UI")
                        self.delegate?.didUpdateRate(rate)
                    } else {
                        print("An error occurred...")
                    }
                }
            }
            
            // 4. Start the task
            // Why resume? because a task can be suspended, and
            // Newly created tasks start in suspended state
            task.resume()
        }
        
    }
    
    func parseJson(coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinApiData.self, from: coinData)
            return decodedData.rate
        } catch {
            self.delegate?.failedWithError(error)
            return nil
        }
    }
}
