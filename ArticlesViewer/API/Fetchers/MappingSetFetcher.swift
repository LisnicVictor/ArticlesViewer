import Foundation

protocol MappingSetFetching {
    func fecthMappingSet(completion: @escaping (Result<[MappingSet], Error>) -> ())
}

final class MappingSetFetcher: MappingSetFetching {
    private let requestSender: RequestSending

    init(requestSender: RequestSending) {
        self.requestSender = requestSender
    }

    func fecthMappingSet(completion: @escaping (Result<[MappingSet], Error>) -> ()) {
        let url = Endpoints.mappingSets
        let request = URLRequest(url: url)
        requestSender.send(request: request) { result in
            switch result {
            case .success(let data):
                guard let data = data else { return completion(.success([])) }
                completion([MappingSet].result(jsonData: data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
