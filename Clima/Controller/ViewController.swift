//
//  ViewController.swift
//  Clima
//
//  Created by Dmytro Vorobei on 29.03.2024.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityNameField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        cityNameField.delegate = self
        weatherManager.delegate = self
    }
    
    func errorMessageAlert(error: String) {
    let alertMessageAlert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
       let okButton = UIAlertAction(title: "OK", style: .default)
       
        alertMessageAlert.addAction(okButton)
       self.present(alertMessageAlert, animated: true)
        
    }
}


//MARK: - TextFieldDelegate
extension ViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        getWeather()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        cityNameField.endEditing(true)
        getWeather()
        return true
    }
    
    func getWeather() {
        if let city = cityNameField.text {
            weatherManager.update(city: city)
        } else {
            errorMessageAlert(error: "The search filed should not be empty!")
        }
    }
}


//MARK: - WeatherDelegate
extension ViewController: WeatherDelegate {
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.errorMessageAlert(error: "Something went wrong! The problem may be in the correct spelling of the city.")
            print("ERROR occured: \(error)")
        }
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityNameField.text = ""
            self.cityName.text = weather.city.uppercased()
            self.weatherDescription.text = weather.description
            self.weatherTemperature.text = String(format: "%.0f", weather.temperature)
            self.weatherImage.image = UIImage(systemName: weather.weatherImage)
        }
    }
}

//MARK: - CLLocationDelegate
extension ViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.update(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessageAlert(error: "The problem occured on getting device location. Please, check the privacy.")
        print(error)
    }
    
}

