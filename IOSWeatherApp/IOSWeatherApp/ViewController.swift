//
//  ViewController.swift
//  IOSWeatherApp
//
//  Created by Ethan Majidi on 2021-04-01.
//  Copyright © 2021 Ethan Majidi. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var table: UITableView!
    var models = [currentWeather]()
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }

    //for getting your location
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else{
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude

        


    
        //open weather map the api used to get weather Information using lat and long
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=c7fe65dd23bb08100043a2ce9341647a"
        
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            //validationCurrentDescription
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            
            //Convert data to models/some objects
            var json: WeatherResponse?
            do{
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            }
            catch{
                print("error!!!: \(error)")
            }
            
            guard let result = json else{
                return
            }
        
            
            
            //Update user interface
            DispatchQueue.main.async {
                //Location Label
                let label = UILabel(frame: CGRect(x: 100, y: 100, width: 400, height: 100))
                label.center.x = self.view.center.x
                label.textAlignment = .center
                label.text = result.name
                label.font = .systemFont(ofSize: 40)
                self.view.addSubview(label)

                //looks kinda bad might not use
                //country Label
                let countryLabel = UILabel(frame: CGRect(x: 100, y: 150, width: 400, height: 100))
                countryLabel.center.x = self.view.center.x
                countryLabel.textAlignment = .center
                countryLabel.text = result.sys.country
                countryLabel.font = .systemFont(ofSize: 20)
                self.view.addSubview(countryLabel)
                
                
                //conditons label
                let weatherConditionsLabel = UILabel(frame: CGRect(x: 100, y: 475, width:200, height: 100))
                weatherConditionsLabel.textAlignment = .center
                weatherConditionsLabel.text = result.weather[0].description
                weatherConditionsLabel.font = .systemFont(ofSize: 20)
                weatherConditionsLabel.center.x = self.view.center.x
                self.view.addSubview(weatherConditionsLabel)
                
                //Temp label
                let temperatureLabel = UILabel(frame: CGRect(x: 100, y: 525, width:200, height: 100))
                temperatureLabel.textAlignment = .center
                let temp:String = String(format: "%.0f", result.main.temp - 273.15)
                temperatureLabel.text = temp + "°"
                temperatureLabel.font = .systemFont(ofSize: 50)
                temperatureLabel.center.x = self.view.center.x + 1
                self.view.addSubview(temperatureLabel)
                
                //feelslike temp
                let feelslikeLabel = UILabel(frame: CGRect(x: 100, y: 560, width:200, height: 100))
                feelslikeLabel.textAlignment = .center
                let feelsTemp:String = String(format: "%.0f", result.main.feels_like - 273.15)
                feelslikeLabel.text = "Feels Like " + feelsTemp + "°"
                feelslikeLabel.font = .systemFont(ofSize: 16)
                feelslikeLabel.textColor = UIColor.lightGray
                feelslikeLabel.center.x = self.view.center.x + 1
                self.view.addSubview(feelslikeLabel)
                
                //min temp label
                let minTempLabel = UILabel(frame: CGRect(x: 75, y: 640, width:100, height: 100))
                minTempLabel.textAlignment = .center
                let tempMin:String = String(format: "%.0f", result.main.temp_min - 273.15)
                minTempLabel.text = tempMin + "°"
                minTempLabel.font = .systemFont(ofSize: 20)
                minTempLabel.center.x = (self.view.center.x)/2 + 1
                self.view.addSubview(minTempLabel)
                
                //max temp label
                let maxTempLabel = UILabel(frame: CGRect(x: 225, y: 640, width:100, height: 100))
                maxTempLabel.textAlignment = .center
                let tempMax:String = String(format: "%.0f", result.main.temp_max - 273.15)
                maxTempLabel.text = tempMax + "°"
                maxTempLabel.font = .systemFont(ofSize: 20)
                maxTempLabel.center.x = (self.view.center.x) + (self.view.center.x)/2 + 1
                self.view.addSubview(maxTempLabel)
                
                
                //mintempText
                let minTempText = UILabel(frame: CGRect(x: 75, y: 620, width:100, height: 100))
                minTempText.textAlignment = .center
                minTempText.text = "Min Temp"
                minTempText.font = .systemFont(ofSize: 15)
                minTempText.center.x = (self.view.center.x)/2
                self.view.addSubview(minTempText)
                
                //maxTempText
                let maxTempText = UILabel(frame: CGRect(x: 225, y: 620, width:100, height: 100))
                maxTempText.textAlignment = .center
                maxTempText.text = "Max Temp"
                maxTempText.font = .systemFont(ofSize: 15)
                maxTempText.center.x = (self.view.center.x) + (self.view.center.x)/2
                self.view.addSubview(maxTempText)
                
                //humidity label
                let humiditylabel = UILabel(frame: CGRect(x: 225, y: 690, width:100, height: 100))
                humiditylabel.textAlignment = .center
                let humidity:String = String(result.main.humidity)
                humiditylabel.text = humidity + "%"
                humiditylabel.font = .systemFont(ofSize: 20)
                humiditylabel.center.x = (self.view.center.x) + (self.view.center.x)/2 + 1
                self.view.addSubview(humiditylabel)
                
                //humiditytext
                let humidityText = UILabel(frame: CGRect(x: 225, y: 670, width:100, height: 100))
                humidityText.textAlignment = .center
                humidityText.text = "Humidity"
                humidityText.font = .systemFont(ofSize: 15)
                humidityText.center.x = (self.view.center.x) + (self.view.center.x)/2
                self.view.addSubview(humidityText)
                
                //clouds label
                let cloudLabel = UILabel(frame: CGRect(x: 75, y: 690, width:100, height: 100))
                cloudLabel.textAlignment = .center
                let cloudy:String = String(result.clouds.all)
                cloudLabel.text = cloudy + "%"
                cloudLabel.font = .systemFont(ofSize: 20)
                cloudLabel.center.x = (self.view.center.x)/2 + 1
                self.view.addSubview(cloudLabel)
                
                //clouds text
                let cloudyText = UILabel(frame: CGRect(x: 75, y: 670, width:100, height: 100))
                cloudyText.textAlignment = .center
                cloudyText.text = "Cloudiness"
                cloudyText.font = .systemFont(ofSize: 15)
                cloudyText.center.x = (self.view.center.x)/2
                self.view.addSubview(cloudyText)
                
                //winddirectionLabel
                let winddirectionLabel = UILabel(frame: CGRect(x: 225, y: 740, width:200, height: 100))
                winddirectionLabel.textAlignment = .center
                let windDirection:String = String(result.wind.deg)
                
                let windDirectionInt = Double(windDirection)
                
                if windDirectionInt! > 337.5{
                    winddirectionLabel.text = "Northerly"
                }
                else if windDirectionInt! > 292.5{
                    winddirectionLabel.text = "North Westerly"
                }
                else if windDirectionInt! > 247.5{
                    winddirectionLabel.text = "Westerly"
                }
                else if windDirectionInt! > 202.5{
                    winddirectionLabel.text = "South Westerly"
                }
                else if windDirectionInt! > 157.5{
                    winddirectionLabel.text = "Southerly"
                }
                else if windDirectionInt! > 122.5{
                    winddirectionLabel.text = "South Easterly"
                }
                else if windDirectionInt! > 67.5{
                    winddirectionLabel.text = "Easterly"
                }
                else if windDirectionInt! > 22.5{
                    winddirectionLabel.text = "North Easterly"
                }
                else{
                    winddirectionLabel.text = "Notherly"
                }
                
                winddirectionLabel.font = .systemFont(ofSize: 20)
                winddirectionLabel.center.x = (self.view.center.x) + (self.view.center.x)/2 + 1
                self.view.addSubview(winddirectionLabel)
                
                //winddirectiontext
                let winddirectionText = UILabel(frame: CGRect(x: 225, y: 720, width:200, height: 100))
                winddirectionText.textAlignment = .center
                winddirectionText.text = "Wind Direction"
                winddirectionText.font = .systemFont(ofSize: 15)
                winddirectionText.center.x = (self.view.center.x) + (self.view.center.x)/2
                self.view.addSubview(winddirectionText)
                
                //wind speed label
                let windspeedLabel = UILabel(frame: CGRect(x: 75, y: 740, width:200, height: 100))
                windspeedLabel.textAlignment = .center
                let windSpeed:String = String(result.wind.speed)
                var windSpeedDouble = Double(windSpeed)
                //coverts from meter to second to
                windSpeedDouble = windSpeedDouble! * 3.6
                windspeedLabel.text = String(format: "%.1f", windSpeedDouble!) + " KM/H"
                windspeedLabel.font = .systemFont(ofSize: 20)
                windspeedLabel.center.x = (self.view.center.x)/2 + 1
                self.view.addSubview(windspeedLabel)
                
                //clouds text
                let windSpeedText = UILabel(frame: CGRect(x: 75, y: 720, width:100, height: 100))
                windSpeedText.textAlignment = .center
                windSpeedText.text = "Wind Speed"
                windSpeedText.font = .systemFont(ofSize: 15)
                windSpeedText.center.x = (self.view.center.x)/2
                self.view.addSubview(windSpeedText)
                
                

                //creates an image view for the icon
                let weatherIcon : UIImageView
                weatherIcon = UIImageView(frame: CGRect(x: 50, y: 200, width: 300, height: 300))
                
                

                
                //getting time used when determining what background to use
                var daytime = false
                
                let time = result.dt
                let sunrise = result.sys.sunrise
                let sunset = result.sys.sunset
                
                if time < sunrise{
                    daytime = false
                }
                else if time >= sunrise && time <= sunset{
                    daytime = true
                }
                else if time > sunset{
                    daytime = false
                }
                
                
            //these all work the same they get API tells the app what icon it needs and it gets it from the assests
            //then it checks to see if it is day or night and sets a correct background
            //there are only a couple of icons this is because Open weather Maps at least according to their website only has this many icon ids
                
                //icon for clear day
                if result.weather[0].icon == "01d"{
                    weatherIcon.image = UIImage(named: "Sunny")
                    self.view.backgroundColor = UIColor(patternImage: UIImage(named:"sunnyday")!)
                }
                //icon for night clear
                else if result.weather[0].icon == "01n"{
                    weatherIcon.image = UIImage(named: "Moon")
                    self.view.backgroundColor = UIColor(patternImage: UIImage(named:"clearNight")!)
                   
                }
                //icons for cloudy
                else if result.weather[0].icon == "02d" || result.weather[0].icon == "02n" || result.weather[0].icon == "03d" || result.weather[0].icon == "03n" || result.weather[0].icon == "04d" || result.weather[0].icon == "04n" {
                    weatherIcon.image = UIImage(named: "Cloudy")
                    //checking whether it is day or night
                    if(daytime == true){
                        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"cloudyDay")!)
                    }
                    else{
                        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"cloudyNight")!)
                    }
                    
                }
                //icon raining
                else if result.weather[0].icon == "09d" || result.weather[0].icon == "09n" || result.weather[0].icon == "10d" || result.weather[0].icon == "10n" {
                    weatherIcon.image = UIImage(named: "Rainy")
                    //checking whether it is day or night
                    if(daytime == true){
                        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"rainyDay")!)
                    }
                    else{
                        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"rainyNight")!)
                    }
                    
                }
                //icon for thunder
                else if result.weather[0].icon == "11n" || result.weather[0].icon == "11n" {
                    weatherIcon.image = UIImage(named: "Thundery")
                    //checking whether it is day or night
                    if(daytime == true){
                        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"rainyDay")!)
                    }
                    else{
                        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"rainyNight")!)
                    }
                }
                //icon for snow
                else if result.weather[0].icon == "13n" || result.weather[0].icon == "11n" {
                    weatherIcon.image = UIImage(named: "Snowy")
                    //checking whether it is day or night
                    if(daytime == true){
                        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"snowyDay")!)
                    }
                    else{
                        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"snowyNight")!)
                    }
                }
                //icon for mist
                else if result.weather[0].icon == "50d" || result.weather[0].icon == "50n" {
                    weatherIcon.image = UIImage(named: "Misty")
                    //checking whether it is day or night
                    if(daytime == true){
                        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"mistyDay")!)
                    }
                    else{
                        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"mistyNight")!)
                    }
                }
                self.view.addSubview(weatherIcon)
                
                
                
            }
            
        }.resume()
    }
    
    //table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    


}
//structs for getting the weather information
struct WeatherResponse: Codable {
    let coord: coordinates
    let weather: [currentWeather]
    let base: String
    let main: currentMain
    let wind: currentWind
    let clouds: currentClouds
    let dt: Int
    let sys: System
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct coordinates: Codable {
    let lon: Double
    let lat: Double
}
struct currentWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
struct currentMain: Codable {
    let temp: Float
    let feels_like: Float
    let pressure: Double
    let humidity: Int
    let temp_min: Float
    let temp_max: Float
}
struct currentWind: Codable {
    let speed: Double
    let deg: Int
}

struct currentClouds: Codable {
    let all: Int
}
struct System: Codable {
    let country: String
    let sunrise: Int
    let sunset: Int
}





























//garbage to extend page

//adljfalkdjflkajjoejfoaejo
