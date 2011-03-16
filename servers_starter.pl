#!/usr/bin/perl
use warnings;
use strict;

my $app_name = 'rddtfsq.pl';
my $solr_path = 'solr/example';

system("perl $app_name daemon > /dev/null 2>&1 &");
system("cd $solr_path && java -jar start.jar > /dev/null 2>&1 &");

print("both server started successfully!");

exit(0);
