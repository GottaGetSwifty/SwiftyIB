//
//  TestNibStuff.swift
//  SwiftyIBExample
//
//  Created by Paul Fechner on 9/4/18.
//  Copyright © 2018 peejweej.inc. All rights reserved.
//
import UIKit

//protocol IBNibCreateable  {
//    static var nibName: String { get }
//}
//
//extension IBNibCreateable where Self: AnyObject {
//    
//    static func makeNib(bundle: Bundle) -> UINib {
//        return UINib(nibName: nibName, bundle: bundle)
//    }
//    
//    static func makeNib() -> UINib {
//        return makeNib(bundle: Bundle(for: self))
//    }
//}
//
//protocol IBNibIdentifiable: IBNibCreateable {
//    static var nibIdentifier: NibIdentifier { get }
//}
//
//extension IBNibIdentifiable {
//    static var nibName: String {
//        return nibIdentifier.rawValue
//    }
//}
//
//protocol IBReusable {
//    static var generatedReuseIdentifier: String { get }
//}
//
//protocol IBReusableIdentifiable: IBReusable {
//    static var IBReuseIdentifier: ReuseIdentifier { get }
//}
//
//extension IBReusableIdentifiable {
//    static var reuseIdentifier: String { 
//        return IBReuseIdentifier.rawValue
//    }
//}
//
//
//protocol NibReusable: IBNibCreateable & IBReusable { }
//
//
//extension UITableView {
//    
//    final func register<T: UITableViewCell>(cellType: T.Type) where T: NibReusable {
//        self.register(T.makeNib(), forCellReuseIdentifier: T.generatedReuseIdentifier)
//    }
//    
//    final func register<T: UITableViewHeaderFooterView>(viewType: T.Type) where T: NibReusable {
//        self.register(T.makeNib(), forHeaderFooterViewReuseIdentifier: T.generatedReuseIdentifier)
//    }
//    
//    final func register<T: UITableViewCell>(cellType: T.Type) where T: IBReusable {
//        self.register(T.self, forCellReuseIdentifier: T.generatedReuseIdentifier)
//    }
//    
//    final func register<T: UITableViewHeaderFooterView>(viewType: T.Type) where T: IBReusable {
//        self.register(T.self, forHeaderFooterViewReuseIdentifier: T.generatedReuseIdentifier)
//    }
//}
//
//extension UICollectionView {
//    
//    final func register<T: UICollectionViewCell>(cellType: T.Type) where T: NibReusable {
//        self.register(T.makeNib(), forCellWithReuseIdentifier: T.generatedReuseIdentifier)
//    }
//    
//    final func register<T: UICollectionReusableView>(viewType: T.Type, forSupplementaryViewOfKind kindOfView: String) where T: NibReusable {
//        self.register(T.makeNib(), forSupplementaryViewOfKind: kindOfView, withReuseIdentifier: T.generatedReuseIdentifier)
//    }
//    
//    final func register<T: UICollectionViewCell>(cellType: T.Type) where T: IBReusable {
//        self.register(T.self, forCellWithReuseIdentifier: T.generatedReuseIdentifier)
//    }
//    
//    final func register<T: UICollectionReusableView>(viewType: T.Type, forSupplementaryViewOfKind kindOfView: String) where T: IBReusable {
//        self.register(T.self, forSupplementaryViewOfKind: kindOfView, withReuseIdentifier: T.generatedReuseIdentifier)
//    }
//}


