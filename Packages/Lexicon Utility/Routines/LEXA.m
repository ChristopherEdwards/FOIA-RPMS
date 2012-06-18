LEXA ;ISA/FJF-Look-up (Silent) ;09-10-01
 ;;2.0;LEXICON UTILITY;**3,4,6,19**;Sep 23, 1996
 ;
 ; Look-up  D LOOK^LEXA(LEXX,LEXAP,LEXLL,LEXSUB)
 ;
 ;         LEXX    user input         LEXAP     application,
 ;         LEXLL   list length        LEXSUB    Mode/Subset
 ;
 ; 1.  Search parameters ^TMP("LEXSCH",$J,PAR)=VALUE
 ; 2.  Expressions found ^TMP("LEXFND",$J,FQ,IEN)=DT
 ; 3.  Review List       ^TMP("LEXHITS",$J,#)=IEN^DT
 ; 4.  Display List      LEX("LIST",#)
 ;
 ;         LEX("LIST",0)=LAST^TOTAL
 ;         LEX("LIST",#)=IEN^DT
 ;
LOOK(LEXX,LEXAP,LEXLL,LEXSUB) ; Search for LEXX
 K DIERR,LEX
 K ^TMP("LEXFND",$J),^TMP("LEXHIT",$J)
 K:+$G(^TMP("LEXSCH",$J,"ADF",0))=0 ^TMP("LEXSCH",$J)  ; PCH 6
 I $D(DIC(0)) D
 .S:DIC(0)["L" DIC(0)=$P(DIC(0),"L",1)_$P(DIC(0),"L",2)
 .S:DIC(0)["I" DIC(0)=$P(DIC(0),"I",1)_$P(DIC(0),"I",2)
 S LEXQ=1,LEXX=$G(LEXX)
 I LEXX=""!(LEXX["^") D EN^LEXAR("^") K LEXAP D EXIT Q
 S LEXAP=$$UP^XLFSTR($G(LEXAP))
 S LEXLL=+$G(LEXLL)
 S LEXSUB=$G(LEXSUB)
 S ^TMP("LEXSCH",$J,"APP",0)=+$$AP^LEXDFN2($G(LEXAP))
 S:^TMP("LEXSCH",$J,"APP",0)=0 ^TMP("LEXSCH",$J,"APP",0)=1
 S:LEXSUB="" LEXSUB=^TMP("LEXSCH",$J,"APP",0)
 S:$L($G(DIC("S"))) ^TMP("LEXSCH",$J,"FIL",0)=DIC("S")
 S:LEXLL=0 LEXLL=5
 S ^TMP("LEXSCH",$J,"LEN",0)=LEXLL
X ; Search for X
 I '$L($G(LEXX)) D  D EXIT Q
 .S LEX("ERR",0)=$G(LEX("ERR",0))+1
 .S LEX("ERR",LEX("ERR",0))="User input LEXX missing or invalid"
APP ; Application
 I +$G(^TMP("LEXSCH",$J,"APP",0))=0!('$D(^LEXT(757.2,+$G(^TMP("LEXSCH",$J,"APP",0)),0))) D  D EXIT Q
 .S LEX("ERR",0)=$G(LEX("ERR",0))+1
 .S LEX("ERR",LEX("ERR",0))="Calling application identification LEXAP missing or invalid"
USR ; User
 I +$G(DUZ)=0!('$D(^VA(200,+$G(DUZ),0))) D  D EXIT Q
 .S LEX("ERR",0)=$G(LEX("ERR",0))+1
 .S LEX("ERR",LEX("ERR",0))="User identification DUZ missing or invalid"
 N LEXFND
 S LEXFND=0
 S ^TMP("LEXSCH",$J,"USR",0)=+$G(DUZ)
 S ^TMP("LEXSCH",$J,"NAR",0)=LEXX
 S ^TMP("LEXSCH",$J,"SCH",0)=$$UP^XLFSTR(LEXX)
 ;
DEF ; Defaults                     CONFIG^LEXSET
 N LEXFIL,LEXDSP,LEXFILR S:$L($G(DIC("S"))) LEXFIL=DIC("S")
 I '$L($G(LEXFIL)),$L($G(^TMP("LEXSCH",$J,"FIL",0))) S LEXFIL=^TMP("LEXSCH",$J,"FIL",0)
 N LEXNS,LEXSS
 S LEXNS=$$NS^LEXDFN2(LEXAP)
 S LEXSS=$$MD^LEXDFN2(LEXSUB)
 I +$G(^TMP("LEXSCH",$J,"ADF",0))=0 D CONFIG^LEXSET(LEXNS,LEXSS)
 I '$L($G(LEXFIL)),$L($G(^TMP("LEXSCH",$J,"FIL",0))) S LEXFIL=^TMP("LEXSCH",$J,"FIL",0)
 S:$L($G(LEXFIL)) LEXFIL=$$FIL(LEXFIL)
 S LEXFIL=$G(LEXFIL)
 K ^TMP("LEXFND",$J),^TMP("LEXHIT",$J)
 D MAN
 I $D(LEX("ERR")) D EXIT Q
 D SETUP^LEXAM($G(^TMP("LEXSCH",$J,"VOC",0)))
 I $D(LEX("ERR")) D EXIT Q
 ;
LK ; Look-up
IEN ; Look-up by IEN               ADDL^LEXAL PCH 4
 I ^TMP("LEXSCH",$J,"NAR",0)?1"`"1N.N D  I $D(LEX("LIST")) D EXIT Q
 .N LEXE,LEXUN
 .S LEXE=+$E(^TMP("LEXSCH",$J,"NAR",0),2,$L(^TMP("LEXSCH",$J,"NAR",0))) Q:LEXE=0
 .S LEXUN=+$G(^TMP("LEXSCH",$J,"UNR",0))
 .Q:'$D(^LEX(757.01,LEXE,0))
 .D ADDL^LEXAL(LEXE,$$DES^LEXASC(LEXE),$$SO^LEXASO(LEXE,$G(^TMP("LEXSCH",$J,"DIS",0)),1))
 .I $D(^TMP("LEXFND",$J)) D BEG^LEXAL
 .I LEXUN>0,$L($G(^TMP("LEXSCH",$J,"NAR",0))) S LEX("NAR")=$G(^TMP("LEXSCH",$J,"NAR",0))
 .I LEXUN>0,$L($G(^LEX(757.01,+$G(LEXE),0))) S LEX("NAR")=$G(^LEX(757.01,+$G(LEXE),0))
 ;
SCT ; Look-up by Shortcuts         EN^LEXASC  
 I +$G(^TMP("LEXSCH",$J,"SCT",0)),$D(^LEX(757.41,^TMP("LEXSCH",$J,"SCT",0))) D
 .S LEXFND=$$EN^LEXASC(^TMP("LEXSCH",$J,"SCH",0),^TMP("LEXSCH",$J,"SCT",0))
 I +LEXFND D EXIT Q
 ;
CODE ; Look-up by Code              EN^LEXABC
 S LEXFND=$$EN^LEXABC(^TMP("LEXSCH",$J,"SCH",0))
 I +LEXFND D EXIT Q
 ;
EXACT ; Look-up Exact Match          EN^LEXAB
 S LEXFND=$$EN^LEXAB(^TMP("LEXSCH",$J,"SCH",0))
 K:+LEXFND=0 ^TMP("LEXFND",$J)
 K ^TMP("LEXHIT",$J)
 ;
KEYWRD ; Look-up by word              EN^LEXALK
 D EN^LEXALK
 ;
EXIT ; Clean-up and quit
 K LEXQ,LEXDICS,LEXFIL,LEXFILR,LEXDSP,LEXSHOW,LEXSHCT,LEXSUB
 K LEXOVR,LEXUN,LEXLKFL,LEXLKGL,LEXLKIX,LEXLKSH,LEXTKNS,LEXTKN
 K LEXI
 D:$D(LEX("ERR")) CLN
 ; If not found create help and save narrative   PCH 3
 I $D(LEX),+$G(LEX)=0,'$D(LEX("LIST")),$L($G(LEXX)) D
 .N LEXC,LEXF,LEXV
 .S LEXC=1
 .S LEXF=$G(^TMP("LEXSCH",$J,"FIL",0))
 .S LEXV=$G(^TMP("LEXSCH",$J,"VOC",0))
 .D:+$G(^TMP("LEXSCH",$J,"UNR",0))>0 EN^LEXAR(LEXX)
 .S LEX("NAR")=LEXX
 .S LEX=0
 .S LEX("HLP",LEXC)="    A suitable term could not be found based on user input"
 .S:LEXF="I 1" LEXF=""
 .I $L(LEXF)!(LEXV'="WRD") D
 ..S LEX("HLP",LEXC)=$G(LEX("HLP",LEXC))_" and "
 ..S LEXC=LEXC+1
 ..S LEX("HLP",LEXC)="    current user defaults"
 ..S LEX("HLP",0)=LEXC
 .S LEX("HLP",LEXC)=$G(LEX("HLP",LEXC))_"."
 ;
 Q
CLN ; Clean
 K LEXQ,LEXTKNS,LEXTKN,LEXI
 K ^TMP("LEXSCH",$J),^TMP("LEXHIT",$J),^TMP("LEXFND",$J)
 Q
CLR ; Clear all (FOR TESTING ONLY)
 K LEX,LEXQ,LEXTKNS,LEXTKN,LEXI
 K ^TMP("LEXSCH"),^TMP("LEXHIT"),^TMP("LEXFND")
 Q
MAN ; Mandatory variables
 N LEXERR
 F LEXERR="SCH","VOC","APP","USR" D
 .I '$L($G(^TMP("LEXSCH",$J,LEXERR,0))) D
 ..S LEX("ERR",0)=$G(LEX("ERR",0))+1
 ..S LEX("ERR",LEX("ERR",0))="Mandatory variable ^TMP(""LEXSCH"",$J,"""_LEXERR_""",0) missing or invalid"
 Q
FIL(X) ; Validate Filter
 S X=$G(X)
 Q:'$L(X) X
 D ^DIM
 S:'$D(X) X=""
 Q X
 ;
 ; D INFO^LEXA(IEN)
 ;
 ;    IEN   Internal Entry Number in file 757.01
 ;
 ; Returns array LEX("SEL") or null
 ;
 ;    LEX("SEL","EXP")   Expressions Concepts/Synonyms/Variants
 ;    LEX("SEL","SIG")   Expression definition
 ;    LEX("SEL","SRC")   Classification Codes
 ;    LEX("SEL"."STY")   Semantic Class/Semantic Types
 ;    LEX("SEL","VAS")   VA Classification Sources
 ;
INFO(X) ;
 K LEX("SEL")
 S X=+$G(X)
 Q:X=0  Q:'$D(^LEX(757.01,X,0))
 D SET^LEXAR4(X)
 Q
