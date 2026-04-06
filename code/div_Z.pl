#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";

# 除法 整数

# 問題生成 変数
my $num_eq = 1200; # 問題数
my $num_rng = 100; # 数値幅

# レイアウト 変数
my $layout_colmuns = 4; # 段組み数
my $layout_breaks = 15; # 改行問題数
my $hight_items = 10; # 改行間隔幅(pt)



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数


    # 問題の式 及び 解答
    my ($num) = gen_num(1, $num_rng, 1);
    my ($dnum) = gen_num(1, (int $num_rng/10), 0);
    $dnum = abs $dnum;

    ### 自然数への制限
    #$num = abs $num;

    # 問題
    $eq = $num . ' \div ' . $dnum;


    # 解答
    my ($quotient, $remainder); #商 剰余

    $remainder = $num % $dnum;
    if ($remainder < 0) {
            $remainder += $dnum;
    }

    $quotient = ($num - $remainder)/$dnum;

    $ans = '商\; ' . $quotient . ',\; 余り\; ' . $remainder;



    # 最終加工
#    $ans = "=" . $ans;

    # 数式モード付与
    $eq = '$' . $eq . '$';
    $ans = '$' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

