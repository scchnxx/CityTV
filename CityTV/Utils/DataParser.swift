import Foundation

class DataParser: NSObject {
    
    enum ParserType {
        case cctvInfo
        case cctvValue
        case roadLevelInfo
        case roadLevelValue
        
        var url: URL {
            switch self {
            case .cctvInfo:       return URL(string: "http://tisvcloud.freeway.gov.tw/cctv_info.xml.gz")!
            case .cctvValue:      return URL(string: "http://tisvcloud.freeway.gov.tw/cctv_value.xml.gz")!
            case .roadLevelInfo:  return URL(string: "http://tisvcloud.freeway.gov.tw/roadlevel_info.xml.gz")!
            case .roadLevelValue: return URL(string: "http://tisvcloud.freeway.gov.tw/roadlevel_value.xml.gz")!
            }
        }
    }
    
    private var dataType: ParserType!
    private var parser: XMLParser!
    private var dataDicts: [[String: String]]?
    
    init(type: ParserType, data: Data) {
        super.init()
        dataType = type
        parser = XMLParser(data: data)
        parser.delegate = self
    }
    
    private func date(from string: String) -> Date? {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return fmt.date(from: string)
    }
    
    func parse() -> [[String: String]]? {
        dataDicts = nil
        parser.parse()
        return dataDicts
    }
    
}

extension DataParser: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        dataDicts = []
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:])
    {
        switch elementName {
        case "XML_Head":
            break
            
        case "Info":
            dataDicts?.append(attributeDict)
            
        default:
            break
        }
    }
    
}
