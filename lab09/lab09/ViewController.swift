//
//  ViewController.swift
//  lab09
//
//  Created by thebv on 12/10/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    let keychain = Lab09Keychain.init(service: "com.thebv.lab09", encryptionKey: "12345678901234567890123456789012")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillDataFromCache()
    }
    
    func fillDataFromCache() {
        self.tfUserName.text = keychain.get(key: "tfUserName")
        self.tfPassword.text = keychain.get(key: "tfPassword")
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func btnDeleteKeychainDataPressed(_ sender: Any) {
        self.keychain.delete(key: "tfUserName")
        self.keychain.delete(key: "tfPassword")
    }
    
    
    @IBAction func btnLoginPressed(_ sender: Any) {
        let username = self.tfUserName.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let password = self.tfPassword.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if (username == "test1" && password == "12345678") {
            
            //save data
            let status1 = keychain.set(key: "tfUserName", value: username)
            print("status1: \(status1)")
            let status2 = keychain.set(key: "tfPassword", value: password)
            print("status2: \(status2)")
            //------
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            self.showAlert(title: "Thông báo", message: "Thông tin đăng nhập không đúng. Quý khách vui lòng thử lại")
        }
    }
    
}

