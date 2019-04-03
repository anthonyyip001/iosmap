//
//  knView.swift
//  Ogenii
//
//  Created by Ky Nguyen on 3/17/17.
//  Copyright © 2017 Ky Nguyen. All rights reserved.
//

import UIKit

class knView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setupView() { }
}

extension UIView {
    func zoomIn(_ isIn: Bool, complete: (() -> Void)? = nil) {
        let initialValue: CGFloat = isIn ? 0.8 : 1
        let endValue: CGFloat = isIn ? 1 : 0.8
        transform = transform.scaledBy(x: initialValue , y: initialValue)
        UIView.animate(withDuration: 0.35, delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.transform = CGAffineTransform.identity.scaledBy(x: endValue, y: endValue)
            }, completion: { _ in complete?() })
    }
    
    func scale(value: CGFloat) {
        transform = CGAffineTransform.identity.scaledBy(x: value, y: value)
    }
    
    func createBorder(_ width: CGFloat, color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    @objc func createRoundCorner(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}

extension UIColor {
    static func color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
    }
}

