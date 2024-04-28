//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Муртазали Магомедов on 27.11.2023.
//

import Foundation

protocol QuestionFactoryProtocol {
    var delegate: QuestionFactoryDelegate? { get set }
    func requestNextQuestion()
    func loadData()
}
