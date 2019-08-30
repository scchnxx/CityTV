import Foundation

struct CCTVValue: DictionayInitializable {
    var id: String
    var url: URL
    var status: Bool
    
    init?(data: [String: String]) {
        guard let id = data["cctvid"],
            let urlStr = data["url"], let url = URL(string: urlStr),
            let statusStr = data["status"], let statusNum = Int(statusStr) else { return nil }
        
        self.id = id
        self.url = url
        self.status = (statusNum == 0)
    }
}
