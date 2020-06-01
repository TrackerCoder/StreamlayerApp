//
//  StreamListDisplayManagerDelegate.swift
//  StreamlayerApp
//
//  Created by Tracker on 30.05.2020.
//

import Foundation

protocol StreamListDisplayManagerDelegate: class {
    func tableView(didSelect video: VideoData)
}
