//
// Created by Scores_Main_User on 1/18/21.
//

import UIKit
import CoreData


class GameCacheManager
{

    public static let instance: GameCacheManager = GameCacheManager()

    var loadedGameData: GameData?


    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    private init()
    {



        loadGameDataFromCache()
//        printInCache()

    }


    func getGameData() -> GameData?
    {
        return loadedGameData

    }


//    public func saveGameDataInCache(gameData: GameData)
//    {
//
//        guard let appDelegate =
//        UIApplication.shared.delegate as? AppDelegate else
//        {
//            return
//        }
//
//        // 1
//        let managedContext =
//                appDelegate.persistentContainer.viewContext
//
//
//        // 2
//        let entity =
//                NSEntityDescription.entity(forEntityName: "CD_GameData",
//                        in: managedContext)!
//
//        let game = NSManagedObject(entity: entity,
//                insertInto: managedContext)
//
//        // 3
//
//
//        let jsonData: Data = try! JSONEncoder().encode(gameData)
//        let jsonString = String(data: jsonData, encoding: .utf8)!
//
//        game.setValue(jsonString, forKeyPath: "cd_game")
//
//        // 4
//        do
//        {
//            try managedContext.save()
//
//        }
//        catch let error as NSError
//        {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//
//        print("GameCacheManager: Saved to cache \(gameData)")
//    }

    public func saveGameDataInCache(gameData: GameData)
    {
        self.loadedGameData = gameData


        let CD_Game_Data: CD_GameData = CD_GameData(context: managedContext)


        // 2
        // creating all the sub entities:


        //   var Competitions: [Competition]?
        createCompetitionsArray(parent: CD_Game_Data)

        if let cd_game: CD_Game = createGame(parent: CD_Game_Data)
        {

            //var Comps: [Competitor]?
            createCompetitorsArray(parent: cd_game)

        }

        guard let lastUpdate = self.loadedGameData?.lastUpdateId else
        {
            return
        }
        CD_Game_Data.cd_lastUpdateID = Int64(lastUpdate)

        // 4
        do
        {
            try managedContext.save()

        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }

        print("GameCacheManager: Saved to cache \(gameData)")
    }


    func createCompetitorsArray(parent game: CD_Game)
    {


        guard let count = self.loadedGameData?.games.first?.comps.count else
        {
            return
        }


        for i in 0..<count
        {
            if let competitor_data = loadedGameData?.games.first?.comps[i]
            {


                let competitor: CD_Competitor = CD_Competitor(context: managedContext)
                competitor.setValue(competitor_data.identifier, forKey: "cd_id")
                competitor.setValue(competitor_data.name, forKey: "cd_name")
                competitor.toGame = game
            }
        }


    }


    func createCompetitionsArray(parent cd_gameData: CD_GameData)
    {

        if let competition_data: Competition = self.loadedGameData?.competitions.first
        {
            let Competition = CD_Competition(context: managedContext)
            Competition.cd_id = Int32(competition_data.identifier)
            Competition.cd_name = competition_data.name

            Competition.toGameData = cd_gameData
        }
    }


    func createGame(parent cd_gameData: CD_GameData) -> CD_Game?
    {

        guard let gameOfGameData = self.loadedGameData?.games.first else
        {
            return nil
        }

        let cd_game: CD_Game = CD_Game(context: managedContext)
        cd_game.cd_active = gameOfGameData.active
        cd_game.cd_comp = Int32(gameOfGameData.comp)
        cd_game.cd_gt = gameOfGameData.gt
        cd_game.cd_gtd = gameOfGameData.gtd
        cd_game.cd_id = Int32(gameOfGameData.identifier)
        cd_game.cd_sTime = gameOfGameData.stime
        cd_game.cd_scrs = gameOfGameData.scrs
        cd_game.toGameDataModel = cd_gameData

        return cd_game

    }


    func loadGameDataFromCache()
    {

        print("attempting to load from cache")

        //2
        let fetchRequest =
                NSFetchRequest<CD_GameData>(entityName: "CD_GameData")


        //3
        do
        {
            let cachedData: [CD_GameData] = try managedContext.fetch(fetchRequest)

            var newGame: Game?
            var cachedLastUpdateId: Int?
            var newCompetition: Competition?


            if let lastData: CD_GameData = cachedData.last
            {


                cachedLastUpdateId = Int(lastData.cd_lastUpdateID)

                if let NSSET_games = lastData.toGames
                {
                    for ns_game in NSSET_games
                    {
                        let convertedToCdGame: CD_Game = ns_game as! CD_Game

                        //creating [Comps]

                        guard let NSSet_cd_comps: NSSet = convertedToCdGame.toCompetitors else
                        {
                            return
                        }

                        var comps = [Competitor]()

                        for cd_comp in NSSet_cd_comps
                        {
                            let converted_comp = cd_comp as! CD_Competitor
                            comps.append(Competitor(ID: Int(converted_comp.cd_id), Name: converted_comp.cd_name))
                        }

                        newGame = Game(ID: Int(convertedToCdGame.cd_id), Comp: Int(convertedToCdGame.cd_comp), Active: convertedToCdGame.cd_active, GT: convertedToCdGame.cd_gt, Scrs: convertedToCdGame.cd_scrs, GTD: convertedToCdGame.cd_gtd, STime: convertedToCdGame.cd_sTime, Comps: comps)


                    }
                }

                if let NSSET_competition = lastData.toCompetitions
                {
                    for ns_competition: NSSet.Element in NSSET_competition
                    {
                        let converted_ns_competition: CD_Competition = ns_competition as! CD_Competition
                        newCompetition = Competition(Name: converted_ns_competition.cd_name, ID: Int(converted_ns_competition.cd_id))
                    }
                }

            }


            if newGame != nil, cachedLastUpdateId != nil, newCompetition != nil
            {
                let newGameDataFromCache: GameData = GameData(LastUpdateID: cachedLastUpdateId, Games: [newGame!], Competitions: [newCompetition!])
                self.loadedGameData = newGameDataFromCache
            }
            else
            {
                return
            }


        }


        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }


    public func printInCache()
    {


        //2
        let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "CD_GameData")


        //3
        do
        {
            let cachedData: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            for item: NSManagedObject in cachedData
            {
                print(item)
            }

        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }


    }


    private func deleteCache()
    {


        //2
        let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "CD_GameData")


        //3
        do
        {
            let cachedData: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            for item: NSManagedObject in cachedData
            {
                print("deleting \(item)")
                managedContext.delete(item)
            }
            try managedContext.save()

        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }


}
