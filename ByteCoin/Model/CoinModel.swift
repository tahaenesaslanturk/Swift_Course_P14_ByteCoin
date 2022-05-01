//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Taha Enes Aslantürk on 1.05.2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let baseCoin: String
    let exchangedCoin: String
    let rate: Double
    
    func getRate() -> String{
        return String(format: "%.2f", rate)
    }
    
}
