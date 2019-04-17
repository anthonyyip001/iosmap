//
//  ListView.swift
//  Ogenii
//
//  Created by Ky Nguyen Coinhako on 7/20/18.
//  Copyright © 2018 Ogenii. All rights reserved.
//

import UIKit


class knTableCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        selectionStyle = .none
    }
    static func wrap(view: UIView, space: UIEdgeInsets = .zero) -> knTableCell {
        let cell = knTableCell()
        cell.backgroundColor = .clear
        cell.addSubviews(views: view)
        view.fill(toView: cell, space: space)
        return cell
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func setupView() { }
}


class knListCell<U>: knTableCell {
    var data: U?
}


class knListView<C: knListCell<U>, U>: knView, UITableViewDataSource, UITableViewDelegate {
    var datasource = [U]() { didSet { tableView.reloadData() }}
    fileprivate let cellId = String(describing: C.self)
    var rowHeight: CGFloat = UITableViewAutomaticDimension

    lazy var tableView: UITableView = { [weak self] in
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.separatorStyle = .none
        tb.showsVerticalScrollIndicator = false
        tb.dataSource = self
        tb.delegate = self
        return tb
        }()

    override func setupView() {
        addSubview(tableView)
        tableView.fill(toView: self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(C.self, forCellReuseIdentifier: cellId)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! C
        cell.data = datasource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return rowHeight }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
    }
    func didSelectRow(at indexPath: IndexPath) { }
}
