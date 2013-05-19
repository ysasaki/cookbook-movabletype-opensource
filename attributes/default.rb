#
# Cookbook Name:: movabletype-opensource
# Attribute:: default
#
# Copyright 2013, Yoshihiro Sasaki
#
# LICENSE: MIT License
# 

# VirtualHost
default['movabletype-opensource']['domain'] = "mt.example.com"

# for installation and web workers
default['movabletype-opensource']['owner'] = "apache"
default['movabletype-opensource']['group'] = "apache"

# MT MySQL
default['movabletype-opensource']['database'] = "movabletype"
default['movabletype-opensource']['dbuser'] = "movabletype"
default['movabletype-opensource']['dbpassword'] = "movabletype"
default['movabletype-opensource']['dbpassword'] = "movabletype"

# MT Default language
default['movabletype-opensource']['default_language'] = "ja"

# Starman
default['movabletype-opensource']['workers'] = 2
default['movabletype-opensource']['psgi_port'] = 80

# perl
default['movabletype-opensource']['perl_install_path'] = "/usr/local/perl-5.16"
default['movabletype-opensource']['perl_version'] = "5.16.3"
