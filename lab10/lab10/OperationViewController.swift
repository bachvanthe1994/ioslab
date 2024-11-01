//
//  OperationViewController.swift
//  lab10
//
//  Created by thebv on 20/10/2024.
//

import UIKit

class CustomOperation: BlockOperation {
//    override func main() {
//        if isCancelled {
//            print("isCancelled: \(isCancelled)")
//            return
//        }
//        for i in 0..<1000 {
//            print("i: \(i)")
//        }
//    }
}

class OperationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vd10()
    }
    
    func vd10() {
        var ob1: BlockOperation?
        ob1 = BlockOperation {
            print("Task 1 do")
            for i in 0..<10000000000 {
                if (ob1?.isCancelled == true) {
                    print("ob1?.isCancelled == true")
                    return;
                }
            }
            print("Task 1 done")
        }
        let ob2 = BlockOperation {
            print("Task 2")
        }
        ob2.addExecutionBlock {
            print("Task 2. block addExecutionBlock")
        }
        ob2.addDependency(ob1.unsafelyUnwrapped)
        let queue = OperationQueue()
        print("------ a")
        queue.addOperations([ob1.unsafelyUnwrapped], waitUntilFinished: true)
        print("------ b")
        queue.addOperation(ob2)
        print("------ c")
        let ob3 = CustomOperation {
            print("Task 3 task")
        }
        ob3.addExecutionBlock {
            print("Task 3 addExecutionBlock")
        }
        print("Task 3 blocks: \(ob3.executionBlocks.count)")
        queue.addOperation(ob3)
        
        ob1?.cancel()
    }

}
