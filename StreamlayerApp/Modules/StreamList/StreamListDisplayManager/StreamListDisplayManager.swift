//
//  StreamListDisplayManager.swift
//  StreamlayerApp
//
//  Created by Tracker on 27.05.2020.
//  Copyright © 2020 Tracker. All rights reserved.
//

import Foundation
import UIKit

class StreamListDisplayManager: NSObject {
    
    var tableView: UITableView
    
    weak var delegate: StreamListDisplayManagerDelegate?
        
    private var data: [VideoData] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "darkGray")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StreamTableViewCell.self, forCellReuseIdentifier: StreamTableViewCell.identifier)
    }
    
    func reload(data: [VideoData]) {
        self.data = data
    }
    
}

extension StreamListDisplayManager: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StreamTableViewCell.identifier) as! StreamTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! StreamTableViewCell
        let index = indexPath.row
        let video = data[index]
        cell.isLast = data.count - 1 == index
        cell.fill(with: video)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let video = data[index]
        delegate?.tableView(didSelect: video)
    }
}
