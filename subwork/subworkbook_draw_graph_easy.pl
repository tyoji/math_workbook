#!/bin/env perl

use strict;
use warnings;

use utf8;
use Encode;

my $print_title = "2次関数のグラフ";
my $num_eq = 120; # 問題数
my $num_rng = 3; # 数値幅

# レイアウト
my $layout_colmuns = 2; # 段組み数
#my $layout_breaks = 12; # 改行問題数
my $hight_items = 40; # 改行間隔幅(pt)



my @ques; # 問題用配列
my @ans; # 解答用配列

# メイン 問題解答生成
for (1..$num_eq) {
    my ($int1,$int2,$int3) = gen_num(3, $num_rng, 0); # 数字生成
    my ($eq,$ans); # 問題の数式と解答用変数

    my ($xver,$yver,$const) = (-1*$int2, $int3, $int1*$int2**2+$int3);

    # 解答
    $ans = '軸:$ x=' . $xver . ' $ , \quad 頂点:$ ( ' . $xver . ' , ' . $yver . ') $' . "\n\n";
    if ($const == 0) {
        $ans .= "\\genbasegraph{$int1}{$xver}{$yver}{}";
    } else {
        $ans .= "\\genbasegraph{$int1}{$xver}{$yver}{$const}";
    }

    my $graph_area =5;
    if (abs($const) < 5) {
        $ans .= "{$graph_area}{0.5}";
    } else {
        $ans .= "{" . abs($const) * 1.2 . "}{" . 5 / abs($const) / 2.4 . "}";
    }



    # 問題の式
    #$eq = "y= " . trans_poly ($int1, 2*$int1*$int2, $int1*$int2**2+$int3);
    $eq = "y= " . trans_num($int1,1) . '\left( ' . trans_poly (1, $int2) . '\right)^{2}'
        . trans_num($int3,2);

    my $anser = "" . $ans;

    push @ques, $eq;
    push @ans, $anser;

}



####*####*####*####*####*####*####*####*####*####*

# ヘッダ プリアンブル

my $header =<<'HEADER';
\documentclass[b5paper,10pt]{ltjsarticle}
%\documentclass[landscape,a4paper,10pt]{ltjsarticle}

\usepackage[top=15truemm,bottom=10truemm,left=10truemm,right=10truemm]{geometry}

\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhead[L]{%\fbox{練習問題} \:
HEADER

$header .= $print_title;

$header .=<<'HEADER';
 %\qquad {\tiny 生成日:\today}
}
\fancyhead[R]{クラス\hspace{30pt}番号\hspace{30pt}名前\hspace{100pt} \qquad
HEADER

$header .= '/' . $num_eq . '}';

$header .=<<'HEADER';
\fancyfoot{}

\usepackage{tikz}

\newcommand{\genbasegraph}[6]{
\begin{tikzpicture}[scale=#6,samples=150]

 % 数値表記 数式環境内LaTeXコマンド
 \def\grph{#1}; % グラフのパラメータ
 \def\xvertex{#2}; % 座標 頂点のx座標 整数小数分数
 \def\yvertex{#3}; % 座標 頂点のy座標 整数小数分数

 \def\ysep{\grph*\xvertex*\xvertex+\yvertex}; % 座標 y軸との交点 整数小数分数
 \def\func{\grph*(\x-\xvertex)^2+\yvertex}; % グラフの式
  %\ifnum \valconst=2 -(\x+1)^2+1 \else (\x+1)^2+1 \fi

 %軸に振る座標の値
 \def\valconst{#4};
 \def\valxver{\xvertex};
 \def\valyver{\yvertex};

 %座標空間の大きさ
 \def\xleft{-#5};
 \def\xright{#5};
 \def\ybottom{-#5};
 \def\ytop{#5};

 %%%%%
 % xy座標
 \draw[->] (\xleft,0) |- (\xright,0) node[below left] at (\xright,0) {$x$};
 \draw[->] (0,\ybottom) |- (0,\ytop) node[above left] at (0,\ytop) {$y$};

 \ifnum \xvertex > 0
   \ifnum \yvertex > 0
     \node[below left] at (0,0) {$O$};
   \else
     \node[above left] at (0,0) {$O$};
   \fi
 \else
   \ifnum \yvertex > 0
     \node[below right] at (0,0) {$O$};
   \else
     \node[above right] at (0,0) {$O$};
   \fi
 \fi
 %%%%%

 \begin{scope}
  \clip (\xleft,\ybottom) rectangle (\xright,\ytop);

  \draw[domain=-10:10] plot (\x,{\func}); % グラフ描画
 \end{scope}

% \draw (\xvertex,0) -- (\xvertex,\yvertex) -- (0,\yvertex);
 \draw[dashed] (\xvertex,0) |- (0,\yvertex);
 \ifnum \yvertex > 0
   \node[below] at (\xvertex,0) {$\valxver$} % 頂点のx座標を軸の下に表示
 \else
   \node[above] at (\xvertex,0) {$\valxver$} % 頂点のx座標を軸の上に表示
 \fi;
 \ifnum \xvertex > 0
   \node[left] at (0,\yvertex) {$\valyver$} % 頂点のy座標を軸の左に表示
 \else
   \node[right] at (0,\yvertex) {$\valyver$} % 頂点のx座標を軸の右に表示
 \fi;
 \ifnum \xvertex > 0
   \node[left] at (0,\ysep) {$\valconst$};
 \else
   \node[right] at (0,\ysep) {$\valconst$};
 \fi;
\end{tikzpicture}
}


\renewcommand{\labelenumi}{(\theenumi)}
%\renewcommand{\baselinestretch}{8}

\usepackage{multicol}

\begin{document}
\small
HEADER

#### #### #### ####
# multicols 環境
#### #### #### ####
my $begin_multicols =<<"BEGINMULTICOLS";
\\begin{multicols}{ $layout_colmuns }
\\begin{enumerate}
\\setlength{\\itemsep}{$hight_items pt}
BEGINMULTICOLS

my $end_multicols =<<'ENDMULTICOLS';
\end{enumerate}
\end{multicols}
ENDMULTICOLS


#### #### #### ####
# フッタ出力
my $footer =<<'FOOTER';
\end{document}
FOOTER


####*####*####*####*####*####*####*####*####*####*
####*####*  LaTeX コード出力
####*####*####*####*####*####*####*####*####*####*


print encode('UTF-8', $header);

print $begin_multicols;
#### #### #### ####
# 問題出力
for my $i (0..$#ques){
#    print '\item $', $ques[$i], '$', "\n";
    print encode('UTF-8',
                 '\item $\displaystyle{} '. $ques[$i]. '$'. "\n". "\n"
#        '\phantom{$', '\displaystyle{} ', $ans[$i], '$}', "\n\n";
                 #                . '\phantom{'. $ans[$i]. '}'. "\n\n"
                 . '\vspace{170pt}'
        );
#    print '\vfill', "\n";
#    if ($i!= $#ques and $i % $layout_breaks == $layout_breaks-1){
#        print '\columnbreak', "\n"
#    }
}

print $end_multicols;

print '\newpage', "\n";

print $begin_multicols;
#### #### #### ####
# 解答出力
for my $i (0..$#ques){
    print encode('UTF-8',
        '\item $\displaystyle{} '. $ques[$i]. '$'. "\n".
         "\n".
                 $ans[$i]. "\n\n"
                 );
#    print '\vfill', "\n";
#    if ($i!= $#ques and $i % $layout_breaks == $layout_breaks-1){
#        print '\columnbreak', "\n";
#    }
}

print $end_multicols;

print $footer;

####*####*####*####*####*####*####*####*####*####*





#### #### #### #### ####
# サブルーチン
#
# 数字の生成
#
# 引数
# 1. 生成する数字の個数 1以上の整数
# 2. 数字の大きさ 1以上の整数n を指定すると、 -n ～ n を生成
# 3. 零の有無 フラグ0 を立てると生成する数に0を含まない
#
sub gen_num {
    my ($count, $range, $include_zero) = @_;
    my @nums;

    while (@nums < $count) {
        my $num = int(rand(2 * $range + 1)) - $range;

        # 0 を含めるかどうかをチェック
        next if !$include_zero && $num == 0;

        push @nums, $num;
    }

    return @nums;
}

# 互いに素な2数を出力
sub coprime_num {
    my ($item, $range, $zero) = @_;
    my @num = gen_num(2,$range,0);
    return gcd(@num)==1 ? @num : coprime_num($item, $range, $zero);
}


# 係数の変換
# 引数
# 1 数値
# 2 フラグ
## 1 式の頭 +記号はつけない -1は-にする
## 2 式の末尾 +記号はつける -1はそのまま
## 0 式の内部 +記号はつける -1は-にする
sub trans_num {
    my ($n, $flag) = @_;
    my $output;

    if ($flag==1) {
        $output="";
    } else {
        $output="+";
    }

    if ($n>1) {
        $output .= $n;
    } elsif ($n<-1) {
        $output = $n;
    } elsif ($n == -1) {
        if ($flag==2) {$output =$n;}else{$output = "-";}
    } elsif ($n==1) {
        if ($flag==2) {$output .=$n;}
    } elsif ($n==0) {
        $output="";
    }

    return $output;
}



# 分数出力 LaTeX
# LaTeX 分数を出力
# 引数は (分子, 分母)
sub trans_frac {
    my ($numerator,  $denominator) = @_;
    my $output="";

    if ($numerator * $denominator <0) {$output = "-";} # 符号チェック
    ($numerator,  $denominator) = (abs $numerator, abs $denominator); # 正の整数へ変換
    my $g = gcd($numerator,  $denominator); # 最大公約数

    if ($g == $denominator) {
        $output .= $numerator/$g ; # 約分ができる場合
    } else {
        $output .= '\frac{' .  ($numerator / $g)  . '}{' . ($denominator / $g) . '}';
    }

    return $output;
}


# 最大公約数
# 整数を2つ入力し、正の整数が1つ出力される
sub gcd {
    my ($n1, $n2) = map {abs} @_;
    return $n2 == 0 ? $n1 : gcd($n2, $n1 % $n2);
}


# 多項式出力 LaTeX
# 引数に整数を指定し、それを係数とする多項式を出力
sub trans_poly {

    my @coefficients = @_;
    my $degree = $#coefficients;
    my $formula = '';

    for my $i (0 .. $degree) {
        my $coeff = $coefficients[$i];
        my $exp = $degree - $i;

        next if $coeff == 0;

        # 符号の処理
        if ($formula ne '') {
            $formula .= $coeff > 0 ? '+' : '';
        }

        # 係数の絶対値を使用して出力（1は省略）
        if ($exp > 1) {
            $formula .= ($coeff == 1 ? '' : $coeff == -1 ? '-' : $coeff) . "x^{$exp}";
        } elsif ($exp == 1) {
            $formula .= ($coeff == 1 ? '' : $coeff == -1 ? '-' : $coeff) . 'x';
        } else {
            $formula .= $coeff;
        }
    }

    return $formula;

}
