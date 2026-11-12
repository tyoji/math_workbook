#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 2次不等式 因数分解利用

# 問題生成 変数
my $num_eq = 600; # 問題数
my $num_rng = 9; # 数値幅

# レイアウト 変数
my $layout_colmuns = 3; # 段組み数
my $layout_breaks = 10; # 改行問題数
my $hight_items = 30; # 改行間隔幅(pt)
my $ans_sp = 0; # 解答用スペース



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数


    # 問題の式 及び 解答

    #my @coeff = gen_num(4, $num_rng, 0); # 数字生成
    my @coeff = ( gen_num(2, $num_rng, 0), gen_num(2, $num_rng, 1) ); # 数字生成

    # 重解の排除
    while ( $coeff[0]*$coeff[3] == $coeff[1]*$coeff[2]  ) {
	@coeff = ( gen_num(2, $num_rng, 0), gen_num(2, $num_rng, 1) ); # 数字再生成
    }

    # 原始多項式
    my ($a1, $a2) = ($coeff[0]/gcd($coeff[0], $coeff[2]), $coeff[2]/gcd($coeff[0], $coeff[2]));
    my ($b1, $b2) = ($coeff[1]/gcd($coeff[1], $coeff[3]), $coeff[3]/gcd($coeff[1], $coeff[3]));

    # 問題
    $eq = trans_poly( $a1*$b1, $a1*$b2+$a2*$b1, $a2*$b2 );

    # 分数
    my ($value_a, $value_b) = ( trans_frac(-1*$a2, $a1), trans_frac(-1*$b2, $b1) );
    if ( -1*$a2/$a1 > -1*$b2/$b1 ) { ($value_a, $value_b) = ($value_b, $value_a); } # 大小順

    # 不等号のフラグ
    # $flag
    # 0 a < x < b
    # 1 a \leq x \leq b
    # 2 x < a, b < x
    # 3 x \leq a, b \leq x
    my $flag = int rand(4);

    # 解答
    if ($flag==0) { # 0 a < x < b
	$ans = "$value_a < x < $value_b";
	if ($a1*$b1 > 0) { $eq .= '<0'; } else { $eq .= '>0' }
    } elsif ($flag==1) { # 1 a \leq x \leq b
	$ans = "$value_a \\leqq x \\leqq $value_b";
	if ($a1*$b1 > 0) { $eq .= '\leq 0'; } else { $eq .= '\geq 0' }
    } elsif ($flag==2) { # 2 x < a, b < x
	$ans = "x < $value_a , \\; $value_b < x";
	if ($a1*$b1 > 0) { $eq .= '>0'; } else { $eq .= '<0' }
    } elsif ($flag==3) { # 3 x \leq a, b \leq x
	$ans = "x \\leqq $value_a , \\; $value_b \\leqq x";
	if ($a1*$b1 > 0) { $eq .= '\geq 0'; } else { $eq .= '\leq 0' }
    }

    


    # 最終加工
    #$ans = "x=" . $ans;

    # 数式モード付与
    $eq = '$' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items, $ans_sp)
);

