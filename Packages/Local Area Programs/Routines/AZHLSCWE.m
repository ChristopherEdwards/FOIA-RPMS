DIWE11 ; IHS/ADC/GTH:KEU - WORD PROCESSING UTILITY FUNCTION 3/4/92 9:55 AM ;
 ;;5.0;AZHLSC;;JUL 10, 1996
 ; IHS/GTH - 02.08.93 - Added tie-in to SAC Checker Spell Checking.
 S DWOU="EFST" ; IHS/GTH - 02.08.93
1 R !,"UTILITY Option: ",X:DTIME S:'$T DTOUT=1 G QQ:U[X!(X=".")
LC I X?1L S X=$C($A(X)-32)
 S J="^DOPT(""DIWE11""," I X?1U S I=$F(DWOU,X)-1 I I>0 S ^DISV(DUZ,J)=I S I=I*2-1 G OPT
 I X=" ",$D(^DISV(DUZ,J)) S I=^(J),X=$E(DWOU,I) I X]"" W X S I=I*2-1 G OPT
 W !?5,"Choose, by first letter, a Utility Command"
 I X?2"?".E W " from the following:" F I=1:1 S J=$E(DWOU,I) Q:J=""  I DWOU[J W !?10,$P($T(@J),";",4) ; IHS/GTH 02.16.92
 ; I X?2"?".E W " from the following:" F I=1:2 S Y=$T(OPT+I),J=$E(Y,1) Q:J=" "  I DWOU[J W !?10,$P(Y,";",4)
 G 1
 ;
 ; Q:$D(DTOUT)  S X1=$T(OPT+I),X=$P(X1,";",3) W $E(X,'$X)_$E(X,2,99) G @$E(X1,1)
OPT Q:$D(DTOUT)  S X1=$T(@X),X=$P(X1,";",3) W $E(X,'$X)_$E(X,2,99) G @$E(X1,1) ; IHS/GTH 02.16.92
E ;;Editor;Editor Change
 G ^DIWE12
F ;;File transfer;File Transfer from Foreign CPU
 G NA:'$D(^%ZOSF("EON"))!'$D(^("EOFF")) D X^DIWE5 G QQ
S ;;Spell Checker;Spell check this WP field ; IHS/GTH - 02.08.93
 NEW AZHL,AZHLROOT,AZHLTERM,AZHLX,D,Q ; IHS/GTH - 02.08.93
 S AZHLROOT=DIC,$P(AZHLROOT,",",$L(DIC,",")-1)=$S(DV:DV,1:""""_DV_""""),AZHLROOT(1)=AZHLROOT_"0)",AZHLROOT(2)="",AZHLROOT(3)="0",$P(%,U,4)=@(AZHLROOT(1)),AZHLROOT(1)="%",AZHLTERM=1,D(3)="",Q=0 ; IHS/GTH - 02.08.93
 G CHECK^AZHLSCS ; IHS/GTH - 02.08.93
T ;;Text-Terminator;Text-Terminator-String Change
 D TT G QQ
 ;;
TT ;
 W !,"Text-Terminator: ",$S(DIWPT="":"<NULL-STRING>",1:DIWPT),"//"
 R X:DTIME S:'$T DTOUT=1 Q:U[X
 K:$L(X)>5!(X'?.ANP)!(X["?")!(X["^") X
 I '$D(X) W !?5,"Answer must be 1 to 5 Characters, no question marks or up-arrows,",!?5,"to go back to the Null-String just type ""@"" !",*7 G TT
 I X="@" W !?5,"Text-Terminator is now Null-String !" S X=""
 S DIWPT=X Q
QQ K DWOU Q
ASK W ! S DIR("A")="MAXIMUM string length? "
 S DIR("B")=75,DIR(0)="N^3:245:0" D ^DIR K DIR I $D(DIRUT) S X="" G XQ1
 W !!,"You have 30 seconds to start sending text."
 W !,"An End Of File is assumed on 30 second time-out."
 W !!,"TABs are converted to 1 thru 9 spaces to start the next character"
 W !,"at a column evenly divisable by 9 plus 1. (10,19,28,37...)"
 W !!,"End of Line = Carriage Return/$C(13) or Escape/$C(27)."
 W !,"All other control characters will be stripped.",!!
 Q
XQ X ^%ZOSF("EON") W !!,"File Transfer Complete",*7,!
XQ1 K %,%1,%2,%B,%0,DIWL,DIR,DIRUT,DIROUT,DTOUT,DUOUT
 Q
NA W !!,"This option is not available without the rest of the KERNEL"
 G QQ
