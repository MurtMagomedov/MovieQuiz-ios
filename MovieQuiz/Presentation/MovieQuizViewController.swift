import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    // MARK: - Lifecycle
    
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    private let presenter = MovieQuizPresenter()
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private var questionFactory: QuestionFactoryProtocol?// фабрика вопросов. Контроллер будет обращаться за вопросами к ней.
    private var currentQuestion: QuizQuestion? // вопрос, который видит пользователь.
    private var correctAnswers = 0
    private var gameCount = 0
    private var statisticService: StatisticService? = StatisticServiceImplementation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        showLoadingIndicator()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
    }
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        let viewModel = presenter.convert(model: question!)
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        let givenAnswer = false
        guard let currentQuestion = currentQuestion else {return}
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        self.noButton.isEnabled = false
        self.yesButton.isEnabled = false
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let givenAnswer = true
        guard let currentQuestion = currentQuestion else {return}
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        self.yesButton.isEnabled = false
        self.noButton.isEnabled = false
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
        if presenter.isLastQuestion() { // 1
            // идём в состояние "Результат квиза"
            gameCount += 1
            self.statisticService?.store(correct: self.correctAnswers, total: presenter.questionsAmount)
            let alertPresenter = AlertPresenter(viewContoller: self)
            alertPresenter.show(
                quiz: AlertModel(
                    title: "Раунд завершён",
                    message: "Ваш результат \(correctAnswers)/10 \n Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0) \n Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(statisticService?.bestGame.total ?? 0) (\(statisticService?.bestGame.date ?? Date().dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0.0))%", 
                    buttonText: "Сыграть ещё раз",
                    completion: {
                        //                        self.statisticSystemElementation?.store(correct: self.correctAnswers, total: 10)
                        self.presenter.resetQuestionIndex()
                        self.correctAnswers = 0
                        self.questionFactory?.requestNextQuestion()
                    })
            )
        } else { // 2
            
            presenter.switchToNextQuestion()
            // идём в состояние "Вопрос показан"
            questionFactory?.requestNextQuestion()
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // возьмём в качестве сообщения описание ошибки
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор больше не скрыт
        activityIndicator.startAnimating() // Включаем анимацию
    }
    
    private func showNetworkError(message: String) {
        
        let model = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let modelButton = UIAlertAction(title: "Return", style: .default, handler: { _ in
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
//            self.viewDidLoad()
        })
        
        model.addAction(modelButton)
        present(model, animated: true, completion: nil)
//                alertPresenter.show(in: self, model: model)
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
                self?.yesButton.isEnabled = true
                self?.noButton.isEnabled = true
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
