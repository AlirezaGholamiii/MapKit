//
//  UIWeatherPanel.swift
//  MapKitExample
//
//  Created by Daniel Carvalho on 08/03/22.
//

import UIKit

class UIWeatherPanel: UIView {

    static private func defaultLabel( text : String,
                                      fontSize : CGFloat = 10,
                                      fontBold : Bool = true,
                                      numberOfLines : Int = 1) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.numberOfLines = numberOfLines
        
        /*
        if fontBold {
            label.font = UIFont.boldSystemFont(ofSize: fontSize)
        } else {
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
         */
        label.font = fontBold ? UIFont.boldSystemFont(ofSize: fontSize) :  UIFont.systemFont(ofSize: fontSize)
        
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private var lblTemperatureValue : UILabel = defaultLabel(text: "??", fontSize: 30, fontBold: true, numberOfLines: 1)
    
    private var lblTemperatureUnit : UILabel = defaultLabel(text: "C")
    
    private var lblCondition : UILabel = defaultLabel(text: "Cloud", fontSize: 12, numberOfLines: 2)
    
    private var lblFeelsLikeText : UILabel = defaultLabel(text: "feels like",  numberOfLines: 2)
    
    private var lblFeelsLikeValue : UILabel = defaultLabel(text: "?", fontSize: 15, fontBold: true)
    


    
    private var imgWeather : UIImageView = {
        
        let img = UIImageView()
        img.image = UIImage(systemName: "")
        img.tintColor = .gray
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
        
    }()
    
    
    public var temperature : String = "" {
        didSet{
            self.lblTemperatureValue.text = temperature
        }
    }
    
    public var temprutureUnit : String = "" {
        didSet{
            self.lblTemperatureUnit.text = temprutureUnit
        }
    }
    
    
    public var feelsLike : String = "" {
        didSet{
            self.lblFeelsLikeValue.text = feelsLike
        }
    }
    
    
    
    public var condition : String = "" {
        didSet{
            self.lblCondition.text = condition
        }
    }
    

    
    
    public var image : String = "" {
            didSet{
                
                self.imgWeather.fetchUImageFromURL(url: URL(string: image )!)
            }
        }
    
    
    public func imageFromUrl( url : String ) {
        self.imgWeather.fetchUImageFromURL(url: URL(string: url)!)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white.withAlphaComponent(0.70)
        
        self.addSubviews(lblTemperatureValue, lblTemperatureUnit, lblFeelsLikeValue, lblFeelsLikeText, lblCondition, imgWeather)
        
        self.layer.cornerRadius = 15
        
        applyConstraints()
    }
    
    private func applyConstraints(){
        
        self.heightAnchor.constraint(equalToConstant: 185).isActive = true
        self.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        self.imgWeather.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        self.imgWeather.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.imgWeather.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.imgWeather.widthAnchor.constraint(equalTo: self.imgWeather.heightAnchor).isActive = true
        

        self.lblTemperatureValue.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.lblTemperatureValue.topAnchor.constraint(equalTo: self.imgWeather.bottomAnchor, constant: 10).isActive = true
        self.lblTemperatureValue.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.lblTemperatureValue.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.lblTemperatureValue.textAlignment = .center
        //        self.lblTemperatureValue.centerXAnchor.constraint(equalTo: self.imgWeather.centerXAnchor).isActive = true
//        self.lblTemperatureValue.widthAnchor.constraint(equalTo: self.lblTemperatureValue.heightAnchor).isActive = true
        

        self.lblTemperatureUnit.bottomAnchor.constraint(equalTo: self.lblTemperatureValue.bottomAnchor).isActive = true
        self.lblTemperatureUnit.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        self.lblTemperatureUnit.heightAnchor.constraint(equalToConstant: 10).isActive = true
        self.lblTemperatureUnit.widthAnchor.constraint(equalTo: self.lblTemperatureUnit.heightAnchor).isActive = true
        

        self.lblCondition.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        self.lblCondition.topAnchor.constraint(equalTo: lblTemperatureValue.bottomAnchor, constant: 10).isActive = true
        self.lblCondition.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        self.lblCondition.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.lblCondition.textAlignment = .center
        
        
        self.lblFeelsLikeText.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        self.lblFeelsLikeText.topAnchor.constraint(equalTo: self.lblCondition.bottomAnchor, constant: 10).isActive = true
        self.lblFeelsLikeText.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.lblFeelsLikeText.widthAnchor.constraint(equalToConstant: 32).isActive = true
        self.lblFeelsLikeText.textAlignment = .center
                
        
        self.lblFeelsLikeValue.leadingAnchor.constraint(equalTo: self.lblFeelsLikeText.trailingAnchor).isActive = true
        self.lblFeelsLikeValue.topAnchor.constraint(equalTo: self.lblFeelsLikeText.topAnchor).isActive = true
        self.lblFeelsLikeValue.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        self.lblFeelsLikeValue.bottomAnchor.constraint(equalTo: self.lblFeelsLikeText.bottomAnchor).isActive = true
        self.lblFeelsLikeValue.textAlignment = .right
        
        
        
    }
    
}
