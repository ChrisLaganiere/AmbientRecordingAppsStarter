
import axios from 'axios'

export const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE || 'https://api.host.domain', // override in .env
  headers: {
    'Content-Type': 'application/json'
  }
})

// response interceptor to unwrap nested status codes
api.interceptors.response.use(
  (response) => {
    const status = response.data?.status
    if (status && status.code !== 0) {
      const error = new Error(status.error_message || `API error code ${status.code}`)
      // @ts-ignore
      error.statusCode = status.code
      throw error
    }
    return response
  },
  (error) => {
    return Promise.reject(error)
  }
)
