//
//  ViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if UserDefaults.standard.string(forKey: "access") != nil {
      navigationController?.setViewControllers([MainViewController()], animated: false)
    } else {
      navigationController?.setViewControllers([StartViewController()], animated: false)
    }
      
    
    
    // Do any additional setup after loading the view.
  }


}

