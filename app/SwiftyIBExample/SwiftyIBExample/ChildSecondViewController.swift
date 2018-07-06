//
//  SecondViewController.swift
//  SwiftyIBExample
//
//  Created by Paul Fechner on 6/1/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//

import UIKit

class ChildSecondViewController: SecondViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // Easily get the segue identifier in prepare(for segue:)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.getSegueIdentifier() {
        case .GoToDetail: break//do what you gotta do
        default: break
        }
    }

}
