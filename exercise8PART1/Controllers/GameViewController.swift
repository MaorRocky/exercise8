//
//  ViewController.swift
//  exercise8_v2
//
//  Created by Scores_Main_User on 1/18/21.
//

import UIKit

class GameViewController: UIViewController
{

    var gamaData: GameData?

    var objectsDictionary: [String: UILabel] = [:]

    let gameManager: GameDataManager

    let initialValues: [Int]




    init(supportCacheValue: Bool, values: [Int])
    {

        //TODO drill down the support cache value to the game Data Manager
        self.initialValues = values

        gameManager = GameDataManager(isSupportCache: supportCacheValue,cachePeriod: values[0], updateFrequency: values[1], gameId: values[2])


        super.init(nibName: nil, bundle: nil)

    }


    required init?(coder: NSCoder)
    {
        fatalError("init(coder:)")
    }


    override func loadView()
    {
        super.loadView()
        view.backgroundColor = .white
        creatUI()

    }


    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.gameManager.delegate = self

        NotificationCenter.default.addObserver(self,
                selector: #selector(applicationDidBecomeActive),
                name: UIApplication.didBecomeActiveNotification,
                object: nil)


        NotificationCenter.default.addObserver(self,
                selector: #selector(applicationDidEnterBackground),
                name: UIApplication.didEnterBackgroundNotification,
                object: nil)


        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackButton))


        startManager()


    }


    @objc private func goBackButton()
    {
        self.gameManager.stopUpdates()
        self.navigationController?.popViewController(animated: true)

    }


    @objc func applicationDidBecomeActive()
    {
        print("applicationDidBecomeActive")
        self.gameManager.startUpdates()

    }


    @objc func applicationDidEnterBackground()
    {
        print("applicationDidEnterBackground")
        self.gameManager.stopUpdates()

    }


    func startManager()
    {
        self.gameManager.loadData()
        self.gameManager.startUpdates()
    }


    func creatUI()
    {
        let boxView: UIView = UIView()
        boxView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(boxView)
        boxView.backgroundColor = .lightGray


        boxView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        boxView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true

        boxView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        boxView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        let competitionLabel: UILabel = UILabel()
        boxView.addSubview(competitionLabel)
        competitionLabel.translatesAutoresizingMaskIntoConstraints = false
        competitionLabel.text = "TEXTTEXT"
        competitionLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor).isActive = true
        competitionLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 10).isActive = true
        self.objectsDictionary["competitionLabel"] = competitionLabel


        let homeLabel: UILabel = UILabel()
        let awayLabel: UILabel = UILabel()
        homeLabel.translatesAutoresizingMaskIntoConstraints = false
        awayLabel.translatesAutoresizingMaskIntoConstraints = false

        boxView.addSubview(homeLabel)
        boxView.addSubview(awayLabel)

        self.objectsDictionary["homeLabel"] = homeLabel
        self.objectsDictionary["awayLabel"] = awayLabel


        homeLabel.text = "HOMEHOME"
        homeLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10).isActive = true
        homeLabel.centerYAnchor.constraint(equalTo: boxView.centerYAnchor, constant: 60).isActive = true

        awayLabel.text = "WAYAWAY"
        awayLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10).isActive = true
        awayLabel.topAnchor.constraint(equalTo: homeLabel.bottomAnchor, constant: 40).isActive = true

        let gameStartTimeLabel: UILabel = UILabel()
        gameStartTimeLabel.text = "16:40"
        gameStartTimeLabel.font = .systemFont(ofSize: 22)
        boxView.addSubview(gameStartTimeLabel)
        gameStartTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        gameStartTimeLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor).isActive = true
        gameStartTimeLabel.centerYAnchor.constraint(equalTo: boxView.centerYAnchor, constant: -50).isActive = true
        self.objectsDictionary["gameStartTimeLabel"] = gameStartTimeLabel


        let gameCurrentTime: UILabel = UILabel()
        gameCurrentTime.text = "20"
        boxView.addSubview(gameCurrentTime)
        gameCurrentTime.translatesAutoresizingMaskIntoConstraints = false
        gameCurrentTime.textColor = .red
        gameCurrentTime.centerXAnchor.constraint(equalTo: boxView.centerXAnchor).isActive = true
        gameCurrentTime.centerYAnchor.constraint(equalTo: gameStartTimeLabel.centerYAnchor, constant: 30).isActive = true

        self.objectsDictionary["gameCurrentTime"] = gameCurrentTime


        let homeScoreViewAndLabel: UIView = createScoreView()
        let awayScoreViewAndLabel: UIView = createScoreView()

        boxView.addSubview(homeScoreViewAndLabel)
        boxView.addSubview(awayScoreViewAndLabel)


        homeScoreViewAndLabel.centerYAnchor.constraint(equalTo: homeLabel.centerYAnchor).isActive = true
        homeScoreViewAndLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80).isActive = true

        awayScoreViewAndLabel.centerYAnchor.constraint(equalTo: awayLabel.centerYAnchor).isActive = true
        awayScoreViewAndLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80).isActive = true


        let labelHome: Array<UIView> = homeScoreViewAndLabel.subviews.filter
        {
            $0 is UILabel
        }
        let labelAway: Array<UIView> = awayScoreViewAndLabel.subviews.filter
        {
            $0 is UILabel
        }
        self.objectsDictionary["awayScoreLabel"] = (labelHome.first as! UILabel)
        self.objectsDictionary["homeScoreLabel"] = (labelAway.first as! UILabel)


    }


    func createScoreView() -> UIView
    {

        let scoreView: UIView = UIView()
        scoreView.backgroundColor = .black

        scoreView.translatesAutoresizingMaskIntoConstraints = false

        scoreView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        scoreView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        scoreView.layer.cornerRadius = 10


        let scoreLabel: UILabel = UILabel()
        scoreView.addSubview(scoreLabel)
        scoreLabel.text = "1"
        scoreLabel.centerWith(to: scoreView)
        scoreLabel.textColor = .white

        return scoreView

    }


    func testDecoder()
    {

        let GameJSON: Data = """

                             {
                               "LastUpdateID": 1548365608,
                               "Games": [
                                 {
                                   "ID": 2260457,
                                   "Comp": 154,
                                   "Active": true,
                                   "GT": 90,
                                   "STime": "02-07-2020 16:00",
                                   "Comps": [
                                     {
                                       "ID": 12384,
                                       "Name": "Radmoiak Radom"
                                     },
                                     {
                                       "ID": 7721,
                                       "Name": "Wigry Sualki"
                                     }
                                   ],
                                   "Scrs": [
                                     3.0,
                                     1.0,
                                     1.0,
                                     0.0,
                                     3.0,
                                     1.0,
                                     -1.0,
                                     -1.0,
                                     -1.0,
                                     -1.0
                                   ]
                                 }
                               ],
                               "Competitions": [
                                 {
                                   "Name": "I Liga",
                                   "ID": 154
                                 }
                               ]
                             }
                             """.data(using: .utf8)!


        let gameDecoder = GameDecoder(jsonData: GameJSON)
        if let gameData: GameData = gameDecoder.decode()
//        {
//            print(gameData)
//        }
        {
            let jsonData: Data = try! JSONEncoder().encode(gameData)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)


        }

    }
}

extension GameViewController: GameDataManagerDelegate
{
    func gameDataManager(_ didLoadData: GameData, _ manager: GameDataManager)
    {
        self.gamaData = didLoadData
        self.updateUIWithData()
    }


    func gameDataManager(_ didFailToLoadDataWithError: Error?, _ manager: GameDataManager)
    {
        print(didFailToLoadDataWithError!)
    }


    func updateUIWithData()
    {
        guard let competitionLabel: UILabel = self.objectsDictionary["competitionLabel"],
              let homeLabel: UILabel = self.objectsDictionary["homeLabel"],
              let awayLabel: UILabel = self.objectsDictionary["awayLabel"],
              let gameStartTimeLabel: UILabel = self.objectsDictionary["gameStartTimeLabel"],
              let gameCurrentTime: UILabel = self.objectsDictionary["gameCurrentTime"],
              let homeScoreLabel: UILabel = self.objectsDictionary["homeScoreLabel"],
              let awayScoreLabel: UILabel = self.objectsDictionary["awayScoreLabel"]
                else
        {

            return
        }


        DispatchQueue.main.async
        {

            competitionLabel.text = self.gamaData?.Competitions.first?.Name

            homeLabel.text = self.gamaData?.Games.first?.Comps.first?.Name

            awayLabel.text = self.gamaData?.Games.first?.Comps[1].Name

            if let stime = self.gamaData?.Games.first?.STime
            {
                gameStartTimeLabel.text = self.getStartTimeFrom_STime(from: stime)
            }


            guard let homeScore: Double = self.gamaData?.Games.first?.Scrs.first,
                  let awayScore: Double = self.gamaData?.Games.first?.Scrs[1] else
            {
                return
            }

            homeScoreLabel.text = homeScore < 0 ? "0" : "\(Int(homeScore))"

            awayScoreLabel.text = awayScore < 0 ? "0" : "\(Int(awayScore))"

            gameCurrentTime.text = self.gamaData?.Games.first?.GTD

        }

    }


    func getStartTimeFrom_STime(from stime: String) -> String
    {
        return String(stime.split(separator: " ")[1])
    }


}


