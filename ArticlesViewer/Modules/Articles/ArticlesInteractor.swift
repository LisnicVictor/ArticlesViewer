import Foundation

class ArticlesInteractor: ArticlesViewControllerOutput {
    weak var view: ArticlesViewControllerInput?
    let articleFetcher: ArticleFetching

    var articles = [Article]()

    init(view: ArticlesViewControllerInput, articleFetcher: ArticleFetching) {
        self.view = view
        self.articleFetcher = articleFetcher
    }
}

extension ArticlesInteractor {
    func viewDidLoad() {
        articleFetcher.fetchArticles { [weak self] result in
            switch result {
            case .success(let articles):
                self?.handleSuccess(with: articles)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func handleSuccess(with articles: [Article]) {
        self.articles = articles.sorted { $0.sortingOrder < $1.sortingOrder }
        DispatchQueue.main.async {
            self.view?.reloadData()
        }
    }

    func numberOfRows(in section: Int) -> Int {
        return articles.count
    }

    func viewModel(for indexPath: IndexPath) -> TextLableCellViewModel {
        let article = articles[indexPath.row]

        return TextLableCellViewModel(text: article.name)
    }

    func didSelectItem(at indexPath: IndexPath) {
        view?.routeToTags(with: articles[indexPath.row])
    }
}

