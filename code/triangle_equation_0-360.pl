#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

require "./latex_code.pl";


# 三角方程式 0-360

# 問題生成 変数
my $num_eq = 1360; # 問題数
#my $num_rng = 5; # 数値幅

# レイアウト 変数
my $layout_colmuns = 4; # 段組み数
my $layout_breaks = 17; # 改行問題数
my $hight_items = 1; # 改行間隔幅(pt)
my $ans_sp = 0; # 解答用スペース


# 度数,弧度
my @angles=(
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
my $angle_flag=0;

# 三角関数の値
my @values_triangle_function=(
    "0",
    "\\frac{1}{2}",
    "\\frac{1}{\\sqrt{2}}",
    "\\frac{\\sqrt{3}}{2}",
    "1",
    "\\frac{1}{\\sqrt{3}}",
    "\\sqrt{3}"
    );

# 角度とその三角比の値のハッシュリスト
my @tri_func = (
    {func => "sin", angle => $angles[0][$angle_flag], value => $values_triangle_function[0]},
    {func => "sin", angle => $angles[1][$angle_flag], value => $values_triangle_function[1]},
    {func => "sin", angle => $angles[2][$angle_flag], value => $values_triangle_function[2]},
    {func => "sin", angle => $angles[3][$angle_flag], value => $values_triangle_function[3]},
    {func => "sin", angle => $angles[4][$angle_flag], value => $values_triangle_function[4]},
    {func => "sin", angle => $angles[5][$angle_flag], value => $values_triangle_function[3]},
    {func => "sin", angle => $angles[6][$angle_flag], value => $values_triangle_function[2]},
    {func => "sin", angle => $angles[7][$angle_flag], value => $values_triangle_function[1]},
    {func => "sin", angle => $angles[8][$angle_flag], value => $values_triangle_function[0]},
    {func => "sin", angle => $angles[9][$angle_flag], value => "-".$values_triangle_function[1]},
    {func => "sin", angle => $angles[10][$angle_flag], value => "-".$values_triangle_function[2]},
    {func => "sin", angle => $angles[11][$angle_flag], value => "-".$values_triangle_function[3]},
    {func => "sin", angle => $angles[12][$angle_flag], value => "-".$values_triangle_function[4]},
    {func => "sin", angle => $angles[13][$angle_flag], value => "-".$values_triangle_function[3]},
    {func => "sin", angle => $angles[14][$angle_flag], value => "-".$values_triangle_function[2]},
    {func => "sin", angle => $angles[15][$angle_flag], value => "-".$values_triangle_function[1]},
#    {func => "sin", angle => $angles[16][$angle_flag], value => $values_triangle_function[0]},
    {func => "cos", angle => $angles[0][$angle_flag], value => $values_triangle_function[4]},
    {func => "cos", angle => $angles[1][$angle_flag], value => $values_triangle_function[3]},
    {func => "cos", angle => $angles[2][$angle_flag], value => $values_triangle_function[2]},
    {func => "cos", angle => $angles[3][$angle_flag], value => $values_triangle_function[1]},
    {func => "cos", angle => $angles[4][$angle_flag], value => $values_triangle_function[0]},
    {func => "cos", angle => $angles[5][$angle_flag], value => "-".$values_triangle_function[1]},
    {func => "cos", angle => $angles[6][$angle_flag], value => "-".$values_triangle_function[2]},
    {func => "cos", angle => $angles[7][$angle_flag], value => "-".$values_triangle_function[3]},
    {func => "cos", angle => $angles[8][$angle_flag], value => "-".$values_triangle_function[4]},
    {func => "cos", angle => $angles[9][$angle_flag], value => "-".$values_triangle_function[3]},
    {func => "cos", angle => $angles[10][$angle_flag], value => "-".$values_triangle_function[2]},
    {func => "cos", angle => $angles[11][$angle_flag], value => "-".$values_triangle_function[1]},
    {func => "cos", angle => $angles[12][$angle_flag], value => $values_triangle_function[0]},
    {func => "cos", angle => $angles[13][$angle_flag], value => $values_triangle_function[1]},
    {func => "cos", angle => $angles[14][$angle_flag], value => $values_triangle_function[2]},
    {func => "cos", angle => $angles[15][$angle_flag], value => $values_triangle_function[3]},
#    {func => "cos", angle => $angles[16][$angle_flag], value => $values_triangle_function[4]},
    {func => "tan", angle => $angles[0][$angle_flag], value => $values_triangle_function[0]},
    {func => "tan", angle => $angles[1][$angle_flag], value => $values_triangle_function[5]},
    {func => "tan", angle => $angles[2][$angle_flag], value => $values_triangle_function[4]},
    {func => "tan", angle => $angles[3][$angle_flag], value => $values_triangle_function[6]},
    {func => "tan", angle => $angles[4][$angle_flag], value => "なし"},
    {func => "tan", angle => $angles[5][$angle_flag], value => "-".$values_triangle_function[6]},
    {func => "tan", angle => $angles[6][$angle_flag], value => "-".$values_triangle_function[4]},
    {func => "tan", angle => $angles[7][$angle_flag], value => "-".$values_triangle_function[5]},
    {func => "tan", angle => $angles[8][$angle_flag], value => $values_triangle_function[0]},
    {func => "tan", angle => $angles[9][$angle_flag], value => $values_triangle_function[5]},
    {func => "tan", angle => $angles[10][$angle_flag], value => $values_triangle_function[4]},
    {func => "tan", angle => $angles[11][$angle_flag], value => $values_triangle_function[6]},
    {func => "tan", angle => $angles[12][$angle_flag], value => "なし"},
    {func => "tan", angle => $angles[13][$angle_flag], value => "-".$values_triangle_function[6]},
    {func => "tan", angle => $angles[14][$angle_flag], value => "-".$values_triangle_function[4]},
    {func => "tan", angle => $angles[15][$angle_flag], value => "-".$values_triangle_function[5]},
#    {func => "tan", angle => $angles[16][$angle_flag], value => $values_triangle_function[0]},
);


my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {

    my ($eq,$ans); # 問題の数式と解答用変数

    # 問題の式 及び 解答
    my $num_of_tri_func = int(rand(@tri_func));
    while ($tri_func[$num_of_tri_func]->{value} eq "なし") {
        $num_of_tri_func = int(rand(@tri_func));
    }

    # 問題の式
    my ($fn, $val)
        = ($tri_func[$num_of_tri_func]->{func}, $tri_func[$num_of_tri_func]->{value});
    $eq = "\\".$fn . "{x}  = " . $val;

    # 解答
    $ans = "";
    for (@tri_func) {
        my ($fn_tr, $an_tr, $vl_tr) = ($_->{func}, $_->{angle}, $_->{value});
        if ($fn eq $fn_tr && $val eq $vl_tr){
            if ($ans ne "") {$ans .= " , ";}
            $ans .= $an_tr;
        }
    }




    # 最終加工
    $ans = "x = " . $ans;


    # 数式モード付与
    $eq = '$\displaystyle ' . $eq . '$' . "\n";
    $ans = '$\displaystyle ' . $ans . '$';

    push @ques, $eq;
    push @ans, $ans;

}


print encode("UTF-8",
  generate_latex_code(\@ques, \@ans, $layout_colmuns, $layout_breaks, $hight_items, $ans_sp)
);

