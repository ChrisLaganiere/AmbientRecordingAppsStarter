
import { api } from './client'
import { Recording, ApiResponse } from '../types'
import { v4 as uuid } from 'uuid'

export async function createRecording(meta: Omit<Recording, 'id' | 'etag' | 'streaming_url'>, audioBlob: Blob): Promise<ApiResponse<Recording>> {
  const boundary = '----APIBoundary'
  const formData = new FormData()
  formData.append('info', JSON.stringify({ client_id: uuid(), item: meta }))
  formData.append('recording', audioBlob, 'audio.m4a')

  const response = await api.post<ApiResponse<Recording>>('/v1/recordings/create', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
  return response.data
}

export async function queryRecordings(params: Record<string, any> = {}): Promise<ApiResponse<Recording>> {
  const response = await api.get<ApiResponse<Recording>>('/v1/recordings/query', { params })
  return response.data
}
