#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 方程式 解の公式利用

# 問題生成 変数
my $num_eq = 420; # 問題数
my $num_rng = 9; # 数値幅

# レイアウト 変数
my $layout_colmuns = 3; # 段組み数
my $layout_breaks = 7; # 改行問題数
my $hight_items = 55; # 改行間隔幅(pt)
my $ans_sp = 0; # 解答用スペース


my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数

    # 問題の式 及び 解答
    # 数字生成
    my @coeff = ( gen_num(1, $num_rng, 0), gen_num(2, $num_rng, 1) );

    # 係数調整
    if ($coeff[0] <0) { $coeff[0] *= -1; $coeff[1] *= -1; $coeff[2] *= -1; }

    # 判別式
    my $discriminant = $coeff[1]*$coeff[1] - 4*$coeff[0]*$coeff[2];

    # 複素数を排除
    while ($discriminant<0) {
        @coeff = ( gen_num(1, $num_rng, 0), gen_num(2, $num_rng, 1) );
        if ($coeff[0] <0) { $coeff[0] *= -1; $coeff[1] *= -1; $coeff[2] *= -1; }
        $discriminant = $coeff[1]*$coeff[1] - 4*$coeff[0]*$coeff[2];
    }

    # 原始多項式
    ($coeff[0], $coeff[1], $coeff[2])
        = ($coeff[0]/gcd($coeff[0], gcd($coeff[1], $coeff[2])),
           $coeff[1]/gcd($coeff[0], gcd($coeff[1], $coeff[2])),
           $coeff[2]/gcd($coeff[0], gcd($coeff[1], $coeff[2]))
        );

    # 問題
    $eq = trans_poly($coeff[0], $coeff[1], $coeff[2]);
    $eq .= "=0";

    # 解答
    my ($out_root, $in_root) = simplify_sqrt($discriminant);
    my ($numerator_b, $denominator_a) = (-1*$coeff[1], 2*$coeff[0]);

    if ($in_root==0) {
        $ans = trans_frac($numerator_b, $denominator_a);
    } elsif ($in_root==1) {
        if ( $numerator_b==0 ) {
            $ans = '\pm' . trans_frac($out_root, $denominator_a);
        } else {
            $ans = trans_frac( ($numerator_b+$out_root), $denominator_a )
                . ', \; ' . trans_frac( ($numerator_b-$out_root), $denominator_a );
        }
    } else {
        if ( $numerator_b==0 ) {
            ($out_root, $denominator_a) = (
                $out_root/gcd($out_root, $denominator_a),
                $denominator_a/gcd($out_root, $denominator_a)
                );
            if ( $denominator_a == 1 ) {
                $ans = '\pm ' . trans_num($out_root,1) . '\sqrt{' . $in_root . '}';
            } else {
                $ans = '\pm \frac{' . trans_num($out_root,1) . '\sqrt{' . $in_root . '}}{' . $denominator_a . '}';
            }
        } else {
            ($numerator_b, $out_root, $denominator_a) = (
                $numerator_b/gcd($numerator_b, gcd($out_root, $denominator_a)),
                $out_root/gcd($numerator_b, gcd($out_root, $denominator_a)),
                $denominator_a/gcd($numerator_b, gcd($out_root, $denominator_a)),
                );
            $ans = '\frac{' . $numerator_b . '\pm ' . trans_num($out_root,1) . '\sqrt{' . $in_root . '}}{' . $denominator_a . '}';
        }
    }

    # 最終加工
    $ans = "x=" . $ans;

    # 数式モード付与
    $eq = '$' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items, $ans_sp)
);

