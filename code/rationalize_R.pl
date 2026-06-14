#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";

# 加法 自然数
my $num_eq = 300; # 問題数
my $num_rng = 5; # 数値幅

# レイアウト
my $layout_colmuns = 3; # 段組み数
my $layout_breaks = 5; # 改行問題数
my $hight_items = 80; # 改行間隔幅(pt)


my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数

    # 問題の式 及び 解答

    my @num=(0,1,0,1,0,1,0,1); # 問題用整数

    while ( # 分子分母が0になる場合と分母が有理数になる場合を除去
            ($num[4] == 0 && $num[6] == 0)
            || ($num[4] == 0 && $num[7] == 1)
            || ($num[6] == 0 && $num[5] == 1)
            || ($num[5] == 1 && $num[7] == 1)
            || ($num[5] == $num[7])
            || ($num[0] == 0 && $num[2] == 0)
            || ($num[1] == 1 && $num[3] == 1 && $num[0] + $num[2] == 0)
            || ($num[1] == $num[3])
        ) {

        #my @in_root = gen_num(4, $num_rng, 0); # 数字生成 ルートの中
        my @in_root = gen_num(2, $num_rng, 0); # 数字生成 ルートの中
        @in_root = (@in_root, @in_root); # 分子分母のルートの中を同じ数にする
        my @out_root = gen_num(4, $num_rng, 1); # 数字生成 ルートの外
        @in_root = map{abs} @in_root; # 自然数への制限

        @num = # 問題の式に利用する数 ルートの外、内の順 4組
            (
             simplify_sqrt($in_root[0]),
             simplify_sqrt($in_root[1]),
             simplify_sqrt($in_root[2]),
             simplify_sqrt($in_root[3])
            );

        for my $i (0..3) { # 係数を掛ける
            $num[2*$i] *= $out_root[$i];
        }

        # 約分
        my $d = gcd(gcd($num[0],$num[2]),gcd($num[4],$num[6]));
        if ($d != 0) {
            ($num[0],$num[2],$num[4],$num[6]) = ($num[0]/$d, $num[2]/$d, $num[4]/$d, $num[6]/$d);
        }
    }


    #########################
    # 問い 生成
    #########################

    $eq = '\frac{';
    # 問い 分子
    if ($num[1] == 1 && $num[3] == 1) { # 整数となる場合
        $eq .= $num[0] + $num[2];
    } else { # 根号を含む場合
        # 第1項
        if ($num[0] != 0) {
            if ($num[1] == 1) {
                $eq .= $num[0];
            } else {
                $eq .= trans_num($num[0],1) . '\sqrt{' . $num[1] . '}';
            }
        }
        # 第2項
        if ($num[2] != 0) {
            if ($num[0] == 0) {
                if ($num[3] == 1) {
                    $eq .= $num[2];
                } else {
                    $eq .= trans_num($num[2],1) . '\sqrt{' . $num[3] . '}';
                }
            } else {
                if ($num[3] == 1) {
                    $eq .= trans_num($num[2],2);
                } else {
                    $eq .= trans_num($num[2],0) . '\sqrt{' . $num[3] . '}';
                }
            }
        }
    }

    $eq .= '}{';

    # 問い 分母
    # 第1項
    if ($num[4] != 0) {
        if ($num[5] == 1) {
            $eq .= $num[4];
        } else {
            $eq .= trans_num($num[4],1) . '\sqrt{' . $num[5] . '}';
        }
    }
    # 第2項
    if ($num[6] != 0) {
        if ($num[4] == 0) {
            if ($num[7] == 1) {
                $eq .= $num[6];
            } else {
                $eq .= trans_num($num[6],1) . '\sqrt{' . $num[7] . '}';
            }
        } else {
            if ($num[7] == 1) {
                $eq .= trans_num($num[6],2);
            } else {
                $eq .= trans_num($num[6],0) . '\sqrt{' . $num[7] . '}';
            }
        }
    }

    $eq .= '}';




    #########################
    # 解答 生成
    #########################


    # ($num[0] sqrt $num[1] + $num[2] sqrt $num[3])($num[4] sqrt $num[5] - $num[6] sqrt $num[7])
    # ------------------------------------------------------------------------------------------
    # ($num[4] sqrt $num[5] + $num[6] sqrt $num[7])($num[4] sqrt $num[5] - $num[6] sqrt $num[7])

    # 分母
    my $denominator = $num[4] ** 2 * $num[5] - $num[6] ** 2 * $num[7];
    if ($denominator<0) {
        $num[0] *= -1;
        $num[2] *= -1;
        $denominator *= -1;
    }
    # 分子
    my %numerator;

    sub times_sqrt {
        my @coe = @_;
        my ($out_root, $in_root) = simplify_sqrt( $coe[1]*$coe[3] );
        return ($coe[0]*$coe[2]*$out_root, $in_root);
    }

    my ($out_root, $in_root);

    ($out_root, $in_root) = times_sqrt($num[0], $num[1], $num[4], $num[5]);
    $numerator{$in_root} += $out_root;
    ($out_root, $in_root) = times_sqrt($num[0], $num[1], -1*$num[6], $num[7]);
    $numerator{$in_root} += $out_root;
    ($out_root, $in_root) = times_sqrt($num[2], $num[3], $num[4], $num[5]);
    $numerator{$in_root} += $out_root;
    ($out_root, $in_root) = times_sqrt($num[2], $num[3], -1*$num[6], $num[7]);
    $numerator{$in_root} += $out_root;


    # 約分
    my $gcd_value = $denominator;
    for my $k (keys %numerator) {
        if ($numerator{$k} == 0) {
            delete $numerator{$k};
        } else {
            $gcd_value = gcd($numerator{$k}, $gcd_value);
        }
    }
    $denominator /= $gcd_value;
    for my $k (keys %numerator) {
        $numerator{$k} /= $gcd_value;
    }

    my $numer_term;
    for my $k (keys %numerator) {
        if ($k>1) {
            $numer_term .= trans_num($numerator{$k},0) . '\sqrt{' . $k . '}';
        } else {
            $numer_term .= trans_num($numerator{$k},2);
        }
    }
    $numer_term =~ s/^\+//;


    if ($denominator == 1) {
        $ans = $numer_term;
    } else {
        $ans = '\frac{' . $numer_term . '}{' . $denominator . '}';
    }





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

