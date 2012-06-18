DGPMGL1 ;ALB/MRL/LM/MJK - G&L ENTRY POINT CONT.; [ 09/13/2001  3:56 PM ]
 ;;5.3;Registration;**1005**;Aug 13, 1993
 ;IHS/ANMC/LJF  3/30/2001 changed references to IHS files
 ;                        added calls to IHS routines for calculate
 ;                        commented out code not needed
 ;IHS/OIT/LJF  01/05/2006 PATCH 1005 removed 2nd time recalc ran on primary date
 ;
 Q
 ;  Continuation from DGPMGL
A S REM=0 I BS!(GL) S Y=LD X:Y]"" ^DD("DD") W !!,"LAST BED STATUS REPORT TOTALS EXIST FOR ",Y
 ;I TSR,TSRI]"",TSLD S Y=TSLD X:Y]"" ^DD("DD") W !!,"LAST TREATING SPECIALTY REPORT TOTALS EXIST FOR ",Y  ;IHS/ANMC/LJF 3/30/2001 not needed
 S X1=DT,X2=-1 D C^%DTC S YD=X
 ;  Updating last date G&L generated
 I LD'=YD S X1=LD,X2=1 D C^%DTC S (LD,Y)=X X ^DD("DD")
 I LD=YD S LD=DT
 K ^UTILITY($J)
 S DD=Y
 ;
WHEN ;  Asking when to print report/s
 W !!,"PRINT REPORT",$S(GL&BS:"S",1:"")," FOR WHICH DATE: ",DD,"// " R X:DTIME
 G Q:X["^"!('$T) S:X="" X=DD S %DT="EPX" D ^%DT G WHEN:Y<0
 S (RD,X1)=+Y,X2=-1 D C^%DTC S PD=X
 I Y<DGPM("G") S Y=+DGPM("G") X ^DD("DD") W !!,"EARLIEST DATE ALLOWED IS ",Y,".",*7 G WHEN
 I Y>DT S Y=DT X ^DD("DD") W !!,"CHOOSE A DATE ON OR BEFORE ",Y,".",*7 G WHEN
 I Y<LD S X1=Y,X2=-1 D C^%DTC
 ;
 ;IHS/ANMC/LJF 3/30/2001 changed reference to IHS file
 ;I '$D(^DG(41.9,WD,"C",X,0)) W !!,"NO TOTALS EXIST FOR PREVIOUS DAY!!",*7 G WHEN
 I '$D(^BDGCWD(+WD,1,X,0)) D  G WHEN
 . W !!,"NO TOTALS EXIST FOR PREVIOUS DAY!!"
 ;IHS/ANMC/LJF 3/30/2001 end of code changes
 ;
 I RD=DT,BS W !!," * BED STATUS REPORT WILL NOT BE CALCULATED...TODAY'S ACTIVITY IS INCOMPLETE! *",*7 S BS=0
 ;
 G IHS  ;IHS/ANMC/LJF 3/30/2001 skip to line IHS
 ;
 I RD=DT,TSR W !!," * THE TSR WILL NOT PRINT...TODAY'S ACTIVITY IS INCOMPLETE! *",*7 S TSR=0
 I 'GL,'BS,'TSR G WHEN
 I TSR I TSRI]"" I RD<TSRI S Y=+TSRI X ^DD("DD") W !!,"EARLIEST DATE FOR TREATING SPECIALTY REPORT IS ",Y,".",*7,!!,"TREATING SPECIALTY REPORT WILL NOT BE PRINTED FOR THE DATE SELECTED!" I 'BS,'GL G WHEN
 I RD=YD,$D(^DG(43,1,"NOT")),$P(^("NOT"),"^",8) D ^DGABUL ;  Transmit Overdue Absence Bulletin
ADC I BS D ^DGPMGL2
 I 'BS&('TSR) S RC=0 D ^DGPMGL2
 I BS!(TSR) D RC I $D(%) G:%=-1 Q^DGPMGL I '$D(RCCK) G:%=2 Q^DGPMGL
 W !!,"Note: This output should be printed at a column width of 132.",!
 ;
IHS ; skipped VA code from above and added IHS code;IHS/ANMC/LJF 3/30/2001
 I 'BS S RC=0
 I BS D RC I $D(%) I %=-1 G Q^DGPMGL
 I GL L +^BDGCWD:5 I '$T W !!,"CENSUS FILES LOCKED; SOMEONE ELSE RUNNING RECALC; TRY AGAIN LATER!!" D PAUSE^BDGF D Q^DGPMGL Q
 NEW BDGFRM,BDGQUIT W ! D FORMAT^BDGAD0 G:$G(BDGQUIT) Q^DGPMGL
 D MSG^BDGF("Printing to HOME puts report into browse mode.",2,1)
 ;IHS/ANMC/LJF 3/30/2001  end of IHS code
 ;
 S %ZIS="QM" D ^%ZIS G Q:POP!(IO="") I $D(IO("Q")) K IO("Q") D QUE G Q
 U IO
 ;
GO D CLEAN^DGPMGLG
 D NOW^%DTC S Y=$E(%,1,12) X ^DD("DD") S DGNOW=Y ; used to print date/time of report
 ;
 ;IHS/ANMC/LJF 3/30/2001 call IHS calculate and print routines
 ;D:$D(RC) UP43^DGPMBSR,^DGPMBSR D ^DGPMGLG
 ;
 ;IHS/OIT/LJF 01/05/2006 PATCH 1005 don't recalc 2nd time into BDGAD1 (DGPMBSR already called BDGAD1) 
 ;D:$D(RC) UP43^DGPMBSR,^DGPMBSR D ^BDGAD1
 D:$D(RC) UP43^DGPMBSR,^DGPMBSR S BDGREP=1 D ^BDGAD1
 ;
 D ^BDGADD:BDGFRM="D",^BDGADS:BDGFRM="S"   ;detailed vs summary format
 ;IHS/ANMC/LJF 3/30/2001 end of code changes
 ;
 S DIE="^DG(43,",DA=1,DR="54////@;55////@;56////@" D ^DIE
Q G DONE^DGPMGLG
 ;
RC ;  G&L corrections
 S RC=$S($P(DGPM("G"),"^",7)>+DGPM("G"):$P(DGPM("G"),"^",7),1:+DGPM("G")),CD=$O(^DGS(43.5,"AGL",RC-1))
 I CD,CD'>RD S Y=CD X ^DD("DD") W !!,"G&L corrections exist from ",Y,"."
 S X1=DT,X2=-7 D C^%DTC S LW=X ; Last Week
 I CD>LW,CD'>RD S RC=CD,%=1 W !,"SINCE G&L CORRECTIONS ARE RECENT (WITHIN LAST WEEK) RECALCULATION WILL OCCUR",!,"AUTOMATICALLY AS THE "_$S('TSR:"BED STATUS REPORT",'BS:"TREATING SPECIALTY REPORT",1:"BSR AND TSR")_" IS COMPUTED!" G RCQ
 ;
 ;IHS/ANMC/LJF 3/30/2001 reference IHS files
 ;I $O(^DIC(42,"AGL",0)) S WD=$O(^DIC(42,"AGL",$O(^(0)),0)) I '$D(^DG(41.9,WD,"C",RD,0)) S RC=RD,%=1 G RCQ
 I $O(^DIC(42,"AGL",0)) S WD=$O(^DIC(42,"AGL",$O(^(0)),0)) I '$D(^BDGCWD(+WD,1,RD,0)) S RC=RD,%=1 G RCQ
 ;IHS/ANMC/LJF 3/30/2001 end of code changes
 ;
 ;
RC1 D RCCK^DGPMBSAR ;  Check for ReCalc already running
 I '$D(RCCK) I $P(DGPM("GLS"),"^",5) I $D(%) I %=2!(%=-1) Q
 I $D(RCR) S RC=0 Q
 ;
 ;IHS/ANMC/LJF 3/30/2001 changed prompt
 ;W !!,"Recalculate BSR" W:TSR "/TSR" W " Totals" S %=2 D YN^DICN G RCQ:%=-1
 I $G(BDGREP) S %=2               ;reprint option selected from menu
 E  W !!,"Recalculate Totals" S %=2 D YN^DICN G RCQ:%=-1  S:%=2 BDGREP=1
 ;IHS/ANMC/LJF 3/30/2001 end of code changes
 ;
 I % S RC=$S(%=2:0,'CD:RD,CD<RD:CD,1:RD) G RCQ
 I '% W !?4,"Answer YES to recalculate totals to insure accurancy or NO to simply print",!?4,"report with existing CENSUS file totals." G RC1
RCQ K LW Q
 ;
QUE S ZTIO=ION_";"_$S($D(IOST)#2:IOST,1:"")_";"_$S($D(IOM)#2:IOM,1:"")_";"_$S($D(IOSL)#2:IOSL,1:""),ZTDESC=$S(GL&(BS):"G&L AND BSR",GL:"G&L",1:"BSR")_" GENERATION",ZTRTN="GO^DGPMGL1"
 F I="DUZ","DIV","RD","TSR","TSRI","BS","GL","DGPM(""G"")","DGPM(""GL"")","DUZ","REM","PD","RC","RM","SS","MT","TS","CP","OS","SNM","VN","SF","TSD" S ZTSAVE(I)=""
 ;
 S ZTSAVE("BDGFRM")=""  ;IHS/ANMC/LJF 3/30/2001 add IHS variable
 ;
 D ^%ZTLOAD Q
 ;
VAR ;  REM=Recalc Patient Days  ;  LD=Last Date G&L was run  ;  YD=YesterDay  ;
 ;  RD=Report Date  ;  PD=Previous Date ; CD= Correction Date ;
 ;  RC=ReCalc from date  ;
