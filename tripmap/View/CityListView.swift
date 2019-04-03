//
//  ListView.swift
//  tripmap
//
//  Created by Ky Nguyen on 4/3/19.
//  Copyright © 2019 Anthony Yip. All rights reserved.
//

import UIKit
import CoreLocation

class CityListPopup: knPopup {
    let cityListView = CityListView()
    var selectAction: ((City) -> Void)?
    var viewHeight: NSLayoutConstraint?
    func setData(data: [City]) {
        if data.count > 10 {
            viewHeight?.constant = UIScreen.main.bounds.height / 2
        }
        cityListView.datasource = data
    }

    override func setupView() {
        cityListView.owner = self
        let titleLabel = UIMaker.makeLabel(text: "City Name", color: .white, alignment: .center)
        titleLabel.backgroundColor = .darkGray

        view.addSubviews(views: titleLabel, cityListView)
        titleLabel.horizontal(toView: view)
        titleLabel.height(44)
        titleLabel.top(toView: view)

        cityListView.fill(toView: view, space: UIEdgeInsets(top: 44))
        viewHeight = cityListView.height(200)

        view.createRoundCorner(7)
    }

    func didSelectCity(_ city: City) {
        selectAction?(city)
    }
}

class City {
    var name: String
    var description: String?
    var point: CLLocationCoordinate2D?

    init(name: String, description: String?, point: CLLocationCoordinate2D) {
        self.name = name
        self.point = point
        self.description = description
    }

    init(name: String) {
        self.name = name
    }
}

class CityItemCell: knListCell<City> {
    override var data: City? { didSet {
        textLabel?.text = data?.name
        }}
    let leftImageView = UIMaker.makeImageView(image: UIImage(named: "strictd"))
    let rightImageView = UIMaker.makeImageView()

    override func setupView() {
        leftImageView.createBorder(1, color: .lightGray)
        leftImageView.createRoundCorner(3)
        leftImageView.square(edge: 24)
        addSubviews(views: leftImageView)
        leftImageView.left(toView: self, space: 16)
        leftImageView.centerY(toView: self)

        rightImageView.createBorder(1, color: .lightGray)
        rightImageView.createRoundCorner(3)
        rightImageView.square(edge: 24)
        addSubviews(views: rightImageView)
        rightImageView.right(toView: self, space: -16)
        rightImageView.centerY(toView: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame.origin.x = 56
    }
}

class CityListView: knListView<CityItemCell, City> {
    weak var owner: CityListPopup?

    override func didSelectRow(at indexPath: IndexPath) {
        owner?.dismiss()
        owner?.didSelectCity(datasource[indexPath.row])
    }
}
