
import Foundation
class subscriptionPurchaseViewModel {
  
    func postSubscription(productId: String,transactionIdentifier: String,transactionDate: String, transactionState: String, productPrice: String,productPriceLocal: String,productPurchaseCurrencyCode: String,planType: String, completion: @escaping (Result<subscriptionPurchaseResponse, Error>) -> Void) {
        let userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""

        APIManager.shared.postSubscriptionInfoNew(
            userID: userId,
            productId: productId,
            transactionIdentifier: transactionIdentifier,
            transactionDate: transactionDate,
            transactionState: transactionState,
            productPrice: productPrice,
            productPriceLocal: productPriceLocal,
            productPurchaseCurrencyCode: productPurchaseCurrencyCode,
            planType: planType,
            isCancelled: strCancelled
        ) { result in
            switch result {
            case .success(let json):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let response = try JSONDecoder().decode(subscriptionPurchaseResponse.self, from: jsonData)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postCancelSubscriptionInfo(isCancelled: String, completion: @escaping (Result<subscriptionPurchaseResponse, Error>) -> Void) {
        let userId = AppUserDefaults.object(forKey: "USERID") as? String ?? ""

        APIManager.shared.postSubscriptionCancelledInfo(
            userID: userId,
            isCancelled: isCancelled
        ) { result in
            switch result {
            case .success(let json):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                    let response = try JSONDecoder().decode(subscriptionPurchaseResponse.self, from: jsonData)
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
