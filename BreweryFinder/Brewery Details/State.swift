enum State: String {
    case alabama, alaska, arizona, arkansas, california, colorado, connecticut, delaware, florida, georgia, hawaii, idaho, illinois, indiana, iowa, kansas, kentucky, louisiana, maine, maryland, massachusetts, michigan, minnesota, mississippi, missouri, montana, nebraska, nevada, newHampshire, newJersey, newMexico, newYork, northCarolina, northDakota, ohio, oklahoma, oregon, pennsylvania, rhodeIsland, southCarolina, southDakota, tennessee, texas, utah, vermont, virginia, washington, westVirginia, wisconsin, wyoming
    
    var abbreviation: String {
        switch self {
        case .alabama:
            return "AL"
        case .alaska:
            return "AK"
        case .arizona:
            return "AZ"
        case .arkansas:
            return "AR"
        case .california:
            return "CA"
        case .colorado:
            return "CO"
        case .connecticut:
            return "CT"
        case .delaware:
            return "DE"
        case .florida:
            return "FL"
        case .georgia:
            return "GA"
        case .hawaii:
            return "HI"
        case .idaho:
            return "ID"
        case .illinois:
            return "IL"
        case .indiana:
            return "IN"
        case .iowa:
            return "IA"
        case .kansas:
            return "KS"
        case .kentucky:
            return "KY"
        case .louisiana:
            return "LA"
        case .maine:
            return "ME"
        case .maryland:
            return "MD"
        case .massachusetts:
            return "MA"
        case .michigan:
            return "MI"
        case .minnesota:
            return "MN"
        case .mississippi:
            return "MS"
        case .missouri:
            return "MO"
        case .montana:
            return "MT"
        case .nebraska:
            return "NE"
        case .nevada:
            return "NV"
        case .newHampshire:
            return "NH"
        case .newJersey:
            return "NJ"
        case .newMexico:
            return "NM"
        case .newYork:
            return "NY"
        case .northCarolina:
            return "NC"
        case .northDakota:
            return "ND"
        case .ohio:
            return "OH"
        case .oklahoma:
            return "OK"
        case .oregon:
            return "OR"
        case .pennsylvania:
            return "PA"
        case .rhodeIsland:
            return "RI"
        case .southCarolina:
            return "SC"
        case .southDakota:
            return "SD"
        case .tennessee:
            return "TN"
        case .texas:
            return "TX"
        case .utah:
            return "UT"
        case .vermont:
            return "VT"
        case .virginia:
            return "VA"
        case .washington:
            return "WA"
        case .westVirginia:
            return "WV"
        case .wisconsin:
            return "WI"
        case .wyoming:
            return "WY"
        }
    }
    
    init?(name: String) {
        self.init(rawValue: name.lowercased())
    }
}
