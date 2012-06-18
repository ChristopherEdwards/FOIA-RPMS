APCM11SL ;IHS/CMI/LAB - IHS MU;
 ;;2.0;IHS PCC SUITE;**6**;MAY 14, 2009;Build 11
 ;; ;
RT ;EP
 ;for each measure list, choose report type
 W !!,"Select List Type.",!,"NOTE:  If you select All Patients, your list may be",!,"hundreds of pages and take hours to print.",!
 S DIR(0)="S^R:Random Patient List;A:All Patients",DIR("A")="Choose report type for the Lists",DIR("B")="R" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCMQUIT="" K APCMLIST Q
 S APCMLIST=Y
 Q
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ1 ;EP
 K APCMGLST,APCMTIND,APCMHIGH,APCMANS,APCMC,APCMGANS,APCMGC,APCMGI,APCMI,APCMX
 Q
 ;; ;
EN ;EP -- main entry point for GPRA LIST DISPLAY
 D EN^VALM("APCM S1 LIST SELECTION")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="IHS 2011 MU Stage 1 Measure Lists of Patients"
 S VALMHDR(2)="* indicates the list has been selected"
 Q
 ;
INIT ; -- init variables and list array
 K APCMGLST,APCMNOLI S APCMHIGH=""
 S APCMXREF=$S(APCMRPTT=1:"EOORDER",1:"AH")
 S (Y,C,I)=0 F  S Y=$O(^APCMMUM(APCMXREF,Y)) Q:Y'=+Y  Q:Y=""  S X=0 F  S X=$O(^APCMMUM(APCMXREF,Y,X)) Q:X'=+X  D
 .Q:'$D(APCMIND(X))
 .I $P(^APCMMUM(X,0),U,7)="" S C=C+1 D  Q
 ..S APCMGLST(C,0)=C_")",$E(APCMGLST(C,0),5)="("_$P(^APCMMUM(X,0),U,3)_") "_$P(^APCMMUM(X,0),U,5),APCMGLST("IDX",C,C)=X I $D(APCMLIST(X)) S APCMGLST(C,0)="*"_APCMGLST(C,0)
 .I $P(^APCMMUM(X,0),U,7)=1 Q  ;S C=C+1 D
 .;.S APCMGLST(C,0)="NO patient list available for measure:  "_$P(^APCMMUM(X,0),U,5),APCMGLST("IDX",C,C)=X,APCMNOLI(X)="" I $D(APCMLIST(X)) S APCMGLST(C,0)="*"_APCMGLST(C,0)
 S (VALMCNT,APCMHIGH)=C
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 W ! S DIR(0)="LO^1:"_APCMHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S APCMGANS=Y,APCMGC="" F APCMGI=1:1 S APCMGC=$P(APCMGANS,",",APCMGI) Q:APCMGC=""  S APCMI=APCMGLST("IDX",APCMGC,APCMGC) I $D(APCMIND(APCMI)),'$D(APCMNOLI(APCMI)) S APCMLIST(APCMI)=""
ADDX ;
 D BACK
 Q
ADDALL ;
 F X=1:1:APCMHIGH S I=$G(APCMGLST("IDX",X,X)) I $D(APCMIND(I)),'$D(APCMNOLI(I)) S APCMLIST(I)=""
 D BACK
 Q
 ;
REM ;
 W ! S DIR(0)="LO^1:"_APCMHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S APCMGANS=Y,APCMGC="" F APCMGI=1:1 S APCMGC=$P(APCMGANS,",",APCMGI) Q:APCMGC=""  S I=APCMGLST("IDX",APCMGC,APCMGC) K APCMLIST(I)
REMX ;
 D BACK
 Q
 ;
PT ;EP
 S (APCMROT,APCMDELT,APCMDELF)=""
 W !!,"Please choose an output type.  For an explanation of the delimited",!,"file please see the user manual.",!
 S DIR(0)="S^P:Print Report on Printer or Screen;D:Create Delimited output file (for use in Excel);B:Both a Printed Report and Delimited File",DIR("A")="Select an Output Option",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S APCMROT=Y
 Q:APCMROT="P"
 S APCMDELF="",APCMDELT=""
 W !!,"You have selected to create a delimited output file.  You can have this",!,"output file created as a text file in the pub directory, ",!,"OR you can have the delimited output display on your screen so that"
 W !,"you can do a file capture.  Keep in mind that if you choose to",!,"do a screen capture you CANNOT Queue your report to run in the background!!",!!
 S DIR(0)="S^S:SCREEN - delimited output will display on screen for capture;F:FILE - delimited output will be written to a file in pub",DIR("A")="Select output type",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PT
 S APCMDELT=Y
 Q:APCMDELT="S"
 S DIR(0)="F^1:40",DIR("A")="Enter a filename for the delimited output (no more than 40 characters)" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PT
 S APCMDELF=Y
 W !!,"When the report is finished your delimited output will be found in the",!,$P($G(^AUTTSITE(1,1)),U,2)," directory.  The filename will be ",APCMDELF,".txt",!
 Q
REPORT ;EP
 S APCMRPT=""
 W !!
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 ;3 files must have the same ien
 L +^APCMMUDC:30 I '$T W !!,"Unable to lock global, try later." G REPORTX
 L +^APCDMUDP:30 I '$T W !!,"Unable to lock global, try later." G REPORTX
 D GETIEN
 I 'APCMIEN W !!,"Something wrong with control files, notify programmer!" S APCMRPT="" G REPORTX
 S DINUM=APCMIEN
 K DIC S X=APCMBD,DIC(0)="L",DIC="^APCMMUDC(",DLAYGO=9001300.03,DIADD=1,DIC("DR")=".02////"_APCMED_";.03////"_APCMPBD_";.04////"_APCMPED_";.05////"_DUZ(2)_";.06////"_$S(APCMRPT=1:"E",1:"H")_";.07////"_$$NOW^XLFDT()
 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S APCMQUIT=1 G REPORTX
 S APCMRPT=+Y
 ;set 11 multiple with variable pointers to each provider/hospital
 I APCMRPTT=1 D  S ^APCMMUDC(APCMRPT,11,0)="^9001300.0311AV^"_C_"^"_C
 .S X=0,C=0 F  S X=$O(APCMPRV(X)) Q:X'=+X  S C=C+1 D
 ..S ^APCMMUDC(APCMRPT,11,C,0)=X_";VA(200,"
 ..S ^APCMMUDC(APCMRPT,11,"B",X_";VA(200,",C)=""
 I APCMRPTT=2 D  S ^APCMMUDC(APCMRPT,11,0)="^9001300.0311AV^"_C_"^"_C
 .S X=0,C=1,X=APCMFAC D
 ..S ^APCMMUDC(APCMRPT,11,C,0)=X_";AUTTLOC("
 ..S ^APCMMUDC(APCMRPT,11,"B",X_";AUTTLOC(",C)=""
 K DIC S X=APCMBD,DIC(0)="L",DIC="^APCMMUDP(",DLAYGO=9001300.04,DIADD=1,DIC("DR")=".02////"_APCMED_";.03////"_APCMPBD_";.04////"_APCMPED_";.05////"_DUZ(2)_";.06////"_$S(APCMRPT=1:"E",1:"H")_";.07////"_$$NOW^XLFDT()
 S DINUM=APCMRPT D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DINUM I Y=-1 W !!,"UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S APCMQUIT=1 G REPORTX
 S APCMRPTP=+Y
 I APCMRPTT=1 D  S ^APCMMUDP(APCMRPTP,11,0)="^9001300.0411AV^"_C_"^"_C
 .S X=0,C=0 F  S X=$O(APCMPRV(X)) Q:X'=+X  S C=C+1 D
 ..S ^APCMMUDP(APCMRPTP,11,C,0)=X_";VA(200,"
 ..S ^APCMMUDP(APCMRPTP,11,"B",X_";VA(200,",C)=""
 I APCMRPTT=2 D  S ^APCMMUDP(APCMRPT,11,0)="^9001300.0411AV^"_C_"^"_C
 .S X=0,C=0,X=APCMFAC,C=C+1 D
 ..S ^APCMMUDP(APCMRPT,11,C,0)=X_";AUTTLOC("
 ..S ^APCMMUDP(APCMRPT,11,"B",X_";AUTTLOC(",C)=""
REPORTX ;
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 L -^APCMMUDC
 L -^APCDMUDP
 Q
GETIEN ;EP -Get next ien available in all 3 files
 S APCMF=9001300.03 D ENT
 S APCMF=9001300.04 D ENT
 S APCMIEN=$P(^APCMMUDC(0),U,3)+1
S I $D(^APCDMUDP(APCMIEN)) S APCMIEN=APCMIEN+1 G S
 Q
 ;
ENT ;
 NEW GBL,NXT,CTR,XBHI,XBX,XBY,ANS
 S GBL=^DIC(APCMF,0,"GL")
 S GBL=GBL_"NXT)"
 S (XBHI,NXT,CTR)=0
 F L=0:0 S NXT=$O(@(GBL)) Q:NXT'=+NXT  S XBHI=NXT,CTR=CTR+1 ;W:'(CTR#50) "."
 S NXT="",XBX=$O(@(GBL)),XBX=^(0),XBY=$P(XBX,U,4),XBX=$P(XBX,U,3)
 S NXT=0,$P(@(GBL),U,3)=XBHI,$P(^(0),U,4)=CTR
 ;
EOJ ;
 KILL ANS,XBHI,XBX,XBY,CTR,DIC,FILE,GBL,L,NXT,APCMF
 Q
