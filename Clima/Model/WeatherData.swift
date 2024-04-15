//
//  WeatherData.swift
//  Clima
//
//  Created by Dmytro Vorobei on 29.03.2024.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

struct WeatherImage {
    let conditionId: Int
    let symbol: String
    
    init(_ conditionId: Int, _ symbol: String) {
        self.conditionId = conditionId
        self.symbol = symbol
    }
}
