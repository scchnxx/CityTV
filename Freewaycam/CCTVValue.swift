import Foundation

struct CCTVData: Equatable {
    
    enum DataType {
        case info
        case value
        
        var url: URL {
            self == .info ?
                URL(string: "http://tisvcloud.freeway.gov.tw/cctv_info.xml.gz")! :
                URL(string: "http://tisvcloud.freeway.gov.tw/cctv_value.xml.gz")!
        }
    }

    struct Info: Equatable {
        var id: String
        var roadsection: String
        var locationpath: Int
        var startlocationpoint: Int
        var endlocationpoint: Int
        var px: CGFloat
        var py: CGFloat
    }

    struct Value: Equatable {
        var id: String
        var url: URL
        var status: Bool
    }
    
    var dataType: DataType
    var updatetime: Date?
    var infos: [Info]?
    var values: [Value]?
}
