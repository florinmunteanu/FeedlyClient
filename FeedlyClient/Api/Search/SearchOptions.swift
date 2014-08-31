
import Foundation

class SearchOptions
{
    init(query: String) {
        self.query = query
    }
    
    var query: String
    
    var numberOfResults: Int?
    
    var locale: String?
    
    var accessToken: String?
}