import Foundation


struct Competitor: Codable
{
    var ID: Int?
    var Name: String?

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
    var Name: String?
    var ID: Int?

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
    var ID: Int?
    var Comp: Int?
    var Active: Bool?
    var GT: Double?
    var Scrs: [Double]?
    var GTD: String?
    var STime: String?
    var Comps: [Competitor]?

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

    var active : Bool{
        return Active ?? false
    }

    var gt : Double {
        return GT ?? 0
    }

}

struct GameData: Codable
{
    var LastUpdateID: Int?
    var Games: [Game]?
    var Competitions: [Competition]?

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
