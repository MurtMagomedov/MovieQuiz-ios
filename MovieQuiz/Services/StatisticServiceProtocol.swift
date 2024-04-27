//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Муртазали Магомедов on 27.04.2024.
//
import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    var totalAnswerAll: Int { get set }
    var corectAnswerAll: Int { get set }

    func store(correct count: Int, total amount: Int)
}
