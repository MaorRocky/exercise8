//
// Created by Scores_Main_User on 1/18/21.
//

import Foundation


protocol GameDataManagerDelegate
{

    func gameDataManager(_ didLoadData: GameData, _ manager: GameDataManager)

    func gameDataManager(_ didFailToLoadDataWithError: Error?, _ manager: GameDataManager)
}

class GameDataManager
{
    var delegate: GameDataManagerDelegate?

    let gameCacheManager: GameCacheManager = GameCacheManager.instance

    var lastUpdateID: Int = -1 // -1 means error

    var updateTimer: Timer?

    var cacheTimer: Timer?

    let gameId: Int

    let updateFrequency: Int

    let cachePeriod: Int

    var gameData: GameData?

    var isSupportCache: Bool


    init(isSupportCache: Bool, cachePeriod: Int, updateFrequency: Int, gameId: Int)
    {
        self.gameId = gameId
        self.updateFrequency = updateFrequency
        self.cachePeriod = cachePeriod
        self.isSupportCache = isSupportCache
    }


    // this function will be called from GAME view controller viewDidLoad
    public func loadData()
    {
        if let gameData: GameData = self.gameCacheManager.loadedGameData
        {
            self.gameData = gameData
            self.delegate?.gameDataManager(gameData, self)
            self.lastUpdateID = gameData.lastUpdateId

            print("game data loaded from cache: \(gameData) ")
        }
        else
        {
            print("No game in cache!\n")

            let gameLoader: GameLoader = GameLoader(gameID: self.gameId, lastUpdateID: nil)

            gameLoader.load
            { (data: GameData?, error: Error?) in
                if let safeData: GameData = data
                {
                    self.gameData = safeData
                    self.updateAndNotifyDelegate()

                }
                else
                {
                    self.delegate?.gameDataManager(error, self)
                }
            }
        }

    }


    public func startUpdates()
    {
        self.updateTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.updateFrequency), target: self, selector: #selector(fireUpdate), userInfo: nil, repeats: true)

        if isSupportCache
        {
            self.cacheTimer = Timer.scheduledTimer(timeInterval: TimeInterval(self.cachePeriod), target: self, selector: #selector(fireCaching), userInfo: nil, repeats: true)
        }

    }


    @objc private func fireUpdate()
    {

        print("fireUpdate!")
        let gameLoader: GameLoader = GameLoader(gameID: self.gameId, lastUpdateID: "\(self.lastUpdateID)")
//        let gameLoader: GameLoader = GameLoader(gameID: self.gameId, lastUpdateID: nil)
//TODO BUG!
        gameLoader.load
        { [self] (data: GameData?, error: Error?) in
            if let safeData: GameData = data
            {

                if var game: Game = safeData.games.first
                {

                    if game.comps.count == 0
                    {
                        game.Comps = self.gameData?.games.first?.comps ?? []
                    }


                    if game.scrs.count == 0
                    {
                        game.Scrs = self.gameData?.games.first?.scrs ?? []
                    }

                    if game.stime == "noValue"
                    {
                        game.STime = self.gameData?.games.first?.stime
                    }

                    if game.comp == -1
                    {
                        game.Comp = self.gameData?.games.first?.comp
                    }

                    if game.gtd == "noGtd"
                    {
                        game.GTD = self.gameData?.games.first?.gtd
                    }

                    self.gameData?.Games = [game]


                }


                if safeData.lastUpdateId != 0
                {

                    self.gameData?.LastUpdateID = safeData.lastUpdateId
                }

                if let competition = safeData.competitions.first
                {

                    self.gameData?.Competitions = [competition]

                }


//                self.gameData = safeData

                DispatchQueue.main.async
                { [self] in
                    print(gameData)
                }
                self.updateAndNotifyDelegate()
            }
        }
    }


    @objc private func fireCaching()
    {
        guard let safeData: GameData = self.gameData else
        {
            return
        }

        self.gameCacheManager.saveGameDataInCache(gameData: safeData)
        print("cached game")
    }


    public func stopUpdates()
    {
        self.updateTimer?.invalidate()
        self.cacheTimer?.invalidate()
    }


    private func updateAndNotifyDelegate()
    {
        guard let safeData: GameData = self.gameData else
        {
            print("ERROR in gameData from updateAndNotifyDelegate")
            return
        }

        self.delegate?.gameDataManager(safeData, self)
        self.lastUpdateID = safeData.lastUpdateId
        self.gameCacheManager.loadedGameData = safeData

    }
}
