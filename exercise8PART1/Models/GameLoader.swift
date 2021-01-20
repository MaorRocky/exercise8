//
//  GameLoader.swift
//  exercise8_v2
//
//  Created by Scores_Main_User on 1/18/21.
//

import Foundation

class GameLoader
{


    let gameId: Int
    let lastUpdateId: String?

    var gameURL: String = "https://qa.365scores.com/Data/Games/GameCenter/?games=$game_id&lang=1&AppType=1&tz=15&theme=dark&uc=1&uid=$update_id"


    init(gameID: Int = 2352106, lastUpdateID: String?)
    {
        print("created GameLoader with \(gameID) and \(lastUpdateID ?? "nil")")
        self.gameId = gameID
        self.lastUpdateId = lastUpdateID
        gameURL = gameURL.replacingOccurrences(of: "$game_id", with: "\(gameID)")
        gameURL = gameURL.replacingOccurrences(of: "$update_id", with: lastUpdateID ?? "")
        print(gameURL)
    }


    /*Loading process will start when the “load(completion:)”
     method will be called and the result will be returned via the “completion” closure*/
    func load(completion: @escaping (GameData?, Error?) -> Void)
    {
        let session = URLSession(configuration: .default)
        // the string is hard coded hence im using "!"
        let url = URL(string: self.gameURL)!

        let task: URLSessionDataTask = session.dataTask(with: url)
        { data, response, error in

            if error != nil || data == nil
            {
                print("Client error!")
                completion(nil, error)
            }

            guard let response: HTTPURLResponse = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else
            {
                print("Server error!")
                return
            }

            guard let mime: String = response.mimeType, mime == "application/json" else
            {
                print("Wrong MIME type!")
                return
            }
            //data is not nil
            if let json: GameData = self.parseJSON(data!)
            {
                print("decoded json and got \(json)")
                completion(json, error)

            }
        }

        task.resume()
    }


    func parseJSON(_ gameData: Data) -> GameData?
    {
        let gameDecoder: GameDecoder = GameDecoder(jsonData: gameData)
        return gameDecoder.decode()
    }

}
