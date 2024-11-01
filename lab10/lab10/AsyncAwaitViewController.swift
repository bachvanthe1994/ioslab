//
//  AsyncAwaitViewController.swift
//  lab10
//
//  Created by thebv on 18/10/2024.
//

import UIKit

@available(iOS 13.0, *)
class AsyncAwaitViewController: UIViewController {

    let dataManager = DataManagerActor() // Khởi tạo DataManager
    private var task1: Task<Void, Never>? // Khai báo task
    private var task2: Task<Void, Never>? // Khai báo task
    
    deinit {
        print("deinit: \(self)")
        self.task1?.cancel()
        self.task2?.cancel()
    }
    
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
            self.task1 = Task { [weak self] in
                guard let self = self else { return }
                for i in 0..<5000 {
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
            self.task2 = Task { [weak self] in
                guard let self = self else { return }
                for i in 0..<5000 {
                    let datas = await self.dataManager.getDatas()
                    print("datas: queryId: \(i): \(datas.count)")
                    
//                    let vc = UIViewController()
//                    vc.view.clipsToBounds = true
//                    vc.view.backgroundColor = .red
//                    self.navigationController?.pushViewController(vc, animated: true)

                }
            }
        } else {
            // Fallback on earlier versions
        }
        
    }

}
