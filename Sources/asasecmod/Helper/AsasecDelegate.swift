import Foundation
import StoreKit

final class AsasecDelegate: NSObject, SKProductsRequestDelegate {
    static let shared: AsasecDelegate = .init()
    var delegates: [SKProductsRequestDelegate] = []
    var cachedProducts: [String: SKProduct] = [:]
    
    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        guard response.products.isEmpty else {
            delegates.forEach { $0.productsRequest(request, didReceive: response) }
            return
        }
        
        var productIdentifiers: [String] = []
        if let internalRequest = request.value(forKey: "_productsRequestInternal") as AnyObject?,
           let identifiers = internalRequest.value(forKey: "_productIdentifiers") as? Set<String> {
            productIdentifiers = Array(identifiers)
        }
        
        guard !productIdentifiers.isEmpty else {
            delegates.forEach { $0.productsRequest(request, didReceive: response) }
            return
        }
        
        var generatedProducts: [SKProduct] = []
        for id in productIdentifiers {
            if let existing = cachedProducts[id] {
                generatedProducts.append(existing)
            } else if let mockProduct = createMockProduct(withIdentifier: id) {
                cachedProducts[id] = mockProduct
                generatedProducts.append(mockProduct)
            }
        }
        
        let fakeResponse = SKProductsResponse()
        fakeResponse.setValue(generatedProducts, forKey: "products")
        
        delegates.forEach { $0.productsRequest(request, didReceive: fakeResponse) }
    }
    
    private func createMockProduct(withIdentifier identifier: String) -> SKProduct? {
        // SKProduct doğrudan init edilemez, runtime üzerinden güvenli türetme
        guard let productClass = NSClassFromString("SKProduct") else {
            return nil
        }
        
        let unsafePtr = Unmanaged.passUnretained(productClass).toOpaque()
        let typedClass = unsafeBitCast(unsafePtr, to: NSObject.Type.classType())
        
        // Swift derleyicisine takılmadan güvenli nesne oluşturma
        let obj = typedClass.init()
        guard let product = obj as? SKProduct else {
            return nil
        }
        
        product.setValue(identifier, forKey: "productIdentifier")
        product.setValue(NSDecimalNumber(string: "0.99"), forKey: "price")
        product.setValue(Locale.current, forKey: "priceLocale")
        
        return product
    }
}
