
export interface Status {
  code: number;
  error_message?: string;
}

export interface Meta {
  total_count: number;
  page_count: number;
  next_page?: number;
  count_per_page: number;
  ctag: string;
}

export interface Appointment {
  id: string;
  etag: string;
  scheduled_start: string;
  scheduled_end: string;
  patient_name: string;
  notes?: string;
}

export interface Recording {
  id: string;
  etag: string;
  appointment_id: string;
  start: string;
  end: string;
  duration: number;
  streaming_url: string;
}

export interface ApiResponse<T> {
  item?: T;
  items?: T[];
  meta?: Meta;
  status: Status;
  client_id?: string;
}
