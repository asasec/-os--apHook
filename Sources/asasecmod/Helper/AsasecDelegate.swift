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
        if let internalRequest = try? request.value(forKey: "_productsRequestInternal") as AnyObject?,
           let identifiers = try? internalRequest?.value(forKey: "_productIdentifiers") as? Set<String> {
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
        guard let productClass = NSClassFromString("SKProduct") as? NSObject.Type,
              let product = productClass.alloc() as? SKProduct else {
            return nil
        }
        
        product.setValue(identifier, forKey: "productIdentifier")
        product.setValue(NSDecimalNumber(string: "0.99"), forKey: "price")
        product.setValue(Locale.current, forKey: "priceLocale")
        
        return product
    }
}
