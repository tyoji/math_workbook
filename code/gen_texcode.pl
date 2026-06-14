#!/bin/env perl

use strict;
use warnings;

my @perl_files = glob("*.pl");
my @rm_files = ($0, "latex_code.pl");

for my $file_name (@rm_files) {
    @perl_files = grep {$_ ne $file_name} @perl_files;
}

my @tex_files = map { s/\.pl$/\.tex/r } @perl_files;

for my $i (0..scalar(@perl_files)-1) {
    system("perl $perl_files[$i] >$tex_files[$i]");
}
