//
//  SecondViewController.swift
//  lab01
//
//  Created by thebv on 09/10/2024.
//

import UIKit
import FlexColorPicker

enum CustomDrawingType {
    case circle
    case rectangle
}

class SecondViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var tfWidth: UITextField!
    @IBOutlet weak var tfHeight: UITextField!
    @IBOutlet weak var vColor: UIView!
    
    private let vCustom = CustomDrawingView.init(frame: .init(x: 0, y: 0, width: caScreenWidth(), height: 200))
    public var type: CustomDrawingType = .circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vColor.backgroundColor = .green
        self.initView()
    }
    
    private func initView() {
        let width = Int(self.tfWidth.text ?? "50") ?? 50
        let height = Int(self.tfHeight.text ?? "50") ?? 50
        self.vCustom.config(
            drawType: self.type,
            drawWidth: width,
            drawHeight: height,
            drawColor: vColor.backgroundColor ?? .green
        )
        if (self.vCustom.superview == nil) {
            self.vCustom.layer.borderWidth = 1
            self.vCustom.layer.borderColor = UIColor.green.cgColor
            self.vContent.addSubview(self.vCustom)
        }
    }
    
    @IBAction func btnPickColorPressed(_ sender: Any) {
        let colorPickerController = DefaultColorPickerViewController()
        colorPickerController.delegate = self
        navigationController?.pushViewController(colorPickerController, animated: true)
    }
    
    @IBAction func btnSubmitConfigPressed(_ sender: Any) {
        self.initView()
    }
    
}

extension SecondViewController: ColorPickerDelegate {
    func colorPicker(_ colorPicker: FlexColorPicker.ColorPickerController, selectedColor: UIColor, usingControl: FlexColorPicker.ColorControl) {
        self.vColor.backgroundColor = selectedColor
    }
    
    func colorPicker(_ colorPicker: FlexColorPicker.ColorPickerController, confirmedColor: UIColor, usingControl: FlexColorPicker.ColorControl) {
        
    }
    
    
}
