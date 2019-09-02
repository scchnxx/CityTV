struct RoadLevelValue: TrafficData {
    var id: String
    var level: Int
    var value: Int
    var traveltime: Int
    
    init?(data: [String: String]) {
        guard let id = data["routeid"],
            let levelStr = data["level"], let level = Int(levelStr),
            let valueStr = data["value"], let value = Int(valueStr),
            let traveltimeStr = data["traveltime"], let traveltime = Int(traveltimeStr) else { return nil }
        self.id = id
        self.level = level
        self.value = value
        self.traveltime = traveltime
    }
}
