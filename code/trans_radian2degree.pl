#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 度数法から弧度法

# 問題生成 変数
my $num_eq = 2000; # 問題数
#my $num_rng = 5; # 数値幅

# レイアウト 変数
my $layout_colmuns = 4; # 段組み数
my $layout_breaks = 25; # 改行問題数
my $hight_items = 3; # 改行間隔幅(pt)
my $ans_sp = 0; # 解答用スペース



# 度数,弧度
my @values=(
    ['0^{\circ}', '0'],
    ['30^{\circ}', '\frac{\pi}{6}'],
    ['45^{\circ}', '\frac{\pi}{4}'],
    ['60^{\circ}', '\frac{\pi}{3}'],
    ['90^{\circ}', '\frac{\pi}{2}'],
    ['120^{\circ}', '\frac{2}{3}\pi'],
    ['135^{\circ}', '\frac{3}{4}\pi'],
    ['150^{\circ}', '\frac{5}{6}\pi'],
    ['180^{\circ}', '\pi'],
    ['210^{\circ}', '\frac{7}{6}\pi'],
    ['225^{\circ}', '\frac{5}{4}\pi'],
    ['240^{\circ}', '\frac{4}{3}\pi'],
    ['270^{\circ}', '\frac{3}{2}\pi'],
    ['300^{\circ}', '\frac{5}{3}\pi'],
    ['315^{\circ}', '\frac{7}{4}\pi'],
    ['330^{\circ}', '\frac{11}{6}\pi'],
    ['360^{\circ}', '2\pi'],
    );



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数

    # 問題の式 及び 解答
    my $nflag = int(rand(@values));

    # 問題
    $eq = $values[$nflag][1];

    # 解答
    $ans = $values[$nflag][0];

    # 最終加工
    $ans = "=" . $ans;

    # 数式モード付与
    $eq = '$\displaystyle ' . $eq . '$';
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items, $ans_sp)
);

