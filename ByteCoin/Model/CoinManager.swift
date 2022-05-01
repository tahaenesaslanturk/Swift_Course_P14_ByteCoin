//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager ,coin: CoinModel )
    func didFailWithError(error: Error)
}

struct CoinManager{
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "API-KEY-HERE"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func fetchCurrency(exchangeCurrency: String) {
        let urlString = "\(baseURL)/\(exchangeCurrency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    var delegate: CoinManagerDelegate?
    
    func performRequest(with urlString: String) {
        // 1. Create URL
        if let url = URL(string: urlString){
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the sessiona a task
            
            
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }
            
            // 4. Start the task
            task.resume()
        }
        
    }
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let base = decodedData.asset_id_base
            let quote = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coin = CoinModel(baseCoin: base, exchangedCoin: quote, rate: rate)
            return coin
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    
}
