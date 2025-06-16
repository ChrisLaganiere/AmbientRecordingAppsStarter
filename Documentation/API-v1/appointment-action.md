# Read/Update/Delete Appointment

Read, update, or delete an individual appointment

URL: `/v1/appointment/:appointmentID` (GET/PUT/DELETE)

### Read

Use GET method to read a resource

Example:
```
GET https://api.host.domain/v1/appointment/60124302
```
->
```
{
    "item": {
        "id": "60124302",
        "etag": "lszzwr",
        "scheduled_start": "2024-03-09T01:15:00.000Z",
        "scheduled_end": "2024-03-09T01:30:00.000Z"
    },
    "status": {
        "code": 0
    }
}
```

### Update

Use PUT method to update a resource

All parameters in body are required

Parameters:
- `scheduled_start` (String): expected start time, ISO 8601 Date string
- `scheduled_end` (String): expected end time, ISO 8601 Date string

On successful response, the newly-updated resource will be returned with a new server-generated `etag`.

Example:
```
PUT https://api.host.domain/v1/appointment/60124302
Body: {
    "client_id": "117",
    "item": {
        "id": "60124302",
        "etag": "lszzwr",
        "scheduled_start": "2024-03-09T01:30:00.000Z",
        "scheduled_end": "2024-03-09T01:45:00.000Z"
    }
}
```
->
```
{
    "client_id": "117",
    "item": {
        "id": "60124302",
        "etag": "lszzws",
        "scheduled_start": "2024-03-09T01:30:00.000Z",
        "scheduled_end": "2024-03-09T01:45:00.000Z"
    },
    "status": {
        "code": 0
    }
}
```

### Delete

Use DELETE method to delete a resource. No body is needed for this request.

Example:
```
DELETE https://api.host.domain/v1/appointment/60124302
```
->
```
{
    "status": {
        "code": 0
    }
}
```

### Handling Failures

When updating an entity, we check for conflicts by comparing `etag` version from the client request with `etag` version saved to database on server. If they match, changes are accepted. If they do not match, changes are rejected and client is encouraged to retry.

Example:
```
{
    "client_id": "116",
    "status": {
        "code": 100,
        "error_message": "Missing required scheduled_start field"
    }
}
```

If an entity is not found, an error code is returned in body to indicate such.

Example:
```
{
    "status": {
        "code": 404,
        "error_message": "Appointment not found"
    }
}
```
