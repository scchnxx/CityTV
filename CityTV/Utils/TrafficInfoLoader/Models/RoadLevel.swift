struct RoadLevel: Equatable {
    var id: String
    var roadsection: String
    var locationpath: Int
    var startlocationpoint: Int
    var endlocationpoint: Int
    var roadtype: Int
    var fromkm: String
    var tokm: String
    var speedlimit: Int

    var level: Int
    var value: Int
    var traveltime: Int    
}

extension RoadLevel: InfoValueCombinable {
    
    init?(info: TrafficData, value: TrafficData) {
        guard let info = info as? RoadLevelInfo, let value = value as? RoadLevelValue else { return nil }
        guard info.id == value.id else { return nil }
        id = info.id
        roadsection = info.roadsection
        locationpath = info.locationpath
        startlocationpoint = info.startlocationpoint
        endlocationpoint = info.endlocationpoint
        roadtype = info.roadtype
        fromkm = info.fromkm
        tokm = info.tokm
        speedlimit = info.speedlimit
        
        level = value.level
        self.value = value.value
        traveltime = value.traveltime
    }
    
}
