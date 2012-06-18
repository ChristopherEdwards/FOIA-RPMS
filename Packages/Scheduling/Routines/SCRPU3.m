SCRPU3 ;ALB/CMM - GENERIC UTILITIES ; 29 Jun 99  04:11PM [ 11/02/2000  3:08 PM ]
 ;;5.3;Scheduling;**41,45,52,140,181,177**;AUG 13, 1993
 ;IHS/ANMC/LJF 11/01/2000 bypass %ZIS call if using list template
 ;             11/02/2000 added checks for list template
 ;
ELIG(DFN) ;
 ;Gets Primary Eligibility
 N PRIM
 I '$D(^DPT(DFN,.36)) Q 0
 I '$D(^DIC(8,+$P(^DPT(DFN,.36),"^"),0)) Q 0
 S PRIM=$P($G(^DIC(8,$P($G(^DPT(DFN,.36)),"^"),0)),"^",9)
 ;MAS Primary Eligibility Code
 S PRIM=$P($G(^DIC(8.1,PRIM,0)),"^")
 ;
 S PRIM=$TR(PRIM,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 I PRIM="NON-SERVICE CONNECTED" S PRIM="NSC"
 I PRIM["SERVICE CONNECTED" S PRIM=$P(PRIM,"SERVICE CONNECTED")_"SC"_$P(PRIM,"SERVICE CONNECTED",2,999)
 I PRIM["LESS THAN" S PRIM=$P(PRIM,"LESS THAN")_"<"_$P(PRIM,"LESS THAN",2,999)
 I PRIM[" TO " S PRIM=$P(PRIM," TO ")_"-"_$P(PRIM," TO ",2,999)
 I PRIM["%" S PRIM=$TR(PRIM,"%","")
 S PRIM=$E(PRIM,1,9)
 Q PRIM
 ;
GETNEXT(DFN,CLN) ;
 ;Get next appointment for patient (DFN) at Clinic (CLN)
 ;Returning the date in 00/00/0000 format
 N NEXT,APPT,FOUND
 S APPT=DT,FOUND=0,NEXT=""
 F  S APPT=$O(^DPT(DFN,"S",APPT)) Q:APPT=""!(FOUND)  D
 .I CLN=+$G(^DPT(DFN,"S",APPT,0))&($P(^DPT(DFN,"S",APPT,0),"^",2)'["C") S FOUND=1,NEXT=$TR($$FMTE^XLFDT(APPT,"5DF")," ","0")
 Q NEXT
 ;
GETLAST(DFN,CLN) ;
 ;Get last appointment for patient (DFN) at Clinic (CLN)
 ;Returning the date in 00/00/0000 format
 N LAST,APPT,FOUND,STATUS
 S APPT=DT,FOUND=0,LAST=""
 F  S APPT=$O(^DPT(DFN,"S",APPT),-1) Q:APPT=""!(APPT=0)!(FOUND)  D
 .I CLN=+$G(^DPT(DFN,"S",APPT,0)) S STATUS=$P(^DPT(DFN,"S",APPT,0),"^",2) D
 ..I STATUS=""!("NAPCA"'[STATUS) S FOUND=1,LAST=$TR($$FMTE^XLFDT(APPT,"5DF")," ","0")
 ..Q
 .Q
 Q LAST
 ;
PDEVICE() ;
 ;Generic Printer Call
 N TION,POP
 S %ZIS="QN" D ^%ZIS K %ZIS Q:POP!(ION="^") -1
 S TION=ION
 I $D(IO("Q")) S TION="Q;"_TION
 Q TION_"^"_IOST
 ;
GETTIME() ;
 ;Prompt for Queue Time
 N X,Y
 S DIR(0)="D^::RFE",DIR("A")="Start Time",DIR("B")="NOW"
 D ^DIR
 I $D(DTOUT)!(X="") S Y=$H
 I $D(DUOUT)!($D(DIROUT)) S Y=-1
 K DIR,DTOUT,DUOUT,DIROUT
 Q Y
 ;
HOLD(PAGE,TIT,MARG) ;
 ;device is home, reached end of page
 N X
 S MARG=$G(MARG) S:MARG'>80 MARG=80
 W !!,"Press Any Key to Continue or '^' to Quit" R X:DTIME
 I '$T!(X="^") S STOP=1 Q
 D NEWP1(.PAGE,TIT,MARG)
 Q
 ;
NEWP1(PAGE,TITL,MARG) ;
 Q:$G(VALM)   ;IHS/ANMC/LJF 11/2/2000
 ;new page
 ;
 S MARG=$G(MARG) S:MARG'>80 MARG=80
 D STOPCHK^DGUTL
 I $G(STOP) D STOPPED^DGUTL Q
 W:PAGE>0 @IOF
 S PAGE=PAGE+1
 D TITLE(PAGE,TITL,MARG)
 Q
 ;
TITLE(PG,TITL,MARG) ;
 Q:$G(VALM)   ;IHS/ANMC/LJF 11/2/2000
 N PDATE,SCX,SCI
 S MARG=$G(MARG) S:MARG'>80 MARG=80
 S PDATE=$$FMTE^XLFDT(DT,"5D")
 S SCI=(IOM-$L(TITL)\2) S:SCI<24 SCI=24
 S SCX="Printed on: "_PDATE
 S $E(SCX,SCI)=TITL
 S $E(SCX,(IOM-6-$L(PG)))="Page: "_PG
 W SCX,!
 Q
 ;
CLOSE ;close device
 D:$E(IOST)'="C" ^%ZISC
 Q
 ;
OPEN ;opens device
 IF IOST?1"C-".E D  Q  ;%zis has already been called via $$pdevice
 .W @IOF
 D ^%ZIS
 Q:POP
 U IO
 Q
 ;
NODATA(TITL) ;
 ;no data to print
 ;returns 1
 ;D OPEN  ;IHS/ANMC/LJF 11/1/2000
 I '$G(VALM) D OPEN  ;IHS/ANMC/LJF 11/1/2000
 D TITLE(1,TITL)
 W !,"No data to report"
 D CLOSE
 Q 1
 ;
HELP W:'$D(VAUTNA) !,"ENTER:",!?5,"- A or ALL for all ",VAUTSTR,"s, or"
 W:($D(VAUTTN))&(VAUTSTR="TEAM") !?5,"- N or NOT for not assigned to a team or"
 W:($D(VAUTPO))&(VAUTSTR="PRACTITIONER") !?5,"- N or NONE or NOT for not assigned to a Practitioner"
 W !?5,"- Select individual "_VAUTSTR W:'$D(VAUTPO) " -- limit 20"
 W !?5,"Imprecise selections will yield an additional prompt."
 I $O(@VAUTVB@(0))]"" W !?5,"- An entry preceeded by a minus [-] sign to remove entry from list."
 I $O(@VAUTVB@(0))]"" W !,"NOTE, you have already selected:" S VAJ=0 F VAJ1=0:0 S VAJ=$O(@VAUTVB@(VAJ)) Q:VAJ=""  W !?8,$S(VAUTNI=1:VAJ,1:@VAUTVB@(VAJ))
 Q
 ;
CONV(ORIGA,NEWA) ;
 ;ORIGA - original array - name(ien)=data
 ;NEWA - new array - name(n)=ien^data
 ;
 N ENT,CNT
 S ENT=0,CNT=0
 S NEWA=ORIGA
 F  S ENT=$O(ORIGA(ENT)) Q:ENT=""!(ENT'?.N)  D
 .S CNT=CNT+1
 .S NEWA(CNT)=ENT_"^"_ORIGA(ENT)
 Q
