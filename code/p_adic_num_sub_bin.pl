#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 2進数の差

# 問題生成 変数
my $num_eq = 600; # 問題数
my $num_rng = 63; # 数値幅

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
    my @number = gen_num(2, $num_rng, 0); # 数字生成
    @number = (abs $number[0], abs $number[1]);

    if ($number[0]<$number[1]){
	($number[0], $number[1]) = ($number[1], $number[0]);
    }

    # 問題
    my $num1_bin = sprintf("%b", $number[0]);
    my $num2_bin = sprintf("%b", $number[1]);

    $eq = $num1_bin . '_{(2)} - ' . $num2_bin . '_{(2)}';

    # 解答
    $ans = sprintf("%b", $number[0] - $number[1]) . '_{(2)}';


    # 最終加工
    $ans = '=' . $ans;

    # 数式モード付与
    $eq = '$' . $eq . '$' . "\n";
    $ans = '$' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;
}

# 問題 解答 出力
print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);
