import Foundation

struct CCTVInfo: DictionayInitializable {
    var id: String
    var roadsection: String
    var locationpath: Int
    var startlocationpoint: Int
    var endlocationpoint: Int
    var px: CGFloat
    var py: CGFloat
    
    init?(data: [String: String]) {
        guard let id = data["cctvid"], let roadsection = data["roadsection"],
            let locationpathStr = data["locationpath"], let locationpath = Int(locationpathStr),
            let startlocationpointStr = data["startlocationpoint"], let startlocationpoint = Int(startlocationpointStr),
            let endlocationpointStr = data["endlocationpoint"], let endlocationpoint = Int(endlocationpointStr),
            let pxStr = data["px"], let px = Double(pxStr),
            let pyStr = data["py"], let py = Double(pyStr) else { return nil }
        
        self.id = id
        self.roadsection = roadsection
        self.locationpath = locationpath
        self.startlocationpoint = startlocationpoint
        self.endlocationpoint = endlocationpoint
        self.px = CGFloat(px)
        self.py = CGFloat(py)
    }
}
