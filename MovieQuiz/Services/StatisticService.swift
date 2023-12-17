//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Муртазали Магомедов on 05.12.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    //метод сохранения текущего результата игры
    func store(correct count: Int, total amount: Int)
}
