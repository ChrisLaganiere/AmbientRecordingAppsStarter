import Foundation

/**
 # QueryRecordingsRequestParams
 Query parameters that can be added to a recordings query
 */
struct QueryRecordingsRequestParams {
    /// identifier of parent entity
    var appointmentID: Appointment.ID?
    /// number of items to return
    var count: Int?
    /// used in coordination with `count` parameter for pagination
    var page: Int?
    /// version of data in collection, which will trigger error response if no longer valid
    var ctag: String?

    /// Format query params into a GET url for API endpoint
    func buildGetRequestURL() -> URL {
        var components = URLComponents(
            url: AmbientEndpoints.queryRecordings.url,
            resolvingAgainstBaseURL: false
        )!

        addParam(
            name: "appointment_id",
            value: appointmentID,
            to: &components
        )
        addParam(
            name: "count",
            value: count.flatMap { "\($0)" },
            to: &components
        )
        addParam(
            name: "page",
            value: page.flatMap { "\($0)" },
            to: &components
        )
        addParam(
            name: "ctag",
            value: ctag, 
            to: &components
        )

        return components.url!
    }

    /// Add a single query param to path components
    func addParam(
        name: String,
        value: String?,
        to components: inout URLComponents
    ) {
        guard let value else {
            return
        }
        components.queryItems?.append(
            URLQueryItem(name: name, value: value)
        )
    }
}
