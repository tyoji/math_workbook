#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 加減 多項式

# 問題生成 変数
my $num_eq = 760; # 問題数
my $num_rng = 9; # 数値幅

# レイアウト 変数
my $layout_colmuns = 2; # 段組み数
my $layout_breaks = 19; # 改行問題数
my $hight_items = 1; # 改行間隔幅(pt)



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数


    # 問題の式 及び 解答
    my @coeff = (gen_num(2, $num_rng, 0), gen_num(4, $num_rng, 1)); # 数字生成

    if(int(rand(2))>0){
        # 加法
        $eq = "("
            . trans_poly($coeff[0],$coeff[2],$coeff[4])
            . ")+("
            . trans_poly($coeff[1],$coeff[3],$coeff[5])
            .")";
        $ans = trans_poly($coeff[0]+$coeff[1],$coeff[2]+$coeff[3],$coeff[4]+$coeff[5]);
    } else {
        # 減法
        $eq = "("
            . trans_poly($coeff[0],$coeff[2],$coeff[4])
            . ")-("
            . trans_poly($coeff[1],$coeff[3],$coeff[5])
            .")";
        $ans = trans_poly($coeff[0]-$coeff[1],$coeff[2]-$coeff[3],$coeff[4]-$coeff[5]);
    }




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

