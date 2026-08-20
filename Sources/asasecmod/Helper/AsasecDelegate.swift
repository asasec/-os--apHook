import StoreKit

final class AsasecDelegate: NSObject, SKProductsRequestDelegate {
    static let shared: AsasecDelegate = .init()
    var delegates: [SKProductsRequestDelegate] = []
    
    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        // İstek atılan orijinal ürün ID'lerini güvenli yoldan alalım
        var identifiers: [String] = []
        if let internalReq = request.value(forKey: "_productsRequestInternal") as? NSObject,
           let productIds = internalReq.value(forKey: "_productIdentifiers") as? Set<String> {
            identifiers = Array(productIds)
        }
        
        // Eğer oyun ürün bulamadıysa veya liste eksikse, kendi sahte ürünlerimizi oluşturalım
        var finalProducts = response.products
        
        if finalProducts.isEmpty && !identifiers.isEmpty {
            finalProducts = identifiers.map { id in
                let product = SKProduct()
                product.setValue(id, forKey: "productIdentifier")
                product.setValue(0.01 as NSDecimalNumber, forKey: "price")
                product.setValue(Locale(identifier: "tr_TR"), forKey: "priceLocale")
                product.setValue("Açıklama", forKey: "localizedDescription")
                product.setValue("Ürün", forKey: "localizedTitle")
                return product
            }
        }
        
        // Sahte ürünleri içeren yeni bir yanıt nesnesi hazırlayalım
        let fakeResponse = SKProductsResponse()
        fakeResponse.setValue(finalProducts, forKey: "products")
        fakeResponse.setValue(response.invalidProductIdentifiers, forKey: "invalidProductIdentifiers")
        
        // Tüm delegelere bu yanıtı iletelim
        _ = delegates.map { $0.productsRequest(request, didReceive: fakeResponse) }
    }
}
