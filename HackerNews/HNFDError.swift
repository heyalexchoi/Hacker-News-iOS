//
//  Public.swift
//  HackerNews
//
//  Created by Alex Choi on 8/14/15.
//  Copyright (c) 2015 Alex Choi. All rights reserved.
//

enum HNFDError: Error {
    
    static let messagesKey = "messages"
    static let hnfdDomain = "hnfd"
    
    case external(underlying: NSError)
    case unableToCreateReachability
    case storyHasNoArticleURL
    
    var description: String {
        switch self {
        case .storyHasNoArticleURL:
            return "Story has no article URL"
        case .unableToCreateReachability:
            return "Unable to determine network connection (unable to create Reachability)"
        case .external(let underlying):
            return underlying.localizedDescription
        }
    }
    
    var code: Int {
        switch self {
        case .external(let underlying):
            return underlying.code
        default:
            return 420
        }
    }
    
    var domain: String {
        switch self {
        default:
            return HNFDError.hnfdDomain
        }
    }
    
    var error: NSError {
        return NSError(domain: domain,
                       code: code,
                       userInfo: [NSLocalizedDescriptionKey: description])
    }    
}