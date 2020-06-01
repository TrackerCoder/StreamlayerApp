//
//  StreamCell.swift
//  StreamlayerApp
//
//  Created by Tracker on 27.05.2020.
//  Copyright © 2020 Tracker. All rights reserved.
//

import Foundation
import UIKit

class StreamListTableViewCell: UITableViewCell {
    
    static let identifier = "StreamListTableViewCell"
    
    var isLast: Bool = false {
        didSet {
            seporatorView.isHidden = isLast
        }
    }
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "gray")
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 13
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    var seporatorView: DashedLineView = {
        return DashedLineView()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(previewImageView)
        
        let margin = layoutMarginsGuide
        
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        previewImageView.leftAnchor.constraint(equalTo: margin.leftAnchor, constant: 0).isActive = true
        previewImageView.topAnchor.constraint(equalTo: margin.topAnchor, constant: 10).isActive = true
        previewImageView.bottomAnchor.constraint(equalTo: margin.bottomAnchor, constant: -10).isActive = true
        previewImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 220.0/590).isActive = true
        previewImageView.heightAnchor.constraint(equalTo: previewImageView.widthAnchor, multiplier: 70.0/125).isActive = true
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: previewImageView.topAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 16).isActive = true
        
        addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14).isActive = true
        
        addSubview(seporatorView)
        seporatorView.translatesAutoresizingMaskIntoConstraints = false
        seporatorView.leftAnchor.constraint(equalTo: margin.leftAnchor).isActive = true
        seporatorView.rightAnchor.constraint(equalTo: margin.rightAnchor).isActive = true
        seporatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seporatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    func fill(with video: VideoData) {
        titleLabel.text = video.title
        timeLabel.text = video.duration
    }
    
}
