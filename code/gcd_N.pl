#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";

# 最大公約数
#
my $num_eq = 200; # 問題数
my $num_rng = 10000; # 数値幅

# レイアウト
my $layout_colmuns = 2; # 段組み数
my $layout_breaks = 5; # 改行問題数
my $hight_items = 100; # 改行間隔幅(pt)


my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {
    my ($eq,$ans); # 問題の数式と解答用変数


    # 問題の式 及び 解答

    my ($num1, $num2) = map{abs} gen_num(2,$num_rng,0);

    while (gcd($num1, $num2)<=10) {
        ($num1, $num2) = map{abs} gen_num(2,$num_rng,0);
    }
    $eq = $num1 . ",\\; " . $num2 . "\n";


    # 解答

    $ans = "最大公約数\\; " . gcd($num1, $num2);

    my $anser;
    $anser = $ans;

    push @ques, $eq;
    push @ans, $anser;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

