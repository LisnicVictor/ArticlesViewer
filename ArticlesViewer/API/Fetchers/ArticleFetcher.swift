import Foundation

protocol ArticleFetching {
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> ())
}

struct ArticleFetcher: ArticleFetching {

    private let requestSender: RequestSending

    init(requestSender: RequestSending) {
        self.requestSender = requestSender
    }

    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> ()) {
        let url = Endpoints.articles
        let request = URLRequest(url: url)
        requestSender.send(request: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return completion(.success([])) }
                completion([Article].result(jsonData: data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
