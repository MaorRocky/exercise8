import Foundation


struct Comp: Codable
{
    let ID: Int
    let Name: String
}


struct Competition: Codable
{
    let Name: String
    let ID: Int
}


struct Game: Codable
{
    let ID: Int
    let Comp: Int
    let Active: Bool
    let GT: Double
    let Scrs: [Double]
    let GTD: String
    let STime: String
    let Comps: [Comp]


}

struct GameData: Codable
{
    let LastUpdateID: Int
    let Games: [Game]
    let Competitions: [Competition]
}
