//
//  GrandCentralDispatchViewController.swift
//  lab10
//
//  Created by thebv on 18/10/2024.
//

import UIKit

class GrandCentralDispatchViewController: UIViewController {
    
    deinit {
        self.item?.cancel()
        print("deinit \(self)")
    }
    
    var item: DispatchWorkItem?
    var dispatch: DispatchQueue?
    var dateFormatterGet = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SS"
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vd3()
//        self.vd4()
    }
    
    func vd1() {
        self.item = DispatchWorkItem(block: { [weak self] in
            if (self?.item?.isCancelled == true) {
                return
            }
            for i in 0..<5000 {
                print("self?.item?.isCancelled: \(String(describing: self?.item?.isCancelled))")
                print("self: \(String(describing: self))")
                if (self?.item?.isCancelled == true || self == nil) {
                    return
                }
                print("datas: queryId: \(i)")
                Thread.sleep(forTimeInterval: 1)
//                let vc = UIViewController()
//                vc.view.clipsToBounds = true
//                vc.view.backgroundColor = .red
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
        if let item = self.item {
            DispatchQueue.global(qos: .background).async(execute: item)
        }
    }
    
    func vd2() {
        DispatchQueue.global(qos: .background).async {
            //tương tác với UI không được do đoạn code dưới đây chưa chạy được
            DispatchQueue.main.async {
                for i in 0..<5000 {
                    print("datas: queryId: \(i)")
                    Thread.sleep(forTimeInterval: 1)
                }
            }
            print("aaaaaa")
            DispatchQueue.main.async {
                for i in 1000..<5000 {
                    print("datas: queryId: \(i)")
                    Thread.sleep(forTimeInterval: 1)
                }
            }
            print("bbbbbb")
        }
    }
    
    func vd3() {
        //tạo dispatch riêng để quản lý
        dispatch = DispatchQueue(
            label: "com.lab10.concurrent",
//            qos: .background, //chỉnh sửa qos của nó
            attributes: .concurrent
        )
        print("datas: A")
        dispatch?.async { [weak self] in
            for i in 0..<5 {
                if (self == nil) {return}
                print("datas: queryId: \(i)")
                Thread.sleep(forTimeInterval: 1)
            }
//            let vc = UIViewController()
//            vc.view.clipsToBounds = true
//            vc.view.backgroundColor = .red
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        print("datas: B")
        dispatch?.async { [weak self] in
            for i in 10..<15 {
                if (self == nil) {return}
                print("datas: queryId: \(i)")
                Thread.sleep(forTimeInterval: 1)
            }
        }
        print("datas: C")
//        dispatch?.async(flags: .barrier) { [weak self] in
//            if (self == nil) {return}
//            for i in 2000..<20010 {
//                if (self == nil) {return}
//                print("datas: barrier: \(i)")
//                Thread.sleep(forTimeInterval: 1)
//            }
//        }
//        dispatch?.async { [weak self] in
//            for i in 2000..<2001 {
//                if (self == nil) {return}
//                print("datas: queryId: \(i)")
//                Thread.sleep(forTimeInterval: 1)
//            }
//        }
    }
    
    func vd4() {
        let btn = UIButton.init(frame: .init(x: 100, y: 100, width: 100, height: 30))
        btn.setTitle("Click me", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.clickMe)))
        self.view.addSubview(btn)
    }
    
    @objc func clickMe() {
        var date1 = Date()
        print("date: \(self.dateFormatterGet.string(from: date1))")
        //đổi giá trị .background và .userInteractive để kiểm tra tốc độ xử lý task
        DispatchQueue(label: "com.lab10", qos: .background).async {
            for i in 0..<1000 {
                
            }
            DispatchQueue.main.async {
                let date2 = Date()
                print("done: \(self.dateFormatterGet.string(from: date2)) ---- \(date2.timeIntervalSince1970 - date1.timeIntervalSince1970)")
            }
        }
    }
}
