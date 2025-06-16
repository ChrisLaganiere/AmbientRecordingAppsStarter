import express from "express";
import bodyParser from "body-parser";
import {
	handleCreateAppointmentRequest,
	handleQueryAppointmentRequest,
	handleDeleteAppointmentRequest,
	handleFindAppointmentRequest
} from "./server/appointments.mjs";
import {
	handleCreateRecordingRequest,
	handleQueryRecordingsRequest
} from "./server/recordings.mjs";


// MARK: Set Up

const app = express();
app.use(bodyParser.json())

import cors from "cors";
app.use(cors({ origin: true }));

// Add delay to simulate real server
app.use(function(req,res,next){setTimeout(next,1000)});


// MARK: Appointments Endpoints

app.post('/v1/appointments/create', (req, res) => {
	let responseBody = handleCreateAppointmentRequest(req);
	res.setHeader('content-type', 'application/json');
	res.send(JSON.stringify(responseBody));
});

app.get('/v1/appointments/query', (req, res) => {
	let responseBody = handleQueryAppointmentRequest(req);
	res.setHeader('content-type', 'application/json');
	res.send(JSON.stringify(responseBody));
});

app.get('/v1/appointment/:appointmentID', (req, res) => {
	let responseBody = handleFindAppointmentRequest(req.params.appointmentID);
	res.setHeader('content-type', 'application/json');
	res.send(JSON.stringify(responseBody));
});

app.delete('/v1/appointments/:appointmentID', (req, res) => {
	let responseBody = handleDeleteAppointmentRequest(req.params.appointmentID);
	res.setHeader('content-type', 'application/json');
	res.send(JSON.stringify(responseBody));
});

// TODO: `/v1/appointment/:appointmentID` (PUT)

// MARK: Recordings Endpoints

app.post('/v1/recordings/create', (req, res) => {
	let responseBody = handleCreateRecordingRequest(req);
	res.setHeader('content-type', 'application/json');
	res.send(JSON.stringify(responseBody))
});

app.get('/v1/recordings/query', (req, res) => {
	let responseBody = handleQueryRecordingsRequest(req);
	res.setHeader('content-type', 'application/json');
	res.send(JSON.stringify(responseBody))
});

// MARK: Server

const port = 8000;

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
