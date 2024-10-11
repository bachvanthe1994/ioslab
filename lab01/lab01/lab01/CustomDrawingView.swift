//
//  CustomDrawingView.swift
//  lab01
//
//  Created by thebv on 09/10/2024.
//

import UIKit

class CustomDrawingView: UIView {
    
    private var drawType: CustomDrawingType = .circle
    private var drawWidth: Int = 50
    private var drawHeight: Int = 50
    private var drawColor: UIColor = .red
    
    func config(drawType: CustomDrawingType, drawWidth: Int, drawHeight: Int, drawColor: UIColor) {
        self.drawType = drawType
        self.drawWidth = drawWidth
        self.drawHeight = drawHeight
        self.drawColor = drawColor
        self.drawCustomViewIfNeed()
    }
    
    override func draw(_ rect: CGRect) {
        self.drawCustomViewIfNeed()
    }
    
    private func drawCustomViewIfNeed() {
        layer.sublayers?.forEach({ l in
            l.removeFromSuperlayer()
        })
        var path: UIBezierPath?
        let size: CGRect = .init(x: 100, y: 100, width: self.drawWidth, height: self.drawHeight)
        if (self.drawType == .circle) {
            path = UIBezierPath(ovalIn: size)
        } else {
            path = UIBezierPath(roundedRect: size, cornerRadius: 0)
        }
        if let path = path {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = drawColor.cgColor
            layer.addSublayer(shapeLayer)
        }
    }
}
