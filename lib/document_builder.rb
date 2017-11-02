class DocumentBuilder
  include Sneakers::Worker
  from_queue 'documents'

  def work(msg)
    worker_trace "RECEIVED #{msg}"
    ack!
  end
end
