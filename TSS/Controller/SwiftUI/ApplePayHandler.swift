import PassKit
import BraintreeCore
import BraintreeApplePay

class ApplePayHandler: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    
    private var braintreeClient: BTAPIClient
    private var nonceHandler: (String) -> Void
    private var completion: (Bool) -> Void
    
    init(braintreeClient: BTAPIClient,
         nonceHandler: @escaping (String) -> Void,
         completion: @escaping (Bool) -> Void) {
        self.braintreeClient = braintreeClient
        self.nonceHandler = nonceHandler
        self.completion = completion
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completionHandler: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        let applePayClient = BTApplePayClient(apiClient: braintreeClient)
        
        applePayClient.tokenize(payment) { nonce, error in
            if let nonce = nonce {
                print("✅ Tokenization succeeded! Nonce: \(nonce.nonce)")
                self.nonceHandler(nonce.nonce) // Send nonce back
                completionHandler(PKPaymentAuthorizationResult(status: .success, errors: nil))
                self.completion(true)
            } else {
                print("❌ Tokenization failed. Error: \(error?.localizedDescription ?? "Unknown error")")
                completionHandler(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                self.completion(false)
            }
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}


/*
import PassKit
import BraintreeCore
import BraintreeApplePay

class ApplePayHandler: NSObject, PKPaymentAuthorizationViewControllerDelegate {
    private var braintreeClient: BTAPIClient
    private var completion: (Bool) -> Void

    init(braintreeClient: BTAPIClient, completion: @escaping (Bool) -> Void) {
        self.braintreeClient = braintreeClient
        self.completion = completion
    }

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            handler completionHandler: @escaping (PKPaymentAuthorizationResult) -> Void) {
        let applePayClient = BTApplePayClient(apiClient: braintreeClient)

        applePayClient.tokenize(payment) { nonce, error in
            if let nonce = nonce {
                print("✅ Tokenization succeeded! Nonce: \(nonce.nonce)")
                completionHandler(PKPaymentAuthorizationResult(status: .success, errors: nil))
                self.completion(true)
            } else {
                print("❌ Tokenization failed. Error: \(error?.localizedDescription ?? "Unknown error")")
                completionHandler(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                self.completion(false)
            }
        }
    }


    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
}
*/
