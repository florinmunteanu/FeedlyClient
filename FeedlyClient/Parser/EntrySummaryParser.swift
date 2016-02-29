
import Foundation

class EntrySummaryParser : NSObject, NSXMLParserDelegate  {
    
    private var parser: NSXMLParser
    
    private var summary: String = ""
    
    private var foundFirstParagraph: Bool = false
    
    init(summaryHtmlContent: String) {
        
        self.parser = NSXMLParser(data: summaryHtmlContent.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        super.init()
        
        self.parser.delegate = self
        self.parser.shouldResolveExternalEntities = false
    }
    
    func parse() -> String {
        self.parser.parse()
        return trimSummary(self.summary, maxLength: 200)
    }
    
    private func trimSummary(summary: String, maxLength: Int) -> String {
        var summaryCopy = summary
        if summary.characters.count > maxLength {
            summaryCopy = summary.substringToIndex(summary.startIndex.advancedBy(maxLength)) + "..."
        }
        
        return summaryCopy
    }
    
    // MARK: NSXMLParserDelegate
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "p" {
            // found the first paragraph tag (<p>)
            self.foundFirstParagraph = true
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if self.foundFirstParagraph && elementName == "p" {
            // found the end tag (</p>)
            self.parser.abortParsing()
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if self.foundFirstParagraph {
            self.summary += string
        }
    }
}