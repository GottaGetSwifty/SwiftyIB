/// Automatically generated from SwiftyIB

extension CollectionReusableView: IBReusableIdentifiable {
    static var ibReuseIdentifier: ReuseIdentifier { 
        return .CollectionReusableView
    }
}

extension TableViewCell: IBReusableIdentifiable {
    static var ibReuseIdentifier: ReuseIdentifier { 
        return .TableViewCell
    }
}

extension CollectionViewCell: IBReusableIdentifiable {
    static var ibReuseIdentifier: ReuseIdentifier { 
        return .CollectionViewCell
    }
}
extension CollectionReusableView: NibReusable {}
extension TableViewCell: NibReusable {}
extension CollectionViewCell: NibReusable {}