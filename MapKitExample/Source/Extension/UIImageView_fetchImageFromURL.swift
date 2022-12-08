//
//  UIImageView_fetchImageFromURL.swift
//  IOS2-MapKit
//
//  Created by Daniel Carvalho on 2022-02-17.
//

import UIKit

extension UIImageView {
    
    func fetchUImageFromURL(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
}


