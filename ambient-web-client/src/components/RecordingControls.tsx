
import { useEffect, useRef, useState } from 'react'

interface Props {
  onComplete: (blob: Blob, duration: number, start: Date, end: Date) => void
}

export default function RecordingControls({ onComplete }: Props) {
  const mediaRecorderRef = useRef<MediaRecorder | null>(null)
  const [isRecording, setIsRecording] = useState(false)
  const [startTime, setStartTime] = useState<Date | null>(null)
  const [duration, setDuration] = useState(0)
  const chunks = useRef<Blob[]>([])

  useEffect(() => {
    let timer: NodeJS.Timeout
    if (isRecording && startTime) {
      timer = setInterval(() => {
        setDuration((Date.now() - startTime.getTime()) / 1000)
      }, 500)
    }
    return () => {
      if (timer) clearInterval(timer)
    }
  }, [isRecording, startTime])

  async function startRecording() {
    const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
    const recorder = new MediaRecorder(stream, { mimeType: 'audio/webm' })
    recorder.ondataavailable = (e) => chunks.current.push(e.data)
    recorder.onstop = () => {
      const blob = new Blob(chunks.current, { type: 'audio/webm' })
      chunks.current = []
      if (startTime) {
        const endTime = new Date()
        onComplete(blob, (endTime.getTime() - startTime.getTime()) / 1000, startTime, endTime)
      }
    }
    mediaRecorderRef.current = recorder
    recorder.start()
    setStartTime(new Date())
    setIsRecording(true)
  }

  function stopRecording() {
    mediaRecorderRef.current?.stop()
    setIsRecording(false)
  }

  return (
    <div className='flex flex-col items-center gap-2'>
      <button
        className={`rounded-full w-24 h-24 flex items-center justify-center ${isRecording ? 'bg-red-500' : 'bg-blue-500'}`}
        onClick={isRecording ? stopRecording : startRecording}
      >
        <span className='text-white text-2xl'>
          {isRecording ? '⏹' : '🎙️'}
        </span>
      </button>
      {isRecording && (
        <p className='text-gray-700'>Duration: {duration.toFixed(1)} s</p>
      )}
    </div>
  )
}
