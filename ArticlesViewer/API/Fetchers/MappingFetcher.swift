import Foundation

protocol MappingFetching {
    func fecthMapping(with uuid: String, completion: @escaping (Result<[Mapping], Error>) -> ())
}

final class MappingFetcher: MappingFetching {
    private let requestSender: RequestSending

    init(requestSender: RequestSending) {
        self.requestSender = requestSender
    }

    func fecthMapping(with uuid: String, completion: @escaping (Result<[Mapping], Error>) -> ()) {
        let url = Endpoints.mapping(with: uuid)
        let request = URLRequest(url: url)
        requestSender.send(request: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return completion(.success([])) }
                completion([Mapping].result(jsonData: data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
