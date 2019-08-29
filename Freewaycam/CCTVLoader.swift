import Foundation
import Gzip

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
    
    init?(data: [String: String]) {
        guard let id = data["cctvid"], let roadsection = data["roadsection"],
            let locationpathStr = data["locationpath"], let locationpath = Int(locationpathStr),
            let startlocationpointStr = data["startlocationpoint"], let startlocationpoint = Int(startlocationpointStr),
            let endlocationpointStr = data["endlocationpoint"], let endlocationpoint = Int(endlocationpointStr),
            let pxStr = data["px"], let px = Double(pxStr),
            let pyStr = data["py"], let py = Double(pyStr),
            let urlStr = data["url"], let url = URL(string: urlStr),
            let statusStr = data["status"], let statusNum = Int(statusStr) else { return nil }
        
        self.id = id
        self.roadsection = roadsection
        self.locationpath = locationpath
        self.startlocationpoint = startlocationpoint
        self.endlocationpoint = endlocationpoint
        self.px = CGFloat(px)
        self.py = CGFloat(py)
        self.url = url
        self.status = (statusNum == 0)
    }
}

enum CCTVDataLoaderError: Error {
    case networkError
    case dataParserError
}

class CCTVLoader: NSObject {
    
    func fetch(type: CCTVDataParser.DataType, _ completion: @escaping (Result<[[String: String]], CCTVDataLoaderError>) -> Void) {
        let req = URLRequest(url: type.url,
                             cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                             timeoutInterval: 3)
        
        let urlDataTask = URLSession(configuration: .default).dataTask(with: req) { data, res, err in
            if let data = try? data?.gunzipped(), err == nil {
                let parser = CCTVDataParser(type: type, data: data)
                
                if let dicts = parser.parse() {
                    completion(.success(dicts))
                } else {
                    completion(.failure(.dataParserError))
                }
            } else {
                completion(.failure(.networkError))
            }
        }
        
        urlDataTask.resume()
    }
    
    func fetch(_ completion: @escaping (Result<[CCTV], CCTVDataLoaderError>) -> Void) {
        let group = DispatchGroup()
        var error = CCTVDataLoaderError.dataParserError
        var infoDicts: [[String: String]]?
        var valueDicts: [[String: String]]?
        
        group.enter()
        fetch(type: .info) { result in
            switch result {
            case .success(let dict): infoDicts = dict
            case .failure(let err):  error = (error == .networkError ? .networkError : err)
            }
            group.leave()
        }
        
        group.enter()
        fetch(type: .value) { result in
            switch result {
            case .success(let dicts): valueDicts = dicts
            case .failure(let err): error = (error == .networkError ? .networkError : err)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            guard let infoDicts = infoDicts, let valueDicts = valueDicts, infoDicts.count == valueDicts.count else {
                completion(.failure(error))
                return
            }
            
            var cctvs = [CCTV]()
            
            for (i, var infoDict) in infoDicts.enumerated() {
                infoDict.merge(valueDicts[i]) { d1, d2 in d1 }
                if let cctv = CCTV(data: infoDict) {
                    cctvs.append(cctv)
                }
            }
            
            completion(.success(cctvs))
        }
    }

}
