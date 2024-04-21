//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Муртазали Магомедов on 05.12.2023.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    private var userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case total, bestGame, correct, gamesCount
    }
        //точность ответов в процентах
    var totalAccuracy: Double {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.total.rawValue),
                let total = try? JSONDecoder().decode(Double.self, from: data) else {
                return 0.0
            }
            return total
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.total.rawValue)
        }
    }
        //результат игры
    var gamesCount: Int {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                let count = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            
            return count
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
        //рекорд
    var bestGame: GameRecord {
        get {
            guard
                let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date().dateTimeString)
            }

            return record
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        if bestGame.correct < count {
            bestGame = GameRecord(correct: count, total: amount, date: Date().dateTimeString)
        }

        totalAccuracy = (Double(count)/Double(amount) * 100)
        
    }
    
    
}
