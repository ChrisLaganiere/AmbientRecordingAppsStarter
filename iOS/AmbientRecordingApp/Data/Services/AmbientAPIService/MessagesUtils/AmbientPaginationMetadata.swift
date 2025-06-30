import Foundation

/**
 # AmbientPaginationMetadata
 Standard format for metadata included in response from query endpoints
 */
struct AmbientPaginationMetadata: Codable {
    /// total number of items in collection
    var totalCount: Int?
    /// total number of pages in collection
    var pageCount: Int?
    /// next page to provide as parameter in next request, if desired
    var nextPage: Int?
    /// number of items returned per-page
    var countPerPage: Int?
    /// version of collection being paged to provide as parameter in next request, if desired
    var ctag: String?

    /// Translate to json key, if needed
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageCount = "page_count"
        case nextPage = "next_page"
        case countPerPage = "count_per_page"
        case ctag
    }
}
