shared_properties = {
  :deployment_name => terraform_outputs[:env]
}

job_address = {
    :nats => {
        :address => "0.nats.default.#{shared_properties[:deployment_name]}.microbosh",
    },
    :syslog_aggregator => {
        :address => "0.syslog-aggregator.#{shared_properties[:deployment_name]}.microbosh"
    }
}
