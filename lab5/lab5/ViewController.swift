//
//  ViewController.swift
//  lab5
//
//  Created by thebv on 11/10/2024.
//

import UIKit

class ViewController: UIViewController, DualThumbSliderDelegate {
    

    @IBOutlet weak var vContent: UIView!
    var lbl: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slider = DualThumbSlider.init(frame: .init(x: 10, y: 10, width: UIScreen.main.bounds.width-20*2-10*2, height: 30))
        slider.delegate = self
        self.vContent.addSubview(slider)
        let lbl = UILabel.init(frame: .init(x: 10, y: 50, width: UIScreen.main.bounds.width-20*2-10*2, height: 30))
        self.vContent.addSubview(lbl)
        self.lbl = lbl
        
        slider.layoutSubviews()
    }
    
    func sliderValueChanged(minValue: Int, maxValue: Int) {
        self.lbl?.text = "minValue: \(minValue), maxValue: \(maxValue)"
    }

}

