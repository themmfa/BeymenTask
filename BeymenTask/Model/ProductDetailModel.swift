import Foundation

// MARK: - Products

struct ProductDetails: Decodable {
    let result: ProductDetail?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - Result

struct ProductDetail: Decodable {
    let productID: Int?
    let externalSystemCode, displayName: String?
    let description: Description?
    let estimatedSupplyDate: JSONNull?
    let brandName, actualPriceText: String?
    let actualPrice: Double?
    let isStrikeThroughPriceExist: Bool?
    let strikeThroughPriceText: String?
    let strikeThroughPrice: Double?
    let discountRateText: String?
    let isVatIncluded: Bool?
    let vatRate: Int?
    let hasHopiParacik: Bool?
    let hopiParacikText: JSONNull?
    let isPreOrder, hasQuantitySelector, isCosmeticProduct, isBanned: Bool?
    let isGiftCard, isAppWidgetNotShown: Bool?
    let images, otherColorList: [JSONAny]?
    let tagAttributes: JSONNull?
    let installment, contentURL, categoryLink, brandLink: BrandLink?
    let shareURL: String?
    let sizeSystem: JSONNull?
    let gtmModel: BrandLink?
    let categoryID: Int?
    let categoryName, breadcrumbCategory, list: String?
    let seller: BrandLink?
    let maxProductQuantityCanSold: JSONNull?

    enum CodingKeys: String, CodingKey {
        case productID = "ProductId"
        case externalSystemCode = "ExternalSystemCode"
        case displayName = "DisplayName"
        case description = "Description"
        case estimatedSupplyDate = "EstimatedSupplyDate"
        case brandName = "BrandName"
        case actualPriceText = "ActualPriceText"
        case actualPrice = "ActualPrice"
        case isStrikeThroughPriceExist = "IsStrikeThroughPriceExist"
        case strikeThroughPriceText = "StrikeThroughPriceText"
        case strikeThroughPrice = "StrikeThroughPrice"
        case discountRateText = "DiscountRateText"
        case isVatIncluded = "IsVatIncluded"
        case vatRate = "VatRate"
        case hasHopiParacik = "HasHopiParacik"
        case hopiParacikText = "HopiParacikText"
        case isPreOrder = "IsPreOrder"
        case hasQuantitySelector = "HasQuantitySelector"
        case isCosmeticProduct = "IsCosmeticProduct"
        case isBanned = "IsBanned"
        case isGiftCard = "IsGiftCard"
        case isAppWidgetNotShown = "IsAppWidgetNotShown"
        case images = "Images"
        case otherColorList = "OtherColorList"
        case tagAttributes = "TagAttributes"
        case installment = "Installment"
        case contentURL = "ContentUrl"
        case categoryLink = "CategoryLink"
        case brandLink = "BrandLink"
        case shareURL = "ShareUrl"
        case sizeSystem = "SizeSystem"
        case gtmModel = "GtmModel"
        case categoryID = "CategoryId"
        case categoryName = "CategoryName"
        case breadcrumbCategory = "BreadcrumbCategory"
        case list = "List"
        case seller = "Seller"
        case maxProductQuantityCanSold = "MaxProductQuantityCanSold"
    }
}

// MARK: - BrandLink

struct BrandLink: Codable {}

// MARK: - Description

struct Description: Codable {
    let özellikler, ürünKodu: String?

    enum CodingKeys: String, CodingKey {
        case özellikler = "Özellikler :"
        case ürünKodu = "Ürün Kodu"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        self.key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: value)
        }
    }
}
