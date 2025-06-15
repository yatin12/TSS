
import Foundation

struct paypalNonceSubmitRequest: Encodable {
    let userId: String
    let Nonce: String
}

@MainActor
class paypalNonceSubmitViewModel: ObservableObject {
    @Published var objPaypalNonceSubmitResponse: paypalNonceSubmitResponse?
    var errorMessage: String?
    var showAlert = false

    func submitPaypalNonceDetails(userId: String, Nonce: String) async -> paypalNonceSubmitResponse? {
      
      //  isLoading = true

        let submitData = paypalNonceSubmitRequest(
            userId: userId,
            Nonce: Nonce
        )
        
        guard let parameters = submitData.parseHandler() else {
            self.errorMessage = "Failed to encode login data"
            self.showAlert = true
          //  self.isLoading = false
            return nil
        }

        do {
            let response: paypalNonceSubmitResponse = try await APIHandler.shared.request(
                url: "\(APIConfig.baseURL + paypalNonceEndpoint)",
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
