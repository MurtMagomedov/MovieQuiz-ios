//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Муртазали Магомедов on 26.04.2024.
//

import Foundation
import UIKit
//
//final class MovieQuizPresenter {
//    let questionsAmount: Int = 10
//    private var currentQuestionIndex: Int = 0
//    
//    func isLastQuestion() -> Bool {
//        currentQuestionIndex == questionsAmount - 1
//    }
//    
//    func resetQuestionIndex() {
//        currentQuestionIndex = 0
//    }
//    
//    func switchToNextQuestion() {
//        currentQuestionIndex += 1
//    }
//    
//    func convert (model: QuizQuestion) -> QuizStepViewModel{
//        return QuizStepViewModel(
//            image: UIImage(data: model.image)  ?? UIImage (),
//            question: model.text,
//            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
//        )
//    }
//    
//    var currentQuestion: QuizQuestion?
//    weak var viewController: MovieQuizViewController?
//    
//    func yesButtonClicked() {
//        didAnswer(isYes: true)
//    }
//    
//    func noButtonClicked() {
//        didAnswer(isYes: false)
//    }
//    
//    private func didAnswer(isYes: Bool) {
//        let givenAnswer = isYes
//        guard let currentQuestion = currentQuestion else {return}
//        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
//        viewController?.noButton.isEnabled = false
//        viewController?.yesButton.isEnabled = false
//    }
//    
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        guard let question = question else {
//            return
//        }
//        let viewModel = convert(model: question)
//        currentQuestion = question
//        DispatchQueue.main.async { [weak self] in
//            self?.viewController?.show(quiz: viewModel)
//        }
//    }
////    
////    func showNextQuestionOrResults() {
////        if isLastQuestion() { // 1
////            // идём в состояние "Результат квиза"
////            viewController?.gameCount += 1
////            self.viewController?.statisticService?.store(correct: viewController!.correctAnswers, total: questionsAmount)
////            let alertPresenter = AlertPresenter(viewContoller: MovieQuizViewController())
////            alertPresenter.show(
////                quiz: AlertModel(
////                    title: "Раунд завершён",
////                    message: "Ваш результат \(viewController?.correctAnswers)/10 \n Количество сыгранных квизов: \(viewController?.statisticService?.gamesCount ?? 0) \n Рекорд: \(viewController?.statisticService?.bestGame.correct ?? 0)/\(viewController?.statisticService?.bestGame.total ?? 0) (\(viewController?.statisticService?.bestGame.date ?? Date().dateTimeString)) \n Средняя точность: \(String(format: "%.2f", viewController?.statisticService?.totalAccuracy ?? 0.0))%",
////                    buttonText: "Сыграть ещё раз",
//////                    buttonText: "Сыграть ещё раз",
////                    completion: {
////                        //                        self.statisticSystemElementation?.store(correct: self.correctAnswers, total: 10)
////                        self.resetQuestionIndex()
////                        self.viewController?.correctAnswers = 0
////                        self.viewController?.questionFactory?.requestNextQuestion()
////                    })
////            )
////        } else { // 2
////            
////            switchToNextQuestion()
////            // идём в состояние "Вопрос показан"
////            viewController?.questionFactory?.requestNextQuestion()
////        }
////    }
////    func showAnswerResult(isCorrect: Bool) {
////        // метод красит рамку
////        
////        if isCorrect {
////            viewController?.correctAnswers += 1
////        }
////        UIView.animate(withDuration: 0.5) { [weak self] in
////            guard let self = self else { return }
////            viewController?.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
////            viewController?.imageView.layer.borderWidth = 8
////        }
////        
////        // запускаем задачу через 1 секунду c помощью диспетчера задач
////        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
////            // код, который мы хотим вызвать через 1 секунду
////            UIView.animate(withDuration: 0.2) { [weak self] in
////                self?.viewController?.imageView.layer.borderWidth = 0
////                self?.viewController?.yesButton.isEnabled = true
////                self?.viewController?.noButton.isEnabled = true
////            }
////            self.showNextQuestionOrResults()
////        }
////    }
//}
