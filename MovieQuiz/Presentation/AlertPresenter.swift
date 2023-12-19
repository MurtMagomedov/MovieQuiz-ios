//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Муртазали Магомедов on 28.11.2023.
//

import UIKit

class AlertPresenter {
    weak var viewContoller: UIViewController?
    
    init(viewContoller: UIViewController) {
        self.viewContoller = viewContoller
    }
    
    private var questionFactory: QuestionFactoryProtocol? = QuestionFactory()
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    func show(quiz result: AlertModels) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            result.completion()
            guard let self = self else { return }
            self.questionFactory?.requestNextQuestion()
        }
        
        alert.addAction(action)
        
        viewContoller?.present(alert, animated: true, completion: nil)
    }
}
