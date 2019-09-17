import Foundation

struct ServerError: Decodable, Error {
    let message: String

    var localizedDescription: String {
        return message
    }
}

protocol RequestSending {
    func send(request: URLRequest, completion: @escaping (Result<Data?, Error>) -> ())
}

struct RequestSender: RequestSending {
    func send(request: URLRequest, completion: @escaping (Result<Data?, Error>) -> ()) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode, 500...599 ~= statusCode {
                completion(.failure(ServerError(message: "Server is down, keep trying..")))
            } else {
                completion(.success(data))
            }
        }.resume()
    }
}
