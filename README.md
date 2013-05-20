Movable Type Open Source Cookbook
=================================

Installs/Configures Movable Type Open Source

* Reverse Proxy and Server static contents - Nginx
* Database - MySQL
* PSGI Server - Starman

This cookbook is based on [デザイナー必見！VPSで高速なMovable Type用サーバをゼロから構築する方法(How to setup Movable Type on VPS for Designers)](http://www.skyarc.co.jp/engineerblog/entry/movabletype_psgi_mysql.html).  
Thanks to [@onagatani](https://twitter.com/onagatani) and [SKYARC CO.,Ltd.](http://www.skyarc.co.jp)

Requirements
------------

Platform
--------

* CentOS

Tested on:

* CentOS release 6.4 (Final)

Packages
--------

* `nginx`
* `mysql` - client and server
* `yum::epel`
* `simple_iptables`

Attributes
----------

#### movabletype-opensource::default

* `default['movabletype-opensource']['domain']` - "mt.example.com"
* `default['movabletype-opensource']['user']` - "movabletype"
* `default['movabletype-opensource']['database']` - "movabletype"
* `default['movabletype-opensource']['dbuser']` - "movabletype"
* `default['movabletype-opensource']['dbpassword']` - "movabletype"
* `default['movabletype-opensource']['default_language']` - "ja"
* `default['movabletype-opensource']['workers']` - 2
* `default['movabletype-opensource']['psgi_port']` - 80
* `default['movabletype-opensource']['perl_install_path']` - "/usr/local/perl-5.16"
* `default['movabletype-opensource']['perl_version']` - "5.16.3"

Chef Solo
---------
```json
{
    "run_list": [
        "yum::epel",
        "nginx",
        "simple_iptables",
        "mysql::server",
        "mysql::client",
        "movabletype-opensource"
    ],
    "movabletype-opensource": {
        "psgi_port": "8080"
    },
    "mysql": {
        "server_root_password": "secret",
        "server_repl_password": "secret",
        "server_debian_password": "secret",
        "tunable": {
            "remove_anonymous_users": true,
            "remove_test_database": true,
            "key_buffer_size": "32M",
            "max_connections": "128",
            "server_id": "1",
            "log_bin": "/var/lib/mysql/mysql-bin",
            "sync_bin_log": "1",
            "log_error": "/var/log/mysql/mysql-error.log"
        }
    },
    "simple_iptables": {
        "rules": {
            "filter" : [
                "-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT",
                "-A INPUT -p icmp -j ACCEPT",
                "-A INPUT -i lo -j ACCEPT",
                "-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT",
                "-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT",
                "-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT",
                "-A INPUT -j REJECT --reject-with icmp-host-prohibited",
                "-A FORWARD -j REJECT --reject-with icmp-host-prohibited"
            ]
        }
    }
}
```

License and Authors
-------------------

The MIT License (MIT)

Copyright (c) 2013 Yoshihiro Sasaki
