import Foundation

fileprivate struct Key {
    static let updatetime = "updatetime"

    /// Keys for `DataType.Info`.
    struct Info {
        static let id = "cctvid"
        static let roadsection = "roadsection"
        static let locationpath = "locationpath"
        static let startlocationpoint = "startlocationpoint"
        static let endlocationpoint = "endlocationpoint"
        static let px = "px"
        static let py = "py"
    }

    /// Keys for `DataType.Value`.
    struct Value {
        static let id = "cctvid"
        static let url = "url"
        static let status = "status"
    }
}

extension CCTVData.Info {

    fileprivate init?(data: [String: String]) {
        guard let id = data[Key.Info.id], let roadsection = data[Key.Info.roadsection],
            let locationpathStr = data[Key.Info.locationpath], let locationpath = Int(locationpathStr),
            let startlocationpointStr = data[Key.Info.startlocationpoint], let startlocationpoint = Int(startlocationpointStr),
            let endlocationpointStr = data[Key.Info.endlocationpoint], let endlocationpoint = Int(endlocationpointStr),
            let pxStr = data[Key.Info.px], let px = Double(pxStr),
            let pyStr = data[Key.Info.py], let py = Double(pyStr) else { return nil }
        
        self.id = id
        self.roadsection = roadsection
        self.locationpath = locationpath
        self.startlocationpoint = startlocationpoint
        self.endlocationpoint = endlocationpoint
        self.px = CGFloat(px)
        self.py = CGFloat(py)
    }
    
}

extension CCTVData.Value {

    fileprivate init?(data: [String: String]) {
        guard let id = data[Key.Value.id],
            let urlStr = data[Key.Value.url], let url = URL(string: urlStr),
            let statusStr = data[Key.Value.status], let statusNum = Int(statusStr) else { return nil }
        
        self.id = id
        self.url = url
        self.status = (statusNum == 0)
    }
    
}

class CCTVDataParser: NSObject {
    
    private var dataType: CCTVData.DataType!
    private var parser: XMLParser!
    private var cctvData: CCTVData?
    
    init(type: CCTVData.DataType, data: Data) {
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
    
    func parse() -> CCTVData? {
        cctvData = nil
        parser.parse()
        return cctvData
    }
    
}

extension CCTVDataParser: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        switch dataType! {
        case .info:  cctvData = CCTVData(dataType: dataType, updatetime: nil, infos: [], values: nil)
        case .value: cctvData = CCTVData(dataType: dataType, updatetime: nil, infos: nil, values: [])
        }
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:])
    {
        switch elementName {
        case "XML_Head":
            guard let dateStr = attributeDict[Key.updatetime] else { break }
            cctvData?.updatetime = date(from: dateStr)
            
        case "Info":
            switch cctvData?.dataType {
            case .info:
                guard let info = CCTVData.Info(data: attributeDict) else { return }
                cctvData?.infos?.append(info)
                
            case .value:
                guard let value = CCTVData.Value(data: attributeDict) else { return }
                cctvData?.values?.append(value)
                
            default:
                break
            }
            
        default:
            break
        }
    }
    
}
