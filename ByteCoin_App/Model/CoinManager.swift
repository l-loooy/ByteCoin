//
//  CoinManager.swift
//  ByteCoin_App
//
//  Created by admin on 14.07.2022.
//  Copyright © 2022 Sergey Lolaev. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func updateRate(_ rate: Double, for currency: String)
    func didFailWithError(_ error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9728DF81-35F2-4B51-BAB2-F352021DCD06"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPriceFor(_ currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let currencyPrice = self.parseJSON(safeData) {
                        self.delegate?.updateRate(currencyPrice, for: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let rate = decodedData.rate
            print(rate)
            return rate
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
