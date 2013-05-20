name             'movabletype-opensource'
maintainer       'Yoshihiro Sasaki'
maintainer_email 'aloelight at gmail.com'
license          'MIT'
description      'Installs/Configures movabletype-opensource'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.2'

recipe 'movabletype-opensource', "Installs/Configures movabletype-opensource";

%w{ centos }.each do |os|
    supports os
end

%w{ yum nginx simple_iptables mysql }.each do |cb|
    depends cb
end
