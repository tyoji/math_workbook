#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 多項式 円の方程式

# 問題生成 変数
my $num_eq = 600; # 問題数
my $num_rng = 7; # 数値幅

# レイアウト 変数
my $layout_colmuns = 2; # 段組み数
my $layout_breaks = 15; # 改行問題数
my $hight_items = 3; # 改行間隔幅(pt)



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数


    # 問題の式 及び 解答
    my @num = gen_num(3, $num_rng, 1); # 数字生成

    my $radius_nu = $num[0]*$num[0] + $num[1]*$num[1] - 4*$num[2]; # 半径の分子
    
    while ($radius_nu <=0) {
	@num = gen_num(3, $num_rng, 1); # 再生成
	$radius_nu = $num[0]*$num[0] + $num[1]*$num[1] - 4*$num[2];
    }

    my ($x_coodinate, $y_coodinate) = (trans_frac(-1*$num[0], 2), trans_frac(-1*$num[1], 2)); # 座標

    
    # 問題
    $eq = 'x^{2}+y^{2}';
    if ($num[0] != 0) {
	$eq .= trans_num($num[0],0) . 'x';
    }
    if ($num[1] != 0) {
	$eq .= trans_num($num[1],0) . 'y';
    }
    if ($num[2] != 0) {
	$eq .= trans_num($num[2],2);
    }
    $eq .= '=0';

    # 解答

    my ($rad_out_sq, $rad_in_sq) = simplify_sqrt ($radius_nu);

    my $radius;
    if ($rad_in_sq == 1) {
	$radius = trans_frac($rad_out_sq, 2);
    } else {
	my $gcd = gcd($rad_out_sq, 2);
	if ($gcd == 2) {
	    $radius = trans_num($rad_out_sq/$gcd,1) . '\sqrt{' . $rad_in_sq . '}';
	} else {
	    $radius = '\frac{' . trans_num($rad_out_sq/$gcd,1) . '\sqrt{' . $rad_in_sq . '}}{2}';
	}
    }

    $ans = '中心\: \left(' . $x_coodinate . ',' . $y_coodinate . '\right), \quad 半径 \ ' . $radius;


    # 最終加工
    #$ans = "=" . $ans;

    # 数式モード付与
    $eq = '$' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

