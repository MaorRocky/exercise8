//
//  CellWithText.swift
//  exercise8PART1
//
//  Created by Scores_Main_User on 1/19/21.
//

import UIKit

class CellWithText: UITableViewCell
{

//    TODO ask why with constraints its not working

    public let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 70, height: 40))


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryView = textField
//        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .right
        textField.isUserInteractionEnabled = true
//        configure()

    }


    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }


    func configure()
    {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.widthAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }


    func setTextFieldText(text: Int)
    {
        self.textField.text = "\(text)"
    }

}


