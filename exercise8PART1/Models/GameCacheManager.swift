//
// Created by Scores_Main_User on 1/18/21.
//

import UIKit
import CoreData


class GameCacheManager
{

    public static let instance: GameCacheManager = GameCacheManager()

    var loadedGameData: GameData?


    private init()
    {
        loadGameDataFromCache()
    }


    func getGameData() -> GameData?
    {
        return loadedGameData

    }


    public func saveGameDataInCache(gameData: GameData)
    {

        guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }

        // 1
        let managedContext =
                appDelegate.persistentContainer.viewContext


        // 2
        let entity =
                NSEntityDescription.entity(forEntityName: "GameDataModel",
                        in: managedContext)!

        let game = NSManagedObject(entity: entity,
                insertInto: managedContext)

        // 3

        let jsonData: Data = try! JSONEncoder().encode(gameData)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        game.setValue(jsonString, forKeyPath: "game")

        // 4
        do
        {
            try managedContext.save()

        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }


    func loadGameDataFromCache()
    {
//1
        guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }

        let managedContext =
                appDelegate.persistentContainer.viewContext

        //2
        let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: "GameDataModel")


        //3
        do
        {
            let cachedData: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            if let jsonString: String = cachedData.first?.value(forKey: "game") as? String
            {
                let gameJson: Data = jsonString.data(using: .utf8)!
                let gameDecoder: GameDecoder = GameDecoder(jsonData: gameJson)
                self.loadedGameData = gameDecoder.decode()
                print("from cache LastUpdateID: \(self.loadedGameData?.LastUpdateID ?? -1)")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }


    func deleteData()
    {


    }
}
