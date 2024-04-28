//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Муртазали Магомедов on 27.04.2024.
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert (quiz result: AlertModel)
}
