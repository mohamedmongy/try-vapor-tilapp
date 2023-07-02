import Fluent
import Vapor

func routes(_ app: Application) throws {
    let acronymsCon = AcronymController()
    try app.register(collection: acronymsCon)
    
    let userCon = UserController()
    try app.register(collection: userCon)
    
    let catCon = CategoryController()
    try app.register(collection: catCon)
    
    let webCon = WebsiteController()
    try app.register(collection: webCon)
}
