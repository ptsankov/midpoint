#!/usr/bin/perl

use Cwd 'abs_path';
use Data::Dumper;

if ( $#ARGV != 1 ) {
  print "Usage: ./aut2jff.pl <aut file> <output file>\n";
  exit;
}

$aut_file_path = abs_path($ARGV[0]);
$jff_file_path = abs_path($ARGV[1]);

if( !-e $aut_file_path ) {
  print "File $aut_file_path does not exist!\n";
  exit;
}
if( -e $jff_file_path ) {
  `rm -i $jff_file_path`;
}

open (JFF_FILE, ">$jff_file_path");

%states = ();
%transitions = ();
%messages = ();

open( AUT_FILE, $aut_file_path) or die $!;
while( <AUT_FILE> ) {
  $line = $_;
  chomp $line;
  if( !($line =~ 'des' ) ) {
    @tokens = split('"',$line);
    $stateA = substr($tokens[0], 1, length($tokens[0])-2);
    $input = $tokens[1];
    $stateB = substr($tokens[2], 1, length($tokens[2])-2);
    $states{$stateA} = 1;
    $states{$stateB} = 1;
    $transitions{"$stateA:$input:$stateB"} = 1;
    if( $messages{$input} eq "") {
      $messages{$input} = scalar keys %messages;
    }
  }
}

print JFF_FILE "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?><!--Created with JFLAP 6.4.--><structure>\n";
print JFF_FILE "\t<type>fa</type>\n";
print JFF_FILE "\t\t<automaton>\n";
print JFF_FILE "\t\t\t<!--The list of states.-->\n";
foreach $state( sort { $a <=> $b } keys %states ) {
  print JFF_FILE "\t\t\t<state id=\"$state\" name=\"$state\">\n";
  if( $state eq 0 ) {
    print JFF_FILE "\t\t\t\t<initial/>\n";
  }
  print JFF_FILE "\t\t\t</state>\n";
}
print JFF_FILE "\t\t\t<!--The list of transitions.-->\n";
foreach $transition( keys %transitions ) {
  @tokens = split(':', $transition);
  print JFF_FILE "\t\t\t<transition>\n";
  print JFF_FILE "\t\t\t\t<from>$tokens[0]</from>\n";
  print JFF_FILE "\t\t\t\t<to>$tokens[2]</to>\n";
  if( $tokens[1] eq 'tau' ) {
    print JFF_FILE "\t\t\t\t<read/>\n";
  } else {
    print JFF_FILE "\t\t\t\t<read>$messages{$tokens[1]}</read>\n";
  }
  print JFF_FILE "\t\t\t</transition>\n";
}
print JFF_FILE "\t</automaton>\n";
print JFF_FILE "</structure>\n";

$msgmap_file_path = "$jff_file_path.msgmap";
open (MSG_FILE, ">$msgmap_file_path");
print "Mapping of messages:\n";
foreach $msg_id ( sort {$messages{$a}<=>$messages{$b}} keys %messages) {
  print "$messages{$msg_id} <-> $msg_id\n";
  print MSG_FILE "$messages{$msg_id}:$msg_id\n";
}
