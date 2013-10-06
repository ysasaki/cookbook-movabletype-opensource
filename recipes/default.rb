#
# Cookbook Name:: movabletype-opensource
# Recipe:: default
#
# Copyright 2013, Yoshihiro Sasaki
#
# LICENSE: MIT License
#

domain       = node['movabletype-opensource']['domain']
user         = node['movabletype-opensource']['user']
group        = user
psgi_port    = node['movabletype-opensource']['psgi_port']
perl_path    = node['movabletype-opensource']['perl_install_path']
perl_version = node['movabletype-opensource']['perl_version']

mt_root   = "/var/www/#{domain}"
cpanm     = "#{mt_root}/cpanm"

# dependencies
%w{
    crontabs
    git
    curl
    db4-devel
    giflib-devel
    libjpeg-devel
    libpng-devel
    librsvg2-devel
    libtiff-devel
    libxml2-devel
    expat-devel
    }
    .each do |pkg|
    package pkg
end

# create user
user user do
    action :create
    system true
end

# mt
directory "/var/www/#{domain}" do
    owner "#{user}"
    group "#{group}"
    action :create
    recursive true
end

%w{ htdocs logs cgi-bin }.each do |dir| 
    directory "/var/www/#{domain}/#{dir}" do 
        owner "#{user}"
        group "#{group}"
        action :create
    end
end

git "/var/www/#{domain}/cgi-bin" do 
    repository "git://github.com/movabletype/movabletype.git"
    reference "db7ee40ddc7c0309a4bd132cfb5d402be7987009"
    depth 1
    destination "#{mt_root}/cgi-bin/mt"
    action :checkout
    user "#{user}"
    group "#{group}"
end

bash "mv mt-static dir" do
  only_if { File.exists?("#{mt_root}/cgi-bin/mt/mt-static") }
  user "#{user}"
  group "#{group}"
  code <<-EOH
  mv #{mt_root}/cgi-bin/mt/mt-static #{mt_root}/htdocs
  EOH
end


# Revese Proxy
template "/etc/nginx/sites-available/001-movabletype.conf" do
    action :create
    source "nginx.conf.erb"
    owner "#{user}"
    group "#{group}"
    mode 0644
end

link "/etc/nginx/sites-enabled/001-movabletype.conf" do
    action :create
    link_type :symbolic
    to "/etc/nginx/sites-available/001-movabletype.conf"
    notifies :restart, 'service[nginx]'
end

template "/var/www/#{domain}/cgi-bin/mt/mt-config.cgi" do 
    action :create
    source "mt-config.cgi.erb"
    owner "#{user}"
    group "#{group}"
    mode 0644
end

# mysql
mysql_database = node['movabletype-opensource']['database']
mysql_user = node['movabletype-opensource']['dbuser']
mysql_password = node['movabletype-opensource']['dbpassword']

bash "setup_mysql_user_and_db" do
  code <<-EOH
  cat <<SQL | mysql -uroot -p#{node['mysql']['server_root_password']}
GRANT USAGE ON *.* TO '#{mysql_user}'@'localhost' IDENTIFIED BY '#{mysql_password}' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
CREATE DATABASE IF NOT EXISTS #{node['movabletype-opensource']['database']};
GRANT ALL PRIVILEGES ON #{mysql_database}.* TO '#{mysql_user}'@'localhost' IDENTIFIED BY '#{mysql_password}';
FLUSH PRIVILEGES;
SQL
  EOH
end

# perl
bash "install_cpanm" do
  not_if { File.exists?(cpanm) }
  user "#{user}"
  group "#{group}"
  cwd "#{mt_root}"
  code <<-EOH
  curl -LO http://xrl.us/cpanm
  chmod +x #{cpanm}
  EOH
end

bash "install_perl_build" do
  not_if { File.exists?("#{perl_path}/bin/perl") }
  code <<-EOH
  curl https://raw.github.com/tokuhirom/Perl-Build/master/perl-build | perl - #{perl_version} #{perl_path}
  EOH
end

# install modules for mt
template "#{mt_root}/cpanfile" do
  action :create
  source "cpanfile.erb"
  user "#{user}"
  group "#{user}"
  mode 0644
end

bash "install_perl_module" do
  user "root"
  group "root"
  cwd "#{mt_root}"
  code <<-EOH
  #{perl_path}/bin/perl #{cpanm} --installdeps .
  EOH
end

# change shebang
bash "change_perl_path" do
  user "root"
  group "root"
  code <<-EOH
  find #{mt_root}/cgi-bin/mt -name '*.cgi' | xargs perl -i -ple 's{/usr/bin/perl}{#{perl_path}/bin/perl}g'
  EOH
end

# crontab
template "#{mt_root}/crontab" do
  user "#{user}"
  group "#{group}"
  action :create
  source "crontab.erb"
  mode 0644
end

bash "set run-periodic-tasks" do
  user "root"
  code <<-EOH
  crontab -u #{user} #{mt_root}/crontab
  EOH
end

# setup starman + start_server 
template "/etc/init.d/movabletype" do
  user "root"
  action :create
  source "init-script.erb"
  mode 0755
end

service "movabletype" do
  supports :start => true, :stop => true, :restart => true
  action [:enable, :start]
end
