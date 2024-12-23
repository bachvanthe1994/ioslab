//
//  ViewController.swift
//  lab10
//
//  Created by thebv on 11/10/2024.
//

import UIKit
import Darwin

actor DataManagerActor {
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

class ViewControllerWithActor: UIViewController {
    
    let dataManager = DataManagerActor() // Khởi tạo DataManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hàm call api để lấy dữ liệu (thực hiện trong background và update dữ liệu vào cùng 1 Object)
        func callApiInBackground(reuqestId: String) async throws {
            let url = URL(string: "https://bachvanthe1994.github.io/demo/learning/demovpb/vpbmenu.json")!
            // Gọi API và phân tích cú pháp dữ liệu JSON
            if #available(iOS 15.0, *) {
                let (data, _) = try await URLSession.shared.data(from: url)
                await self.dataManager.addUser("\(reuqestId)-\(data)")
            } else {
                // Fallback on earlier versions
            }
        }
        
        //Tạo nhiều request để call API
        if #available(iOS 13.0, *) {
            Task {
                for i in 0..<1000000 {
                    do {
                        try await callApiInBackground(reuqestId: "requestId[\(i)]")
                    } catch {
                        print("error: \(error)")
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 13.0, *) {
            Task {
                for i in 0..<1000000 {
                    let datas = await self.dataManager.getDatas()
                    print("datas: queryId: \(i): \(datas.count)")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

