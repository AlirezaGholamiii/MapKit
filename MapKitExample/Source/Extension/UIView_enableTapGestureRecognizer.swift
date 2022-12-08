//
//  UIView_enableTapGestureRecognizer.swift
//  MapKit
//
//  Created by Daniel Carvalho on 18/02/22.
//

import Foundation
import UIKit

extension UIView {
    
    func enableTapGestureRecognizer( target : Any?, action : Selector? ) {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
}
