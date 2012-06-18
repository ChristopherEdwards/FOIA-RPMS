BNIGVL ; IHS/CMI/LAB - bni general retrieval ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;visit general retrieval
START ; 
 K BNIGQUIT,BNIGDTR
 D XIT
 D INFORM
 S BNIGPTVS="R"
TYPE ;--- get type of report
 S (BNIGPCNT,BNIGPTCT)=0
 K BNIGTYPE ;--- just in case variable left around
 S BNIGTYPE="RS"
 D @BNIGTYPE,XIT
 Q
RS ;
 S BNIIOSL=$S($G(BNIGUI):55,1:$G(IOSL))
GETDATES ;
 S BNIGLHDR="DATE RANGE SELECTION" W !!?((80-$L(BNIGLHDR))/2),BNIGLHDR
GETDATE1 ;
BD ;get beginning date
 W !
 S BNIGBD=""
 S DIR(0)="FO^6:7",DIR("A")="Enter Beginning Month (e.g. 01/2006)",DIR("?")="Enter a month and 4 digit year in the following format:  1/1999, 01/2000.  The slash is required between the month and year.  Date must be in the past."
 KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 Q:X=""
 I Y'?1.2N1"/"4N W !,"Enter the month/4 digit year in the format 03/2005.  Slash is required and ",!,"4 digit year is required.",! G BD
 K %DT S X=Y,%DT="EP" D ^%DT
 I Y=-1 W !!,"Enter a month and 4 digit year.  Date must be in the past.  E.g.  04/2005 or 01/2000." G BD
 I Y>DT W !!,"No future dates allowed!",! G BD
 S BNIGBD=Y
ED ;get ending date
 W !
 S BNIGED=""
 S DIR(0)="FO^6:7",DIR("A")="Enter Ending Month (e.g. 01/2006)",DIR("?")="Enter a month and 4 digit year in the following format:  1/1999, 01/2000.  The slash is required between the month and year.  Date must be in the past."
 KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 Q:X=""
 I Y'?1.2N1"/"4N W !,"Enter the month/4 digit year in the format 03/2005.  Slash is required and ",!,"4 digit year is required.",! G ED
 K %DT S X=Y,%DT="EP" D ^%DT
 I Y=-1 W !!,"Enter a month and 4 digit year.  Date must be in the past.  E.g.  04/2005 or 01/2000." G ED
 I Y>DT W !!,"No future dates allowed!",! G ED
 S BNIGED=Y
 S BNIGBDD=$$FMTE^XLFDT(BNIGBD),BNIGEDD=$$FMTE^XLFDT(BNIGED)
 Q:$D(BNIGDTR)
 D ADD I $D(BNIGQUIT) D DEL K BNIGQUIT G RS
 I '$D(BNIGCAND) D D1 Q
 D TITLE I $D(BNIGQUIT) K BNIGQUIT G TYPE
 D ZIS
 Q
D1 ;if visit, no prev defined report used
D11 K ^BNIRTMP(BNIGRPT,11) D SCREEN I $D(BNIGQUIT) K BNIGQUIT D DEL G RS
D12 K ^BNIRTMP(BNIGRPT,12) S BNIGTCW=0 D COUNT I $D(BNIGQUIT) K BNIGQUIT G D11
D13 D TITLE I $D(BNIGQUIT) K BNIGQUIT G D12
 D SAVE,ZIS
 Q
SCREEN ;
 S BNIGCNTL="S"
 D ^BNIGVL4
 Q
COUNT ;count only or detailed report
BN D COUNT^BNIGVL3
 Q
TITLE ;
 D TITLE^BNIGVL3
 Q
SAVE ;
 D SAVE^BNIGVL3
 Q
ZIS ;call to XBDBQUE
 K BNIGOPT
 I 'BNIGTCW S BNIGTCW=IOM
 S BNIGDONE=""
 D SHOW^BNIGVLS,SHOWP^BNIGVLS,SHOWR^BNIGVLS
 D XIT1
 I BNIGCTYP="D"!(BNIGCTYP="S") D
 .S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 .I $D(DIRUT) S BNIGQUIT="" Q
 .S BNIGOPT=Y
 G:$G(BNIGQUIT) SAVE
 I $G(BNIGOPT)="B" D BROWSE,XIT Q
 S XBRP="^BNIGVLP",XBRC="^BNIGVL1",XBRX="XIT^BNIGVL",XBNS="BNIG"
 D ^XBDBQUE
 D XIT
 Q
DEL ;EP DELETE LOG ENTRY IF ONE EXISTS AND USER "^" OUT
 I $G(BNIGRPT),$D(^BNIRTMP(BNIGRPT,0)),'$P(^BNIRTMP(BNIGRPT,0),U,2) S DIK="^BNIRTMP(",DA=BNIGRPT D ^DIK K DIK,DA,DIC
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BNIGVLP"")"
 S XBRC="^BNIGVL1",XBRX="XIT^BNIGVL",XBIOP=0 D ^XBDBQUE
 Q
XIT ;
 D XIT^BNIGVL1
XIT1 ;
 D XIT1^BNIGVL1
 Q
ADD ;EP
 K BNIGCAND
 W !!
 I $D(BNIGNCAN) G ADD1
 I $D(BNIGSEAT),'$D(BNIGEP1) G ADD1
 S DIR(0)="Y",DIR("A")="Do you want to use a PREVIOUSLY DEFINED REPORT",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BNIGQUIT=1 Q
 I 'Y G ADD1
 S DIC="^BNIRTMP(",DIC("S")="I $P(^(0),U,2)&($P(^(0),U,6)=BNIGPTVS)" S:$D(BNIGEP1) DIC("S")=DIC("S")_"&($P(^(0),U,9)=BNIGPACK)" S DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 I Y=-1 S BNIGQUIT=1 Q
 S BNIGRPT=+Y,BNIGCAND=1
 ;--- set up sorting and report control variables
 S BNIGSORT=$P(^BNIRTMP(BNIGRPT,0),U,7),BNIGSORV=$P(^(0),U,8),BNIGSPAG=$P(^(0),U,4),BNIGCTYP=$P(^(0),U,5)
 S X=0 F  S X=$O(^BNIRTMP(BNIGRPT,12,X)) Q:X'=+X  S BNIGTCW=BNIGTCW+$P(^BNIRTMP(BNIGRPT,12,X,0),U,2)+2
 Q
ADD1 ;
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 S %H=$H D YX^%DTC S X=$P(^VA(200,DUZ,0),U)_"-"_Y,DIC(0)="L",DIC="^BNIRTMP(",DLAYGO=90512.88,DIADD=1,DIC("DR")=".13////"_DUZ D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT ENTRY - NOTIFY SITE MANAGER!" S BNIGQUIT=1 Q
 S BNIGRPT=+Y
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 ;DELETE ALL 11 MULTIPLE HERE
 K ^BNIRTMP(BNIGRPT,11)
 Q
INFORM ;EP
 S BNIGTCW=0
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC(),80),!
 W $$CTR($$USR(),80)
 W !!,$$CTR("CPHAD GENERAL RETRIEVAL PROGRAM",80),!
 S T="INTRO" F J=1:1 S X=$T(@T+J),X=$P(X,";;",2) Q:X="END"  W !,X
 K J,X,T
 Q
 ;
INTRO ;
 ;;This is the general retrieval program for the Computerized Public
 ;;Health Activity Data System (CPHAD).
 ;;END
  Q
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Hit return to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
TEST ;
 D BDMG(3030101,3060601,17)
 Q
BDMG(BNIGBD,BNIGED,BNIGRPT,BNIGTITL) ;PEP - gui call
 I $G(BNIGBD)="" S BNIIEN=-1 Q
 I $G(BNIGED)="" S BNIIEN=-1 Q
 I $G(BNIGRPT)="" S BNIIEN=-1 Q
 S BNIGTITL=$G(BNIGTITL)
 ;create entry in fileman file to hold output
 S BNIGUI=1
 N BNIOPT  ;maw
 S BNIOPT="CPHAD GENERAL RETRIEVAL"
 S BNIGPTVS="R"
 S (BNIGPCNT,BNIGPTCT)=0
 K BNIGTYPE ;--- just in case variable left around
 S BNIGTYPE="RS"
 S BNIGBDD=$$FMTE^XLFDT(BNIGBD),BNIGEDD=$$FMTE^XLFDT(BNIGED)
 S BNIGSORT=$P(^BNIRTMP(BNIGRPT,0),U,7),BNIGSORV=$P(^(0),U,8),BNIGSPAG=$P(^(0),U,4),BNIGCTYP=$P(^(0),U,5)
 I BNIGCTYP="T" S BNIGSORT=1,BNIGSORV="Activity Date"
 S X=0,BNIGTCW=0 F  S X=$O(^BNIRTMP(BNIGRPT,12,X)) Q:X'=+X  S BNIGTCW=BNIGTCW+$P(^BNIRTMP(BNIGRPT,12,X,0),U,2)+2
 D NOW^%DTC
 S BNINOW=$G(%)
 K DD,D0,DIC,DIR
 S X=$J_"."_$H
 S DIC("DR")=".02////"_DUZ_";.03////"_BNINOW_";.05////"_BNIOPT_";.06///R;.07///"_$S(BNIGCTYP="L":"D",1:"P")
 S DIC="^BNIGUI(",DIC(0)="L",DIADD=1,DLAYGO=90512.08
 D FILE^DICN
 K DIADD,DLAYGO,DIC,DA
 I Y=-1 S BNIIEN=-1 Q
 S BNIIEN=+Y
 S BDMGIEN=BNIIEN  ;cmi/maw added
 D ^XBFMK
 K ZTSAVE S ZTSAVE("*")=""
 ;D GUIEP ;for interactive testing
 S ZTIO="",ZTDTH=$$NOW^XLFDT,ZTRTN="GUIEP^BNIGVL",ZTDESC="GUI CPHAD GEN RETRIEVAL" D ^%ZTLOAD
 D XIT
 Q
GUIEP ;EP - called from taskman
 D ^BNIGVL1
 K ^TMP($J,"BNIGVL")
 S IOM=80  ;cmi/maw added
 D GUIR^XBLM("^BNIGVLP","^TMP($J,""BNIGVL"",")
 Q:$G(BNIDSP)  ;quit if to screen
 S X=0,C=0 F  S X=$O(^TMP($J,"BNIGVL",X)) Q:X'=+X  D
 .S BNIDATA=^TMP($J,"BNIGVL",X)
 .I BNIDATA="ZZZZZZZ" S BNIDATA=$C(12)
 .S ^BNIGUI(BNIIEN,11,X,0)=BNIDATA,C=C+1
 S ^BNIGUI(BNIIEN,11,0)="^^"_C_"^"_C_"^"_DT_"^"
 S DA=BNIIEN,DIK="^BNIGUI(" D IX1^DIK
 D ENDLOG
 K ^TMP($J,"BNIGVL")
 S ZTREQ="@"
 Q
 ;
ENDLOG ;-- write the end of the log
 D NOW^%DTC
 S BNINOW=$G(%)
 S DIE="^BNIGUI(",DA=BNIIEN,DR=".04////"_BNINOW_";.06////C"
 D ^DIE
 K DIE,DR,DA
 Q
 ;
