import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    private var questionsAmount: Int = 10 // общее количество вопросов для квиза. Пусть оно будет равно десяти.
    private var questionFactory: QuestionFactoryProtocol? = QuestionFactory() // фабрика вопросов. Контроллер будет обращаться за вопросами к ней.
    private var currentQuestion: QuizQuestion? // вопрос, который видит пользователь.
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var gameCount = 0
    private var statisticService: StatisticService? = StatisticServiceImplementation()
    
    override func viewDidLoad() {
        questionFactory?.delegate = self
        questionFactory?.requestNextQuestion()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        super.viewDidLoad()
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    } 
        
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let givenAnswer = false
        guard let currentQuestion = currentQuestion else {return}
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let givenAnswer = true
        guard let currentQuestion = currentQuestion else {return}
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 { // 1
            // идём в состояние "Результат квиза"
            gameCount += 1
            self.statisticService?.store(correct: self.correctAnswers, total: questionsAmount)
            let alertPresenter = AlertPresenter(viewContoller: self)
            alertPresenter.show(
                quiz: AlertModels(
                    title: "Раунд завершён",
                    buttonText: "Сыграть ещё раз",
                    message: "Ваш результат \(correctAnswers)/10 \n Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0) \n Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(statisticService?.bestGame.total ?? 0) (\(statisticService?.bestGame.date ?? Date().dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0))%",
                    completion: {
//                        self.statisticSystemElementation?.store(correct: self.correctAnswers, total: 10)
                        self.currentQuestionIndex = 0
                        self.correctAnswers = 0
                        self.questionFactory?.requestNextQuestion()
                    })
            )
        } else { // 2
            
            currentQuestionIndex += 1
            // идём в состояние "Вопрос показан"
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func convert (model: QuizQuestion) -> QuizStepViewModel{
        return QuizStepViewModel(
            image: UIImage(named: model.image)  ?? UIImage (),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            
            questionFactory?.requestNextQuestion()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

// приватный метод, который меняет цвет рамки
// принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
// метод красит рамку
        
        if isCorrect {
            correctAnswers += 1
        }
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            self.imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            self.imageView.layer.borderWidth = 8
        }
        
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
           // код, который мы хотим вызвать через 1 секунду
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.imageView.layer.borderWidth = 0
            }
            self.showNextQuestionOrResults()
        }
        
    }
    

}


    
    

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
