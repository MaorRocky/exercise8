//
//  ViewController.swift
//  exercise8PART1
//
//  Created by Scores_Main_User on 1/19/21.
//

import UIKit

class ViewController: UIViewController
{

    let tableView = UITableView()

    var rowNamesArr: [String] = ["Support cache", "Updates frequency", "Game ID", "Show Game"]

    var values: [Int] = []

    let tagDict: [String: Int] = ["Updates frequency": 1, "Game ID": 2, "Cache validity period": 0]

    var cacheSwitch: Bool = false

    let userStorageManager: UserStorageManager = UserStorageManager.instance


    override func viewDidLoad()
    {
        super.viewDidLoad()


        NotificationCenter.default.addObserver(self,
                selector: #selector(handleTerminationOrBackground),
                name: UIApplication.willTerminateNotification,
                object: nil)

        NotificationCenter.default.addObserver(self,
                selector: #selector(handleTerminationOrBackground),
                name: UIApplication.didEnterBackgroundNotification,
                object: nil)


        NotificationCenter.default.addObserver(self,
                selector: #selector(applicationDidBecomeActive),
                name: UIApplication.didBecomeActiveNotification,
                object: nil)


        self.setupTableView()

        tableView.delegate = self
        tableView.dataSource = self


        self.updateValuesArrayAndCacheToggle()
    }


    @objc func applicationDidBecomeActive()
    {
        self.userStorageManager.loadFromUserDefaults()
        self.updateValuesArrayAndCacheToggle()

    }


    @objc func handleTerminationOrBackground()
    {
        self.userStorageManager.saveToUserDefaults(isCacheSupported: cacheSwitch, values: values)

    }


    func updateValuesArrayAndCacheToggle()
    {
        self.values = [userStorageManager.cachePeriod, userStorageManager.updateFrequency, userStorageManager.gameId]
        self.cacheSwitch = userStorageManager.isCacheSupported
    }


    func setupTableView()
    {
        self.view.addSubview(tableView)
        self.tableView.pin(to: view)

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.register(CellWithText.self, forCellReuseIdentifier: "textCell")
    }


}


extension ViewController: UITableViewDelegate
{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        guard let cell: UITableViewCell = tableView.cellForRow(at: indexPath) else
        {
            return
        }

        guard let cellText: String = cell.textLabel?.text else
        {
            return
        }


        if (cellText == "Show Game")
        {
            let vc = GameViewController(supportCacheValue: self.cacheSwitch, values: self.values)

            self.navigationController?.pushViewController(vc, animated: true)
        }

    }


    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 75
    }
}

extension ViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.rowNamesArr.count
    }


    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell

        let rowName: String = self.rowNamesArr[indexPath.row]

        if indexPath.row == 0
        {
            let mySwitch: UISwitch = UISwitch()
            mySwitch.addTarget(self, action: #selector(didChangeSwitch(_:)), for: .valueChanged)
            mySwitch.setOn(self.cacheSwitch, animated: false)

            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.accessoryView = mySwitch


        }
        else if indexPath.row < self.rowNamesArr.count - 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! CellWithText


            (cell as! CellWithText).textField.delegate = self

            if let tagNumber = self.tagDict[rowName]
            {
                (cell as! CellWithText).textField.tag = tagNumber

            }

            if rowNamesArr.count < 5
            {
                (cell as! CellWithText).setTextFieldText(text: values[indexPath.row])

            }
            else
            {
                (cell as! CellWithText).setTextFieldText(text: values[indexPath.row - 1])

            }

        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        }
        cell.textLabel?.text = rowName

        return cell

    }


    @objc func didChangeSwitch(_ sender: UISwitch)
    {
        if sender.isOn
        {
            let newIndexPath: IndexPath = IndexPath(row: 1, section: 0)
            self.rowNamesArr.insert("Cache validity period", at: 1)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            self.cacheSwitch = true
        }
        else
        {
            self.rowNamesArr.remove(at: 0)
            let indexPath = IndexPath(item: 1, section: 0)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.cacheSwitch = false
        }
    }


}

extension ViewController: UITextFieldDelegate
{
    public func textFieldDidEndEditing(_ textField: UITextField)
    {
        if let text: String = textField.text
        {
            self.values[textField.tag] = Int(text)!
        }
        self.userStorageManager.saveToUserDefaults(isCacheSupported: cacheSwitch, values: values)

    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.endEditing(true)
        print(textField.text!)
        self.userStorageManager.saveToUserDefaults(isCacheSupported: cacheSwitch, values: values)
        return true
    }


}

