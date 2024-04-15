//
//  WeatherDelegate.swift
//  Clima
//
//  Created by Dmytro Vorobei on 02.04.2024.
//

import Foundation

protocol WeatherDelegate {
    
    func didFailWithError(error: Error)
    
    func didUpdateWeather(weather: WeatherModel)
}
