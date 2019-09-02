struct RoadLevelInfo: TrafficData {
    var id: String
    var roadsection: String
    var locationpath: Int
    var startlocationpoint: Int
    var endlocationpoint: Int
    var roadtype: Int
    var fromkm: String
    var tokm: String
    var speedlimit: Int
    
    init?(data: [String: String]) {
        guard let id = data["routeid"],
            let roadsection = data["roadsection"],
            let locationpathStr = data["locationpath"], let locationpath = Int(locationpathStr),
            let startlocationpointStr = data["startlocationpoint"], let startlocationpoint = Int(startlocationpointStr),
            let endlocationpointStr = data["endlocationpoint"], let endlocationpoint = Int(endlocationpointStr),
            let roadtypeStr = data["roadtype"], let roadtype = Int(roadtypeStr),
            let fromkm = data["fromkm"],
            let tokm = data["tokm"],
            let speedlimitStr = data["speedlimit"], let speedlimit = Int(speedlimitStr) else { return nil }
        
        self.id = id
        self.roadsection = roadsection
        self.locationpath = locationpath
        self.startlocationpoint = startlocationpoint
        self.endlocationpoint = endlocationpoint
        self.roadtype = roadtype
        self.fromkm = fromkm
        self.tokm = tokm
        self.speedlimit = speedlimit
    }
}
