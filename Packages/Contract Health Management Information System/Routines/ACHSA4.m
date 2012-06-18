ACHSA4 ; IHS/ITSC/PMF - ENTER DOCUMENTS (5/8)-(CAN) ;    [ 02/01/2005  12:24 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3,16**;JUN 11, 2001
 ;ACHS*3.1*3  fix bug in reference to cost center
 ;ACHS*3.1*16 Fixed problem w/CANS
 ;
 ;
 S ACHSTV=$O(^ACHS("TEST VERSION","B","ACHSA4",""))
 I ACHSTV'="" S ACHSTV=$G(^ACHS("TEST VERSION",ACHSTV,1)) I $P(ACHSTV,U,3) S ACHSTV=U_$P(ACHSTV,U,2) G @ACHSTV
 ;
 ;
 ;COST CENTER CODES
 S ACHS573=$O(^ACHS(1,"B",573,0))        ;CHS GM & S HOSPITALIZTION
 S ACHS568=$O(^ACHS(1,"B",568,0))        ;DENTAL SERVICES
 S ACHS574=$O(^ACHS(1,"B",574,0))        ;CHS AMBULATORY CARE
 S ACHS575=$O(^ACHS(1,"B",575,0))        ;CHS ALL OTHER
 S ACHSF638=$P($G(^ACHSF(DUZ(2),0)),U,8) ;'FACILITY IS 638 TYPE'
 S ACHS533=$O(^ACHS(1,"B",533,0))        ;NOT DEFINED HERE
 ;
 I ACHS573,ACHS568,ACHS574 G A1
 I ACHSF638="Y",$D(^ACHS(1,"B")) G A1
 ;
 W *7,!!,"CHS COST CENTER TABLE INCOMPLETE.",!
 W:ACHSF638'="Y" !,"Must have Cost Centers 568, 573, and 574."
 Q
 ;
A1 ;EP
 W !!,"Enter last 4 digits of the CAN Number: "
 I ACHSCAN,$D(^ACHS(2,ACHSCAN,0)) S ACHSCC=$P($G(^ACHS(2,ACHSCAN,0)),U,2) W $P($G(^ACHS(2,ACHSCAN,0)),U),"// "
 D READ^ACHSFU
 I $G(ACHSQUIT) D END^ACHSA Q
 G A3^ACHSA:$D(DUOUT)    ;GO BACK TO ?   PROMPT
 I Y?1"?".E G A2
 I Y="" G ACHK:ACHSCAN]"" W *7,"  Must Have CAN Number" G A1
 I $D(DTOUT) G A3^ACHSA
 I $L(Y)'=4 W *7,"  ??" G A1
 ;
 ;GET  'AREA'
 S Y=$P($G(^AUTTAREA($P($G(^AUTTLOC(DUZ(2),0)),U,4),0)),U,4)_Y
 ;
 W "     ",Y
 ;
 ;
 S N=$O(^ACHS(2,"B",Y,""))
 I N,$D(^ACHS(2,N,0)),$S('+$P($G(^ACHS(2,N,0)),U,4):1,1:+$P($G(^ACHS(2,N,0)),U,4)>DT) S ACHSCAN=N,ACHSCC=$P($G(^ACHS(2,N,0)),U,2) G ACHK
 W *7,"  ??",!!
 I +N,$D(^ACHS(2,N,0)),$P($G(^ACHS(2,N,0)),U,4)]"",$P($G(^ACHS(2,N,0)),U,4)<DT W !?20,"CAN ",Y," EXPIRED ",$$FMTE^XLFDT($P($G(^ACHS(2,N,0)),U,4)),".",!?21," PLEASE SELECT ANOTHER CAN!" W !!
 G A1
 ;
A2 ;
 ;beginning Y2K fix
 I $$PARM^ACHS(2,24)'="Y"!($D(^XUSEC("ACHSZMGR",DUZ))) G ALLCAN
 ;BEGIN Y2K FIX BLOCK 2;CS;2990525
 K ACHS("FY") S R="" F  S R=$O(^ACHS(2,"FY",DUZ(2),R)) Q:R=""  S ACHS("FY",R+$S(R'<1000:0,R<84:2000,1:1900))=R ;Y2000
 ;END Y2K FIX BLOCK 2
 ;S R="",ACHS=0 ;Y2000
 S (OLDR,R)="",ACHS=0 ;Y2000
A3 ;
 ;Y2000 Changes are required to R and $E(ACHSCFY,3,4)
 ;Y2000 I think that the sliding window approach is best here
 ;Y2000 The variable R appears to be local this this piece of code
 ;S R=$O(^ACHS(2,"FY",DUZ(2),R)) ;Y2000
 ;Y2000 Because of the reentrant nature of this section the following
 ;Y2000 goof-age is required, otherwise I would be facing a major rewrite
 S R=OLDR,R=$O(ACHS("FY",R)),OLDR=R ;Y2000
 G AEND:R=""
 I R>ACHSCFY G A3 ;Y2000
 I R<(ACHSCFY-1) G A3 ;Y2000
 S R=ACHS("FY",R) ;Y2000
 ;end Y2K fix block
 S ACHSRR=0
A3A ;
 S ACHSRR=$O(^ACHS(2,"FY",DUZ(2),R,ACHSRR))
 G A3:ACHSRR=""
 ;if facility does not match, go for next EIN (A3A), not next year (A3)
 G:$P($G(^ACHS(2,ACHSRR,0)),U,3)'=DUZ(2) A3A I $P($G(^ACHS(2,ACHSRR,0)),U,4)]"",$P($G(^ACHS(2,ACHSRR,0)),U,4)<DT G A3A
 S ACHSRRR=0
A3B ;
 S ACHSRRR=$O(^ACHS(2,"FY",DUZ(2),R,ACHSRR,ACHSRRR))
 G A3A:ACHSRRR=""
 I '$D(^ACHS(2,ACHSRR,1,ACHSRRR,0)) G A3B
 S ACHSCNFY=R,ACHSCANZ=$P($G(^ACHS(2,ACHSRR,0)),U)
 G:ACHSF638="Y" CANDSP
 S ACHSAQ=$P($G(^ACHS(2,ACHSRR,0)),U,2)
 G:ACHSTYP'=1 A4
 I ACHSAQ=ACHS573!(ACHSAQ=ACHS575)!(ACHSAQ=ACHS533) G CANDSP
 G A3B
 ;
A4 ;
 G A8:ACHSTYP=3,CANDSP:ACHSAQ=ACHS568,A3B
A8 ;
 I ACHSAQ=ACHS568 G A3B
CANDSP ;
 S ACHS=ACHS+1,ACHS(ACHS)=ACHSRR_"^"_ACHSRRR
 I ACHS=1 D HDR
 W !,$J(ACHS,5),?10,ACHSCNFY,?15,ACHSCANZ
 I $P($G(^ACHS(2,ACHSRR,0)),U,2)'="" W ?30,$P($G(^ACHS(1,$P($G(^ACHS(2,ACHSRR,0)),U,2),0)),U,2)
 I '(ACHS#15),'$$DIR^XBDIR("E") S R="" G AEND
 G A3B
 ;
 ;
AEND ;
 I ACHS=0 W *7,!!,"There are no CHS COMMON ACCOUNTING NUMBERs for this facility.",!!,"Please contact your Site Manager.",!,*7 G A1
 S Y=$$DIR^XBDIR("N^1:"_ACHS,"ENTER ITEM # FOR CAN NUMBER ","","","","^W !,""Enter the number next to the CAN you want for this P.O.""",1)
 G A1:$D(DUOUT),END^ACHSA:$D(DIRUT)
 S ACHSCAN=$P(ACHS(+Y),U,1)
 G A1
 ;
ACHK ;EP.
 S %=$E($P($G(^ACHS(2,ACHSCAN,0)),U),5)        ;CAN NUMBER
 I %="O" W *7,!?5,"'O' CANs are not authorized." G A1
 ;beginning Y2K fix
 ;Y2000 The following code appears to be OK as is
 ;I "MNPJK"[% D  I % G A1       ;ACHS*3.1*16 10/1/2009   IHS/OIT/FCJ REMOVED TEST FOR 2 YR CAN'S.
 ;. S %=$S(((%="M")&(ACHSACFY'=1993)):1,((%="N")&(ACHSACFY'=1994)):1,((%="P")&(ACHSACFY'=1995)):1,((%="J")&(ACHSACFY'=1996)):1,((%="K")&(ACHSACFY'=1997)):1,1:%)
 ;. I % W *7,!?5,"CAN '",$P($G(^ACHS(2,ACHSCAN,0)),U),"' is invalid for FY '",ACHSACFY,"'." Q
 ;. S %=$$FY^ACHSVAR($A(%)+22-$S(%="P":7,%="M":6,%="N":6,1:0))
 ;. S %=$S(ACHSEDOS<$P(%,U):1,ACHSEDOS>($P(%,U,2)+10000):2,1:0)
 ;. I % W *7,!?5,"Date Of Service ",$S(%=1:"BEFORE",1:"AFTER")," 2-year CAN's authority."
 ;.Q
 ;end Y2K fix block
 S ACHSCNFY=0
 I DUZ(2)'=+$P($G(^ACHS(2,ACHSCAN,0)),U,3) W *7,"  CAN # NOT FOR THIS FACILITY" G A1
 S (ACHSAQ,ACHSCC)=$P($G(^ACHS(2,ACHSCAN,0)),U,2)
 G ACHKA:ACHSF638="Y",ACHKA:ACHSTYP'=2,ACHKA:ACHSAQ=ACHS568
 W !!,*7," CAN # NOT VALID FOR DOCUMENT TYPE"
 G A1
 ;
ACHKA ;
 I '$O(^ACHS(2,ACHSCAN,1,0)) G ACHKB
 S %=0
 F  S %=$O(^ACHS(2,ACHSCAN,1,%)) Q:'%  I $G(^ACHS(2,ACHSCAN,1,%,0))=$E(ACHSACFY,1,4)!($G(^ACHS(2,ACHSCAN,0))=$E(ACHSCFY,3,4)) G ACHKB
 W *7,!,"  CAN # CANNOT BE USED FOR THIS FISCAL YEAR."
 G A1
 ;
ACHKB ;
 I '$P($G(^ACHS(2,ACHSCAN,0)),U,4)!($P($G(^ACHS(2,ACHSCAN,0)),U,4)>DT) G ACHK1
 W *7,!,"  CAN # HAS EXPIRED AND CANNOT BE USED"
 G A1
 ;
ACHK1 ;
 I ACHSTYP'=1 G ACHK2
 S ACHSSCC=""
 I $D(^ACHS(3,DUZ(2),1,"B","252G"))&(ACHSAQ=ACHS573)!(ACHSAQ=ACHS533) S ACHSSCC=+$O(^ACHS(3,DUZ(2),1,"B","252G",0))
 I ACHSF638="Y" G ACHK2:ACHSAQ=$O(^ACHS(1,"B",873,0)),ACHK2:ACHSAQ=$O(^ACHS(1,"B",875,0))
 I ACHSAQ=ACHS573!(ACHSAQ=ACHS575)!(ACHSAQ=ACHS533) G ACHK2
 W !!,*7," NOT VALID CAN NUMBER FOR HSA-43"
 G A1
 ;
ACHK2 ;
 G ^ACHSA5
 ;
ALLCAN ;
 ;beginning Y2k fix
 S ACHSR1="",ACHS=0
ALL1 ;
 S ACHSR1=$O(^ACHS(2,"B",ACHSR1))
 I ACHSR1="" S R="" G AEND
 S ACHSRR1=0,ACHSRR1=$O(^ACHS(2,"B",ACHSR1,ACHSRR1))
 G:$P($G(^ACHS(2,ACHSRR1,0)),U,3)'=DUZ(2) ALL1
 I $P($G(^ACHS(2,ACHSRR1,0)),U,4)]"",$P($G(^ACHS(2,ACHSRR1,0)),U,4)<DT G ALL1
 S ACHSCNFY="",ACHSCANZ=$P($G(^ACHS(2,ACHSRR1,0)),U)
 I '$D(^ACHS(2,ACHSRR1,1,0)) G ALL1B
 S ACHSRRR1=""
ALL1A ;
 S ACHSRRR1=$O(^ACHS(2,ACHSRR1,1,ACHSRRR1))
 G:ACHSRRR1="" ALL1 G:ACHSRRR1=0 ALL1A
 S ACHSCNFY=$P($G(^ACHS(2,ACHSRR1,1,ACHSRRR1,0)),U)
 G:ACHSCNFY="" ALL1A
 ;Y2000 The following line will fail in 2000
 ;I ACHSCNFY>$E(ACHSCFY,3,4) G ALL1A
 ;Y2000 This is a predy bogus way to deal with this but if not
 ;Y2000 done like this it would be a major rewrite.
 S:$L(ACHSCNFY)<4 ACHSCNFY=ACHSCNFY+$S(ACHSCNFY<84:2000,1:1900)
 I ACHSCNFY>ACHSCFY G ALL1A
 S ACHSCNFY=$E(ACHSCNFY,3,4)
 ;end Y2k fix block
ALL1B ;
 G:ACHSF638="Y" CANDSP1
 S ACHSAQ=$P($G(^ACHS(2,ACHSRR1,0)),U,2)
 G:ACHSTYP'=1 ALL2
 I ACHSAQ=ACHS573!(ACHSAQ=ACHS575)!(ACHSAQ=ACHS533) G CANDSP1
 G ALL1
 ;
ALL2 ;
 G ALL3:ACHSTYP=3,CANDSP1:ACHSAQ=ACHS568,ALL1
ALL3 ;
 I ACHSAQ=ACHS568 G ALL1
CANDSP1 ;
 S ACHS=ACHS+1,ACHS(ACHS)=ACHSRR1
 I ACHS=1 D HDR
 W !,$J(ACHS,5),?10,ACHSCNFY,?15,ACHSCANZ
 ;
 ;ACHS*31.*3  2/11/02  pmf  don't reference local array, reference global
 ;I $P($G(ACHS(2,ACHSRR1,0)),U,2)'="" W ?30,$P($G(^ACHS(1,$P($G(^ACHS(2,ACHSRR1,0)),U,2),0)),U,2)  ; ACHS*3.1*3
 I $P($G(^ACHS(2,ACHSRR1,0)),U,2)'="" W ?30,$P($G(^ACHS(1,$P($G(^ACHS(2,ACHSRR1,0)),U,2),0)),U,2)  ; ACHS*3.1*3
 ;
 I '(ACHS#15),'$$DIR^XBDIR("E") S R="" G AEND
 I '$D(^ACHS(2,ACHSRR1,1,0)) G ALL1
 G ALL1A
 ;
HDR ;
 W !!,"ITEM #",?10,"FY",?15,"CAN NUMBER",?30,"DESCRIPTION OF THE CAN NUMBER",!,"------",?10,"--",?15,"----------",?30,"-----------------------------"
 Q
 ;
GTH ;
 S DIC="^ACHS(2,"
 S DIC(0)="AEMQ"
 D ^DIC
 Q
