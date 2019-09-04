import Foundation

struct CCTV: Equatable {
    var id: String
    var roadsection: String
    var locationpath: LocationPath
    var startlocationpoint: Int
    var endlocationpoint: Int
    var px: CGFloat
    var py: CGFloat
    var url: URL
    var status: Bool
    var direction: Direction
}

extension CCTV: InfoValueCombinable {
    
    init?(info: TrafficData, value: TrafficData) {
        guard let info = info as? CCTVInfo, let value = value as? CCTVValue else { return nil }
        guard info.id == value.id else { return nil }
        let idComponents = info.id.split(separator: "-").map(String.init)
        guard idComponents.count == 5, let dir = Direction(rawValue: idComponents[2]) else { return nil }
        // "nfbCCTV-N1-S-0-M"

        id = info.id
        roadsection = info.roadsection
        locationpath = info.locationpath
        startlocationpoint = info.startlocationpoint
        endlocationpoint = info.endlocationpoint
        px = info.px
        py = info.py
        
        url = value.url
        status = value.status
        
        direction = dir
    }
    
}
