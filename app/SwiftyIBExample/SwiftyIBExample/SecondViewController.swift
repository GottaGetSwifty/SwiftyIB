//
//  SecondViewController.swift
//  SwiftyIBExample
//
//  Created by Paul Fechner on 6/1/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//

import UIKit
import SwiftyIB

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
    
        SecondViewController._Scene.storyboardIdentifier
        
        // works through an extension
        Scene.storyboardIdentifier
        
        // Doesn't work. Segues aren't usable from a static context
//        SecondViewController._Scene._Segues.GoToDetail
        
        // works
        Scene.Segues.GoToDetail
    }

    
    // Easily make the initial viewController for a storyboard
    let initialVC = StoryboardIdentifier.Main.makeStoryboard()?.instantiateInitialViewController()
    
    // Build ViewControllers programatically with no hassel.
    let secondViewController = SecondViewController._Scene.makeFromStoryboard()
    
    // Easily perform a segue WITH code completion! 
    func startDetailScreen() {
        Scene.Segues.GoToDetail.perform()
    }
    
    // Easily get the segue identifier in prepare(for segue:)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.getSegueIdentifier() {
        case .GoToDetail: break//do what you gotta do
        default: break
        }
    }

}
