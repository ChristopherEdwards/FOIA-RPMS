BDMDDTSN ; IHS/CMI/LAB - DISPLAY IND LISTS ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**9**;JUN 14, 2007;Build 78
 ;; ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 I '$D(BDMGUI) D EN^XBVK("BDM")
 Q
 ;; ;
EN ;EP -- main entry point for 
 D EN^VALM("BDMDD SNOMED VIEW")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
HDR ; -- header code
 S VALMHDR(1)="SNOMED LISTS TO SUPPORT 2016 DIABETES AUDIT REPORTING"
 S VALMHDR(2)="* View SNOMED Lists"
 Q
 ;
INIT ;EP -- init variables and list array
 K BDMTAX S BDMHIGH="",C=0
 S BDMYR=$O(^BDMSNME("B",2016,0))
 S BDMX=0,J=0 F  S BDMX=$O(^BDMSNME(BDMYR,11,"B",BDMX)) Q:BDMX=""  D
 .S BDMY=$O(^BDMSNME(BDMYR,11,"B",BDMX,0))
 .S J=J+1
 .S BDMTAX(J,0)=J_")  "_BDMX
 .S BDMTAX("IDX",J,J)=BDMYR_U_BDMY
 .S C=C+1
 .Q
 S (VALMCNT,BDMHIGH)=C
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
DISP ;EP - add an item to the selected list - called from a protocol
 W !
 S DIR(0)="NO^1:"_BDMHIGH,DIR("A")="Which SNOMED List"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No list selected." G DISPX
 I $D(DIRUT) W !,"No list selected." G DISPX
 S BDMTAXI=$P(BDMTAX("IDX",Y,Y),U,1),BDMTAXT=$P(BDMTAX("IDX",Y,Y),U,2),BDMTAXN=$P(^BDMSNME(BDMTAXI,11,BDMTAXT,0),U,1)
 ;BROWSE OR PRINT
 D FULL^VALM1
 W ! S DIR(0)="S^P:PRINT SNOMED List Output;B:BROWSE SNOMED List Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D XIT Q
 S BDMOPT=Y
 I Y="B" D BROWSE,XIT Q
 S XBRP="PRINT^BDMDDTSN",XBRC="",XBRX="XIT^BDMDDTSN",XBNS="BDM"
 D ^XBDBQUE
 D DISPX
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BDMDDTSN"")"
 S XBRC="",XBRX="XIT^BDMDDTSN",XBIOP=0 D ^XBDBQUE
 Q
PHDR ;
 I 'BDMPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S BDMPG=BDMPG+1
 I $G(BDMGUI),BDMPG'=1 W !,"ZZZZZZZ"
 W !,$P(^VA(200,DUZ,0),U,2),?72,"Page ",BDMPG,!
 W ?(80-$L($P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U))/2),$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),U),!
 W $$CTR("Listing of the "_BDMTAXN_" SNOMED List",80),!,BDM80D,!
 Q
PRINT ;
 S BDMPG=0
 K BDMQ
 S BDM80D="-------------------------------------------------------------------------------"
 D PHDR
P1 ;
 F  S BDMX=$O(^BDMSNME(BDMTAXI,11,BDMTAXT,11,"B",BDMX)) Q:BDMX=""  D
 .I $Y>(IOSL-3) D PHDR Q:$D(BDMQ)
 .W BDMX D
 ..I $T(CONC^BSTSAPI)="" Q
 ..NEW D,B,E,V,A,B
 ..W ?25,$P($$CONC^BSTSAPI(BDMX_"^^^1"),U,4),!
 D XIT
 Q
DISPX ;
 D BACK
 Q
XIT ;
 K ^TMP($J,"BDMTAXDSP")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
