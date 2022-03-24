//
//  Verification.swift
//  TranslateMVC
//
//  Created by 최대식 on 2022/03/21.
//

import Foundation
import UIKit

class Verification {
    static func urlFormat(urlString: String) -> String {
        if self.verifyUrl(urlString: urlString) {
            return urlString
        } else {
            if urlString.contains("www.") || urlString.contains(".com") || urlString.contains(".net"){
                let newString = "https://" + urlString
                if self.verifyUrl(urlString: newString) {
                    return newString
                }
            }
            if URL(string: "http://www.google.com/search?q=" + urlString) == nil {
                if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    return "http://www.google.com/search?q=" + encodedString
                    // 구글 쿼리에 영어가 아닌 글자가 들어가면 (ex, 한글) 인코딩을 해줘야함.
                    // 안 그럴 경우, URL이 nil값을 리턴함.
                }
            }
            return "http://www.google.com/search?q=" + urlString
        }
    }
    
    static func verifyUrl(urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}
