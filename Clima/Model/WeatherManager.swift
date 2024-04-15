//
//  WeatherMenager.swift
//  Clima
//
//  Created by Dmytro Vorobei on 29.03.2024.
//

import Foundation
import CoreLocation

struct WeatherManager {
    private let urlAPI = "https://api.openweathermap.org/data/2.5/weather?appid=bf2ea19b92c294fd2decb878535910ac&units=metric"
    
    var delegate: WeatherDelegate?
    
    func update(city: String) {
        let url = "\(urlAPI)&q=\(city)"
        fetch(url)
    }
    
    func update(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let url = "\(urlAPI)&lat=\(latitude)&lon=\(longitude)"
        fetch(url)
    }
    
    private func fetch(_ urlRequest: String) {
        if let url = URL(string: urlRequest) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            return WeatherModel(id: decodedData.weather[0].id,
                                city: decodedData.name,
                                description: decodedData.weather[0].description,
                                temperature: decodedData.main.temp)
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
