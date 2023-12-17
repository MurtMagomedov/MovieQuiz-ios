//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Муртазали Магомедов on 28.11.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
} 
