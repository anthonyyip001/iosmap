//
//  knPopup.swift
//  knPopup
//
//  Created by Ky Nguyen Coinhako on 10/9/18.
//  Copyright © 2018 Ky Nguyen. All rights reserved.
//

import UIKit

class knPopup: knView {
    let blackView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let view: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    let okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.backgroundColor = UIColor.color(r: 71, g: 204, b: 54)
        button.height(54)
        button.createRoundCorner(27)
        return button
    }()
    
    override func setupView() {}
    
    func show(in container: UIView) {
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blackView.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        addSubviews(views: blackView, view)
        blackView.fill(toView: self)
        view.centerY(toView: self)
        view.horizontal(toView: self, space: 24)
        
        blackView.alpha = 0
        UIView.animate(withDuration: 0.1, animations:
            { [weak self] in self?.blackView.alpha = 1 })
        view.zoomIn(true)
        
        container.addSubviews(views: self)
        fill(toView: container)
    }
    
    @objc func dismiss() {
        let initialValue: CGFloat = 1
        let middleValue: CGFloat = 1.025
        let endValue: CGFloat = 0.001
        func fadeOutContainer() {
            UIView.animate(withDuration: 0.2, animations:
                { [weak self] in self?.view.alpha = 0 })
        }
        func zoomInContainer() {
            UIView.animate(withDuration: 0.05,
                           animations: { [weak self] in self?.view.scale(value: middleValue) })
        }
        func zoomOutContainer() {
            UIView.animate(withDuration: 0.3, delay: 0.05, options: .curveEaseIn,
                           animations:
                { [weak self] in
                    self?.view.scale(value: endValue)
                    self?.blackView.alpha = 0
                }, completion: { [weak self] _ in self?.removeFromSuperview() })
        }
        
        view.transform = view.transform.scaledBy(x: initialValue , y: initialValue)
        fadeOutContainer()
        zoomInContainer()
        zoomOutContainer()
    }
}

