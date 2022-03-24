//
//  BookmarkDB.swift
//  TranslateMVC
//
//  Created by 최대식 on 2022/03/20.
//

import Foundation
import RealmSwift

class BookmarkDB {
    let localRealm = try? Realm()
    static var shared = BookmarkDB()
    
    func requestData() -> Results<Bookmark>? {
        return self.localRealm?.objects(Bookmark.self)
    }
    
    func updataData(data: Bookmark) {
        print("update")
        let duplicated = self.localRealm?.objects(Bookmark.self).where {
            $0.urlString == data.urlString
        }
        
        do {
            try self.localRealm?.write({
                if duplicated != nil {
                    print("duplicated")
                    self.localRealm?.delete(duplicated!)
                }
                print("not duplicated")
                self.localRealm?.add(data)
            })
        } catch {
            print(error)
        }
    }
    
    func deleteData(data: Bookmark) {
        try? self.localRealm?.write({
            self.localRealm?.delete(data)
        })
    }
}
