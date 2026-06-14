#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 多項式 除算

# 問題生成 変数
my $num_eq = 200; # 問題数
my $num_rng = 9; # 数値幅

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
    my @coeff = (gen_num(1, $num_rng, 0), gen_num(2, $num_rng, 1), # 除数 divisor
                 gen_num(1, $num_rng, 0), gen_num(3, $num_rng, 1)); # 商 剰余 # 数字生成

    # 係数の符号調整
    if ($coeff[0] <0) { $coeff[0] *= -1; $coeff[1] *= -1; $coeff[2] *= -1;}


    # 問題
    $eq = '(' .
            trans_poly(
                $coeff[0]*$coeff[3] ,
                $coeff[1]*$coeff[3] + $coeff[0]*$coeff[4] ,
                $coeff[2]*$coeff[3] + $coeff[1]*$coeff[4] ,
                                      $coeff[2]*$coeff[4]
            )
            . ') \div ('
                       . trans_poly($coeff[0], $coeff[1], $coeff[2]) . ')';

    # 解答
    $ans = "商 : " . trans_poly($coeff[3],$coeff[4])
        . ', \quad 剰余 : ' . trans_poly($coeff[5],$coeff[6]);



    # 最終加工
    #$ans = "=" . $ans;

    # 数式モード付与
    $eq = '$' . $eq . '$' . "\n";
    $ans = '$' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

