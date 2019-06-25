#!/usr/bin/env perl
#
#   ARM Generator
#   Copyright (C) 2019 Institute for Software Technology at Graz University of Technology
#
#   This file is part of ARM Generator.
#
#   ARM Generator is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   ARM Generator is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with ARM Generator.  If not, see <https://www.gnu.org/licenses/>.
#
#   mail: ykoerogl@ist.tugraz.at
#   address: Inffeldgasse 16b/II, 8010 Graz/AUSTRIA
#
use lib '.';
use warnings; #no warnings 'once'; no warnings 'recursion';
use strict;
use autodie;
use v5.14;

my %component2model;
my %facts;
my %FSMstates;
my %FSMinputs;
my %FSMtransitions;

#
# Parameters
#   NONE
#
# Returns
#   UNUSED
#
sub showCopyright {
    say '';
    say 'ARM Generator Copyright (C) 2019 Institute for Software Technology at Graz University of Technology';
    say 'This program comes with ABSOLUTELY NO WARRANTY; for details type "show w".';
    say 'This is free software, and you are welcome to redistribute it';
    say 'under certain conditions; type "show c" for details.';
    say '';
}

#
# Parameters
#   NONE
#
# Returns
#   UNUSED
#
sub showWarranty {
    say '';
    say 'This program is distributed in the hope that it will be useful,';
    say 'but WITHOUT ANY WARRANTY; without even the implied warranty of';
    say 'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the';
    say 'GNU General Public License for more details.';
    say '';
    say 'You should have received a copy of the GNU General Public License';
    say 'along with this program.  If not, see <https://www.gnu.org/licenses/>.';
    say '';
}

#
# Parameters
#   NONE
#
# Returns
#   UNUSED
#
sub showLicense {
    open LICENSE, "<LICENSE" or die("No LICENSE file found!");
    print while(<LICENSE>);
    close LICENSE;
}

#
# Parameters
#	NONE
#
# Returns
#	UNUSED
#
sub showUsage {
	say '';
	say "$0 version 1906.25";
	say '';
	say "\tUsage: $0 <system-file> <template-file> <output-file>";
	say '';
}

sub main {
    my $SUTfile = shift @ARGV or (showUsage(), exit);
    my $templatefile = shift @ARGV or (showUsage(), exit);
    my $outputfile = shift @ARGV or (showUsage(), exit);

    say "LOADING TEMPLATE = $templatefile";
    open (TEMPLATES, "<$templatefile");
    my $lineno = 0;
    while (<TEMPLATES>) {
        if (/BEGIN COMPONENT (\S+)/) {
            my $componentTypeName = $1;
            #say "LOADING COMPONENT = $componentTypeName";
            my $line = <TEMPLATES>;
            if (defined $component2model{$componentTypeName}) {
                warn "Redefining $componentTypeName in Line $lineno";
            }
            $component2model{$componentTypeName} = '';
            until ($line =~ /END COMPONENT/) {
                $component2model{$componentTypeName} .= $line;
                $line = <TEMPLATES>;
            }
            say "COMPONENT TYPE = $componentTypeName";
        }
        $lineno++;
    }
    close (TEMPLATES);
    say "TEMPLATE LOADED = $templatefile";
    say '';

    open (OUTPUT, ">$outputfile");
    open (SUT, "<$SUTfile");
    my $cid = 0;
    my $sid = 0;
    while (my $line = <SUT>) {
        if ($line =~ /^\s*(\S+)\s*->\s*(\S+)\s*\[label=\"(\S+)\"\];/) {
            my ($state, $nextstate, $input) = ($1, $2, $3);
            $input =~ s/\\n//g;
            $FSMstates{$state} = '';
            $FSMstates{$nextstate} = '';
            $FSMinputs{$input} = '' unless ($input eq 'else');
            $FSMtransitions{"$state:$input"} = $nextstate;
        } else {
            for my $componentType (keys %component2model) {
                if ($line =~ /^\s*$componentType\s*\((.*)\);/) {
                    my $paramstr = $1;
                    $paramstr =~ s/\s//g;
                    $paramstr =~ s/\[//g;
                    $paramstr =~ s/\]//g;
                    my @parameters = split ',', $paramstr;
                    for (@parameters) {
                        $facts{$_} = "val($_,false), val($_,true) -> false.";
                    }

                    my $string = $component2model{$componentType};
                    $string =~ s/\#C/C$cid/g;
                    while ($string =~ /\#([0-9]+)/) {
                        my $pid = $1;
                        $string =~ s/\#$pid/$parameters[$pid]/g;
                    }

                    say OUTPUT $string;

                    $cid++;
                }
            }
        }
    }
    close (SUT);

    my @states = sort keys %FSMstates;
    my $i = 0;
    while ($i < $#states) {
        my $j = $i + 1;
        while ($j <= $#states) {
            $facts{"$states[$i]:$states[$j]"} = "state($states[$i]), state($states[$j]) -> false.\nnextstate($states[$i]), nextstate($states[$j]) -> false.";
            $j++;
        }
        $i++;
    }
    my @inputs = sort keys %FSMinputs;
    $i = 0;
    while ($i < $#inputs) {
        my $j = $i + 1;
        while ($j <= $#inputs) {
            $facts{"$inputs[$i]:$inputs[$j]"}
                = "val(FSMinput,$inputs[$i]), val(FSMinput,$inputs[$j]) -> false.";
            $j++;
        }
        $i++;
    }
    for my $state (@states) {
        my $stuckatpossible = 0;
        my %possiblenextstates = ();
        for my $input (@inputs) {
            if (defined $FSMtransitions{"$state:$input"}) {
                my $nextstate = $FSMtransitions{"$state:$input"};
                say OUTPUT "Correct($state), state($state), val(FSMinput,$input) -> nextstate($nextstate).";
                $stuckatpossible = 1 if ($state ne $nextstate);
                $possiblenextstates{$nextstate} = '';
            } elsif (defined $FSMtransitions{"$state:else"}) {
                my $nextstate = $FSMtransitions{"$state:else"};
                say OUTPUT "Correct($state), state($state), val(FSMinput,$input) -> nextstate($nextstate).";
                $stuckatpossible = 1 if ($state ne $nextstate);
                $possiblenextstates{$nextstate} = '';
            } else {
                warn("FSM may be incomplete. From state $state, there is no nextstate after input $input");
            }
        }
        if ($stuckatpossible) {
            say OUTPUT "StuckAt($state), state($state) -> nextstate($state).";
        }
        for my $candidate (@states) {
            unless ($state eq $candidate or defined $possiblenextstates{$candidate}) {
                say OUTPUT "StateGlitch($state), state($state) -> nextstate($candidate).";
            } else {
                for my $input (@inputs) {
                    unless (defined $FSMtransitions{"$state:$input"} or
                        (
                            defined $FSMtransitions{"$state:else"} and
                            defined $FSMtransitions{"$state:else"} eq $candidate
                        ))
                    {
                        say OUTPUT "TransitionGlitch($state), state($state), val(FSMinput,$input) -> nextstate($candidate).";
                    }
                }
            }
        }
        say OUTPUT '';
    }

    say OUTPUT $_ for (sort values %facts);
    close (OUTPUT);
}

showCopyright();
if ("@_" =~ /show w/) {
    showWarranty();
    exit;
} elsif ("@_" =~ /show c/) {
    showLicense();
    exit;
} else {
    main();
}
