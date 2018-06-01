//
//  SecondViewController.swift
//  SwiftyIBExample
//
//  Created by Paul Fechner on 6/1/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func test() {
    
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.getSegueIdentifier() {
        case .GoToDetail: //do what you gotta do
        default: break
        }
    }
    

}
