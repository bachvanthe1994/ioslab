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
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(self.drawColor.cgColor)
        let size: CGRect = .init(x: 100, y: 100, width: self.drawWidth, height: self.drawHeight)
        if (self.drawType == .circle) {
            context.fillEllipse(in: size)
        } else {
            context.fill(size)
        }
    }
}
