//
//  Bookmark.swift
//  TranslateMVC
//
//  Created by 최대식 on 2022/03/19.
//

import Foundation
import RealmSwift

class Bookmark: Object {
    @Persisted var title: String
    @Persisted var urlString: String
    @Persisted var iconUrlString: String
    
    convenience init(title: String, urlString: String, iconUrlString: String) {
        self.init()
        self.title = title
        self.urlString = urlString
        self.iconUrlString = iconUrlString
    }
}
