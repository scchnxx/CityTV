enum RoadPath: Int, CustomStringConvertible {
    case n1   = 166
    case n2   = 135
    case n3   = 28
    case n3A  = 143
    case n4   = 128
    case n5   = 154
    case n6   = 5104
    case n8   = 121
    case n10  = 113
    case n1H  = 147
    case t66  = 4104
    case t68  = 4113
    case t72  = 4121
    case t74  = 4129
    case t74A = 5253
    case t76  = 4141
    case t78  = 4149
    case t82  = 4158
    case t84  = 4165
    case t86  = 4171
    case t88  = 4179
    case n2K  = 4969
    case n3N  = 490
    
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

