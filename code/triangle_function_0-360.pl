#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 三角関数 0-360

# 問題生成 変数
my $num_eq = 1500; # 問題数
#my $num_rng = 5; # 数値幅

# レイアウト 変数
my $layout_colmuns = 5; # 段組み数
my $layout_breaks = 15; # 改行問題数
my $hight_items = 7; # 改行間隔幅(pt)



# 三角比の値
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
    {"ques" => "\\sin{0^\\circ}", "ans" => $vl[0]},
    {"ques" => "\\sin{30^\\circ}", "ans" => $vl[1]},
    {"ques" => "\\sin{45^\\circ}", "ans" => $vl[2]},
    {"ques" => "\\sin{60^\\circ}", "ans" => $vl[3]},
    {"ques" => "\\sin{90^\\circ}", "ans" => $vl[4]},
    {"ques" => "\\sin{120^\\circ}", "ans" => $vl[3]},
    {"ques" => "\\sin{135^\\circ}", "ans" => $vl[2]},
    {"ques" => "\\sin{150^\\circ}", "ans" => $vl[1]},
    {"ques" => "\\sin{180^\\circ}", "ans" => $vl[0]},
    {"ques" => "\\sin{210^\\circ}", "ans" => "-".$vl[1]},
    {"ques" => "\\sin{225^\\circ}", "ans" => "-".$vl[2]},
    {"ques" => "\\sin{240^\\circ}", "ans" => "-".$vl[3]},
    {"ques" => "\\sin{270^\\circ}", "ans" => "-".$vl[4]},
    {"ques" => "\\sin{300^\\circ}", "ans" => "-".$vl[3]},
    {"ques" => "\\sin{315^\\circ}", "ans" => "-".$vl[2]},
    {"ques" => "\\sin{330^\\circ}", "ans" => "-".$vl[1]},
    {"ques" => "\\sin{360^\\circ}", "ans" => $vl[0]},
    {"ques" => "\\cos{0^\\circ}", "ans" => $vl[4]},
    {"ques" => "\\cos{30^\\circ}", "ans" => $vl[3]},
    {"ques" => "\\cos{45^\\circ}", "ans" => $vl[2]},
    {"ques" => "\\cos{60^\\circ}", "ans" => $vl[1]},
    {"ques" => "\\cos{90^\\circ}", "ans" => $vl[0]},
    {"ques" => "\\cos{120^\\circ}", "ans" => "-".$vl[1]},
    {"ques" => "\\cos{135^\\circ}", "ans" => "-".$vl[2]},
    {"ques" => "\\cos{150^\\circ}", "ans" => "-".$vl[3]},
    {"ques" => "\\cos{180^\\circ}", "ans" => "-".$vl[4]},
    {"ques" => "\\cos{210^\\circ}", "ans" => "-".$vl[3]},
    {"ques" => "\\cos{225^\\circ}", "ans" => "-".$vl[2]},
    {"ques" => "\\cos{240^\\circ}", "ans" => "-".$vl[1]},
    {"ques" => "\\cos{270^\\circ}", "ans" => $vl[0]},
    {"ques" => "\\cos{300^\\circ}", "ans" => $vl[1]},
    {"ques" => "\\cos{315^\\circ}", "ans" => $vl[2]},
    {"ques" => "\\cos{330^\\circ}", "ans" => $vl[3]},
    {"ques" => "\\cos{360^\\circ}", "ans" => $vl[4]},
    {"ques" => "\\tan{0^\\circ}", "ans" => $vl[0]},
    {"ques" => "\\tan{30^\\circ}", "ans" => $vl[5]},
    {"ques" => "\\tan{45^\\circ}", "ans" => $vl[4]},
    {"ques" => "\\tan{60^\\circ}", "ans" => $vl[6]},
    {"ques" => "\\tan{90^\\circ}", "ans" => "なし"},
    {"ques" => "\\tan{120^\\circ}", "ans" => "-".$vl[6]},
    {"ques" => "\\tan{135^\\circ}", "ans" => "-".$vl[4]},
    {"ques" => "\\tan{150^\\circ}", "ans" => "-".$vl[5]},
    {"ques" => "\\tan{180^\\circ}", "ans" => $vl[0]},
    {"ques" => "\\tan{210^\\circ}", "ans" => $vl[5]},
    {"ques" => "\\tan{225^\\circ}", "ans" => $vl[4]},
    {"ques" => "\\tan{240^\\circ}", "ans" => $vl[6]},
    {"ques" => "\\tan{270^\\circ}", "ans" => "なし"},
    {"ques" => "\\tan{300^\\circ}", "ans" => "-".$vl[6]},
    {"ques" => "\\tan{315^\\circ}", "ans" => "-".$vl[4]},
    {"ques" => "\\tan{330^\\circ}", "ans" => "-".$vl[5]},
    {"ques" => "\\tan{360^\\circ}", "ans" => $vl[0]},
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
    }


    # 数式モード付与
    $eq = '$\displaystyle ' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items)
);

