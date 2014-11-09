require 'win32/registry'

host = ARGV.shift
port = ARGV.shift

proxy = "127.0.0.1"

proxy = host.to_s + port.to_s

Win32::Registry::HKEY_CURRENT_USER.open(
  "Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\",
  Win32::Registry::KEY_WRITE) do |reg|
    reg.write("ProxyServer",Win32::Registry::REG_SZ, proxy.to_s)
end