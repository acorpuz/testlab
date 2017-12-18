# frozen_string_literal: true
haproxy_install 'package'

haproxy_config_global '' do
  chroot '/var/lib/haproxy'
  daemon true
  maxconn 256
  log '/dev/log local0'
  log_tag 'WARDEN'
  pidfile '/var/run/haproxy.pid'
  stats socket: '/var/lib/haproxy/stats level admin'
  tuning 'bufsize' => '262144'
end

haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5000ms',
          client: '5000ms',
          server: '5000ms'
end

haproxy_frontend 'http-in' do
  bind '*:80'
  default_backend 'servers'
end

environment = node.chef_environment
role = 'myloadbalancer'


#app_backends = search(:node, "roles:#{role} AND chef_environment:#{environment}")
app_backends = [{hostname: 'mynode' ,ipaddress: '192.168.50.11'}]
#server_array = ['disabled-server 127.0.0.1:1 disabled']
server_array = []

app_backends.each do |be|
  server_array.push("#{be[:hostname]} #{be[:ipaddress]}:8080 maxconn 32")
  #server_array.push("#{be['hostname']} #{be['ipaddress']}:8000 maxconn 32")
end

haproxy_listen 'admin' do
  bind '0.0.0.0:1337'
  mode 'http'
  stats uri: '/',
        realm: 'Haproxy-Statistics',
        auth: 'user:pwd'
  http_request 'add-header X-Proto http'
  http_response 'set-header Expires %[date(3600),http_date]'
  default_backend 'servers'
  extra_options('bind-process' => 'odd')
end

haproxy_backend 'servers' do
  server server_array
end
