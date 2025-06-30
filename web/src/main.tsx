
import React from 'react'
import ReactDOM from 'react-dom/client'
import { BrowserRouter, Route, Routes, Navigate } from 'react-router-dom'
import AppointmentsPage from './pages/AppointmentsPage'
import AppointmentPage from './pages/AppointmentPage'
import NewAppointmentForm from './pages/NewAppointmentForm'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path='/' element={<Navigate to='/appointments' replace />} />
        <Route path='/appointments' element={<AppointmentsPage />} />
        <Route path='/appointment/:id' element={<AppointmentPage />} />
        <Route path="/appointments/new" element={<NewAppointmentForm />} />
      </Routes>
    </BrowserRouter>
  </React.StrictMode>
)
