APSPFNC7 ;IHS/MSC/PJJ/PLS - Number to Word Formatting ;25-Feb-2013 11:56;DKA
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1015**;Sep 23, 2004;Build 62
 ;=================================================================
 ;Returns textual representation of a numeric value
WRDFMT(INT) ;EP-
 N RET,COMP,X
 S RET=""
 Q:INT'=+INT RET
 ; DKA 2013-02-25 artf13536 Return null for decimal values, per grammatical standard.
 Q:INT'=(INT\1) RET
 S X=+INT
 Q:+INT=0 $$LABEL($T(BASE+1))
 F I=1:1:3 Q:X=0  D
 .S COMP(I)=X#1000
 .S X=X\1000
 F I=1:1:3 D
 .Q:'$G(COMP(4-I))
 .S RET=$$ADD(RET,$$ADD($$GRPTOWD(COMP(4-I)),$$LABEL($T(SCALES+4-I))),", ")
 K COMP,X
 Q RET
 ;
LABEL(TEXT) ;EP-
 ;Q $E(TEXT,4,99)
 Q $P(TEXT,";;",2)
ADD(RES,EXTRA,SEP) ;EP-
 Q RES_$S((RES'="")&(EXTRA'=""):$G(SEP," "),1:"")_EXTRA
GRPTOWD(GROUP) ;EP-
 N HDRDS,TENMOD,TENS,ONES,RES
 S RES=""
 S HDRDS=GROUP\100
 S TENMOD=GROUP#100
 S TENS=TENMOD\10
 S ONES=TENMOD#10
 S:HDRDS'=0 RES=$$LABEL($T(BASE+HDRDS+1))_" Hundred"
 I TENS>1 D
 .S RES=$$ADD(RES,$$LABEL($T(TENS+TENS+1)))
 .S:ONES'=0 RES=$$ADD(RES,$$LABEL($T(BASE+ONES+1)))
 E  I TENMOD'=0 D
 .S RES=$$ADD(RES,$$LABEL($T(BASE+TENMOD+1)))
 Q RES
BASE ;EP-
 ;;Zero
 ;;One
 ;;Two
 ;;Three
 ;;Four
 ;;Five
 ;;Six
 ;;Seven
 ;;Eight
 ;;Nine
 ;;Ten
 ;;Eleven
 ;;Twelve
 ;;Thirteen
 ;;Fourteen
 ;;Fifteen
 ;;Sixteen
 ;;Seventeen
 ;;Eighteen
 ;;Nineteen
TENS ;EP-
 ;
 ;
 ;;Twenty
 ;;Thirty
 ;;Forty
 ;;Fifty
 ;;Sixty
 ;;Seventy
 ;;Eighty
 ;;Ninety
SCALES ;EP-
 ;
 ;;Thousand
 ;;Million
 ;;Billion
 ;;Trillion
ASSERT(EXPR,MSG) ;EP-
 N Y
 X EXPR
 W $S(Y:"Passed",1:"Failed")_": "_MSG,!
 Q Y
ASSRTEQ(EXP,ACTL) ;EP-
 Q $$ASSERT("S Y=$S("""_EXP_"""="""_ACTL_""":1,1:0)",EXP_" equal to "_ACTL)
TEST ;EP-
 Q:'$$ASSRTEQ($$WRDFMT(0),"Zero")
 Q:'$$ASSRTEQ($$WRDFMT(60),"Sixty")
 Q:'$$ASSRTEQ($$WRDFMT(1),"One")
 Q:'$$ASSRTEQ($$WRDFMT(17),"Seventeen")
 Q:'$$ASSRTEQ($$WRDFMT(100),"One Hundred")
 Q:'$$ASSRTEQ($$WRDFMT(150),"One Hundred Fifty")
 Q:'$$ASSRTEQ($$WRDFMT(115),"One Hundred Fifteen")
 Q:'$$ASSRTEQ($$WRDFMT(1115),"One Thousand, One Hundred Fifteen")
 Q:'$$ASSRTEQ($$WRDFMT(2000114),"Two Million, One Hundred Fourteen")
 Q:'$$ASSRTEQ($$WRDFMT(6.5),"")
