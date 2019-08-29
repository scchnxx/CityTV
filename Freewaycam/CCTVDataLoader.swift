import Foundation
import Gzip

enum CCTVDataLoaderError: Error {
    case networkError
    case dataParserError
    case busy
}

class CCTVDataLoader: NSObject {
    
    private var urlSession = URLSession(configuration: .default)
    
    deinit {
        urlSession.invalidateAndCancel()
    }
    
    func fetch(type: CCTVData.DataType, _ completion: @escaping (Result<CCTVData, CCTVDataLoaderError>) -> Void) {
        let req = URLRequest(url: type.url,
                             cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                             timeoutInterval: 3)
        
        let urlDataTask = urlSession.dataTask(with: req) { data, res, err in
            if let data = try? data?.gunzipped(), err == nil {
                let parser = CCTVDataParser(type: type, data: data)
                
                if let cctvData = parser.parse() {
                    completion(.success(cctvData))
                } else {
                    completion(.failure(.dataParserError))
                }
            } else {
                completion(.failure(.networkError))
            }
        }
        
        urlDataTask.resume()
    }

}
