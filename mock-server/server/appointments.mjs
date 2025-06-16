/**
 * appointments.mjs
 * Data-layer helper methods and persistence for Appointments
 */

import { buildUUID } from "./helpers.mjs";

/**
 * In-memory store of appointments
 */
var appointments = [];

/**
 * Build and save a new appointment
 * Parameters:
 * - `patientName` (String): name of patient who is the focus of appointment
 * - `scheduledStart` (String): expected start time, ISO 8601 Date string
 * - `scheduledEnd` (String): expected end time, ISO 8601 Date string
 * - `notes` (String): any additional notes (optional)
 * Returns: new appointment
 */
function createAppointment(patientName, scheduledStart, scheduledEnd, notes) {
	let appointment = {
		"id": buildUUID(),
		"etag": buildUUID(),
		"patient_name": patientName,
		"scheduled_start": scheduledStart,
		"scheduled_end": scheduledEnd,
		"notes": notes
	};
	appointments.push(appointment);
	return appointment;
}

/**
 * Handle incoming request to create a new appointment
 * Parameters:
 * - `req` (express request): incoming request
 * Returns: newly-created appointment object
 */
function createAppointmentWithRequest(req) {
	const {
		patient_name: patientName,
		scheduled_start: scheduledStart,
		scheduled_end: scheduledEnd,
		notes
	} = req.body.item;
	console.log(`Creating new appointment for ${patientName}`);
	return createAppointment(patientName, scheduledStart, scheduledEnd, notes);
}

/**
 * Handle incoming request to create a new appointment
 * Parameters:
 * - `req` (express request): incoming request
 * Returns: response object, ready to be formatted into JSON
 */
export function handleCreateAppointmentRequest(req) {
	let clientID = req.body["client_id"];
	try {
		let appointment = createAppointmentWithRequest(req);
		return {
			"client_id": clientID,
			"item": appointment,
			"status": {
				"code": 0
			}
		}
	}
	catch (error) {
		console.log(`Error creating appointment, body: ${JSON.stringify(req.body)}`)
		console.log(`Error creating appointment: ${error.toString()}`)
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
 * Handle incoming request to query appointments
 * Parameters:
 * - `req` (express request): incoming request
 * Returns: appointment objects
 */
function findAppointmentsWithRequest(req) {
	const {
		start,
		end,
		count,
		page
	} = req.query;

	// BOGUS: for now, just return everything.
	// Full query can be implemented later
	let results = appointments;

	console.log(`Performing appointment query with params: ${JSON.stringify(req.query)}, found count: ${results.length}`);

	return results;
}

/**
 * Handle incoming request to query a collection of appointments
 * Parameters:
 * - `req` (express request): incoming request
 * Returns: response object, ready to be formatted into JSON
 */
export function handleQueryAppointmentRequest(req) {
	let appointments = findAppointmentsWithRequest(req);
	return {
		"items": appointments,
		"meta": {
	        "total_count": appointments.length,
	        "page_count": 1,
	        "count_per_page": appointments.length,
	        "ctag": buildUUID()
	    },
	    "status": {
	        "code": 0
	    }
	}
}


/**
 * Handle incoming request to find an appointment
 * Parameters:
 * - `appointmentID` (String): unique identifier for entity
 * Returns: response object, ready to be formatted into JSON
 */
export function handleFindAppointmentRequest(appointmentID) {
	const found = appointments.filter((appointment) => appointment.id === appointmentID);

	if (found.length === 0) {
		return {
			"client_id": appointmentID,
			"status": {
				"code": 404,
				"error_message": "NOT FOUND"
			}
		};
	}

	console.log(`Found appointment matching id: ${appointmentID}`)

	return {
		"item": found[0],
	    "status": {
	        "code": 0
	    }
	}
}

/**
 * Handle incoming request to delete an appointment
 * Parameters:
 * - `appointmentID` (String): unique identifier for entity to delete
 * Returns: response object, ready to be formatted into JSON
 */
export function handleDeleteAppointmentRequest(appointmentID) {
	let before = appointments.length;

	// Filter in-memory entities to delete
	
	appointments = appointments.filter((appointment) => appointment.id != appointmentID);

	let after = appointments.length;
	console.log(`Deleted ${before-after} appointment matching id: ${appointmentID}`)

	return {
	    "status": {
	        "code": 0
	    }
	}
}


