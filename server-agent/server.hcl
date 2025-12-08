server = true
bootstrap_expect = 3

# Service mesh configuration
# Note: Consul limits configuration moved to performance tuning section if needed

ui = true
client_addr = "0.0.0.0"
bind_addr = "{{ GetDefaultInterfaces | attr \"address\" }}"
advertise_addr_wan = "34.61.227.179"

connect {
  enabled = true
}

ui_config {
  enabled = true
  metrics_provider = "prometheus"
  metrics_proxy {
    base_url = "http://localhost:9090"
  }
  dashboard_url_templates {
    service = "http://localhost:3000/d/lDlaj-NGz/service-overview?orgId=1&var-service={{Service.Name}}&var-namespace={{Service.Namespace}}&var-partition={{Service.Partition}}&var-dc={{Datacenter}}"
  }
}

ports {
  https = 8501
  grpc_tls = 8502
}


