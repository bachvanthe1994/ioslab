//
//  ViewController.swift
//  lab10
//
//  Created by thebv on 11/10/2024.
//

import UIKit

class DataManagerCrash {
    private var datas: [String] = []
    
    func addUser(_ data: String) {
        datas.append(data)
        print("data: \(data)")
    }
    
    func removeData(_ data: String) {
        if let index = datas.firstIndex(of: data) {
            datas.remove(at: index)
        }
    }
    
    func getDatas() -> [String] {
        return datas
    }
}

class ViewControllerCrash: UIViewController {
    
    let dataManager = DataManagerCrash() // Khởi tạo DataManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hàm call api để lấy dữ liệu (thực hiện trong background và update dữ liệu vào cùng 1 Object)
        func callApiInBackground(reuqestId: String) async throws {
            let url = URL(string: "https://bachvanthe1994.github.io/demo/learning/demovpb/vpbmenu.json")!
            // Gọi API và phân tích cú pháp dữ liệu JSON
            let (data, _) = try await URLSession.shared.data(from: url)
            self.dataManager.addUser("\(reuqestId)-\(data)")
        }
        
        //Tạo nhiều request để call API
        Task {
            for i in 0..<1000000 {
                do {
                    try await callApiInBackground(reuqestId: "requestId[\(i)]")
                } catch {
                    print("error: \(error)")
                }
            }
        }
        
        DispatchQueue.global().async {
            for i in 0..<1000000 {
                let datas = self.dataManager.getDatas()
                print("datas: queryId: \(i): \(datas.count)")
            }
        }
    }
}

