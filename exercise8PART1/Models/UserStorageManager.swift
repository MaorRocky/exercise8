//
// Created by Scores_Main_User on 1/20/21.
//

import Foundation


class UserStorageManager
{

    public static let instance: UserStorageManager = UserStorageManager()


    public var isCacheSupported: Bool = false

    public var cachePeriod: Int = 30

    public var updateFrequency: Int = 10

    public var gameId: Int = 2352106

    public var rowNamesArr: [String] = ["Support cache", "Updates frequency", "Game ID", "Show Game"]

    private let defaults = UserDefaults.standard


    private init()
    {
        loadFromUserDefaults()
    }


    public func loadFromUserDefaults()
    {
        guard let vals: [Int] = self.defaults.array(forKey: "values") as? [Int] else
        {
            return
        }
        self.cachePeriod = vals[0]
        self.updateFrequency = vals[1]
        self.gameId = vals[2]

        let cacheSwitchVal: Bool = self.defaults.bool(forKey: "cacheSwitch")
        self.isCacheSupported = cacheSwitchVal

        guard let rows: [String] = self.defaults.array(forKey: "rows") as? [String] else
        {
            return
        }

        self.rowNamesArr = rows

    }


    public func saveToUserDefaults(isCacheSupported: Bool, values: [Int], rows: [String])
    {
        print("save was called with \(rows)")
        defaults.set(values, forKey: "values")
        defaults.set(isCacheSupported, forKey: "cacheSwitch")
        defaults.set(rows, forKey: "rows")

        self.isCacheSupported = isCacheSupported
        self.rowNamesArr = rows
        self.cachePeriod = values[0]
        self.updateFrequency = values[1]
        self.gameId = values[2]

        print("Saved!")
        print("Values are now \(rowNamesArr.description) \t ")
    }


}