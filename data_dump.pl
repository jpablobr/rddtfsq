#!/usr/bin/perl
# Author: José Pablo Barrantes R. <xjpablobrx@gmail.com>
# Created: 12 Mar 2011
# Version: 0.1.0

use warnings;
use strict;
use Tie::File;
use XML::Writer;
use File::Find;

my (@file_meta_data,
    @files_spliter,
    @file,
    %file,
    %files_parser_helper,
    $data_path,
    $solr_path,
    $xml_file,
    $file_path,
    $file_path_xml,
    $medium_details,
    $file_name,
    $writer,
    $path,
    $size,
    $datestamp,
    $year,
    $month,
    $day,
    $location,
    $key,
    $value,
    $n,
    $i
);

# Paths
$data_path = "../cd_details";
$solr_path = "./solr/example/exampledocs";

find( sub {
    my @dir_files = "$File::Find::name" unless -d && ! -f || $_ eq '' || $_ eq '.';

    for (@dir_files) {
        @files_spliter = split('/', $_);
        $files_parser_helper{$files_spliter[3]} = $files_spliter[2] unless
            $files_spliter[3] =~ m/\.xml$/;
    }
}, "$data_path" );

while (($key, $value) = each(%files_parser_helper)) {

    $file_path = $data_path . '/' . $value . '/' . $key;
    $file_path_xml = $file_path . '.xml';

    open($xml_file, "+> $file_path_xml") || die "problem opening xml_file\n";

    $writer = new XML::Writer( OUTPUT => $xml_file );
    $writer->xmlDecl( 'UTF-8' );
    $writer->startTag('add');

    tie @file,
        'Tie::File',
        $file_path or die "Could not open the file.";

    $location = $file[0];

    $n = 1;
    while ( $file[$n] ne '' ) { $medium_details .= " $file[$n] "; $n++; }

    $i = 0;
    for (@file) { $file{$i} = $_; $i++; }

    while (($key, $value) = each(%file)) {
        if ( $key > $n ) {
            @file_meta_data = split(':', $value);
            $file_name      = (defined $file_meta_data[0]) ? $file_meta_data[0] : 'no_file_name';
            $size           = (defined $file_meta_data[1]) ? $file_meta_data[1] : 'no_file_size';
            $path           = (defined $file_meta_data[5]) ? $file_meta_data[5] : 'no_file_path';
            $year           = (defined $file_meta_data[2]) ? $file_meta_data[2] : 'no_file_year';
            $month          = (defined $file_meta_data[3]) ? $file_meta_data[3] : 'no_file_month';
            $day            = (defined $file_meta_data[4]) ? $file_meta_data[4] : 'no_file_day';
            $datestamp      = $year . '/' . $month . '/' . $day;

            &creat_xml_file_element;
        }
    }
    $writer->endTag();
    $writer->end();

    system("java -jar $solr_path/post.jar $file_path_xml");
}

sub creat_xml_file_element {
    $writer->startTag('doc');
    $writer->startTag('field', 'name' => 'id');
    $writer->characters("$path");
    $writer->endTag();
    $writer->startTag('field', 'name' => 'name');
    $writer->characters("$file_name");
    $writer->endTag();
    $writer->startTag('field', 'name' => 'text');
    $writer->characters("$size");
    $writer->endTag('field');
    $writer->startTag('field', 'name' => 'cat');
    $writer->characters("$location");
    $writer->endTag('field');
    $writer->startTag('field', 'name' => 'features');
    $writer->characters("$medium_details");
    $writer->endTag('field');
    $writer->startTag('field', 'name' => 'text');
    $writer->characters("$location");
    $writer->endTag('field');
    $writer->endTag();
}

exit(0);
