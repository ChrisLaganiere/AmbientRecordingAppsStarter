
import { api } from './client'
import { Appointment, ApiResponse } from '../types'
import { v4 as uuid } from 'uuid'

export async function createAppointment(data: Omit<Appointment, 'id' | 'etag'>): Promise<ApiResponse<Appointment>> {
  const client_id = uuid()
  const body = { client_id, item: data }
  const response = await api.post<ApiResponse<Appointment>>('/v1/appointments/create', body)
  return response.data
}

export async function queryAppointments(params: Record<string, any> = {}): Promise<ApiResponse<Appointment>> {
  const response = await api.get<ApiResponse<Appointment>>('/v1/appointments/query', { params })
  return response.data
}

export async function readAppointment(id: string): Promise<ApiResponse<Appointment>> {
  const response = await api.get<ApiResponse<Appointment>>(`/v1/appointment/${id}`)
  return response.data
}

export async function updateAppointment(id: string, appointment: Appointment): Promise<ApiResponse<Appointment>> {
  const body = { client_id: uuid(), item: appointment }
  const response = await api.put<ApiResponse<Appointment>>(`/v1/appointment/${id}`, body)
  return response.data
}

export async function deleteAppointment(id: string): Promise<ApiResponse<unknown>> {
  const response = await api.delete<ApiResponse<unknown>>(`/v1/appointment/${id}`)
  return response.data
}
