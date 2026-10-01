#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 定積分

# 問題生成 変数
my $num_eq = 300; # 問題数
my $num_rng = 5; # 数値幅

# レイアウト 変数
my $layout_colmuns = 3; # 段組み数
my $layout_breaks = 5; # 改行問題数
my $hight_items = 80; # 改行間隔幅(pt)


my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数

    # 問題の式 及び 解答
    my @coeff = (gen_num(1, $num_rng, 0), gen_num(4, $num_rng, 1)); # 数字生成

    # 問題
    my ($alpha, $beta) = ($coeff[3], $coeff[4]);
    if ($alpha == $beta) { $beta++ }
    if ($alpha > $beta) { ($alpha, $beta) = ($beta, $alpha) }

    $eq = '\int_{' . $alpha . '}^{' . $beta . '}';
    
    if ( $coeff[0]>0 && $coeff[1] == 0 && $coeff[2] == 0 ){
        $eq .= trans_poly( $coeff[0], $coeff[1], $coeff[2] ) . ' \mathrm{d}x';
    } else {
        $eq .= '\left( ' . trans_poly( $coeff[0], $coeff[1], $coeff[2] ) . ' \right) \mathrm{d}x';
    }

    # 解答
    my $nu = 2*$coeff[0]*($beta**3-$alpha**3) + 3*$coeff[1]*($beta**2-$alpha**2) + $coeff[2]*($beta-$alpha);
    $ans = trans_frac($nu, 6);


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

