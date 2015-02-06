#!/usr/bin/perl

use Cwd 'abs_path';
use Data::Dumper;

if ( $#ARGV != 1 ) {
  print "Usage: ./aut2jff.pl <jff file> <jff.msgmap file>\n";
  exit;
}

$jff_file_path = abs_path($ARGV[0]);
$msgmap_file_path = abs_path($ARGV[1]);

if( !-e $jff_file_path ) {
  print "File $aut_file_path does not exist!\n";
  exit;
}
if( !-e $msgmap_file_path ) {
  print "File $aut_file_path does not exist!\n";
  exit;
}
open( JFF_FILE, $jff_file_path) or die $!;
open( MSGMAP_FILE, $msgmap_file_path) or die $!;
open(JFF_FILE_TMP, ">$jff_file_path.tmp") or die $!;

%msg = ();
while( <MSGMAP_FILE> ) {
  $line = $_;
  chomp $line;
  @tokens = split(':', $line);
  $msg{$tokens[0]} = $tokens[1];
}

while( <JFF_FILE> ) {
  $line = $_;
  chomp $line;
  if( $line =~ '<read>' ) {
    $line =~ m/(\d+)/;
    print JFF_FILE_TMP "\t\t\t\t<read>$msg{$1}</read>\n";
  } else {
    print JFF_FILE_TMP "$line\n";
  }
}

`mv $jff_file_path.tmp $jff_file_path`;
