import Foundation
import Combine

public class APIServiceCombine {
    
    
    public static let shared = APIServiceCombine()
    var cancellable = Set<AnyCancellable>()
    public enum APIError: Error {
        case error(_ errorString: String)
    }
    
    public func getJSON<T: Decodable>(urlString: String,
                                      dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                      keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys ,
                                      completion: @escaping (Result<T, APIError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.error("Error: Invalid URL")))
            return
        }
        
        let request = URLRequest(url: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        //MARK: - With Combine Framework
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .sink { (taskCompletion) in
                switch taskCompletion {
                
                case .finished: //received the decodedData without any errors, then the receiveValue closure will execute
                    return
                case .failure(let decodingError):
                    completion(.failure(APIError.error("Error: \(decodingError.localizedDescription)")))
                }
            } receiveValue: { (decodedData) in
                completion(.success(decodedData))
            }
            
            .store(in: &cancellable)
        
        
        
        
        //MARK: - API Service Without Combine
        
        //        URLSession.shared.dataTask(with: request) { (data, response, error) in
        //            if let err = error {
        //                completion(.failure(.error("Error: \(err.localizedDescription)")))
        //                return
        //            }
        //
        //
        //            guard let data = data else {
        //                completion(.failure(.error(NSLocalizedString("Error: Data us corrupt.", comment: ""))))
        //                return
        //            }
        //
        //            let decoder = JSONDecoder()
        //            decoder.dateDecodingStrategy = dateDecodingStrategy
        //            decoder.keyDecodingStrategy = keyDecodingStrategy
        //
        //
        //            do {
        //                let decodedData = try decoder.decode(T.self, from: data)
        //                completion(.success(decodedData))
        //                return
        //            } catch let decodingError {
        //                completion(.failure(APIError.error("Error: \(decodingError.localizedDescription)")))
        //                return
        //            }
        //
        //        }.resume()
        
    }
}
