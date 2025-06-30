import request from 'supertest';
import app from '../server.mjs';

test('GET /health returns OK', async () => {
  const res = await request(app).get('/v1/appointments/query');
  expect(res.statusCode).toBe(200);
});
