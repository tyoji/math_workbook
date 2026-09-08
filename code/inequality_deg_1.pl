#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 一次不等式

# 問題生成 変数
my $num_eq = 900; # 問題数
my $num_rng = 9; # 数値幅

# レイアウト 変数
my $layout_colmuns = 3; # 段組み数
my $layout_breaks = 15; # 改行問題数
my $hight_items = 9; # 改行間隔幅(pt)



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数


    # 問題の式 及び 解答
    my @coeff = gen_num(4, $num_rng, 0); # 数字生成
    while ($coeff[0]==$coeff[2]){
        @coeff = gen_num(4, $num_rng, 0); # 数字再生成
    }
    my $flag_sign = int rand(4);
    my @sign = ('<', '>', '\leqq ', '\geqq ');

    # 問題
    $eq = trans_poly($coeff[0], $coeff[1])
        . $sign[$flag_sign] .
        trans_poly($coeff[2], $coeff[3]);

    # 解答
    # 分子分母
    my ($numer, $denomi) = ($coeff[3]-$coeff[1], $coeff[0]-$coeff[2]);

    $ans = "x";
    if ($denomi < 0) {
        if ($flag_sign == 0 or $flag_sign == 2) {
            $flag_sign++;
        } else {
            $flag_sign--;
        }
    }
    $ans .= $sign[$flag_sign];
    $ans .= trans_frac($numer, $denomi);


    # 数式モード付与
    $eq = '$' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

