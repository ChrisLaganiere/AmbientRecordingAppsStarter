# Create Appointment

Create a new appointment entity.

URL: `/v1/appointments/create` (POST)
Content-type: `application/json`

### Request

Required Parameters:
- `scheduled_start` (String): expected start time, ISO 8601 Date string
- `scheduled_end` (String): expected end time, ISO 8601 Date string
- `patient_name` (String): name of patient who is the focus of appointment

Optional Parameters:
- `notes` (String): any additional notes

Body:
```
{
    "client_id": "115",
    "item": {
        "scheduled_start": "2024-03-09T01:15:00.000Z",
        "scheduled_end": "2024-03-09T01:30:00.000Z",
        "patient_name": "Kelsey K"
    }
}
```

### Response

On successful response, the newly-created resource will be returned with a new server-generated `id`.

Body:
```
{
    "client_id": "115",
    "item": {
        "id": "60124302",
        "etag": "lszzwr",
        "scheduled_start": "2024-03-09T01:15:00.000Z",
        "scheduled_end": "2024-03-09T01:30:00.000Z",
        "patient_name": "Kelsey K"
    },
    "status": {
        "code": 0
    }
}
```

### Handling Failures

Example: response indicating missing required data
```
{
    "client_id": "116",
    "status": {
        "code": 100,
        "error_message": "Missing required patient_name field"
    }
}
```
