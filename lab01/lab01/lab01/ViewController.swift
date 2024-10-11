//
//  ViewController.swift
//  lab01
//
//  Created by thebv on 09/10/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func openScreenSecond(type: CustomDrawingType) {
        let vc = SecondViewController.init(nibName: "SecondViewController", bundle: Bundle.main)
        vc.type = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCirclePressed(_ sender: Any) {
        self.openScreenSecond(type: .circle)
    }
    
    @IBAction func btnRectanglePressed(_ sender: Any) {
        self.openScreenSecond(type: .rectangle)
    }
    

}

