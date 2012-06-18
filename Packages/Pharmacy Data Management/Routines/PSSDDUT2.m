PSSDDUT2 ;BIR/LDT-Pharmacy Data Management DD Utility ; 10/30/97 9:41
 ;;1.0;PHARMACY DATA MANAGEMENT;**3,21,61**;9/30/97
 ;
 ;Reference to ^DIC(42 supported by DBIA #10039
 ;Reference to ^DD(59.723 supported by DBIA #2159
 ;Reference to ^PSNDF(50.68 supported by DBIA 3735
 ;
DEA ;(Replaces ^PSODEA)
 S PSSHLP(1)="THE SPECIAL HANDLING CODE IS A 2 TO 6 POSTION FIELD.  IF APPLICABLE,"
 S PSSHLP(2)="A SCHEDULE CODE MUST APPEAR IN THE FIRST POSITION.  FOR EXAMPLE,"
 S PSSHLP(3)="A SCHEDULE 3 NARCOTIC WILL BE CODED '3A', A SCHEDULE 3 NON-NARCOTIC WILL BE"
 S PSSHLP(4)="CODED '3C' AND A SCHEDULE 2 DEPRESSANT WILL BE CODED '2L'."
 S PSSHLP(5)="THE CODES ARE:"
 D WRITE
 F II=1:1 Q:$P($T(D+II),";",3)=""  S PSSHLP(II)=$P($T(D+II),";",3,99)
 S PSSHLP(1,"F")="!!" D WRITE
 D PKIND,WRITE
D K II Q
 ;;0          MANUFACTURED IN PHARMACY
 ;;1          SCHEDULE 1 ITEM
 ;;2          SCHEDULE 2 ITEM
 ;;3          SCHEDULE 3 ITEM
 ;;4          SCHEDULE 4 ITEM
 ;;5          SCHEDULE 5 ITEM
 ;;6          LEGEND ITEM
 ;;9          OVER-THE-COUNTER
 ;;L          DEPRESSANTS AND STIMULANTS
 ;;A          NARCOTICS AND ALCOHOLS
 ;;P          DATED DRUGS
 ;;I          INVESTIGATIONAL DRUGS
 ;;M          BULK COMPOUND ITEMS
 ;;C          CONTROLLED SUBSTANCES - NON NARCOTIC
 ;;R          RESTRICTED ITEMS
 ;;S          SUPPLY ITEMS
 ;;B          ALLOW REFILL (SCH. 3, 4, 5 NARCOTICS ONLY)
 ;;W          NOT RENEWABLE
 ;;F          NON REFILLABLE
 ;;
SIG ;checks SIG for RXs (Replaces SIG^PSOHELP)
 I $E(X)=" " D EN^DDIOL("Leading spaces are not allowed in the SIG! ","","$C(7),!") K X Q
SIGONE S SIG="" Q:$L(X)<1  F Z0=1:1:$L(X," ") G:Z0="" EN S Z1=$P(X," ",Z0) D  G:'$D(X) EN
 .I $L(Z1)>32 D EN^DDIOL("MAX OF 32 CHARACTERS ALLOWED BETWEEN SPACES.","","$C(7),!?5") K X Q
 .D:$D(X)&($G(Z1)]"")  S SIG=SIG_" "_Z1
 ..S Y=$O(^PS(51,"B",Z1,0)) Q:'Y!($P($G(^PS(51,+Y,0)),"^",4)>1)  S Z1=$P(^PS(51,Y,0),"^",2) Q:'$D(^(9))  S Y=$P(X," ",Z0-1),Y=$E(Y,$L(Y)) S:Y>1 Z1=^(9)
EN K Z1,Z0 ;S:$G(POERR) PSOERR("SIG")="("_$E(SIG,2,999999999)_")"
 Q
 ;
DRUGW ;(Replaces DRUGW^PSOUTLA)
 F Z0=1:1 Q:$P(X,",",Z0,99)=""  S Z1=$P(X,",",Z0) D:$D(^PS(54,Z1,0)) EN^DDIOL($P(^(0),"^"),"","!,?35") I '$D(^(0)) D EN^DDIOL("NO SUCH WARNING LABEL","","?35") K X Q
 Q
 ;
P ;(Replaces ^PSODSRC)
 S PSSHLP(1)="A TWO OR THREE POSITION CODE IDENTIFIES THE SOURCE OF SUPPLY AND WHETHER"
 ;S PSSHLP(1,"F")="@IOF"
 S PSSHLP(2)="THE DRUG IS STOCKED BY THE STATION SUPPLY DIVISION.  THE FIRST"
 S PSSHLP(3)="POSITION OF THE CODE IDENTIFIES SOURCE OF SUPPLY.  THE CODES ARE:"
 D WRITE
 F II=0:1:10 S PSSHLP(II+1)=$P($T(S+II+1),";",3),PSSHLP(II+1,"F")="!?10"
 S PSSHLP(1,"F")="!!?10"
 D WRITE
 S PSSHLP(1)="THE SECOND POSITION OF THE CODE INDICATES WHETHER THE ITEM IS"
 S PSSHLP(2)="OR IS NOT AVAILABLE FROM SUPPLY WAREHOUSE STOCK.  THE CODES ARE:"
 S PSSHLP(3)="P          POSTED STOCK"
 S PSSHLP(3,"F")="!!?10"
 S PSSHLP(4)="U          UNPOSTED"
 S PSSHLP(4,"F")="!?10"
 S PSSHLP(5)="M          BULK COMPOUND"
 S PSSHLP(5,"F")="!?10"
 S PSSHLP(6)="*  USE CODE 0 ONLY WITH SECOND POSITION M."
 D WRITE Q
 ;
S ;;DESCRIPTION MEANINGS
 ;;0          BULK COMPOUND ITEMS *
 ;;1          VA SERVICING SUPPLY DEPOT
 ;;2          OPEN MARKET
 ;;3          GSA STORES DEPOT
 ;;4          VA DECENTRALIZED CONTRACTS
 ;;5          FEDERAL PRISON INDUSTRIES, INC.
 ;;6          FEDERAL SUPPLY SCHEDULES
 ;;7          VA SUPPLY DEPOT, HINES
 ;;8          VA SUPPLY DEPOT, SOMERVILLE
 ;;9          APPROPRIATE MARKETING DIVISION
 ;;10         VA SUPPLY DEPOT, BELL
EDIT ;INPUT XFORM FOR DEA FIELD IN DRUG FILE (Replaces EDIT^PSODEA)
 I X["F",X["B" D EN^DDIOL("Inappropriate F designation!","","$C(7),!") K X Q
 I X["B",(+X<3!(X'["A")) D EN^DDIOL("The B designation is only valid for schedule 3, 4, 5 narcotics !","","$C(7),!") K X Q
 I X["A"&(X["C"),+X=2!(+X=3) D EN^DDIOL("The A & C designation is not valid for schedule 2 or 3 narcotics !","","$C(7),!") K X Q
 I $E(X)=1,X[2!(X[3)!(X[4)!(X[5) D EN^DDIOL("It contains other inappropriate schedule 2-5 narcotics!","","$C(7),!") K X Q
 I $E(X)=2,X[1!(X[3)!(X[4)!(X[5) D EN^DDIOL("It contains other inappropriate schedule 1,3-5 narcotics!","","$C(7),!") K X Q
 I $E(X)=3,X[1!(X[2)!(X[4)!(X[5) D EN^DDIOL("It contains other inappropriate schedule 1-2,4-5 narcotics!","","$C(7),!") K X Q
 I $E(X)=4,X[1!(X[2)!(X[3)!(X[5) D EN^DDIOL("It contains other inappropriate schedule 1-3,5 narcotics!","","$C(7),!") K X Q
 I $E(X)=5,X[1!(X[2)!(X[3)!(X[4) D EN^DDIOL("It contains other inappropriate schedule 1-4 narcotics!","","$C(7),!") K X Q
 Q
 ;
WRITE ;Calls EN^DDIOL to write text
 D EN^DDIOL(.PSSHLP) K PSSHLP Q
 Q
 ;
PKIND I +$P($G(^PSDRUG(DA,"ND")),"^",3) S PSSK=$P(^("ND"),"^",3) D
 .S PSSK=$$GET1^DIQ(50.68,PSSK,19,"I") I PSSK S PSSK=$$CSDEA^PSSDDUT2(PSSK) D
 ..I $L(PSSK)=1,$P(^PSDRUG(DA,0),"^",3)[PSSK Q
 ..I $P(^PSDRUG(DA,0),"^",3)[$E(PSSK),$P(^PSDRUG(DA,0),"^",3)[$E(PSSK,2) Q
 ..W !!,"The CS Federal Schedule associated with this drug in the VA Product file"
 ..W !,"represents a DEA, Special Handling code of "_PSSK
 Q
 ;
CSDEA(CS) ;
 Q:'CS ""
 Q $S(CS?1(1"2n",1"3n"):+CS_"C",+CS=2!(+CS=3)&(CS'["C"):+CS_"A",1:CS)
 ;
CLOZ ;DEL node of DRUG file 50, fields 17.2, 17.3, 17.4
 S PSSHLP(1)="To delete this field use the Unmark Clozapine Drug option in the"
 S PSSHLP(2)="Clozapine Pharmacy Manager menu."
 D WRITE
 Q
 ;
NONF ;Non-Formulary Input Transform DRUG file 50, field 51
 S PSSHLP(1)="This drug cannot be marked as a non-formulary item because it is"
 S PSSHLP(2)="designated as a formulary alternative for the following drugs."
 S PSSHLP(3)=" ",PSSHLP(1,"F")="!!"
 D WRITE
 F MM=0:0 S MM=$O(^PSDRUG("AFA",DA,MM)) Q:'MM  S SHEMP=$P(^PSDRUG(MM,0),"^") D EN^DDIOL(SHEMP,"","!?3")
 S X=""
 Q
 ;
ATC ;Executable help for field 212.2, DRUG file 50
 S PSSHLP(1)="The mnemonic entered here must match the mnemonic entered into the"
 S PSSHLP(2)="ATC for this drug EXACTLY, and cannot be numbers only."
 D WRITE
 Q
 ;
ADTM ;ADMINISTRATION SCHEDULE file 51.1, field 1 Executable Help
 S PSSHLP(1)="ALL TIMES MUST BE THE SAME LENGTH (2 OR 4 CHARACTERS), MUST BE"
 S PSSHLP(2)="SEPARATED BY DASHES ('-'), AND BE IN ASCENDING ORDER"
 D WRITE
 Q
 ;
LBLS ;PHARMACY SYSTEM file 59.7, field 61.2 Executable Help
 S PSSHLP(1)="ANY NEW LABELS OLDER THAN THE NUMBER OF DAYS SPECIFIED HERE WILL"
 S PSSHLP(2)="AUTOMATICALLY BE PURGED."
 D WRITE
 Q
NFH I '$D(DA(1)) D EN^DDIOL(" (This non-formulary item is "_$P(^PSDRUG($S($D(DA(1)):DA(1),1:DA),0),"^")_".)")
 Q
STRTH S STR=" "_$P(X," ",2),PSSHLP(1)=STR,PSSHLP(1,"F")="" D WRITE K STR
 Q
PSYS1 D EN^DDIOL("(""From"" ward is "_$S('$D(^PS(59.7,D0,22,D1,0)):"UNKNOWN",'$D(^DIC(42,+^(0),0)):"UNKNOWN",$P(^(0),"^")]"":$P(^(0),"^"),1:"UNKNOWN")_")","","!?3")
 Q
PSYS2 D EN^DDIOL("(""From"" service is "_$S('$D(PS(59.7,D0,23,D1,0)):"UNKNOWN",$P(^(0),"^")]"":$P(^PS(";"_$P(^DD(59.723,.01,0),"^",3),";"_$P(^PS(59.7,D0,23,D1,0),"^")_":",2),";"),1:"UNKNOWN")_")")
 Q
