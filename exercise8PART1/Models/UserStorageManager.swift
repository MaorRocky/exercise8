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


    }


    public func saveToUserDefaults(isCacheSupported: Bool, values: [Int])
    {
        defaults.set(values, forKey: "values")
        defaults.set(isCacheSupported, forKey: "cacheSwitch")
    }


}