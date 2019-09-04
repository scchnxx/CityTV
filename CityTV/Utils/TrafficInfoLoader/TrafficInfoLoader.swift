import Foundation
import Gzip

enum TrafficInfoLoaderError: Error {
    case networkError
    case dataParserError
}

extension TrafficInfoLoader {
    
    enum DataType {
        case cctv
        case roadLevel
        
        fileprivate var dataParserTypes: (info: DataParser.ParserType, value: DataParser.ParserType) {
            switch self {
            case .cctv:      return (.cctvInfo, .cctvValue)
            case .roadLevel: return (.roadLevelInfo, .roadLevelValue)
            }
        }
        
        fileprivate var dataTypes: (info: TrafficData.Type, value: TrafficData.Type) {
            switch self {
            case .cctv:      return (CCTVInfo.self, CCTVValue.self)
            case .roadLevel: return (RoadLevelInfo.self, RoadLevelValue.self)
            }
        }
    }
    
}

class TrafficInfoLoader: NSObject {
    
    private func fetch(parserType: DataParser.ParserType, _ completion: @escaping (Result<[[String: String]], TrafficInfoLoaderError>) -> Void) {
        let session = URLSession(configuration: .default)
        let req = URLRequest(url: parserType.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                             timeoutInterval: 3)
        
        let urlDataTask = session.dataTask(with: req) { data, res, err in
            if let data = try? data?.gunzipped(), err == nil {
                let parser = DataParser(type: parserType, data: data)
                
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
    
    func fetch<T: InfoValueCombinable>(_ t: T.Type, type: DataType, _ completion: @escaping (Result<[T], TrafficInfoLoaderError>) -> Void) {
        let group = DispatchGroup()
        var error = TrafficInfoLoaderError.dataParserError
        var cctvInfos: [TrafficData]?
        var cctvValues: [TrafficData]?
        
        group.enter()
        fetch(parserType: type.dataParserTypes.info) { result in
            switch result {
            case .success(let infos): cctvInfos = infos.compactMap { type.dataTypes.info.init(data: $0) }
            case .failure(let err):   error = (error == .networkError ? .networkError : err)
            }
            group.leave()
        }
        
        group.enter()
        fetch(parserType: type.dataParserTypes.value) { result in
            switch result {
            case .success(let values): cctvValues = values.compactMap { type.dataTypes.value.init(data: $0) }
            case .failure(let err):    error = (error == .networkError ? .networkError : err)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let infos = cctvInfos, let values = cctvValues {
                let results: [T] = infos.compactMap { info in
                    guard let value = values.first(where: { $0.id == info.id }) else { return nil }
                    return T.init(info: info, value: value)
                }
                completion(.success(results))
            } else {
                completion(.failure(error))
            }
        }
    }

}
