//
//  File.swift
//  
//
//  Created by Mongy on 30/06/2023.
//

import Fluent
import Vapor

final class User: Model {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String
    
    @Children(for: \.$user)
    var acronyms: [Acronym]
    
    @Field(key: "username")
    var username: String

    init() { }

    init(
        id: UUID? = nil,
        name: String,
        userName: String
    ) {
        self.id = id
        self.name = name
        self.username = userName
    }
}

extension User: Content {}
