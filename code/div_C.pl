#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 除法 複素数

# 問題生成 変数
my $num_eq = 600; # 問題数
my $num_rng = 5; # 数値幅

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
    my ($int1,$int2,$int3,$int4) = gen_num(4, $num_rng, 0); # 数字生成

    $eq = "(" . trans_cplx($int1, $int2) . ")";
    $eq .= '\div';

    # 計算
    my ($re_nu, $im_nu, $de) # 分子(実部、虚部) 分母
        = ($int1 * $int3 + $int2 * $int4,
           -1 * $int1 * $int4 + $int2 * $int3,
           $int3 * $int3 + $int4 * $int4);

    if ($im_nu) {
        if ($re_nu){
            $ans = trans_frac($re_nu, $de);
            if ($im_nu >0) { $ans .= "+"; }
            if ($im_nu/$de == -1) {
                $ans .= "-i"
            } elsif ($im_nu/$de == 1) {
                $ans .= "i"
            } else {
                $ans .= trans_frac($im_nu, $de) . "i";
            }
        } else {
            if ($im_nu/$de == -1) {
                $ans = "-i"
            } elsif ($im_nu/$de == 1) {
                $ans = "i"
            } else {
                $ans = trans_frac($im_nu, $de) . "i";
            }
        }
    } else {
        $ans = trans_frac($re_nu, $de);
    }


    $eq .= "(" . trans_cplx($int3, $int4) . ")";



    # 最終加工
    $ans = "=" . $ans;

    # 数式モード付与
    $eq = '$\displaystyle ' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

