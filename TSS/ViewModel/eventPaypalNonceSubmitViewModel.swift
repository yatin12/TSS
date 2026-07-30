
import Foundation

struct eventPaypalNonceSubmitRequest: Encodable {
    let userId: String
    let Nonce: String
    let amount: String
    let productID: String
}

@MainActor
class eventPaypalNonceSubmitViewModel: ObservableObject {
    @Published var objPaypalNonceSubmitResponse: eventPaypalNonceSubmitResponse?
    var errorMessage: String?
    var showAlert = false

    func submitEventPaypalNonceDetails(userId: String, Nonce: String, strAmount: String, strProductID: String) async -> eventPaypalNonceSubmitResponse? {
      
      //  isLoading = true

        let submitData = eventPaypalNonceSubmitRequest(
            userId: userId,
            Nonce: Nonce,
            amount: strAmount,
            productID: strProductID
        )
        
        guard let parameters = submitData.parseHandler() else {
            self.errorMessage = "Failed to encode login data"
            self.showAlert = true
          //  self.isLoading = false
            return nil
        }

        do {
            let response: eventPaypalNonceSubmitResponse = try await APIHandler.shared.request(
                url: "\(APIConfig.baseURL + eventPaypalNonceEndpoint)",
                method: .post,
                parameters: parameters
            )

          //  self.isLoading = false
            self.objPaypalNonceSubmitResponse = response
            self.showAlert = false

            print("Decoded MirrorModel: \(response)")

            return response
        } catch let error as APIErrorSwiftUI {
           // self.isLoading = false
            self.errorMessage = error.localizedDescription
            self.showAlert = true
            return nil
        } catch {
          //  self.isLoading = false
            self.errorMessage = "An unknown error occurred"
            self.showAlert = true
            return nil
        }
    }
}
