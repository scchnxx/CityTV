enum LocationPath: String, CustomStringConvertible, CaseIterable {
    case n1   = "N1"
    case n2   = "N2"
    case n3   = "N3"
    case n3A  = "N3A"
    case n4   = "N4"
    case n5   = "N5"
    case n6   = "N6"
    case n8   = "N8"
    case n10  = "N10"
    case n1H  = "N1H"
    case n3N  = "N3N"
    case t66  = "T66"
    case t68  = "T68"
    case t72  = "T72"
    case t74  = "T74"
    case t74A = "T74A"
    case t76  = "T76"
    case t78  = "T78"
    case t82  = "T82"
    case t84  = "T84"
    case t86  = "T86"
    case t88  = "T88"
    case n2K  = "N2K"
    
    init?(code: Int) {
        for path in LocationPath.allCases {
            if path.code == code {
                self = path
                return
            }
        }
        return nil
    }
    
    var description: String {
        switch self {
        case .n1:   return "國道1號"
        case .n2:   return "國道2號"
        case .n3:   return "國道3號"
        case .n3A:  return "國3甲"
        case .n4:   return "國道4號"
        case .n5:   return "國道5號"
        case .n6:   return "國道6號"
        case .n8:   return "國道8號"
        case .n10:  return "國道10號"
        case .n1H:  return "汐五高架"
        case .n3N:  return "南港連絡道"
        case .t66:  return "快速公路66號"
        case .t68:  return "快速公路68號"
        case .t72:  return "快速公路72號"
        case .t74:  return "快速公路74號"
        case .t74A: return "快速公路74號甲"
        case .t76:  return "快速公路76號"
        case .t78:  return "快速公路78號"
        case .t82:  return "快速公路82號"
        case .t84:  return "快速公路84號"
        case .t86:  return "快速公路86號"
        case .t88:  return "快速公路88號"
        case .n2K:  return "台2己"
        }
    }
    
    var code: Int {
        switch self {
            case .n1:   return 166
            case .n2:   return 135
            case .n3:   return 28
            case .n3A:  return 143
            case .n4:   return 128
            case .n5:   return 154
            case .n6:   return 5104
            case .n8:   return 121
            case .n10:  return 113
            case .n1H:  return 147
            case .n3N:  return 490
            case .t66:  return 4104
            case .t68:  return 4113
            case .t72:  return 4121
            case .t74:  return 4129
            case .t74A: return 5253
            case .t76:  return 4141
            case .t78:  return 4149
            case .t82:  return 4158
            case .t84:  return 4165
            case .t86:  return 4171
            case .t88:  return 4179
            case .n2K:  return 4969
        }
    }
    
    var roadType: RoadType {
        switch self {
        case .n1:  fallthrough
        case .n2:  fallthrough
        case .n3:  fallthrough
        case .n3A: fallthrough
        case .n4:  fallthrough
        case .n5:  fallthrough
        case .n6:  fallthrough
        case .n8:  fallthrough
        case .n10: fallthrough
        case .n1H: fallthrough
        case .n2K: fallthrough
        case .n3N: return .freeway
        default:   return .expressway
        }
    }
    
}

