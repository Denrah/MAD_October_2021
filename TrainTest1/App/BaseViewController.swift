//
//  BaseViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import SnapKit
import MBProgressHUD

class BaseViewController: UIViewController {
  
  let network = Network()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      view.backgroundColor = .dark1
      navigationController?.navigationBar.tintColor = .white
      
      network.onRefreshFailed = { [weak self] in
        self?.navigationController?.setViewControllers([StartViewController(), SignInViewController()], animated: true)
      }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
  func showAlert(text: String) {
    let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
  
  func showProgress() {
    MBProgressHUD.showAdded(to: navigationController?.view ?? view, animated: true)
  }
  
  func hideProgress() {
    MBProgressHUD.hide(for: navigationController?.view ?? view, animated: true)
  }

}
