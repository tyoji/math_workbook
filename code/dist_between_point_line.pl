#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 微分

# 問題生成 変数
my $num_eq = 400; # 問題数
my $num_rng = 3; # 数値幅

# レイアウト 変数
my $layout_colmuns = 2; # 段組み数
my $layout_breaks = 10; # 改行問題数
my $hight_items = 30; # 改行間隔幅(pt)


my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数

    # 問題の式 及び 解答
    my @coeff = gen_num(5, $num_rng, 0); # 数字生成


    # 問題
    $eq = trans_num( $coeff[0], 1 ) . "x"
        . trans_num( $coeff[1], 0 ) . "y"
        . trans_num( $coeff[2], 2 )
        . "=0";

    $eq = "直線:" . $eq . ',\quad ' . "点 ( $coeff[3], $coeff[4] )";

    # 解答
    my $frac_nu = abs( $coeff[0]*$coeff[3] + $coeff[1]*$coeff[4] + $coeff[2] );

    if ( $frac_nu == 0 ) {
        $ans =0;
    } else {
        my ($frac_de_out, $frac_de_in)
            = simplify_sqrt( $coeff[0]*$coeff[0] + $coeff[1]*$coeff[1] );

        if ($frac_nu == $frac_de_out * $frac_de_in ) {
            $ans = '\sqrt{' . $frac_de_in . '}';
        } else {
            $ans = trans_frac( $frac_nu, $frac_de_out * $frac_de_in )
                . '\sqrt{' . $frac_de_in . '}';
        }
    }

    # 最終加工
    $ans = '距離 : ' . $ans;

    # 数式モード付与
    $eq = '$' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;
}

print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);
