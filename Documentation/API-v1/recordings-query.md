# Query Recordings

Fetch recordings from server. This endpoint supports pagination of a particular query, to scale infinitely.

URL: `/v1/recordings/query` (GET)
Content-type: `application/json`

### Request

All request parameters are optional, and can be used in conjunction.

URL Parameters:
- `appointment_id`: identifier of parent entity
- `count`: number of items to return (default 50)
- `page`: used in coordination with `count` parameter for pagination (default 0)
- `ctag`: version of data in collection, which will trigger error response if no longer valid

Example:
```
https://api.host.domain/v1/recordings/query?appointment_id=60124301
```

### Response

Body:
```
{
    "items": [<Recording>],
    "meta": {
        "total_count": 4,
        "page_count": 1,
        "count_per_page": 50,
        "ctag": "lsyery"
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

Example: invalid `ctag` in request, indicating that query being paged is no longer valid, and pagination should be restarted with a new query.

```
{
    "status": {
        "code": 102,
        "error_message": "Invalid ctag"
    }
}
```
