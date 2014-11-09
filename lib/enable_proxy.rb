require 'win32/registry'

Win32::Registry::HKEY_CURRENT_USER.open(
  "Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\",
  Win32::Registry::KEY_WRITE) do |reg|
    reg.write("ProxyEnable",Win32::Registry::REG_DWORD, 1)
end