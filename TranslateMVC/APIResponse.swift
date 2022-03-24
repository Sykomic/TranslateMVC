//
//  APIResponse.swift
//  TranslateMVC
//
//  Created by 최대식 on 2022/03/19.
//

import Foundation

struct APIResponse: Codable {
    let message: Message?
    let errorMessage: String?
}

struct Message: Codable {
    let result: Result
}

struct Result: Codable {
    let sourceLanguage: String
    let targetLanguage: String
    let translatedText: String

    enum CodingKeys: String, CodingKey {
        case translatedText
        case targetLanguage = "tarLangType"
        case sourceLanguage = "srcLangType"
    }
}
