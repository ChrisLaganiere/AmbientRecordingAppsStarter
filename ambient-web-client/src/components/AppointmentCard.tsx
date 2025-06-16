
import dayjs from 'dayjs'
import { Appointment } from '../types'

interface Props {
  appointment: Appointment
  onClick: () => void
}

export default function AppointmentCard({ appointment, onClick }: Props) {
  return (
    <div
      className='border rounded-lg p-4 shadow-sm cursor-pointer hover:bg-gray-100 flex justify-between'
      onClick={onClick}
    >
      <div>
        <p className='text-sm text-gray-500'>{dayjs(appointment.scheduled_start).format('h:mm A')}</p>
        <p className='text-lg font-medium text-blue-600'>{appointment.patient_name}</p>
        <p className='text-sm text-gray-400'>State: scheduled</p>
      </div>
      <div className='self-center text-gray-400'>✓</div>
    </div>
  )
}
