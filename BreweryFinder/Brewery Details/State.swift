enum State: String {
    case alabama = "Alabama"
    case alaska = "Alaska"
    case arizona = "Arizona"
    case arkansas = "Arkansas"
    case california = "California"
    case colorado = "Colorado"
    case connecticut = "Connecticut"
    case delaware = "Delaware"
    case florida = "Florida"
    case georgia = "Georgia"
    case hawaii = "Hawaii"
    case idaho = "Idaho"
    case illinois = "Illinois"
    case indiana = "Indiana"
    case iowa = "Iowa"
    case kansas = "Kansas"
    case kentucky = "Kentucky"
    case louisiana = "Louisiana"
    case maine = "Maine"
    case maryland = "Maryland"
    case massachusetts = "Massachusetts"
    case michigan = "Michigan"
    case minnesota = "Minnesota"
    case mississippi = "Mississippi"
    case missouri = "Missouri"
    case montana = "Montana"
    case nebraska = "Nebraska"
    case nevada = "Nevada"
    case newHampshire = "New Hampshire"
    case newJersey = "New Jersey"
    case newMexico = "New Mexico"
    case newYork = "New York"
    case northCarolina = "North Carolina"
    case northDakota = "North Dakota"
    case ohio = "Ohio"
    case oklahoma = "Oklahoma"
    case oregon = "Oregon"
    case pennsylvania = "Pennsylvania"
    case rhodeIsland = "RhodeIsland"
    case southCarolina = "SouthCarolina"
    case southDakota = "SouthDakota"
    case tennessee = "Tennessee"
    case texas = "Texas"
    case utah = "Utah"
    case vermont = "Vermont"
    case virginia = "Virginia"
    case washington = "Washington"
    case westVirginia = "West Virginia"
    case wisconsin = "Wisconsin"
    case wyoming = "Wyoming"
    
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
        self.init(rawValue: name)
    }
}
