#
# Cookbook Name:: movabletype-opensource
# Attribute:: default
#
# Copyright 2013, Yoshihiro Sasaki
#
# LICENSE: MIT License
# 

default['movabletype-opensource']['domain'] = "mt.example.com"
default['movabletype-opensource']['owner'] = "apache"
default['movabletype-opensource']['group'] = "apache"
default['movabletype-opensource']['database'] = "movabletype"
default['movabletype-opensource']['dbuser'] = "movabletype"
default['movabletype-opensource']['dbpassword'] = "movabletype"
default['movabletype-opensource']['dbpassword'] = "movabletype"
default['movabletype-opensource']['default_language'] = "ja"
default['movabletype-opensource']['psgi_port'] = 8080
default['movabletype-opensource']['perl_install_path'] = "/usr/local/perl-5.16"
default['movabletype-opensource']['perl_version'] = "5.16.3"
