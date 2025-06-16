import { useEffect, useState } from 'react'
import { Appointment } from '../types'
import AppointmentCard from '../components/AppointmentCard'
import { queryAppointments } from '../api/appointments'
import { useNavigate } from 'react-router-dom'

export default function AppointmentsPage() {
  const [appointments, setAppointments] = useState<Appointment[]>([])
  const [loading, setLoading] = useState(true)
  const navigate = useNavigate()

  useEffect(() => {
    queryAppointments().then((resp) => {
      if (resp.items) setAppointments(resp.items)
      setLoading(false)
    })
  }, [])

  return (
    <div className="max-w-md mx-auto py-6 px-4 flex flex-col gap-4">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-bold">Appointments</h1>
        <button
          onClick={() => navigate('/appointments/new')}
          className="text-blue-500 hover:underline"
        >
          + New
        </button>
      </div>

      {loading ? (
        <p className="text-gray-500">Loading appointments...</p>
      ) : appointments.length === 0 ? (
        <div className="text-center mt-16 text-gray-500">
          <p className="text-lg">No appointments yet</p>
          <p className="mt-2 text-sm">Click “New” to schedule your first one.</p>
        </div>
      ) : (
        <div className="flex flex-col gap-3">
          {appointments.map((apt) => (
            <AppointmentCard
              key={apt.id}
              appointment={apt}
              onClick={() => navigate(`/appointment/${apt.id}`)}
            />
          ))}
        </div>
      )}
    </div>
  )
}
