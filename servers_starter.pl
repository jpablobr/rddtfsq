#!/usr/bin/perl
use warnings;
use strict;

my $app_name = 'rddtfsq.pl';
my $solr_path = 'solr/example';

system("perl $app_name daemon &");
system("cd $solr_path && java -jar start.jar &");

print("both server started successfully!");

exit(0);