//
//  SectionHeader.swift
//  TranslateMVC
//
//  Created by 최대식 on 2022/03/19.
//

import Foundation
import UIKit

class SectionHeader: UICollectionReusableView {
    var title: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func setupTitle() {
        self.title = UILabel()
        self.title.textColor = .white
        self.title.font = .boldSystemFont(ofSize: 20)
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(title)
    }
    
    func layoutTitle() {
        title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupTitle()
        self.layoutTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
