//
//  ViewController.swift
//  MapKitExample
//
//  Modified by Alireza Gholami on 23/02/22.
//

import UIKit
import MapKit


class ViewController: UIViewController, UICoordinatePanelDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIAddressPanelDelegate {
 
    var mapView : MKMapView = MKMapView()   // handles the map (view)
    
    var locationManager : CLLocationManager = CLLocationManager()  // handles the GPS/coordinates
    
    var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D() // store the coordinate value
    
    
    public var coordinatePanel : UICoordinatePanel = UICoordinatePanel()
    
    public var addressPanel : UIAddressPanel = UIAddressPanel()
    
    public var weatherPanel : UIWeatherPanel = UIWeatherPanel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
        initialize()
        
    }
    
    private func initialize(){
        
        self.view.addSubviews(mapView, coordinatePanel, addressPanel, weatherPanel)
    
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.coordinatePanel.delegate = self
        
        self.addressPanel.delegate = self


        applyConstraints()
        
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
        
        
        
    }

    
    func coordinatePanelMapCenterTapped() {
        
//        print("imgCenter tapped!")
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
        
        
        WeatherAPI.weatherNow(city: city, successHandler: WeatherAPISuccessHandeler, failHandler: WeatherAPICurrentFailHandeler)
        
    }
    
    
    // 200 OK -> int = 200, String = OK
    func WeatherAPISuccessHandeler(_ httpStatusCode : Int, _ response : [String: Any]) {
        
        if (httpStatusCode == 200) {
            guard let current = response["current"] as? [String : Any] else {
                return
            }
            
            if let currentWeather = WeatherAPICurrent.decode(json: current){
                print(currentWeather.temp_c)
            }
        }
    }
    
    // 401 Forbiden
    func WeatherAPICurrentFailHandeler(_ httpStatusCode : Int, _ errorMessage: String) {}
    
    func locationManagerGetAddressFailHandler() {
        
        print("Error fetching address")
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
    

}
