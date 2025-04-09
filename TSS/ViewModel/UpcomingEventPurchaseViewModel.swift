
import Foundation
class UpcomingEventPurchaseViewModel {

    func postUpcomingEventPurchaseInfo(postid: String, productId: String,transactionIdentifier: String,transactionDate: String, transactionState: String, productPrice: String,productPriceLocal: String,productPurchaseCurrencyCode: String, completion: @escaping (Result<upcomingEventPurchaseResponse, Error>) -> Void) {
        let userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""

        APIManager.shared.postUpcomingEventPurchaseInfo(
            userID: userId,
            postid: postid,
            productId: productId,
            transactionIdentifier: transactionIdentifier,
            transactionDate: transactionDate,
            transactionState: transactionState,
            productPrice: productPrice,
            productPriceLocal: productPriceLocal,
            productPurchaseCurrencyCode: productPurchaseCurrencyCode,
            isCancelled: strCancelled
        ) { result in
            switch result {
            case .success(let json):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let response = try JSONDecoder().decode(upcomingEventPurchaseResponse.self, from: jsonData)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
