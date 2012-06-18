BRNRU ; IHS/OIT/LJF - ROI REPORTING UTILITY DRIVER
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 10/19/2007 PATCH 1 Added this routine series and function to patch 1
 ;                               Main logic and code borrowed from PCC VGEN
 ;
 NEW BRNBD,BRNED,BRNBDD,BRNEDD,BRNQUIT,BRNPCNT,BRNDCNT,BRNPREV,BRNRPT,BRNSORT,X
 NEW BRNSORV,BRNSPAG,BRNCTYP,BRNTCW,BRNCNTL
 S (BRNPTCT,BRNPCNT,BRNRCNT)=0 ;BRNPCCT = # of patients; BRNRCNT = # of disclosures
 ;
 ;date range selection
 S X="DATE RANGE SELECTION" W !!?((80-$L(X))/2),X,!!
BD ;get beginning date
 S BRNBD=$$READ^BRNU("D^:DT:DP","Enter Beginning Request Date for search") Q:BRNBD<1
 ;get ending date
 S BRNED=$$READ^BRNU("D^:DT:DP","Enter Ending Request Date for search") I BRNED<1 D BD Q
 S BRNED=BRNED_.2359
 S BRNBDD=$$FMTE^XLFDT(BRNBD,"D"),BRNEDD=$$FMTE^XLFDT(BRNED,"D")  ;external format for dates
 ;
 ; use previous report or not
 S BRNPREV=0 D PREV        ;check if a previous report will be used, if not create a temporary shell
 I $D(BRNQUIT) D DEL Q     ;if user quit, delete any shell that was created
 I BRNPREV=0 D NEW Q       ;if new, build report, select title and print device then quit
 ;
 D TITLE^BRNRU3 I $D(BRNQUIT) Q   ;otherwise, update title for previously used report
 D ZIS                            ;call print device
 Q
 ;
NEW ; prev defined report not used; build new one
N1 K ^BRNRPT(BRNRPT,11) S BRNCNTL="S" D ^BRNRU2 I $D(BRNQUIT) D DEL Q            ;ask screening questions
N2 K ^BRNRPT(BRNRPT,12) S BRNTCW=0 D COUNT^BRNRU3 I $D(BRNQUIT) K BRNQUIT G N1   ;ask for type of report
 D TITLE^BRNRU3 I $D(BRNQUIT) K BRNQUIT G N2                                   ;select title for report
 D SAVE^BRNRU3,ZIS                                                             ;ask to save report and select print device
 Q
 ;
PREV ;called to selelct previous report or create a new temporary one
 W !!
 S Y=$$READ^BRNU("Y","Do you want to use a PREVIOUSLY DEFINED REPORT","NO") I Y=0 D BUILD Q
 I Y'=1 S BRNQUIT=1 Q
 S DIC="^BRNRPT(",DIC("S")="I $P(^(0),U,2)",DIC(0)="AEQ",DIC("A")="REPORT NAME:  ",D="C" D IX^DIC K DIC,DA,DR
 I Y=-1 S BRNQUIT=1 Q
 S BRNRPT=+Y,BRNPREV=1,BRNTCW=0
 ;--- set up sorting and report control variables
 S BRNSORT=$P(^BRNRPT(BRNRPT,0),U,7)     ;sort item
 S BRNSORV=$P(^BRNRPT(BRNRPT,0),U,8)     ;sort text
 S BRNSPAG=$P(^BRNRPT(BRNRPT,0),U,4)     ;use separate pages?
 S BRNCTYP=$P(^BRNRPT(BRNRPT,0),U,5)     ;report type (totals, subcounts, details)
 S $P(^BRNRPT(BRNRPT,13),U)=$G(BRNBD)    ;reset beginning date
 S $P(^BRNRPT(BRNRPT,13),U,2)=$G(BRNED)  ;reset ending date
 S X=0 F  S X=$O(^BRNRPT(BRNRPT,12,X)) Q:X'=+X  S BRNTCW=BRNTCW+$P(^BRNRPT(BRNRPT,12,X,0),U,2)+2   ;set right margin
 Q
 ;
BUILD ;create new report entry
 S %H=$H D YX^%DTC S X=$P(^VA(200,DUZ,0),U)_"-"_Y
 S DIC(0)="L",DIC="^BRNRPT(",DLAYGO=90264.8,DIADD=1,DIC("DR")=".13////"_DUZ
 D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DINUM
 I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BRNQUIT=1 Q
 S BRNRPT=+Y
 K ^BRNRPT(BRNRPT,11)  ;make sure 11 multiple is clean
 Q
 ;
ZIS ;call to XBDBQUE to select print device
 K BRNOPT
 I 'BRNTCW S BRNTCW=IOM
 S BRNDONE=""
 D SHOW^BRNRUS,SHOWP^BRNRUS,SHOWR^BRNRUS  ;show report summary
 D CLEAN    ;clean up variables before continuing
 I $G(BRNBQC)=1 Q
 I BRNCTYP="D"!(BRNCTYP="S") D
 . S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 . I $D(DIRUT) S BRNQUIT="" Q
 . S BRNOPT=Y
 G:$G(BRNQUIT) SAVE^BRNRU3
 I $G(BRNOPT)="B" D BROWSE,XIT Q
 S XBRP="^BRNRUP",XBRC="^BRNRU11",XBRX="XIT^BRNRU",XBNS="BRN"
 D ^XBDBQUE
 D XIT
 Q
 ;
DEL ;EP Delete log entry inf one exists and user "^" out
 I $G(BRNRPT),$D(^BRNRPT(BRNRPT,0)),'$P(^BRNRPT(BRNRPT,0),U,2) S DIK="^BRNRPT(",DA=BRNRPT D ^DIK K DIK,DA,DIC
 Q
ADD ;
 D ADD^BRNRU1
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BRNRUP"")"
 S XBRC="^BRNRU11",XBRX="XIT^BRNRU",XBIOP=0 D ^XBDBQUE
 Q
 ;
XIT ;EP; called by XBDBQUE
 D EN^XBVK("BRN")
 K C,D,D0,DA,DIC,DD,DFN,DIADD,DLAYGO,DICR,DIE,DIK,DINUM,DIQ,DIR,DIRUT,DUOUT,DTOUT,DR,J,I,J,K,M,S,TS,X,Y,DIG,DIH,DIV,DQ,DDH
 ;
CLEAN ; clean up variables not to be sent to XBDBQUE
 K BRNPREV
 Q
