#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 乗法 複素数

# 問題生成 変数
my $num_eq = 900; # 問題数
my $num_rng = 10; # 数値幅

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
    my ($int1,$int2,$int3,$int4) = gen_num(4, $num_rng, 0); # 数字生成

    $eq = "(" . trans_cplx($int1, $int2) . ")";

    # 計算
    my $flag = 1; # 0:加減, 1:乗

    if ($flag == 0) {
        if (rand(2) <1) {
            $eq .= ' + ';
            $ans = trans_cplx($int1 + $int3, $int2 + $int4);
        } else {
            $eq .= ' - ';
            $ans = trans_cplx($int1 - $int3, $int2 - $int4);
        }
    } else {
        $eq .= '';
        $ans = trans_cplx($int1 * $int3 - $int2 * $int4, $int1 * $int4 + $int2 * $int3);
    }


    $eq .= "(" . trans_cplx($int3, $int4) . ")";



    # 最終加工
    $ans = "=" . $ans;

    # 数式モード付与
    $eq = '$\displaystyle ' . $eq . '$';
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

