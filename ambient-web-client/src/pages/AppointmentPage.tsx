
import { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { Appointment, Recording } from '../types'
import { readAppointment } from '../api/appointments'
import { createRecording } from '../api/recordings'
import RecordingControls from '../components/RecordingControls'
import dayjs from 'dayjs'

export default function AppointmentPage() {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const [appointment, setAppointment] = useState<Appointment | null>(null)
  const [recordings, setRecordings] = useState<Recording[]>([])

  useEffect(() => {
    if (id) {
      readAppointment(id).then((resp) => {
        if (resp.item) setAppointment(resp.item)
      })
    }
  }, [id])

  async function handleComplete(blob: Blob, duration: number, start: Date, end: Date) {
    if (!id) return
    const resp = await createRecording({
      appointment_id: id,
      start: start.toISOString(),
      end: end.toISOString(),
      duration
    } as any, blob)
    if (resp.item) {
      setRecordings((prev) => [...prev, resp.item!])
    }
  }

  if (!appointment) return <p className='p-4'>Loading...</p>

  return (
    <div className='max-w-md mx-auto px-4 py-4 flex flex-col gap-4'>
      <button className='text-blue-500' onClick={() => navigate(-1)}>&larr; Back</button>
      <div>
        <p className='text-sm text-gray-500'>{dayjs(appointment.scheduled_start).format('h:mm A')}</p>
        <h1 className='text-2xl font-bold'>{appointment.patient_name}</h1>
        <p className='text-sm text-gray-400'>State: completed</p>
        {appointment.notes && <p className='mt-2'>{appointment.notes}</p>}
      </div>

      <RecordingControls onComplete={handleComplete} />

      {recordings.length > 0 && (
        <div className='mt-4'>
          <h2 className='text-lg font-semibold mb-2'>Recordings</h2>
          <ul className='list-disc ml-6'>
            {recordings.map((r) => (
              <li key={r.id}>
                <a className='text-blue-600 underline' href={r.streaming_url} target='_blank'>
                  {new Date(r.start).toLocaleTimeString()} ({r.duration.toFixed(1)}s)
                </a>
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  )
}
