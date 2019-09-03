import Foundation

extension String {
    func transformingHalfwidthFullwidth(from aSet: CharacterSet) -> String {
        return String(map {
            if String($0).rangeOfCharacter(from: aSet) != nil {
                let string = NSMutableString(string: String($0))
                CFStringTransform(string, nil, kCFStringTransformFullwidthHalfwidth, true)
                return String(string).first!
            } else {
                return $0
            }
        })
    }
}

struct CCTVCellViewModel {
    var from: String = ""
    var to: String = ""
    
    init(cctv: CCTV) {
        if let start = cctv.roadsection.range(of: "(")?.upperBound {
            let range = start..<cctv.roadsection.index(before: cctv.roadsection.endIndex)
            let name = String(cctv.roadsection[range]).transformingHalfwidthFullwidth(from: CharacterSet.alphanumerics.inverted)
            var nameComponents = name.split(separator: "到").map(String.init)
            if nameComponents.count == 2 {
                nameComponents[0] += String(repeating: "　", count: 8 - nameComponents[0].count)
                from = nameComponents[0]
                to = nameComponents[1]
            }
        }
    }
}
