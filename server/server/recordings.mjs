/**
 * recordings.mjs
 * Data-layer helper methods and persistence for Recordings
 */

import { buildUUID } from "./helpers.mjs";

/**
 * In-memory store of recordings
 */
var recordings = [];


/**
 * Build and save a new recording
 * Parameters:
 * - `appointmentID` (String): unique identifier for parent entity
 * - `start` (String): time when recording began, ISO 8601 Date string
 * - `end` (String): time when recording ended, ISO 8601 Date string
 * - `duration` (Number): duration of recording, in seconds
 * Returns: new recording
 */
function createRecording(appointmentID, start, end, duration) {
	let recording = {
		"id": buildUUID(),
		"etag": buildUUID(),
		"appointment_id": appointmentID,
		"start": start,
		"end": end,
		"duration": duration
	};
	recordings.push(recording);
	return recording;
}

/**
 * Handle incoming request to create a new recording
 * Parameters:
 * - `req` (express request): incoming request
 * Returns: newly-created recording object
 */
function createRecordingWithRequest(req) {
	const {
		appointment_id: appointmentID,
		start,
		end,
		duration
	} = req.body.item;
	console.log(`Creating new recording with duration ${duration}`);
	return createRecording(appointmentID, start, end, duration);
}

/**
 * Handle incoming request to create a new recording
 * Parameters:
 * - `req` (express request): incoming request
 * Returns: response object, ready to be formatted into JSON
 */
export function handleCreateRecordingRequest(req) {
	let clientID = req.body["client_id"];
	try {
		let recording = createRecordingWithRequest(req);
		return {
			"client_id": clientID,
			"item": recording,
			"status": {
				"code": 0
			}
		}
	}
	catch (error) {
		console.log(`Error creating recording: ${error.toString()}`)
		return {
			"client_id": clientID,
			"status": {
				"code": 400,
				"error_message": error.toString()
			}
		}
	}
}

/**
 * Handle incoming request to query recordings
 * Parameters:
 * - `req` (express request): incoming request
 * Returns: recording objects
 */
function findRecordingsWithRequest(req) {
	const {
		appointment_id: appointmentID,
		count,
		page
	} = req.query;	

	// BOGUS: for now, just return everything, filtered by appointment_id.
	// Full query can be implemented later
	let filtered = recordings.filter((recording) => recording.appointment_id == appointmentID);

	console.log(`Performing recordings query with params: ${JSON.stringify(req.query)}, found count: ${filtered.length}`);

	return filtered;
}

/**
 * Handle incoming request to query a collection of recordings
 * Parameters:
 * - `req` (express request): incoming request
 * Returns: response object, ready to be formatted into JSON
 */
export function handleQueryRecordingsRequest(req) {
	let recordings = findRecordingsWithRequest(req);
	return {
		"items": recordings,
		"meta": {
	        "total_count": recordings.length,
	        "page_count": 1,
	        "count_per_page": recordings.length,
	        "ctag": buildUUID()
	    },
	    "status": {
	        "code": 0
	    }
	}
}
