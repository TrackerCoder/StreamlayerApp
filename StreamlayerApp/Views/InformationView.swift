//
//  InformationView.swift
//  StreamlayerApp
//
//  Created by Tracker on 01.06.2020.
//

import Foundation
import UIKit
import SnapKit

class InformationView: UIView {
    
    public var shareDidTapped: (() -> Void)?
    
    private var shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "shareIcon"), for: .normal)
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    @objc private func share() {
        shareDidTapped?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupLayout() {
        backgroundColor = .black
        addSubview(titleLabel)
        addSubview(shareButton)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
        }

        shareButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.width.height.equalTo(23)
            $0.centerY.equalToSuperview()
        }
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
}
