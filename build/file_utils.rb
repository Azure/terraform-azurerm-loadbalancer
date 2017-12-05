require 'fileutils'

def clean_up_terraform
  if File.exists? '.terraform'
    print "INFO: Cleaning up the .terraform folder...\n"
    FileUtils.rm_rf('.terraform')
  end
end