#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 多項式 平方完成 難

# 問題生成 変数
my $num_eq = 300; # 問題数
my $num_rng = 5; # 数値幅

# レイアウト 変数
my $layout_colmuns = 3; # 段組み数
my $layout_breaks = 5; # 改行問題数
my $hight_items = 90; # 改行間隔幅(pt)



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数


    # 問題の式 及び 解答
    my @num = (gen_num(2, $num_rng, 0), gen_num(1, $num_rng, 1)); # 数字生成

    # 問題
    $eq = trans_poly( $num[0], $num[1], $num[2]);


    # 解答
    my $p_term = "+" . trans_frac($num[1], 2*$num[0]);
    $p_term =~ s/\+-/-/;

    $ans = trans_num($num[0],1) . '\left( x' . $p_term . '\right)^{2}';

    my $discriminant = -1*$num[1]*$num[1]+4*$num[0]*$num[2];
    if($discriminant){
        my $q_term = "+" . trans_frac($discriminant, 4*$num[0]);
        $q_term =~ s/\+-/-/;
        $ans .= $q_term;
    }



    # 最終加工
    $ans = "=" . $ans;

    # 数式モード付与
    $eq = '$' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

