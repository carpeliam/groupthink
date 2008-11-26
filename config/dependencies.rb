# dependencies are generated using a strict version, don't forget to edit the dependency versions when upgrading.
merb_gems_version = "1.0.3"
dm_gems_version   = "0.9.7"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version  
#dependency "merb-cache", merb_gems_version   
dependency "merb-helpers", merb_gems_version 
dependency "merb-mailer", merb_gems_version  
dependency "merb-slices", merb_gems_version  
dependency "merb-auth-core", merb_gems_version
dependency "merb-auth-more", merb_gems_version
dependency "merb-auth-slice-password", merb_gems_version
#dependency "merb-param-protection", merb_gems_version
#dependency "merb-exceptions", merb_gems_version
 
dependency "dm-core", dm_gems_version         
dependency "dm-aggregates", dm_gems_version   
dependency "dm-migrations", dm_gems_version   
dependency "dm-timestamps", dm_gems_version   
#dependency "dm-types", dm_gems_version        
dependency "dm-validations", dm_gems_version

dependency "dm-is-versioned", dm_gems_version
dependency "dm-adjust", dm_gems_version # required by dm-is-nested_set
dependency "dm-is-nested_set", dm_gems_version
dependency "dm-paperclip" # version is (somewhat) independent

dependency "will_paginate", '2.5.0'
dependency "multibyte"

dependency "RedCloth", :require_as => 'redcloth'

dependency "merb_watchable"
