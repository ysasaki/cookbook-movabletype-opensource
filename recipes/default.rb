#
# Cookbook Name:: movabletype-opensource
# Recipe:: default
#
# Copyright 2013, Yoshihiro Sasaki
#
# LICENSE: MIT License
#

domain = node['movabletype-opensource']['domain']
owner  = node['movabletype-opensource']['owner']
group  = node['movabletype-opensource']['group']

directory "/var/www/#{domain}" do
    owner "#{owner}"
    group "#{group}"
    action :create
    recursive true
end

%w{ htdocs logs cgi-bin }.each do |dir| 
    directory "/var/www/#{domain}/#{dir}" do 
        owner "#{owner}"
        group "#{group}"
        action :create
    end
end

git "/var/www/#{domain}/cgi-bin/mt" do 
    repository "git://github.com/movabletype/movabletype.git"
    reference "master"
    action :checkout
    user "#{owner}"
    group "#{group}"
end

template "/var/www/#{domain}/cgi-bin/mt-config.cgi" do 
    source "mt-config.cgi"
end
