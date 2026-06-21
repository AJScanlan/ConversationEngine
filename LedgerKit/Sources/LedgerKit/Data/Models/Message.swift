//
//  Message.swift
//  LedgerKit
//
//  Created by Alexander Scanlan on 27/06/2026.
//

public struct Message: Identifiable {
    public let id: String
    public let content: String
    
    public init(id: String, content: String) {
        self.id = id
        self.content = content
    }
}
