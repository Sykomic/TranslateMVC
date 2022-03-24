//
//  BookmarkCell.swift
//  TranslateMVC
//
//  Created by 최대식 on 2022/03/19.
//

import Foundation
import UIKit

class BookmarkCell: UICollectionViewCell {
    var icon: UIImageView!
    var title: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
//    func configureWithItem(item: Bookmark) { // Bookmark가 모델이니깐 얘네 둘이 연결?하면 안되지 않나...
////        self.icon.image = UIImage(
////        self.icon.title.text = item.title
//    }
    
    func setupUIElements() {
        self.setupTitle()
        self.setupIcon()
    }
    
    func setupIcon() {
        self.icon = UIImageView()
//        self.icon.backgroundColor = .gray
        self.icon.image = UIImage(systemName: "book.fill")
        self.icon.layer.cornerRadius = 10
        self.icon.contentMode = .scaleAspectFit
        self.icon.clipsToBounds = true
        self.icon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(icon)
    }
 
    func setupTitle() {
        self.title = UILabel()
        self.title.text = "Title"
        self.title.textColor = .white
        self.title.textAlignment = .center
        self.title.font = .boldSystemFont(ofSize: 13)
        self.title.contentMode = .scaleAspectFit
        self.title.clipsToBounds = true
        self.title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
    }
    
    func layout() {
        self.layoutTitle()
        self.layoutIcon()
        
        contentView.layoutIfNeeded()
    }
    
    func layoutIcon() {
        self.icon.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        self.icon.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6).isActive = true
        self.icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        self.icon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    func layoutTitle() {
        self.title.topAnchor.constraint(equalTo: self.icon.bottomAnchor).isActive = true
        self.title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUIElements()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
