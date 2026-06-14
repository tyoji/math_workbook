#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 加減 多項式

# 問題生成 変数
my $num_eq = 200; # 問題数
my $num_rng = 3; # 数値幅

# レイアウト 変数
my $layout_colmuns = 2; # 段組み数
my $layout_breaks = 5; # 改行問題数
my $hight_items = 95; # 改行間隔幅(pt)



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数


    # 問題の式 及び 解答
    my @coeff = gen_num(6, $num_rng, 0); # 数字生成

    # 係数の符号調整
    if ($coeff[0] <0) { $coeff[0] *= -1; $coeff[1] *= -1; }
    if ($coeff[2] <0) { $coeff[2] *= -1; $coeff[3] *= -1; }
    if ($coeff[4] <0) { $coeff[4] *= -1; $coeff[5] *= -1; }

    # 原始多項式
    my ($a1, $b1) = ($coeff[0]/gcd($coeff[0], $coeff[1]), $coeff[1]/gcd($coeff[0], $coeff[1]));
    my ($a2, $b2) = ($coeff[2]/gcd($coeff[2], $coeff[3]), $coeff[3]/gcd($coeff[2], $coeff[3]));
    my ($a3, $b3) = ($coeff[4]/gcd($coeff[4], $coeff[5]), $coeff[5]/gcd($coeff[4], $coeff[5]));


    # 解答
    my %polynomial_degree;
    $polynomial_degree{"(" . trans_poly($a1, $b1) . ")" }++;
    $polynomial_degree{"(" . trans_poly($a2, $b2) . ")" }++;
    $polynomial_degree{"(" . trans_poly($a3, $b3) . ")" }++;

#    $ans="";
    for my $polynomial (sort keys %polynomial_degree) {
        my $deg = $polynomial_degree{ $polynomial };
        if ($deg >1) {
            $ans .= "$polynomial ^{ $deg }";
        } else {
            $ans .= $polynomial;
        }
    }



    # 問題
    $eq = trans_poly(
        $a1 * $a2 * $a3,
        ($a1 * $a2 * $b3) + ($a1 * $b2 * $a3) + ($b1 * $a2 * $a3),
        ($a1 * $b2 * $b3) + ($b1 * $a2 * $b3) + ($b1 * $b2 * $a3),
        $b1 * $b2 * $b3
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

