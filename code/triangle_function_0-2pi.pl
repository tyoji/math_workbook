#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 三角関数 0-2pi

# 問題生成 変数
my $num_eq = 1500; # 問題数
#my $num_rng = 5; # 数値幅

# レイアウト 変数
my $layout_colmuns = 3; # 段組み数
my $layout_breaks = 25; # 改行問題数
my $hight_items = 2; # 改行間隔幅(pt)
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

# 度数,弧度切り替えフラグ
my $aflag=1;

# 三角関数の値
my @vl=(
    "0",
    "\\frac{1}{2}",
    "\\frac{1}{\\sqrt{2}}",
    "\\frac{\\sqrt{3}}{2}",
    "1",
    "\\frac{1}{\\sqrt{3}}",
    "\\sqrt{3}"
    );

# 角度とその三角比の値のハッシュリスト
my @angles = (
    {"ques" => "\\sin{$values[0][$aflag]}", "ans" => $vl[0]},
    {"ques" => "\\sin{$values[1][$aflag]}", "ans" => $vl[1]},
    {"ques" => "\\sin{$values[2][$aflag]}", "ans" => $vl[2]},
    {"ques" => "\\sin{$values[3][$aflag]}", "ans" => $vl[3]},
    {"ques" => "\\sin{$values[4][$aflag]}", "ans" => $vl[4]},
    {"ques" => "\\sin{$values[5][$aflag]}", "ans" => $vl[3]},
    {"ques" => "\\sin{$values[6][$aflag]}", "ans" => $vl[2]},
    {"ques" => "\\sin{$values[7][$aflag]}", "ans" => $vl[1]},
    {"ques" => "\\sin{$values[8][$aflag]}", "ans" => $vl[0]},
    {"ques" => "\\sin{$values[9][$aflag]}", "ans" => "-".$vl[1]},
    {"ques" => "\\sin{$values[10][$aflag]}", "ans" => "-".$vl[2]},
    {"ques" => "\\sin{$values[11][$aflag]}", "ans" => "-".$vl[3]},
    {"ques" => "\\sin{$values[12][$aflag]}", "ans" => "-".$vl[4]},
    {"ques" => "\\sin{$values[13][$aflag]}", "ans" => "-".$vl[3]},
    {"ques" => "\\sin{$values[14][$aflag]}", "ans" => "-".$vl[2]},
    {"ques" => "\\sin{$values[15][$aflag]}", "ans" => "-".$vl[1]},
    {"ques" => "\\sin{$values[16][$aflag]}", "ans" => $vl[0]},
    {"ques" => "\\cos{$values[0][$aflag]}", "ans" => $vl[4]},
    {"ques" => "\\cos{$values[1][$aflag]}", "ans" => $vl[3]},
    {"ques" => "\\cos{$values[2][$aflag]}", "ans" => $vl[2]},
    {"ques" => "\\cos{$values[3][$aflag]}", "ans" => $vl[1]},
    {"ques" => "\\cos{$values[4][$aflag]}", "ans" => $vl[0]},
    {"ques" => "\\cos{$values[5][$aflag]}", "ans" => "-".$vl[1]},
    {"ques" => "\\cos{$values[6][$aflag]}", "ans" => "-".$vl[2]},
    {"ques" => "\\cos{$values[7][$aflag]}", "ans" => "-".$vl[3]},
    {"ques" => "\\cos{$values[8][$aflag]}", "ans" => "-".$vl[4]},
    {"ques" => "\\cos{$values[9][$aflag]}", "ans" => "-".$vl[3]},
    {"ques" => "\\cos{$values[10][$aflag]}", "ans" => "-".$vl[2]},
    {"ques" => "\\cos{$values[11][$aflag]}", "ans" => "-".$vl[1]},
    {"ques" => "\\cos{$values[12][$aflag]}", "ans" => $vl[0]},
    {"ques" => "\\cos{$values[13][$aflag]}", "ans" => $vl[1]},
    {"ques" => "\\cos{$values[14][$aflag]}", "ans" => $vl[2]},
    {"ques" => "\\cos{$values[15][$aflag]}", "ans" => $vl[3]},
    {"ques" => "\\cos{$values[16][$aflag]}", "ans" => $vl[4]},
    {"ques" => "\\tan{$values[0][$aflag]}", "ans" => $vl[0]},
    {"ques" => "\\tan{$values[1][$aflag]}", "ans" => $vl[5]},
    {"ques" => "\\tan{$values[2][$aflag]}", "ans" => $vl[4]},
    {"ques" => "\\tan{$values[3][$aflag]}", "ans" => $vl[6]},
    {"ques" => "\\tan{$values[4][$aflag]}", "ans" => "なし"},
    {"ques" => "\\tan{$values[5][$aflag]}", "ans" => "-".$vl[6]},
    {"ques" => "\\tan{$values[6][$aflag]}", "ans" => "-".$vl[4]},
    {"ques" => "\\tan{$values[7][$aflag]}", "ans" => "-".$vl[5]},
    {"ques" => "\\tan{$values[8][$aflag]}", "ans" => $vl[0]},
    {"ques" => "\\tan{$values[9][$aflag]}", "ans" => $vl[5]},
    {"ques" => "\\tan{$values[10][$aflag]}", "ans" => $vl[4]},
    {"ques" => "\\tan{$values[11][$aflag]}", "ans" => $vl[6]},
    {"ques" => "\\tan{$values[12][$aflag]}", "ans" => "なし"},
    {"ques" => "\\tan{$values[13][$aflag]}", "ans" => "-".$vl[6]},
    {"ques" => "\\tan{$values[14][$aflag]}", "ans" => "-".$vl[4]},
    {"ques" => "\\tan{$values[15][$aflag]}", "ans" => "-".$vl[5]},
    {"ques" => "\\tan{$values[16][$aflag]}", "ans" => $vl[0]},
);



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数

    # 問題の式 及び 解答
    my $nflag = int(rand(@angles));

    # 問題の式
    $eq = $angles[$nflag]->{ques};

    # 解答
    $ans = $angles[$nflag]->{ans};



    # 最終加工
    #$ans = "=" . $ans;
    if ($ans ne "なし") {
        $ans = "=" . $ans;
    } else {
        $ans = "\\quad " . $ans;
    }


    # 数式モード付与
    $eq = '$\displaystyle ' . $eq . '$';
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items, $ans_sp)
);

