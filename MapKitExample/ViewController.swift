//
//  ViewController.swift
//  MapKitExample
//
//  Created by Daniel Carvalho on 23/02/22.

//Ghazar ghazarian 202015953
//Mohamad Nour AL Shaar -1933176
//Alireza Gholami- 1931230
//Dannysh-singh Baurun

import UIKit
import MapKit



class ViewController: UIViewController, UICoordinatePanelDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIAddressPanelDelegate {
    
    private var slider = UISlider()
    
    var mapView : MKMapView = MKMapView()   // handles the map (view)
    
    var locationManager : CLLocationManager = CLLocationManager()  // handles the GPS/coordinates
    
    var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D() // store the coordinate value
    
    
    public var coordinatePanel : UICoordinatePanel = UICoordinatePanel()
    
    public var addressPanel : UIAddressPanel = UIAddressPanel()
    
    public var weatherPanel : UIWeatherPanel = UIWeatherPanel()
    
    var isTempC : Bool = true
    var isTempSet : Bool = true

    
    var currentWeather : WeatherAPICurrent?
    var currentCity : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        initialize()
        startTimmer5Second()  // 5" timer...
        startTimmer5min()
        
    }
    
    private func initialize(){
        
        self.slider = CreateSlider()
        self.slider.value = Float(self.mapView.region.span.latitudeDelta)
        
        self.view.addSubviews(mapView, coordinatePanel, addressPanel, weatherPanel, self.slider)
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.coordinatePanel.delegate = self
        
        self.addressPanel.delegate = self
        
        
        applyConstraints()

    }
    
    func CreateSlider() -> UISlider {
        let mySlider = UISlider()
        mySlider.maximumValue = 0.1
        mySlider.minimumValue = 0.001
        mySlider.translatesAutoresizingMaskIntoConstraints = false
        mySlider.isContinuous = true
        mySlider.tintColor = .red
        mySlider.addTarget(self, action: #selector(self.onSliderChange(_ :)), for: .valueChanged)
        return mySlider
    }
    
    @objc func onSliderChange(_ sender : UISlider) {
        var zoom = Double(self.slider.value)
        zoom = Double(self.slider.maximumValue) - zoom
        var currentRegion = self.mapView.region
        currentRegion.span = MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
        self.mapView.region = currentRegion
    }
    
    private func applyConstraints() {
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        coordinatePanel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        coordinatePanel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        coordinatePanel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        coordinatePanel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        addressPanel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        addressPanel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        addressPanel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        addressPanel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        weatherPanel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        weatherPanel.topAnchor.constraint(equalTo: self.coordinatePanel.bottomAnchor, constant: 20).isActive = true

        
        slider.leadingAnchor.constraint(equalTo: self.addressPanel.leadingAnchor, constant: 15).isActive = true
        slider.trailingAnchor.constraint(equalTo: self.addressPanel.trailingAnchor, constant: -15).isActive = true
        slider.bottomAnchor.constraint(equalTo: self.addressPanel.bottomAnchor).isActive = true
        
        
        
    }
    
    
    func coordinatePanelMapCenterTapped() {
        
     
        startUpdatingLocation()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startUpdatingLocation()
        
    }
    
    private func startUpdatingLocation() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            locationManager.stopUpdatingLocation()
            
            setMapLocation(location: location)
            
            
        }
        
    }
    
    private func setMapLocation(location: CLLocation ) {
        
        self.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        // 0.001 (street) - 1-10 (global)
        
        showMap( coordinate: self.coordinate, latLongDelta : 0.002)
        
        coordinatePanel.longitude = self.coordinate.longitude
        coordinatePanel.latitude = self.coordinate.latitude
        
        self.locationManager.getAddress(from: self.coordinate, successHandler: locationManagerGetAddressSuccessHandler, failHandler: locationManagerGetAddressFailHandler)
        
        
        // Adding an annotation in our map (user position)
        let pin = MKPointAnnotation()
        pin.coordinate = self.coordinate
        pin.title = "You are here"
        pin.subtitle = "Enjoy the area"
        
        mapView.addAnnotation(pin)
        
        
    }
    
    func locationManagerGetAddressSuccessHandler(_ address : String, _ city : String) {
        
        addressPanel.address = address
        addressPanel.isHidden = false
        currentCity = city
        
        WeatherAPI.weatherNow(city: city, successHandler: weatherAPICurrentSuccessHandler, failHandler: weatherAPICurrentFailHandler)
        
        
        
        
    }
    
    private func showMap( coordinate: CLLocationCoordinate2D, latLongDelta : Float) {
        
        // MKCoordinateSpan is the widht and height of the map view in degress (0.001 - 1-10)
        let span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(latLongDelta), longitudeDelta: CLLocationDegrees(latLongDelta))
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        
        mapView.setRegion(region, animated: true)
        
    }
    
    func AddressPanelBtnCloseTapped() {
        // It is coming from the UIAddressPanel protocol
        
        addressPanel.isHidden = true
        
    }
    
    
    
    
    @objc func timerTrigged5min() {
        
        print("Timer 5 min trigged")
 
        WeatherAPI.weatherNow(city: self.currentCity!, successHandler: weatherAPICurrentSuccessHandler, failHandler: weatherAPICurrentFailHandler)

       
    }
    
    
    
     func weatherAPICurrentSuccessHandler(_ httpStatusCode : Int, _ response : [String: Any]) {
        
        if httpStatusCode == 200 {
            
            guard let current = response["current"] as? [String : Any] else {
                return
            }
            
            if let currentWeather = WeatherAPICurrent.decode(json: current){
                
                self.currentWeather = currentWeather
                
                print(currentWeather.temp_c)
                print(currentWeather.condition.text)
                print(currentWeather.feelslike_c)
                print(currentWeather.temp_f)
                print(currentWeather.feelslike_f)
                
                DispatchQueue.main.async {
                self.weatherPanel.temperature = String(Int(currentWeather.temp_c))
                self.weatherPanel.feelsLike = String(Int(currentWeather.feelslike_c))
                self.weatherPanel.imageFromUrl(url: "https:" + currentWeather.condition.icon)
                self.weatherPanel.condition = String(currentWeather.condition.text)
                self.weatherPanel.temprutureUnit = String("C")
                    
                }
                


                
            }
            
        }
    }
    
    func weatherAPICurrentFailHandler(_ httpStatusCode : Int, _ errorMessage: String) {
        
    }
    
    
    
    func locationManagerGetAddressFailHandler() {
        
        print("Error fetching address")
    }
    
    
    
    func startTimmer5Second() {
        
        var timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerTrigged), userInfo: nil, repeats: true)
        
        
    }
    func startTimmer5min() {
        
        var timer5min = Timer.scheduledTimer(timeInterval: 11, target: self, selector: #selector(timerTrigged5min), userInfo: nil, repeats: true)
        
        
    }
    
    
    
    @objc func timerTrigged() {
        
        print("Timer trigged")
        
        if self.currentWeather == nil {
            // no internet connection (could not fetch the api)
            return
        }
        
        if(self.isTempC == true)
        {
            DispatchQueue.main.async {
                self.weatherPanel.temperature = String(Int(self.currentWeather!.temp_c))
                self.weatherPanel.feelsLike = String(Int(self.currentWeather!.feelslike_c))
                self.weatherPanel.temprutureUnit = String("C")
                
                
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.weatherPanel.temperature = String(Int(self.currentWeather!.temp_f))
                self.weatherPanel.feelsLike = String(Int(self.currentWeather!.feelslike_f))
                self.weatherPanel.temprutureUnit = String("F")
               
            }
        }

        self.isTempC = !self.isTempC

    }
    
}
