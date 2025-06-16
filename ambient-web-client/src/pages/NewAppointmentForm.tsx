import { useState } from 'react'
import { createAppointment } from '../api/appointments'
import { useNavigate } from 'react-router-dom'
import dayjs from 'dayjs'

export default function NewAppointmentForm() {
  const navigate = useNavigate()
  const [patientName, setPatientName] = useState('')
  const [start, setStart] = useState(dayjs().format('YYYY-MM-DDTHH:mm'))
  const [end, setEnd] = useState(dayjs().add(15, 'minute').format('YYYY-MM-DDTHH:mm'))
  const [notes, setNotes] = useState('')
  const [submitting, setSubmitting] = useState(false)

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setSubmitting(true)
    try {
      const result = await createAppointment({
        scheduled_start: new Date(start).toISOString(),
        scheduled_end: new Date(end).toISOString(),
        patient_name: patientName,
        notes,
      })
      if (result.item?.id) {
        navigate(`/appointment/${result.item.id}`)
      }
    } catch (err) {
      alert('Failed to create appointment')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="max-w-md mx-auto px-4 py-6">
      <button className="text-blue-500 mb-4" onClick={() => navigate(-1)}>
        ← Back
      </button>
      <h1 className="text-2xl font-bold mb-4">New Appointment</h1>
      <form onSubmit={handleSubmit} className="flex flex-col gap-4">
        <label className="flex flex-col">
          <span className="text-sm font-medium text-gray-700">Patient Name</span>
          <input
            required
            type="text"
            value={patientName}
            onChange={(e) => setPatientName(e.target.value)}
            className="border rounded px-2 py-1"
          />
        </label>

        <label className="flex flex-col">
          <span className="text-sm font-medium text-gray-700">Start Time</span>
          <input
            required
            type="datetime-local"
            value={start}
            onChange={(e) => setStart(e.target.value)}
            className="border rounded px-2 py-1"
          />
        </label>

        <label className="flex flex-col">
          <span className="text-sm font-medium text-gray-700">End Time</span>
          <input
            required
            type="datetime-local"
            value={end}
            onChange={(e) => setEnd(e.target.value)}
            className="border rounded px-2 py-1"
          />
        </label>

        <label className="flex flex-col">
          <span className="text-sm font-medium text-gray-700">Notes (optional)</span>
          <textarea
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            className="border rounded px-2 py-1"
          />
        </label>

        <button
          type="submit"
          disabled={submitting}
          className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 disabled:opacity-50"
        >
          {submitting ? 'Saving...' : 'Create Appointment'}
        </button>
      </form>
    </div>
  )
}
