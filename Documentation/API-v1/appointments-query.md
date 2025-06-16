# Query Appointments

Fetch appointments from server. This endpoint supports pagination of a particular query, to scale infinitely.

URL: `/v1/appointments/query` (GET)
Content-type: `application/json`

### Request

All request parameters are optional, and can be used in conjunction.

URL Parameters:
- `start` (ISO 8601 Date string): earliest scheduled start of appointments
- `end` (ISO 8601 Date string): latest scheduled end of appointments
- `count`: number of items to return (default 50)
- `page`: used in coordination with `count` parameter for pagination (default 0)
- `ctag`: version of data in collection, which will trigger error response if no longer valid. Sent only when requesting subsequent pages continuing initial query

Example:
```
https://api.host.domain/v1/appointments/query?start=2024-03-09T00:00:00.000Z&end=2024-03-16T23:59:59.999Z
```

### Response

Body:
```
{
    "items": [<Appointment>],
    "meta": {
        "total_count": 120,
        "page_count": 3,
        "next_page": 2,
        "count_per_page": 50,
        "ctag": "lsyeru"
    },
    "status": {
        "code": 0
    }
}
```

Metadata fields (`meta`):
- `total_count` (Number): total number of items in collection
- `page_count` (Number): total number of pages in collection
- `next_page` (Number): next page to provide as parameter in next request, if desired
- `count_per_page` (Number): number of items returned per-page
- `ctag` (String): version of collection being paged to provide as parameter in next request, if desired


### Handling Failures

Example: invalid `ctag` in request, indicating that paged query is no longer valid, and pagination should be restarted with a new query.

```
{
    "status": {
        "code": 102,
        "error_message": "Invalid ctag"
    }
}
```
