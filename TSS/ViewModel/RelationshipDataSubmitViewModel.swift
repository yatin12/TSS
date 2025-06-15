
import Foundation

struct relationshipDataSubmitRequest: Encodable {
    let userId: String
    let feminine_energy: String
    let relationship_status: String
    let coaching_session: String
    let energy_package: String
    let IAgree_RelationShip: String
}

@MainActor
class RelationshipDataSubmitViewModel: ObservableObject {
    @Published var objRelationshipDataSubmitResponse: RelationshipDataSubmitResponse?
    var errorMessage: String?
    var isLoading = false
    var showAlert = false

    func submitRelationshipDetails(userId: String, feminine_energy: String, relationship_status: String, coaching_session: String, energy_package: String, IAgree_RelationShip: String) async -> RelationshipDataSubmitResponse? {
      
        isLoading = true

        let submitData = relationshipDataSubmitRequest(
            userId: userId,
            feminine_energy: feminine_energy,
            relationship_status: relationship_status,
            coaching_session: coaching_session,
            energy_package: energy_package,
            IAgree_RelationShip: IAgree_RelationShip
        )
        
        guard let parameters = submitData.parseHandler() else {
            self.errorMessage = "Failed to encode login data"
            self.showAlert = true
            self.isLoading = false
            return nil
        }

        do {
            let response: RelationshipDataSubmitResponse = try await APIHandler.shared.request(
                url: "\(APIConfig.baseURL + relationshipDataSubmitEndpoint)",
                method: .post,
                parameters: parameters
            )

            self.isLoading = false
            self.objRelationshipDataSubmitResponse = response
            self.showAlert = false

            print("Decoded MirrorModel: \(response)")

            return response
        } catch let error as APIErrorSwiftUI {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
            self.showAlert = true
            return nil
        } catch {
            self.isLoading = false
            self.errorMessage = "An unknown error occurred"
            self.showAlert = true
            return nil
        }
    }
}


