#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 不定積分

# 問題生成 変数
my $num_eq = 600; # 問題数
my $num_rng = 9; # 数値幅

# レイアウト 変数
my $layout_colmuns = 3; # 段組み数
my $layout_breaks = 10; # 改行問題数
my $hight_items = 20; # 改行間隔幅(pt)


my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数

    # 問題の式 及び 解答
    my @coeff = (gen_num(1, $num_rng, 0), gen_num(2, $num_rng, 1)); # 数字生成

    # 問題
    if ( $coeff[0]>0 && $coeff[1] == 0 && $coeff[2] == 0 ){
        $eq = '\int ' . trans_poly( $coeff[0], $coeff[1], $coeff[2] ) . ' \mathrm{d}x';
    } else {
        $eq = '\int \left( ' . trans_poly( $coeff[0], $coeff[1], $coeff[2] ) . ' \right) \mathrm{d}x';
    }

    # 解答
    if ( gcd($coeff[0], 3) == 3 ) {
        $ans = trans_num( $coeff[0]/3, 1 ) . 'x^{3}';
    } else {
        $ans = trans_frac($coeff[0], 3) . 'x^{3}';
    }

    if ( $coeff[1] != 0 ) {
        if ( gcd($coeff[1], 2) == 2 ) {
            $ans .= trans_num( $coeff[1]/2, 0 ) . 'x^{2}';
        } else {
            $ans .= '+' . trans_frac( $coeff[1], 2) . 'x^{2}';
        }
        $ans =~ s/\+-/-/;
    }

    if ( $coeff[2] != 0 ) {
        $ans .= trans_num($coeff[2], 0) . 'x';
    }

    $ans .= '+ C';


    # 最終加工
    $ans = '=' . $ans;

    # 数式モード付与
    $eq = '$\displaystyle ' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;
}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

