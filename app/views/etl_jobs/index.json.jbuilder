json.array!(@etl_jobs) do |etl_job|
  json.extract! etl_job, :id
  json.url etl_job_url(etl_job, format: :json)
end
