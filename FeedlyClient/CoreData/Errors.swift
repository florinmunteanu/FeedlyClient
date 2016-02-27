
import Foundation

enum EntryError: ErrorType {
    case NotFound(entryId: String)
    case DuplicateFound(entryId: String)
}