datacenter = "gcp-dc1"
data_dir = "/opt/consul"
node_name = "server-2"
node_meta = {
  hostname = "hashi-server-2-252"
  gcp_instance = "hashi-server-2-252"
  gcp_zone = "us-central1-a"
}
encrypt = "N75KTeT916Jv5lvc+LbHALyOgUja20RC5W3R0jaT6sg="
retry_join = ["provider=gce project_name=hc-345dad90334f4a45a0c3832d80f tag_value=gcp-dc1 zone_pattern=\"us-central1-[a-z]\""]
license_path = "/etc/consul.d/license.hclic"
log_level = "TRACE"

tls {
   defaults {
      ca_file = "/etc/consul.d/tls/consul-agent-ca.pem"
      cert_file = "/etc/consul.d/tls/gcp-dc1-server-consul-0.pem"
      key_file = "/etc/consul.d/tls/gcp-dc1-server-consul-0-key.pem"
      verify_incoming = false
      verify_outgoing = true
      verify_server_hostname = false
   }
   internal_rpc {
      verify_server_hostname = true
   }
}

performance {
  enable_xds_load_balancing = false
}

auto_encrypt {
  allow_tls = true
}

acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true
  tokens = {
    initial_management = "Consu43v3r"
    agent = "Consu43v3r"
    dns = "Consu43v3r"
  }
}

audit {
  enabled = true
  sink "gcp-dc1_sink" {
    type   = "file"
    format = "json"
    path   = "/opt/consul/audit/audit.json"
    delivery_guarantee = "best-effort"
    rotate_duration = "24h"
    rotate_max_files = 15
    rotate_bytes = 25165824
    mode = "644"
  }
}

reporting {
  license {
    enabled = false
  }
}


