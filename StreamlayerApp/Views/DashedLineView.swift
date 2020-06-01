//
//  DashedLine.swift
//  StreamlayerApp
//
//  Created by Tracker on 28.05.2020.
//  Copyright © 2020 Tracker. All rights reserved.
//

import Foundation
import UIKit

class DashedLineView: UIView {
    
    private var shapeLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawDashedLine()
    }
    
    func drawDashedLine() {
        
        if shapeLayer == nil {
            initShapeLayer()
        }
        
        let path = CGMutablePath()
        let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
        let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func initShapeLayer() {
        shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.withAlphaComponent(0.8).cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4, 2]
    }
    
}
