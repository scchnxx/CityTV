import Foundation

struct CCTVInfo: TrafficData {
    var id: String
    var roadsection: String
    var locationpath: LocationPath
    var startlocationpoint: Int
    var endlocationpoint: Int
    var px: CGFloat
    var py: CGFloat
    
    init?(data: [String: String]) {
        guard let id = data["cctvid"], let roadsection = data["roadsection"],
            let locationpathStr = data["locationpath"], let locationpathCode = Int(locationpathStr), let locationPath = LocationPath(code: locationpathCode),
            let startlocationpointStr = data["startlocationpoint"], let startlocationpoint = Int(startlocationpointStr),
            let endlocationpointStr = data["endlocationpoint"], let endlocationpoint = Int(endlocationpointStr),
            let pxStr = data["px"], let px = Double(pxStr),
            let pyStr = data["py"], let py = Double(pyStr) else { return nil }
        
        self.id = id
        self.roadsection = roadsection
        self.locationpath = locationPath
        self.startlocationpoint = startlocationpoint
        self.endlocationpoint = endlocationpoint
        self.px = CGFloat(px)
        self.py = CGFloat(py)
    }
}
