#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 多項式 因数分解

# 問題生成 変数
my $num_eq = 600; # 問題数
my $num_rng = 9; # 数値幅

# レイアウト 変数
my $layout_colmuns = 3; # 段組み数
my $layout_breaks = 10; # 改行問題数
my $hight_items = 30; # 改行間隔幅(pt)



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数


    # 問題の式 及び 解答
    my @coeff = gen_num(4, $num_rng, 0); # 数字生成

    # 係数の符号調整
    if ($coeff[0] <0) { $coeff[0] *= -1; $coeff[2] *= -1; }
    if ($coeff[1] <0) { $coeff[1] *= -1; $coeff[3] *= -1; }
    # 原始多項式
    ($coeff[0], $coeff[2]) = ($coeff[0]/gcd($coeff[0], $coeff[2]), $coeff[2]/gcd($coeff[0], $coeff[2]));
    ($coeff[1], $coeff[3]) = ($coeff[1]/gcd($coeff[1], $coeff[3]), $coeff[3]/gcd($coeff[1], $coeff[3]));


    # 解答
    if ( $coeff[0]==$coeff[1] && $coeff[2]==$coeff[3] ) {
        $ans = "(" . trans_poly($coeff[0],$coeff[2]) . ')^{2}';
    } else {
        $ans = "(" . trans_poly($coeff[0],$coeff[2])
            . ")(" . trans_poly($coeff[1],$coeff[3]) . ")";
    }
    # 問題
    $eq = trans_poly(
        $coeff[0]*$coeff[1],
        $coeff[0]*$coeff[3]+$coeff[1]*$coeff[2],
        $coeff[2]*$coeff[3]
        );




    # 最終加工
    $ans = "=" . $ans;

    # 数式モード付与
    $eq = '$' . $eq . '$' . "\n";
    $ans = '$' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

