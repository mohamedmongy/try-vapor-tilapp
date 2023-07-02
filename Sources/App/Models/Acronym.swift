import Fluent
import Vapor

final class Acronym: Model {
    static let schema = "acronyms"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @Field(key: "short")
    var short: String
    
    @Field(key: "long")
    var long: String
    
    @Siblings(through: AcronymCategory.self, from: \.$acronym, to: \.$category)
    var categories: [Category]
    
    init() { }

    init(
        id: UUID? = nil,
        short: String,
        long: String,
        userID: UUID
    ) {
        self.id = id
        self.short = short
        self.long = long
        self.$user.id = userID
    }
}

extension Acronym: Content {}
