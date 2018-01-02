//
//  IBExtensions.swift
//  SwiftyIBExample
//
//  Created by Paul Fechner on 1/1/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//

import Foundation

extension ViewController {
    struct Scenes {
        struct MainVCScene {
            static var identifier: SceneIdentifier { return SceneIdentifier.MainVCScene }
        }
    }
    
    
    static var Scenes = [SceneIdentifier.MainVCScene, SceneIdentifier.EmbededVC]
    
}


struct SceneRepresentation {
    let identifier:SceneIdentifier
}
