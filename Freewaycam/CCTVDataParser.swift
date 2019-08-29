import Foundation

class CCTVDataParser: NSObject {
    
    enum DataType {
        case info
        case value
        
        var url: URL {
            self == .info ?
                URL(string: "http://tisvcloud.freeway.gov.tw/cctv_info.xml.gz")! :
                URL(string: "http://tisvcloud.freeway.gov.tw/cctv_value.xml.gz")!
        }
    }
    
    private var dataType: DataType!
    private var parser: XMLParser!
    private var cctvDataDicts: [[String: String]]?
    
    init(type: DataType, data: Data) {
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
        cctvDataDicts = nil
        parser.parse()
        return cctvDataDicts
    }
    
}

extension CCTVDataParser: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        cctvDataDicts = []
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
            cctvDataDicts?.append(attributeDict)
            
        default:
            break
        }
    }
    
}
