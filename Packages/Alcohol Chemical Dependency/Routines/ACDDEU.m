ACDDEU ;IHS/ADC/EDE/KML - COMMON FUNCTIONS; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
DEV ; EP - SELECT OUTPUT DEVICE
 K ACDSLAVE
 S ACDQ=0
 S %ZIS="Q",%ZIS("B")="" D ^%ZIS
 I POP S ACDQ=1
 I $D(IO("S")) S ACDSLAVE=ION W @IOF D ^%ZISC
 Q
 ;
PAUSE ; EP - PAUSE FOR USER
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT["TRM")!$D(IO("S"))   ;*** TESTING - AEF *** CHANGED ="TRM" TO ["TRM" TO ACCOUNT FOR "VTRM"
 S DIR(0)="E",DIR("A")="Press any key to continue"
 K DIRUT
 D ^DIR K DIR
 Q
 ;
CONF ; EP - CONFIDENTIAL CLIENT DATA HEADER
 W !,"*** CONFIDENTIAL CLIENT INFORMATION UNDER CFR 42 PART 2 ***",!
 NEW X,Y
 D NOW^%DTC S Y=$$DD^ACDFUNC(%) W !,"PRINTED: "_Y_" BY: "_$P($G(^VA(200,DUZ,0)),U)_"@"_ACDSITE,!
 S X="",$P(X,"=",79)="" W X,!
 Q
 ;
HDR ; EP - DISPLAY HEADER
 D HDR2
 S X="",$P(X,"-",79)=""
 W X,!
 K X
 Q
 ;
HDR2 ;
 W @IOF,"Signon Program is            : ",$P(^DIC(4,DUZ(2),0),U),!
 I ACDMODE="A" D
 . W "Records that may be added are: THOSE WITHIN YOUR SIGNIN PROGRAM.",!!
 . W "ADDING CDMIS VISIT RECORDS...",!!
 . Q
 I ACDMODE="E" D
 . W "Editable Records are: THOSE NOT EXTRACTED.",!
 . W "                      THOSE WITHIN YOUR SIGNIN PROGRAM.",!!
 . W "EDITING CDMIS VISIT RECORDS...",!!
 . Q
 Q:$G(ACDCOMCL)=""
 W "COMPONENT (CODE)             : ",ACDCOMCL,!
 W "COMPONENT (TYPE)             : ",ACDCOMTL,!
 I ACDLPTYP=1 Q:$G(ACDPROV)=""  W !,"PRIMARY PROVIDER             : ",ACDPROVN,!
 Q:ACDCONTL=""
 W !,"TYPE CONTACT                 : ",ACDCONTL,!
 I ACDLPTYP=2,$G(ACDCSDP)'=""  W "DEFAULT PROVIDER             : ",ACDCSDP,!
 Q:ACDVDTE=""
 W "VISIT DATE                   : ",ACDVDTE,!
 Q
 ;
DSPVSIT(VISIT) ; EP - DISPLAY CDMIS VISIT ENTRY
 Q:'VISIT
 S DIC="^ACDVIS(",DA=VISIT,DR=0
 D DIQ^ACDFMC
 Q
 ;
DSPHIST ; EP - DISPLAY CDMIS VISIT HISTORY  
 I '$D(^TMP("ACD",$J,"VISITS")) D  Q
 . W !,"----------",!
 . W "No CDMIS VISIT history for client ",ACDDFN,!
 . W "----------",!
 . Q
 I $E(IOST,1,2)="P-" D FWD I 1
 E  D BCK
 Q
 ;
FWD ; FORWARD DISPLAY FOR PRINTERS ONLY
 D CONF W !
 W "CDMIS VISIT history for client ",ACDDFN,!!
 W "----------",!
 S ACDX=0
 F  S ACDX=$O(^TMP("ACD",$J,"VISITS",ACDX)) Q:ACDX=""  S ACDY=0 F  S ACDY=$O(^TMP("ACD",$J,"VISITS",ACDX,ACDY)) Q:'ACDY  D DSPV I $P(^ACDVIS(ACDY,0),U,4)="CS" S ACDVIEN=ACDY D DSPCSH
 W "----------",!
 Q
 ;
BCK ; BACKWARD DISPLAY FOR CRTS
 W !,"----------",!
 W "Recent CDMIS VISIT history for client ",ACDDFN,!!
 S ACDX="A",ACDCNT=0
 F  Q:ACDX="Q"  S ACDX=$O(^TMP("ACD",$J,"VISITS",ACDX),-1) Q:ACDX=""  S ACDY=0 F  S ACDY=$O(^TMP("ACD",$J,"VISITS",ACDX,ACDY)) Q:'ACDY  D DSPV S ACDCNT=ACDCNT+1 I ACDCNT>17 S ACDX="Q" Q
 K ACDCNT
 W "----------",!
 Q
 ;
DSPV ; EP-DISPLAY CDMIS VISIT ENTRY
 S DIC="9002172.1",DA=ACDY,DR=".01;1;3;5",DIQ="ACDPDD("
 D DIQ1^ACDFMC
 W ACDPDD(9002172.1,ACDY,.01),?12," - ",ACDPDD(9002172.1,ACDY,1),"/",ACDPDD(9002172.1,ACDY,5),?52,ACDPDD(9002172.1,ACDY,3),?70,$S($P(^ACDVIS(ACDY,0),U,25):" <EXTR>",1:""),!
 K ACDPDD
 Q
 ;
DSPCSH ; EP-DISPLAY CDMIS CLIENT SERVICE HISTORY FOR ONE CS VISIT
 K ^TMP("ACD",$J,"CS")
 S Y=0
 F  S Y=$O(^ACDCS("C",ACDVIEN,Y)) Q:'Y  S X=^ACDCS(Y,0),^TMP("ACD",$J,"CS",$P(X,U),Y)=$P(X,U,2)
 S Y=0
 F  S Y=$O(^TMP("ACD",$J,"CS",Y)) Q:'Y  S Z=0 F  S Z=$O(^TMP("ACD",$J,"CS",Y,Z)) Q:'Z  D
 .  S X=^TMP("ACD",$J,"CS",Y,Z)
 .  D PFTV^XBPFTV(9002170.6,X,.W)
 .  W ?15,Y,?19,W,?55,$J(+$P(^ACDCS(Z,0),U,4),5,2)_" h",!
 .  Q
 K ^TMP("ACD",$J,"CS")
 Q
 ;
GETVSITS ; EP - GET CDMIS VISITS FOR THIS CLIENT
 K ^TMP("ACD",$J,"VISITS")
 S ACDVCNT=0,Y=0
 F  S Y=$O(^ACDVIS("D",ACDDFNP,Y)) Q:'Y  S X=^ACDVIS(Y,0) I $P($G(^("BWP")),U)=ACDPGM D
 .  I $G(ACDTCTG)'="",$P(X,U,4)'=ACDTCTG Q  ; quit if tc not wanted
 .  S ^TMP("ACD",$J,"VISITS",$P(X,U),Y)=X,ACDVCNT=ACDVCNT+1
 .  Q
 Q
 ;
CHKFIN ; EP - CHECK FOR INITIAL CONTACT TYPE
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S ACDX="",(ACDY,Y)=0
 F  S ACDX=$O(^TMP("ACD",$J,"VISITS",ACDX)) Q:ACDX=""  S Y=0 F  S Y=$O(^TMP("ACD",$J,"VISITS",ACDX,Y)) Q:'Y  S X=^(Y) I $P(X,U,2)=ACDCOMC,$P(X,U,7)=ACDCOMT,$P(X,U,4)="IN" S ACDY=Y Q
 I ACDY,'ACDINR W !,IORVON,"INITIAL type contact already exists for patient ",ACDDFN,!,"in the ",ACDCOMCL,"/",ACDCOMTL," component.",IORVOFF,! D DSPVSIT^ACDDEU(ACDY),PAUSE^ACDDEU S ACDQ=1 Q
 Q:ACDY  ;            quit if INITIAL type contact found
 Q:'ACDINR  ;         quit if INITIAL type contact not required.
 S ACDQ=1
 W !,IORVON,"No INITIAL type contact for patient ",ACDDFN,!,"in the ",ACDCOMCL,"/",ACDCOMTL," component.",IORVOFF,!!,"Now searching for a REOPEN.",!
 S ACDX="",(ACDY,Y)=0
 F  S ACDX=$O(^TMP("ACD",$J,"VISITS",ACDX)) Q:ACDX=""  S Y=0 F  S Y=$O(^TMP("ACD",$J,"VISITS",ACDX,Y)) Q:'Y  S X=^(Y) I $P(X,U,2)=ACDCOMC,$P(X,U,7)=ACDCOMT,$P(X,U,4)="RE" S ACDY=Y Q
 I ACDY S ACDQ=0 W !,"REOPEN found.",! Q
 W !,IORVON,"No INITIAL or REOPEN found.",IORVOFF,!
 D PAUSE^ACDDEU
 Q
 ;
GETDTR ; EP-GET DATE RANGE
 ; returns ACDDTLO and ACDDTHI or ACDQ=1
 F  D GETDTR2 Q:$D(DIRUT)  Q:'ACDQ
 K:ACDQ ACDDTLO,ACDDTHI
 Q
 ;
GETDTR2 ;
 S ACDQ=1
 S DIR(0)="DO^::EP",DIR("A")="Enter beginning date" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 Q:Y=""
 S ACDDTLO=Y
 S DIR(0)="DO^::EP",DIR("A")="Enter ending date" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 Q:Y=""
 S ACDDTHI=Y
 I ACDDTHI<ACDDTLO W !!,"Ending date before beginning date!",!! Q
 S:$E(ACDDTLO,6,7)="01" $E(ACDDTLO,6,7)="00" ;   to get CS visits
 S ACDQ=0
 Q
GETTOB ; get tobacco use info
 ; utilized by input templates ACD I/I/F ADD and ACD T/D/C/ ADD
 N DIR S DIR(0)="S^0:NONE;1:SMOKING;2:SMOKELESS;3:SMOKING & SMOKELESS",DIR("A")="TOBACCO USE" D ^DIR
 I Y N DR S DR="30///^S X=Y" D ^DIE
 Q
