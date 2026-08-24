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
        // Bazı oyunlar geçersiz ürün listesini de kontrol eder, burayı boş geçiyoruz
        fakeResponse.setValue([String](), forKey: "invalidProductIdentifiers")
        
        delegates.forEach { $0.productsRequest(request, didReceive: fakeResponse) }
    }
    
    private func createMockProduct(withIdentifier identifier: String) -> SKProduct? {
        guard let productClass = NSClassFromString("SKProduct") as? NSObject.Type,
              let instance = productClass.init() as? SKProduct else {
            return nil
        }
        
        // Oyunun kontrol ettiği tüm kritik alanları dolduruyoruz
        instance.setValue(identifier, forKey: "productIdentifier")
        instance.setValue(NSDecimalNumber(string: "0.99"), forKey: "price")
        instance.setValue(Locale.current, forKey: "priceLocale")
        instance.setValue("Asasec Item", forKey: "localizedTitle")
        instance.setValue("Unlocked via Asasec IAP Hook", forKey: "localizedDescription")
        instance.setValue(true, forKey: "downloadable")
        instance.setValue([Int](), forKey: "downloadContentLengths")
        instance.setValue("", forKey: "downloadContentVersion")
        
        return instance
    }
}
