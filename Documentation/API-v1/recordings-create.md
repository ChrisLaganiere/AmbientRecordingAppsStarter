# Create Recording

Create a new recording entity with audio data.

URL: `/v1/recordings/create` (POST)

### Request

This endpoint uses a multipart content type in order to upload binary audio data along with JSON information about the new entity to create.

Content-type: `multipart/form-data; boundary= -------APIBoundary`

Body:
```
-------APIBoundary
Content-Disposition: form-data; name="info"
Content-Type: application/json

{
    "client_id": "113",
    "item": {
        "appointment_id": "60124301",
        "start": "2024-03-09T12:49:15.000Z",
        "end": "2024-03-09T12:53:19.000Z",
        "duration": 244
    }
}

-------APIBoundary
Content-Disposition: form-data; name="recording"; filename="audio.m4a"
Content-Type: audio/mp4

<audio file data>
-------APIBoundary--
```

### Response

On successful response, the newly-created recording will be returned with a new server-generated `id`.

Content-type: `application/json`

Body:
```
{
    "client_id": "113",
    "item": {
        "id": "112092107",
        "etag": "lszzwr",
        "appointment_id": "60124301",
        "start": "2024-03-09T12:49:15.000Z",
        "end": "2024-03-09T12:53:19.000Z",
        "duration": 244,
        "streaming_url": "https://media.host.domain/v1/recordings/112092107/stream"
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
    "client_id": "114",
    "status": {
        "code": 100,
        "error_message": "Missing required appointment_id field"
    }
}
```
