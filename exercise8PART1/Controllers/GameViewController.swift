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

    /*****************************/

    let boxView: UIView = UIView()
    let competitionLabel: UILabel = UILabel()
    let homeLabel: UILabel = UILabel()
    let awayLabel: UILabel = UILabel()
    let gameStartTimeLabel: UILabel = UILabel()
    let gameCurrentTime: UILabel = UILabel()

    var homeScoreViewAndLabel: UIView = UIView()
    var awayScoreViewAndLabel: UIView = UIView()

    let homeScoreLabel: UILabel = UILabel()
    let awayScoreLabel: UILabel = UILabel()


    init(supportCacheValue: Bool, values: [Int])
    {

        self.initialValues = values

        gameManager = GameDataManager(isSupportCache: supportCacheValue, cachePeriod: values[0], updateFrequency: values[1], gameId: values[2])

        super.init(nibName: nil, bundle: nil)

        creatUI()
    }


    required init?(coder: NSCoder)
    {
        fatalError("init(coder:)")
    }


    override func loadView()
    {
        super.loadView()
        view.backgroundColor = .white
//        creatUI()

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

        boxView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(boxView)
        boxView.backgroundColor = .lightGray


        boxView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        boxView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true

        boxView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        boxView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true


        boxView.addSubview(competitionLabel)
        competitionLabel.translatesAutoresizingMaskIntoConstraints = false
        competitionLabel.text = "TEXTTEXT"
        competitionLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor).isActive = true
        competitionLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: 10).isActive = true


        homeLabel.translatesAutoresizingMaskIntoConstraints = false
        awayLabel.translatesAutoresizingMaskIntoConstraints = false

        boxView.addSubview(homeLabel)
        boxView.addSubview(awayLabel)


        homeLabel.text = "HOMEHOME"
        homeLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10).isActive = true
        homeLabel.centerYAnchor.constraint(equalTo: boxView.centerYAnchor, constant: 60).isActive = true

        awayLabel.text = "WAYAWAY"
        awayLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10).isActive = true
        awayLabel.topAnchor.constraint(equalTo: homeLabel.bottomAnchor, constant: 40).isActive = true

        gameStartTimeLabel.text = "16:40"
        gameStartTimeLabel.font = .systemFont(ofSize: 22)
        boxView.addSubview(gameStartTimeLabel)
        gameStartTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        gameStartTimeLabel.centerXAnchor.constraint(equalTo: boxView.centerXAnchor).isActive = true
        gameStartTimeLabel.centerYAnchor.constraint(equalTo: boxView.centerYAnchor, constant: -50).isActive = true


        gameCurrentTime.text = "20"
        boxView.addSubview(gameCurrentTime)
        gameCurrentTime.translatesAutoresizingMaskIntoConstraints = false
        gameCurrentTime.textColor = .red
        gameCurrentTime.centerXAnchor.constraint(equalTo: boxView.centerXAnchor).isActive = true
        gameCurrentTime.centerYAnchor.constraint(equalTo: gameStartTimeLabel.centerYAnchor, constant: 30).isActive = true


        boxView.addSubview(homeScoreViewAndLabel)
        boxView.addSubview(awayScoreViewAndLabel)


        homeScoreViewAndLabel.backgroundColor = .black
        homeScoreViewAndLabel.translatesAutoresizingMaskIntoConstraints = false

        homeScoreViewAndLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        homeScoreViewAndLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        homeScoreViewAndLabel.layer.cornerRadius = 10

        homeScoreViewAndLabel.addSubview(homeScoreLabel)
        homeScoreLabel.text = "1"
        homeScoreLabel.centerWith(to: homeScoreViewAndLabel)
        homeScoreLabel.textColor = .white


        awayScoreViewAndLabel.backgroundColor = .black
        awayScoreViewAndLabel.translatesAutoresizingMaskIntoConstraints = false

        awayScoreViewAndLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        awayScoreViewAndLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        awayScoreViewAndLabel.layer.cornerRadius = 10

        awayScoreViewAndLabel.addSubview(awayScoreLabel)
        awayScoreLabel.text = "1"
        awayScoreLabel.centerWith(to: awayScoreViewAndLabel)
        awayScoreLabel.textColor = .white


        homeScoreViewAndLabel.centerYAnchor.constraint(equalTo: homeLabel.centerYAnchor).isActive = true
        homeScoreViewAndLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80).isActive = true

        awayScoreViewAndLabel.centerYAnchor.constraint(equalTo: awayLabel.centerYAnchor).isActive = true
        awayScoreViewAndLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80).isActive = true


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
        self.updateGameUIWithGameData()
        self.updateCompetitionsUIWithGameData()

    }


    func gameDataManager(_ didFailToLoadDataWithError: Error?, _ manager: GameDataManager)
    {
        print(didFailToLoadDataWithError!)
    }


    func updateGameUIWithGameData()
    {


        DispatchQueue.main.async
        { [self] in


            guard let game: Game = gamaData?.games.first else
            {
                return
            }


            if game.comps.count > 1
            {

                homeLabel.text = gamaData?.games.first?.comps.first?.name

                awayLabel.text = self.gamaData?.games.first?.comps[1].name
            }


            if game.stime != "noValue"
            {
                gameStartTimeLabel.text = self.getStartTimeFrom_STime(from: game.stime)
            }


            if game.scrs.count > 1
            {

                let homeScore = game.scrs[0]
                let awayScore = game.scrs[1]

                homeScoreLabel.text = homeScore < 0 ? "0" : "\(Int(homeScore))"

                awayScoreLabel.text = awayScore < 0 ? "0" : "\(Int(awayScore))"
            }

            if game.gtd != "noGtd"
            {
                gameCurrentTime.text = game.gtd
            }


        }

    }


    func updateCompetitionsUIWithGameData()
    {
        DispatchQueue.main.async
        { [self] in

            guard let competition: [Competition] = gamaData?.competitions else
            {
                return
            }

            if let competitionName = competition.first?.name
            {
                if competitionName != "noName"
                {
                    competitionLabel.text = competitionName
                }
            }

        }
    }


    func getStartTimeFrom_STime(from stime: String) -> String
    {
        return String(stime.split(separator: " ")[1])
    }


}


