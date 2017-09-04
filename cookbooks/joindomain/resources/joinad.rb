resource_name :joinad
property :domain, String, required: false, default: '<domain name>'
property :domain_user, String, required: true
property :domain_password, String, required: true
property :ou, [String, NilClass], required: false, default: nil

default_action :join

action :join do
    
 powershell_script 'joindomain' do
    code <<-EOH
    $user = "#{new_resource.domain}\\#{new_resource.domain_user}"
    $password = '#{new_resource.domain_password}' | ConvertTo-SecureString -asPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential($user,$password)
    $comp = Get-WmiObject -Class Win32_ComputerSystem
    $hostname = hostname
    Add-computer -DomainName "#{new_resource.domain}" -oupath "#{new_resource.ou}" -Credential $cred -force -Options JoinWithNewName,AccountCreate -Passthru -Restart
    EOH
    guard_interpreter :powershell_script
    only_if { node['kernel']['cs_info']['domain_role'].to_i == 0 || node['kernel']['cs_info']['domain_role'].to_i == 2 }
 end

end