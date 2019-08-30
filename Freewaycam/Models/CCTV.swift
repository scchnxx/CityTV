import Foundation

struct CCTV: Equatable {
    var id: String
    var roadsection: String
    var locationpath: Int
    var startlocationpoint: Int
    var endlocationpoint: Int
    var px: CGFloat
    var py: CGFloat
    var url: URL
    var status: Bool
}

extension CCTV: InfoValueCombinable {
    
    init?(info: DictionayInitializable, value: DictionayInitializable) {
        guard let info = info as? CCTVInfo, let value = value as? CCTVValue else { return nil }
        guard info.id == value.id else { return nil }
        id = info.id
        roadsection = info.roadsection
        locationpath = info.locationpath
        startlocationpoint = info.startlocationpoint
        endlocationpoint = info.endlocationpoint
        px = info.px
        py = info.py
        
        url = value.url
        status = value.status
    }
    
}
