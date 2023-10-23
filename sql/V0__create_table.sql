SET search_path TO app;

CREATE TABLE httpchecks(
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  uri VARCHAR(255) NOT NULL,
  is_paused BOOLEAN NOT NULL,
  num_retries INT NOT NULL,
  uptime_sla INT NOT NULL,
  response_time_sla INT NOT NULL,
  use_ssl BOOLEAN NOT NULL,
  response_status_code INT NOT NULL,
  check_interval_in_seconds INT NOT NULL,
  check_created DATE,
  check_updated DATE
);
