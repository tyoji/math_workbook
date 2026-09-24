#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 微分

# 問題生成 変数
my $num_eq = 900; # 問題数
my $num_rng = 9; # 数値幅

# レイアウト 変数
my $layout_colmuns = 3; # 段組み数
my $layout_breaks = 15; # 改行問題数
my $hight_items = 10; # 改行間隔幅(pt)


my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数

    # 問題の式 及び 解答
    my @coeff = (gen_num(1, $num_rng, 0), gen_num(3, $num_rng, 1)); # 数字生成

    $coeff[0] = abs $coeff[0];

    # 問題
    $eq = "f(x)=" . trans_poly( $coeff[0], $coeff[1], $coeff[2], $coeff[3] );

    # 解答
    $ans = trans_poly( 3*$coeff[0], 2*$coeff[1], $coeff[2] );

    # 最終加工
    $ans = 'f^{\prime}(x)=' . $ans;

    # 数式モード付与
    $eq = '$' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

