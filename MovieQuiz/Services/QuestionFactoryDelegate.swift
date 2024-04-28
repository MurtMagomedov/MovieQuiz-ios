//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Муртазали Магомедов on 28.11.2023.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
