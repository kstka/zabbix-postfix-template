# zabbix-postfix-template
Zabbix template for Postfix SMTP server

Tested on zabbix 5.4.3 and Python3

originally orked from http://admin.shamot.cz/?p=424 , I forked it from kstka/zabbix-postfix-template

# Requirements
* [pflogsum](http://jimsun.linxnet.com/postfix_contrib.html)
* [pygtail](https://pypi.org/project/pygtail/)

# Installation
    # for Ubuntu / Debian
    apt-get install pflogsumm
    
    # for CentOS
    yum install postfix-perl-scripts
    
    # install pygtail using pip
    # alternatively you can manually install pygtail and specify the executable-path in zabbix-postfix-status.sh
    pip install pygtail
    
    # ! check MAILLOG path in zabbix-postfix-stats.sh
    # ! check path for pygtail executable
    cp zabbix-postfix-stats.sh /usr/bin/
    chmod +x /usr/bin/zabbix-postfix-stats.sh

    cp userparameter_postfix.conf /etc/zabbix/zabbix_agentd.d/
    
    # run visudo as root
    Defaults:zabbix !requiretty
    zabbix ALL=(ALL) NOPASSWD: /usr/bin/zabbix-postfix-stats.sh
    
    systemctl restart zabbix-agent

Finally import template_app_zabbix.xml and attach it to your host
