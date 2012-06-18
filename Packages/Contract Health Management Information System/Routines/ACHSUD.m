ACHSUD ; IHS/ITSC/PMF - SELECT CHS DOCUMENT FOR DISPLAY ;   [ 05/20/2003  1:56 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5**;JUN 11, 2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - Prevent <UNDEF> when Jumping.
 ;
 ;THE FOLLOWING LINES ARE A GALLANT ATTEMPT TO USE FILEMAN TO DO THE
 ;LOOKUP PROPERLY. HOWEVER IT DID NOT WORK. STRUCTURE OF THE DATA?????
 ;S DIC="^ACHSF("_DUZ(2)_","    ;"D"","
 ;S DIC(0)="AQEM",D="AC"
 ;B
 ;D MIX^DIC1
 ;W !,Y
 ;
 ;
 ;Q
 ;
ACHSUDOD ;
 K ACHSDIEN,DIC,DA,D0
A1 ;
 ;
 S Y=$$DIR^XBDIR("FO","Select Document","","","Enter the P.O. number or ""??"" for a list","^D Q1^ACHSUD",2)
 Q:$D(DTOUT)!$D(DUOUT)!(Y="")
 ;FOLLOWING LINE TRIES TO DO SPACE RECOVER LAST ENTRY TYPE THING
 I Y=" ",$D(^DISV(DUZ,"ACHSUD")) S Y=$G(^DISV(DUZ,"ACHSUD")),Y=$E(Y,2)_"-"_$E(Y,3,99) W Y
 ;
 I Y?1.U.1",".U G NAME
 F I=1:1:$L(Y) I $E(Y,I)?1P,$E(Y,I)'="-" S Y=$E(Y,1,I-1)_"-"_$E(Y,I+1,999)
 F I=1:1 S F=$F(Y,"--") Q:'F  S Y=$P(Y,"--")_"-"_$P(Y,"--",2,999)
 S (N,F,C)="",P=$L(Y,"-")
 I P>3 W *7,"  ??" G A1
 S N=$P(Y,"-",P)
 I P=3 S F=$P(Y,"-",2),C=+Y G A2
 I P=2 S C=$P(Y,"-") S:$L(C)>1 F=C,C=""
A2 ;
 S ACHSFC=$$FC^ACHS(DUZ(2)) ;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 S:C="" C=$E(ACHSCFY,4)
 S:F="" F=ACHSFC
 I $L(F)<3 S F=$E("000",1,3-$L(F))_F
 I $L(N)<6 S N=$E("00000",1,5-$L(N))_N
 S X="1"_C_N
 S DIC="^ACHSF("_DUZ(2)_",""D"","
 S DIC(0)="QZE"
 ;S DIC("W")="W ""  "",$P(^(0),U,14),""-"",ACHSFC,""-"",$P(^(0),U)"
A3 ;
 D ^DIC
 K DIC
 G A1:Y<1
 S ACHSDIEN=+Y
 S ^DISV(DUZ,"ACHSUD")=$P(Y,U,2)
 Q
 ;
NAME ; undocumented feature...too slow to publish.
 N ACHSDUZ2
 I $$PARM^ACHS(2,5)="Y" S ACHSDUZ2=DUZ(2),DUZ(2)=0
 S DIC="^AUPNPAT(",DIC(0)="EMQ",AUPNLK("INAC")=""
 S X=Y
 D ^DIC
 K DFN,DIC,AUPNLK("INAC")
 I Y'<1 S DFN=+Y
 I $G(ACHSDUZ2) S ACHSYAYA=42,DUZ(2)=ACHSDUZ2 K ACHSYAYA
 Q:'$D(DFN)
 S X="??",DIC(0)="E",DIC="^ACHSF("_DUZ(2)_",""D"",",DIC("W")="D Q3^ACHSUD",DIC("S")="I $P(^(0),U,22)=DFN"
 G A3
 ;
 ;HELP SUBROUTINE FOR INITIAL DOCUMENT SELECT PROMPT AT A1+1
Q1 ;EP - From ^DIR.
 ; W !,"  Enter the Patient's Name, or"
 W !!,"  Enter the 'Order Number' for the document",!,"  In the following format:  F-LOC-NUMBER",!!,"  Where",!?12,"F",?20,"Is the one-digit fiscal year code",!?12,"LOC",?20,"Is the three-character financial location code"
 W !?12,"NUMBER",?20,"Is The 5-digit document number",!!,"  You May Omit The First Two Items If You Wish",!,"  (Current Fiscal Year And Location Code Will Be Assumed)",!,"  Also, leading zeros on the document are OPTIONAL."
Q2 ;
 I $$DIR^XBDIR("Y","Do you wish to see a list of documents","N","","","",2) D    ;GET LISTING OF POSSIBLES
 .K DIC
 .S LISTCNT=$G(LISTCNT) I 'LISTCNT S LISTCNT=1    ;INITIALIZE LIST COUNTER
 .S X="??",DIC(0)="ES",DIC="^ACHSF("_DUZ(2)_",""D"","
 .S DIC("W")="D Q3^ACHSUD"   ;USE THIS SUBRTN FOR LISTING CHOICES
 .D ^DIC K DIC
 Q
 ;
Q3 ;EP - From call to ^DIC.  See line Q2+1.
 ;
 S LISTCNT=$G(LISTCNT)+1
 S DOCDATA=$G(^ACHSF(DUZ(2),"D",+Y,0))   ;DOCUMENT SUB FILE 0 NODE
 ;
 ;GET FINANCE CODE
 S ACHSFC=$P($G(^AUTTLOC(DUZ(2),0)),U,17)
 I $L(ACHSFC)'=3!(ACHSFC="") W !!,"SOMETHING WRONG WITH THIS FACILITY'S FINANCE CODE" W !!,"REPORT THIS TO YOUR SITE MANAGER IMMEDIATELY!!" D RTRN^ACHS Q
 ;
 S:ACHSFC'="" ACHSFC=$P(^AUTTAREA($P(^AUTTLOC(DUZ(2),0),U,4),0),U,3)_$E(ACHSFC,2,3)
 ;
 ;WRITE FULL DOCUMENT NUMBER
 W ?14,$P(DOCDATA,U,14),"-",ACHSFC,"-",$P(DOCDATA,U)_"("_+Y_")"
 S ACHS=$P(DOCDATA,U,4)     ;TYPE OF SERVICE
 ;                          '1' FOR 43 (HOSPITAL SERVICE);
 ;                          '2' FOR 57 (DENTAL SERVICE);
 ;                          '3' FOR 64 (OUTPATIENT SERVICE)
 W ?30,$S(ACHS=1:"HOSPITAL",ACHS=2:"DENTAL",ACHS=3:"OUTPATIENT",1:"??")
 ;
 S ACHS=$P(DOCDATA,U,12)       ;STATUS
 W ?45,$S(ACHS=0:"OPEN",ACHS=1:"SUPPLEMENTAL",ACHS=2:"PARTIAL CANCEL",ACHS=3:"PAID",ACHS=4:"CANCELED",1:"??")
 ;
 ;BLANKET ORDER
 W:$P(DOCDATA,U,3) ?55,$S($P(DOCDATA,U,3)=1:"* BLANKET",$P(DOCDATA,U,3)=2:"* SPECIAL TRANS",1:"")
 ;
 ;
 ;WHY THIS LINE??
 ;I $D(^ACHSF(DUZ(2),"D",+Y,"T",1,0)),$P(^ACHSF(DUZ(2),"D",+Y,0),U,3),$D(^DPT(+$P(DOCDATA,U,3),0)) W ?75,$P(DOCDATA,U) ;
 Q
 ;
SELTRANS(D) ;EP - Display trans of doc D, and allow selection.
 N C,T
 ;
 W !!?10,"----------------------------------------------------",!?10,"TRANS",?30,"TRANS",!?11,"NUM",?19,"D A T E",?30,"TYPE",?40,"AMOUNT",!?10,"----------------------------------------------------",!!
 ;
 S (C,T)=0
 F  S T=$O(^ACHSF(DUZ(2),"D",D,"T",T)) Q:+T=0  S Y=$G(^ACHSF(DUZ(2),"D",D,"T",T,0)),C=C+1,C(C)=T W !?10,$J(C,3) D DISTRANS(D,T)
 S Y=$$DIR^XBDIR("N^1:"_C,"Select a transaction","","","Enter the number corresponding to the transaction you want","",2)
 Q:$D(DUOUT)!$D(DTOUT)!(Y=0) 0
 Q C(Y)
 ;
DISTRANS(D,T) ; 
 S Y=$G(^ACHSF(DUZ(2),"D",D,"T",T,0))
 W ?17,$$FMTE^XLFDT($P(Y,U,1)),?32,$P(Y,U,2),$P(Y,U,5),?35,$J($FN($P(Y,U,4),",",2),11),"   <",$$EXTSET^XBFUNC(9002080.02,1,$P(Y,U,2)),">"
 Q
 ;
