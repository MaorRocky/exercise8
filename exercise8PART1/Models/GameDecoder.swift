//
//  GameDecoder.swift
//  exercise8_v2
//
//  Created by Scores_Main_User on 1/18/21.
//

import Foundation

class GameDecoder
{


    private let data: Data


    init(jsonData: Data)
    {
        self.data = jsonData
    }


    func decode() -> GameData?
    {

        print("decoder got:")
        print(String(data: self.data, encoding: .utf8)!)


        let decoder = JSONDecoder()
        do
        {
            let gameData = try decoder.decode(GameData.self, from: self.data)
            return gameData
        }
        catch
        {
            print("Error while decoding \(error.localizedDescription) ")
            print("\n")
            return nil
        }
    }

}
