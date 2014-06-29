#!/usr/bin/perl -w

use strict;
use CGI;
use CGI::Carp qw(fatalsToBrowser);
use JIRA::Client;
use Data::Util qw(:validate);

my $jirauser = 'YOURUSER';
my $passwd   = 'YOURPASS';
my $icingacmd = "/var/lib/icinga/rw/icinga.cmd";
my $jira = "ttps://srfmmz.atlassian.net";

my @priorities = ('Blocker', 'Critical', 'Major', 'Minor');
my $priorityselect;


my $q = new CGI;
my %params = $q->Vars;
my $param;
my $out;
my $ackcommand;
my $now = time();  
my $comment;


foreach (@priorities) {
  $priorityselect .= "<option>" . $_ . "</option>\n";
 } 

if ($params{'insert'} eq 'insert') {
  my $jira = JIRA::Client->new($jira, $jirauser, $passwd);
  my $baseurl = $jira->getServerInfo()->{baseUrl};
  my $newissue = $jira->create_issue({
      project => 'OST',
      type    => 'Bug',
      summary => $params{'summary'},
      description => $params{'description'},
      priority => 'Blocker'
  });
  $out = "<h1>Created <a href='$baseurl/browse/$newissue->{key}'>$newissue->{key}</a></h1>\n";

  if($params{'acknowledge'} eq 'on'){
    $out .= "ACKNOWLEDGED  ";
    $ackcommand = "[$now] ACKNOWLEDGE_SVC_PROBLEM;$params{'hostname'};$params{'servicedesc'};0;0;0;$ENV{AUTHENTICATE_UID};$params{'summary'}\n\n$params{'description'}\n\n<a href='$baseurl/browse/$newissue->{key}'>$newissue->{key}</a>";
    $ackcommand =~ s/\n/<br>/g;
    open(my $fh, '>', $icingacmd) or die "Could not open file '$icingacmd' $!";
    print $fh $ackcommand;
    close $fh;

    #$out .= $ackcommand;
  }
}else{

  $out = "
  <form method='POST' action='$ENV{'_'}'>
  <input type='hidden' name='insert' id='insert' value='insert'>
  <input type='hidden' name='hostname' id='hostname' value='$params{'hostname'}'>
  <input type='hidden' name='servicedesc' id='servicedesc' value='$params{'servicedesc'}'>

  <table border=1 class='filter' cellspacing=20 cellpadding=0>
    <tr>
      <td>Summary</td>
      <td><input type='text' name='summary' id='summary' size='55' value='$params{'hostname'} -> $params{'servicedesc'}'></td>
    </tr>
    <tr>
      <td>Priority</td>
      <td>
        <select name='priority'>
          $priorityselect
        </select>
      </td>
    </tr>
    <tr>
      <td>Description</td>
      <td><textarea name='description' id='description' cols='50' rows='10'>{code}\n\n{code}$params{'description'} \n\n$ENV{AUTHENTICATE_UID}</textarea></td>
    </tr>

    <tr>
      <td>Acknowledge Alert</td>
      <td><input type='checkbox' name='acknowledge' id='acknowledge'></td>
    </tr>
    <tr>
      <td></td>
      <td><input type='submit'></td>
    </tr>
  </table>
  </form>
  ";
}

print "Content-type: text/html\n\n";
print "
<html>
<link rel='shortcut icon' href='/images/favicon.ico' type='image/ico'>
<meta http-equiv='Pragma' CONTENT='no-cache'>
<meta http-equiv='content-type' content='text/html; charset=utf-8'>
<title>Icinga Jira Bridge</title>
<link rel='stylesheet' TYPE='text/css' HREF='/stylesheets/common.css'>
<link rel='stylesheet' TYPE='text/css' HREF='/stylesheets/status.css'>
<link rel='stylesheet' type='text/css' href='/stylesheets/dd.css'/>
<body>
<div align='center'>
<p>";
 
# DEBUG START
#foreach $param (sort keys %params) {
#  print "$param = $params{$param} <br>";
#}
#DEBUG END
print $out;

print "
</div>
</body>
</html>";

