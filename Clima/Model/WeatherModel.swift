//
//  WeatherModel.swift
//  Clima
//
//  Created by Dmytro Vorobei on 29.03.2024.
//

import Foundation

struct WeatherModel {
    let id: Int
    let city: String
    let description: String
    let temperature: Double
    
    var weatherImage: String {
        let imgItem = weatherImages.filter( { return $0.conditionId == id } )
        return imgItem.count > -1 ? imgItem[0].symbol : "sun.min"
    }
}
