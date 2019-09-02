enum LocationPath: String, CustomStringConvertible {
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
    case n3N  = "N3N"
    
    init?(id: Int) {
        switch id {
        case 166:  self = .n1
        case 135:  self = .n2
        case 28:   self = .n3
        case 143:  self = .n3A
        case 128:  self = .n4
        case 154:  self = .n5
        case 5104: self = .n6
        case 121:  self = .n8
        case 113:  self = .n10
        case 147:  self = .n1H
        case 4104: self = .t66
        case 4113: self = .t68
        case 4121: self = .t72
        case 4129: self = .t74
        case 5253: self = .t74A
        case 4141: self = .t76
        case 4149: self = .t78
        case 4158: self = .t82
        case 4165: self = .t84
        case 4171: self = .t86
        case 4179: self = .t88
        case 4969: self = .n2K
        case 490:  self = .n3N
        default:   return nil
        }
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
        case .n3N:  return "南港連絡道"
        }
    }
}

