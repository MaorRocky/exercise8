import Foundation


struct Competitor: Codable
{
    let ID: Int?
    let Name: String?

    var identifier: Int
    {
        return ID ?? -1
    }

    var name: String
    {
        return Name ?? "noName"
    }
}


struct Competition: Codable
{
    let Name: String?
    let ID: Int?

    var identifier: Int
    {
        return ID ?? -1
    }

    var name: String
    {
        return Name ?? "noName"
    }
}


struct Game: Codable
{
    let ID: Int?
    let Comp: Int?
    let Active: Bool?
    let GT: Double?
    let Scrs: [Double]?
    let GTD: String?
    let STime: String?
    let Comps: [Competitor]?

    var identifier: Int
    {
        return ID ?? -1
    }

    var comp: Int
    {
        return Comp ?? -1
    }

    var scrs: [Double]
    {
        return Scrs ?? []
    }

    var gtd: String
    {
        return GTD ?? "noGtd"
    }

    var stime: String
    {
        return STime ?? "noValue"
    }

    var comps: [Competitor]
    {
        return Comps ?? []
    }

}

struct GameData: Codable
{
    let LastUpdateID: Int?
    let Games: [Game]?
    let Competitions: [Competition]?

    var lastUpdateId: Int
    {
        return LastUpdateID ?? 0
    }

    var games: [Game]
    {
        return Games ?? []
    }
    var competitions: [Competition]
    {
        return Competitions ?? []
    }
}
