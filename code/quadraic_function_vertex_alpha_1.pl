#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 2次関数 頂点の座標 易1

# 問題生成 変数
my $num_eq = 1140; # 問題数
my $num_rng = 10; # 数値幅

# レイアウト 変数
my $layout_colmuns = 3; # 段組み数
my $layout_breaks = 19; # 改行問題数
my $hight_items = 1; # 改行間隔幅(pt)



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数


    # 問題の式 及び 解答
    my @num = (gen_num(1, $num_rng, 0), gen_num(2, $num_rng, 1)); # 数字生成

    # 問題
    if ( $num[1]==0 ) {
        $eq = trans_poly( $num[0], $num[1], $num[2] );
    } else {
        $eq = trans_num($num[0],1) . '\left( ' . trans_poly(1, $num[1]) . '\right)^{2}' . trans_num($num[2], 2);
    }

    $eq = "y=" . $eq;

    # 解答
    $ans = '\left( ' . -1*$num[1] . " , " . $num[2] . ' \right)';


    # 最終加工
    $ans = "頂点" . $ans;

    # 数式モード付与
    $eq = '$\displaystyle ' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

