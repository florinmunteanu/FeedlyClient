
import Foundation

class CssRules {
    internal class func createFontScript(fontFamily: String, fontSizeInPixels: String) -> String {
        var js = ""
        
        js += " var st = document.getElementsByTagName('style')[0];"
        js += " st.textContent = '"
        js += " * { font-family: \(fontFamily) ; font-size: \(fontSizeInPixels)px }"
        js += " ';"
        
        return createStyleElementIfNotExists() + js
    }
    
    private class func createStyleElementIfNotExists() -> String {
        var js = ""
        
        js += "var styleElements = document.getElementsByTagName('style');"
        
        js += "if (styleElements.length == 0) {"
        js += "   var s = document.createElement('style');"
        js += "   document.documentElement.appendChild(s);"
        js += "}"
        js += "\n"
        
        return js
    }
}