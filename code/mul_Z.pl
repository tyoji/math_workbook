#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";

# 乗法 整数

# 問題生成 変数
my $num_eq = 2400; # 問題数
my $num_rng = 9; # 数値幅

# レイアウト 変数
my $layout_colmuns = 4; # 段組み数
my $layout_breaks = 30; # 改行問題数
my $hight_items = 5; # 改行間隔幅(pt)



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数

    # 問題の式 及び 解答

    my @number = gen_num(2, $num_rng, 1); # 数字生成


    #### 自然数への制限

    #@number = map{abs} @number;



    $eq = $number[0] . '\times ';
    if ( $number[1] < 0 ){
        $eq .= "(" . $number[1] . ")";
    } else {
        $eq .= $number[1];
    };
    $ans = $number[0] * $number[1];


    # 最終加工
    $ans = "=" . $ans;

    # 数式モード付与
    $eq = '$' . $eq . '$';
    $ans = '$' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

