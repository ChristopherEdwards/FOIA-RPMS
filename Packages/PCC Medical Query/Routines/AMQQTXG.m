AMQQTXG ; IHS/CMI/THL - POINTER TAXONOMY ;
 ;;2.0;IHS PCC SUITE;**11**;MAY 14, 2009;Build 58
 ;-----
EN3 ; ENTRY POINT FOR POINTER TAXONOMY
 S AMQQHELP="PHELP"
 S AMQQHEL1="PHELP1"
 S AMQQLKUP="PLOOKUP"
VAR ;
 S AMQQTAXI=$P(^AMQQ(5,AMQQATN,0),U,17)
RUN D GET
 I '$D(AMQQQUIT),'$D(AMQQSCMP),AMQQTAXT'=2,'$D(AMQQXX) D LIST^AMQQTX
EXIT K X,AMQQTAXI,I,AMQQTGFG,AMQQTDIC,AMQQHELP,AMQQHEL1,AMQQLKUP,AMQQXXN,%,%Y,N,T,C
 Q
 ;
GET I '$D(AMQQXX) W !
GETR ;
 K AMQQISYS,ICDSYS
 I $D(AMQQXXTT),$D(AMQQXXN) S AMQQXXN=$O(^UTILITY("AMQQ",$J,"XXTAX",AMQQXXTT,AMQQXXN)) Q:'AMQQXXN  S X=^(AMQQXXN) G GRR
 I $D(AMQQNTAX),AMQQNTAX="" Q
 I $D(AMQQNTAX) S X=AMQQNTAX,AMQQNTAX="" G GRR
 I $D(AMQQXX),$D(AMQQONE) S X="ALL" G GRR
 ;I AMQQTGBL="^ICD9"!(AMQQTGBL="^ICD0") K AMQQNDB D ICDGET G GRR  ;X RETURNED AS INPUT VALUE
 S %="Enter "_$S($D(^UTILITY("AMQQ TAX",$J,AMQQURGN)):"ANOTHER ",1:"")_AMQQTNAR
 K AMQQNDB
 W !,%,": "
 R X:DTIME E  S X=U
GRR ;
 I X="",'$D(^UTILITY("AMQQ TAX",$J,AMQQURGN)),'$D(AMQQSCMP) D ACA^AMQQAC Q:X=4  I X="" W ! G GETR
 I X="" Q
 I X=U S AMQQQUIT="" Q
 I X="]" S AMQQTTOT=9 K AMQQTGFG G GETR
 I X="@" S X="NULL" W " (NULL SET)"
 I X="EXIST" S X="EXISTS" W "S"
 I X="ALL",AMQQATN[681 S X="*"
 I '$D(AMQQSCMP),$D(AMQQSQNM),$D(AMQQSQSJ),AMQQSQNM'=AMQQSQSJ,AMQQSQNM'="RESULT/DIAGNOSIS" F %="ALL","ANY","EXISTS" I X=% W " ??" G GET
 I '$D(AMQQSCMP) F %="ALL","ANY","EXISTS","NULL" I X=% G GEXIT
 I X="*" D EDALL G GETR
 I X?1"?" D @(AMQQHELP_"^AMQQTXG1") G GETR
 I X?2"?" D LIST^AMQQTX G GETR
 I X?3."?" D @(AMQQHEL1_"^AMQQTXG1") G GETR
 I $E(X)="-",'$D(^UTILITY("AMQQ TAX",$J,AMQQURGN)) W "  ??",*7 G GETR
 I AMQQTAXT=2,$L(X,"-")>2 D DASH I Y W "  ??",*7 G GETR
 I $E(X)="-" S X=$E(X,2,99) S AMQQTXEX=""
 I $E(X,1,2)="[?" D WHATG^AMQQTX G GETR
 I $E(X)="[" D RESTORE^AMQQTX0 G GETR
 I $E(X)="""",$E(X,$L(X))="""" S X=$E(X,2,($L(X)-1)),AMQQNDB=""
 I X="[" W "  ??",*7 G GETR
 D @(AMQQLKUP_"^AMQQTXG1")
 I $D(AMQQQUIT) Q
 I Y'=-1,AMQQTAXT'=2 D SET^AMQQTX
 I Y=-1,$D(AMQQXX) K ^UTILITY("AMQQ TAX",$J,AMQQURGN),AMQQTAX Q
 I $G(^UTILITY("AMQQ TAX",$J,AMQQURGN))="REFUSAL" Q
 G GETR
 ;
GEXIT I X'="NULL" K ^UTILITY("AMQQ TAX",$J,AMQQURGN) S AMQQSCMP=X Q
 D:$D(AMQQCNAM) NULL^AMQQTX
 I $D(AMQQQUIT) Q
 I $D(AMQQSCMP),AMQQSCMP="NULL" Q
 I "Yy"'[$E($G(%Y)) W " ??",*7
 G GETR
 ;
EDALL S %=$P(^AMQQ(1,AMQQLINK,0),U,5)
 S %=$P(^AMQQ(4,%,0),U)
 I %="G" D EDA Q
 I AMQQTLOK="^ICD9("!(AMQQTLOK="^ICD0(") D  Q
 .D ICDCS
 .I AMQQISYS="" W !!,"Coding system must be selected." Q
 .NEW AMQQTEMP
 .D LST^ATXAPI(AMQQISYS,$S(AMQQTLOK="^ICD9(":80,1:80.1),"*","CODE","AMQQTEMP")
 .S %="" F  S %=$O(AMQQTEMP(%)) Q:%=""  S Y=$P(AMQQTEMP(%),U,1) I Y'="" S ^UTILITY("AMQQ TAX",$J,AMQQURGN,Y)="" W "."
 S X=AMQQTLOK_"""B"")"
 S %=""
 F  S %=$O(@X@(%)) Q:%=""  S Y=$O(^(%,"")) I Y'="" S ^UTILITY("AMQQ TAX",$J,AMQQURGN,Y)="" W "."
 Q
 ;
EDA N I,%
 F I=2:1 S %=$P(AMQQSSET,";",I),%=$P(%,":") Q:%=""  S ^UTILITY("AMQQ TAX",$J,AMQQURGN,%)="" W "."
 Q
 ;
DASH S Y=0
 I $L(X,"-")>3 S Y=1 Q
 I $P(X,"-")'="" S Y=1 Q
 F %=2,3 I $P(X,"-",%)="" S Y=1 Q
 Q
 ;
EN5 ; ENTRY POINT FOR HYBRID TAX
 D EN3
 Q
 ;
EN1 ; ENTRY POINT FOR FREE TEXT TAX
 S (AMQQHELP,AMQQHEL1)="FHELP"
 S AMQQLKUP="FLOOKUP"
 D VAR
 Q
 ;
EN4 ; ENTRY POINT FOR GROUP OF CODES TAXONOMY
 S AMQQHEL1="GHELP1"
 S AMQQHELP="PHELP"
 S AMQQLKUP="GLOOKUP"
 D VAR
 Q
 ;
EN2 ; ENTY POINT FOR RANGE OF CODES
 S AMQQHELP="RHELP"
 S AMQQLKUP="RLOOKUP"
 S AMQQHEL1="RHELP1"
 D VAR
 Q
 ;
ICDGET ;
 NEW DIC,Y,ICDSYS
 ;WHAT CODING SYSTEM?
 S AMQQSYS=""
 W ! ;,"You must enter the coding system to which the codes belong.",!
 S DIC("A")="Select the ICD CODING SYSTEM (ICD-9 or ICD-10):  ",DIC="^ICDS(",DIC("S")="I $P(^(0),U,3)=80",DIC(0)="AEMQ" D ^DIC K DIC
 I $D(DUOUT) S X=U Q
 I Y=-1 S X="" Q
 S AMQQISYS=+Y
 NEW DIR
 S DIR("A")="Enter "_$S($D(^UTILITY("AMQQ TAX",$J,AMQQURGN)):"ANOTHER ",1:"")_AMQQTNAR D SETDIR,^DIR K DIR
 I "^"[Y S X="" Q
 Q
ICDCS ;EP
 NEW DIC,Y,ICDSYS
 ;WHAT CODING SYSTEM?
 S AMQQISYS=""
 W ! ;,"You must enter the coding system from which these codes belong.",!
 S DIC("A")="Select the ICD CODING SYSTEM (ICD-9 or ICD-10):  ",DIC="^ICDS(",DIC("S")="I $P(^(0),U,3)="_$S(AMQQTGBL="^ICD9":80,1:80.1)_"",DIC(0)="AEMQ" D ^DIC K DIC
 I $D(DUOUT) S X=U Q
 I Y=-1 S X="" Q
 S AMQQISYS=+Y
 Q
SETDIR ; ENTRY POINT - SETS HELP AND DIR FOR INIT SUBROUTINE OF APCDFQA3
 S DIR(0)="FO",DIR("?",1)="Enter ICD diagnosis code or narrative.  You may enter a range of",DIR("?",2)="codes by placing a ""-"" between two codes.  Codes in a range will"
 S DIR("?",3)="include the first and last codes indicated and all codes that fall",DIR("?",4)="between.  Only one code or one range of codes at a time.  "
 S DIR("?",5)="To select all codes in a set you can use a '*' wildcard.  E.g. E11*, 250*"
 S DIR("?",6)="You can also ""de-select"" a code or range of codes by placing a ""-"" in",DIR("?",7)="front of it. (e.g. '-250.00' or '-250.01-250.91')"
 Q
