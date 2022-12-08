//
//  UICoordinatePanel.swift
//  MapKit
//
//  Created by Daniel Carvalho on 18/02/22.
//

import UIKit

protocol UICoordinatePanelDelegate {
    
    func coordinatePanelMapCenterTapped()
    
}

extension UICoordinatePanelDelegate {
    
    func coordinatePanelMapCenterTapped() {
        // no code
    }
    
}


class UICoordinatePanel: UIView {

    public var delegate : UICoordinatePanelDelegate?
    
    static private func defaultLabel( text : String, bold : Bool = false ) -> UILabel {
        
        let lbl = UILabel()
        lbl.text = text
        // Ternary conditional operator
        lbl.font = bold ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        
        // we need this translates...intoContraints = false to apply constraints on this object.
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
        
    }
    
    
    private var lblLatitudeTitle : UILabel = UICoordinatePanel.defaultLabel(text: "Latitude")
    
    private var lblLongitudeTitle : UILabel = UICoordinatePanel.defaultLabel(text: "Longitude")
    
    private var lblLatitude : UILabel = UICoordinatePanel.defaultLabel(text: "?", bold: true)
    
    private var lblLongitude : UILabel = UICoordinatePanel.defaultLabel(text: "?", bold: true)
    
    
    private var imgMapCenter : UIImageView = {
        
        let img = UIImageView()
        img.image = UIImage(systemName: "target")
        img.tintColor = .black
        // because we are applying constraints...
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
        
    }()
    
    
    public var latitude : Double = 0 {
        didSet{
            self.lblLatitude.text = String(format: "%.6f", latitude)
        }
    }
    
    public var longitude : Double = 0 {
        didSet{
            self.lblLongitude.text = String(format: "%.6f", longitude)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initialize() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .white.withAlphaComponent(0.7)
        
        self.addSubviews(lblLongitudeTitle, lblLatitudeTitle, lblLongitude, lblLatitude, imgMapCenter)
        
        self.imgMapCenter.enableTapGestureRecognizer(target: self, action: #selector(imgMapCenterTapped))
        
        applyConstraints()
        
    }
    
    @objc private func imgMapCenterTapped() {
        
        if self.delegate != nil {
            self.delegate!.coordinatePanelMapCenterTapped()
        }
        
    }
    
    private func applyConstraints() {
        
        
        // Leading  = Left
        // Trailing = Right
        
        lblLatitudeTitle.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        lblLatitudeTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        lblLatitudeTitle.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5, constant: -20).isActive = true
        lblLatitudeTitle.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        lblLongitudeTitle.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        lblLongitudeTitle.topAnchor.constraint(equalTo: lblLatitudeTitle.topAnchor).isActive = true
        lblLongitudeTitle.widthAnchor.constraint(equalTo: lblLatitudeTitle.widthAnchor).isActive = true
        lblLongitudeTitle.heightAnchor.constraint(equalTo: lblLatitudeTitle.heightAnchor).isActive = true
        
        
        lblLatitude.leadingAnchor.constraint(equalTo: lblLatitudeTitle.leadingAnchor).isActive = true
        lblLatitude.topAnchor.constraint(equalTo: lblLatitudeTitle.bottomAnchor).isActive = true
        lblLatitude.heightAnchor.constraint(equalTo: lblLatitudeTitle.heightAnchor).isActive = true
        lblLatitude.widthAnchor.constraint(equalTo: lblLatitudeTitle.widthAnchor).isActive = true
        
    
        lblLongitude.leadingAnchor.constraint(equalTo: lblLongitudeTitle.leadingAnchor).isActive = true
        lblLongitude.topAnchor.constraint(equalTo: lblLongitudeTitle.bottomAnchor).isActive = true
        lblLongitude.heightAnchor.constraint(equalTo: lblLongitudeTitle.heightAnchor).isActive = true
        lblLongitude.widthAnchor.constraint(equalTo: lblLongitudeTitle.widthAnchor).isActive = true
        

        imgMapCenter.trailingAnchor.constraint(equalTo: lblLongitudeTitle.trailingAnchor).isActive = true
        imgMapCenter.centerYAnchor.constraint(equalTo: lblLongitudeTitle.bottomAnchor).isActive = true
        imgMapCenter.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imgMapCenter.widthAnchor.constraint(equalTo: imgMapCenter.heightAnchor).isActive = true
        
        
        
        
    }
    
    
}
