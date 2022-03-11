//
//  UIAddressPanel.swift
//  MapKitExample
//
//  Created by Alireza gholami on 01/03/22.
//

import UIKit

protocol UIAddressPanelDelegate {
    
    func AddressPanelBtnCloseTapped()
    
}

extension UIAddressPanelDelegate {
    
    func AddressPanelBtnCloseTapped() {
        // no code ... in this case, the implementation will be optional
    }
}



class UIAddressPanel: UIView {
    
    public var delegate : UIAddressPanelDelegate?
   
    private let lblAddress : UILabel = {
        
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
        
    }()
    
    private let btnClose : UIImageView = {
        
        let img = UIImageView()
        img.image = UIImage(systemName: "xmark")
        img.tintColor = .gray
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
        
    }()

    public var address : String = "" {
        didSet{
            lblAddress.text = address
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
        
        self.addSubviews(lblAddress, btnClose)
        
        self.btnClose.enableTapGestureRecognizer(target: self, action: #selector(btnCloseTapped))
        
        applyConstraints()
    }
    
    @objc private func btnCloseTapped() {
        
        // PENDING: call the protocol
        if delegate != nil {
            delegate?.AddressPanelBtnCloseTapped()
        }
        
    }
    
    private func applyConstraints() {
        
        lblAddress.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        lblAddress.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        lblAddress.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        lblAddress.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
//        lblAddress.backgroundColor = .red
        
        btnClose.topAnchor.constraint(equalTo: lblAddress.topAnchor).isActive = true
        btnClose.leadingAnchor.constraint(equalTo: lblAddress.trailingAnchor).isActive = true
//        btnClose.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10).shouldGroupAccessibilityChildren = true
        btnClose.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        btnClose.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btnClose.widthAnchor.constraint(equalTo: btnClose.heightAnchor).isActive = true
        
//        btnClose.backgroundColor = .orange
        
    }
    

}
