//
//  ViewController.swift
//  lab12
//
//  Created by thebv on 31/10/2024.
//

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testDecode()
    }
    
    func testDecode() {
//        let json = """
//[
//    {
//        "key1": "value1",
//        "key2": "value2",
//        "data": {
//            "data_key1": "data_value1",
//            "data_key2": {
//                "key3": "value3",
//            }
//        }
//    },
//    {
//        "key1": "value1",
//        "key2": "value2",
//        "data": {
//            "data_key1": "data_value1",
//            "data_key2": {
//                "key3": "value3",
//            }
//        }
//    }
//]
//"""
//        let data = json.data(using: .utf8)
        let data: Any? = nil
//        [
//            [
//                "key1": "value1",
//            ]
//        ]
        let result = self.decodeJSON(from: data, to: [ObjectModel].self)
        print("result: \(result?[0].key1 ?? "nil")")
    }
    
    func testJson() {
        let json = """
{
    "key": "value",
    "key2": "value2",
    "data": {
        "obj1": "value1",
        "obj2": {
            "key3": "value3",
        }
    }
}
""".data(using: .utf8)
        
        let model = JSON(json)
        print("model: \(model["key2"])")
        let a = model.rawString([.maxObjextDepth: 1])
        print("model: \(a)")
    }


}
