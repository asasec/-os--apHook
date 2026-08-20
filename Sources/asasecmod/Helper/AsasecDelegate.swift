import StoreKit

final class AsasecDelegate: NSObject, SKProductsRequestDelegate {
    static let shared: AsasecDelegate = .init()
    var delegates: [SKProductsRequestDelegate] = []
    var products: [SKProduct] = []
    
    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        // Eğer gelen yanıt boş değilse orijinal akışı bozmadan ilet
        guard response.products.isEmpty else {
            _ = delegates.map { $0.productsRequest(request, didReceive: response) }
            return
        }
        
        // Ürün listesini güvenli bir şekilde cache'leyip döndürelim
        if products.isEmpty {
            if let _request = request.value(forKey: "_productsRequestInternal") as? AnyObject,
               let _identifiers = _request.value(forKey: "_productIdentifiers") as? Set<String> {
                let identifiers: [String] = Array(_identifiers)
                
                products = identifiers.map { id in
                    let product = SKProduct()
                    // Çökmeyi önlemek için güvenli alanlar
                    product.setValue(id, forKey: "productIdentifier")
                    return product
                }
            }
        }
        
        let fakeResponse = SKProductsResponse()
        fakeResponse.setValue(products, forKey: "products")
        
        _ = delegates.map { $0.productsRequest(request, didReceive: fakeResponse) }
    }
}
