icinga2jira-bridge
==================

Create your Jira troubleshooting tickets in Icinga/Nagios. 

### What is it for
We have a businessprocess in which we create Jira tickets in Jira for Icinga alerts, where actions are needed. After creating the Ticket we acknowledge the alert in Icinga and write the Jira issuenumber into the comment. Pretty annoying ... 

This Perl script enables you to create Jira issues directly from your Icinga alerts. At the same time it will acknowledge your allert an leave a comment, with the Ticket-Number from Jira which was created for this alert. 

### Rquirements
 - Icinga 1.x
 - Perl 5.x
 - libexpat1-dev
 - Perl CPAN Module: JIRA-Client 0.41 
 - Perl CPAN Module: Data-Util 0.58
 - Perl CPAN Module: SOAP-Lite 1.11
 - Perl CPAN Module: Class-Inspector 1.24
 - Perl CPAN Module: XML-Parser 2.41

### How to install 
Make shure you have a propper Icinga installation.

Install the needed Library:
```
apt-get install libexpat1-dev
```

Download and install the necessary CPAN Modules:
```
wget http://search.cpan.org/CPAN/authors/id/G/GN/GNUSTAVO/JIRA-Client-0.41.tar.gz 
wget http://search.cpan.org/CPAN/authors/id/G/GF/GFUJI/Data-Util-0.58.tar.gz
wget http://search.cpan.org/CPAN/authors/id/P/PH/PHRED/SOAP-Lite-1.11.tar.gz
wget http://search.cpan.org/CPAN/authors/id/A/AD/ADAMK/Class-Inspector-1.24.tar.gz
wget http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/XML-Parser-2.41.tar.gz
```

Install the needed Library (required by XML-Parser):
```
apt-get install libexpat1-dev
```

copy the perl script to the right place and make shure its executable: 
Edit the credential variabls in the beginning of the scrip. 
```
cp jiraplugin.pl /usr/lib/cgi-bin/icinga/jiraplugin.pl
chmod +x /usr/lib/cgi-bin/icinga/jiraplugin.pl
```

Update your generic-service template (somewhere here : /etc/icinga/objects/templates.cfg ) to add the icon to every services:
```
action_url                      jiraplugin.pl?hostname=$HOSTNAME$&servicedesc=$SERVICEDESC$&serviceoutput=$SERVICEOUTPUT$
        }
### How to use


