use strict;
use warnings;

#### #### #### #### ####
# サブルーチン
#
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


# 最大公約数
# 整数を2つ入力し、正の整数が1つ出力される
sub gcd {
    my ($n1, $n2) = map {abs} @_;
    return $n2 == 0 ? $n1 : gcd($n2, $n1 % $n2);
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


# 根号内の数字と外の数字
# 引数 自然数
# 戻り値 配列(根号外、根号内)
sub simplify_sqrt {
    my ($outside, $inside, $div) = (1, shift, 2);
    while ($div * $div <= $inside) {
        $inside % ($div * $div) ? $div++ : ($outside *= $div, $inside /= $div * $div);
    }
    return ($outside, $inside);
}





#### #### #### #### ####
# サブルーチン
#
#
# LaTeX Code 生成

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

# 複素数出力
#
sub trans_cplx {
    my ($re, $im) = @_;
    my $cplx;

    if ($im == 0) {
        $cplx = $re;
    } else {
        if ($re) {
            $cplx = $re . trans_num($im, 0) . "i";;
        } else {
            $cplx = trans_num($im, 1) . "i";
        }
    }
    
    return $cplx;
}


# 多項式出力 LaTeX
# 引数に整数を指定し、それを係数とする多項式を出力
# 配列0番が最高次数の係数となり、末尾が定数項となる数式
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







# 問題集出力
# 引数は 問題配列、解答配列、段組数、1段あたりの問題数、行間(pt)
sub generate_latex_code {
    my ($ques_arr, $ans_arr, $cols, $brk, $sep) = @_;

    my $ques_num = scalar @$ques_arr;

    # ガード句: 配列が空、または引数が不正な場合
    return "Err" if ($ques_num == 0 || $cols <= 0 || $brk <= 0 || $sep <= 0);

    my $latex_code = "\\setcounter{quesnum}{" . ($cols * $brk) . "}\n\n";

    for my $count (0 .. 1) {

        # multicols 環境の開始 (引数 cols)
        $latex_code .= "\\begin{multicols}{" . $cols . "}\n";
        $latex_code .= "\\begin{enumerate}\n  \\itemsep=" . $sep . "pt\n";

        for my $i (0 .. $ques_num-1) {
            # 各要素を \item として追加
            $latex_code .= "  \\item " . $ques_arr->[$i] . "\n\n";

            $latex_code .= " " x 8;
            if ($count == 0) {$latex_code .= "\\phantom{"}
            $latex_code .= $ans_arr->[$i];
            if ($count == 0) {$latex_code .= "}"}
            $latex_code .= "\n\n";

            # $brk 個ごと、かつ配列の最後でない場合に \columnbreak を挿入
            if (($i + 1) % $brk == 0 && $i != $ques_num-1) {
                $latex_code .= "\\columnbreak % " . ($i+1) . "\n\n";
                if (($i + 1) % ($cols * $brk) == 0) {
                    $latex_code .= "\\resetques\n\n";
                }
            }
        }

        # 各環境を閉じる
        $latex_code .= "\\end{enumerate}\n";
        $latex_code .= "\\end{multicols}\n";

        if ($count == 0) {
            $latex_code .= "\n\\newpage\n";
            $latex_code .= "\\resetdrill\n\n";
        }

    }

    return $latex_code;
}


# 実行コード出力

print "\n\n%%% perl code : $0\n\n";

# End Of File
1;
