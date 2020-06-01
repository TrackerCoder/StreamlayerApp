//
//  StreamListViewController.swift
//  StreamlayerApp
//
//  Created by Tracker on 01.06.2020.
//

import Foundation
import UIKit
import SnapKit

class StreamListViewController: UIViewController {
    
    private let tableView = UITableView()
    
    public var streamDidSelect: ((VideoData) -> Void)?

    private var data: [VideoData] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "darkGray")
        tableView.register(StreamListTableViewCell.self, forCellReuseIdentifier: StreamListTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        setupLayout()
    }
    
    func setupLayout() {
        view.insertSubview(tableView, at: 0)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }
    
    func reload(data: [VideoData]) {
        self.data = data
    }
    
}

extension StreamListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StreamListTableViewCell.identifier) as! StreamListTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! StreamListTableViewCell
        let index = indexPath.row
        let video = data[index]
        cell.isLast = data.count - 1 == index
        cell.fill(with: video)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let video = data[index]
        streamDidSelect?(video)
    }
}
