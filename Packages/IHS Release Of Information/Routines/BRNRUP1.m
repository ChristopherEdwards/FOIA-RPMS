BRNRUP1 ; IHS/OIT/LJF - CONTINUED REPORT UTILITY PRINT LOGIC
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 10/25/2007 PATCH 1 Added this routine
 ;
COVPAGE ;EP
 W:$D(IOF) @IOF
 W !?20,"ROI REPORT UTILITY ",$S(BRNCTYP="D":"LISTING",1:"COUNT")
 W !?34,"SUMMARY PAGE"
 W !!,"REPORT REQUESTED BY: ",$P(^VA(200,DUZ,0),U),!
 W !,"Disclosure Record Selection Criteria"
 W !?6,"Request Date range:  ",BRNBDD," to ",BRNEDD
 ;
 ; if no sleection criteria, show print criteria
 I '$D(^BRNRPT(BRNRPT,11)) D SHOWP Q
 ;
 ; else, show selection criteria first
 NEW BRNI,BRNY,C,BRNQ,X
 S BRNI=0 F  S BRNI=$O(^BRNRPT(BRNRPT,11,BRNI)) Q:BRNI'=+BRNI  D
 . I $Y>(IOSL-5) D PAUSE^BRNU W @IOF
 . W !?6,$P(^BRNSORT(BRNI,0),U),":  "
 . S BRNY="",C=0 K BRNQ
 . F  S BRNY=$O(^BRNRPT(BRNRPT,11,BRNI,11,"B",BRNY)) S C=C+1 W:C'=1&(BRNY'="") " ; " Q:BRNY=""!($D(BRNQ))  D
 . . S X=BRNY X:$D(^BRNSORT(BRNI,2)) ^(2) W X     ;translation logic
 D SHOWP
 Q
 ;
SHOWP ; display what the report will contain based on report type
 W !!,"REPORT/OUTPUT TYPE",!
 I BRNCTYP="T" D COUNT Q        ;totals: display and quit
 ;
 ; subtotals
 I BRNCTYP="S" D  I 1
 . I $Y>(IOSL-6) D PAUSE^BRNU W @IOF
 . W ?6,"Report will contain sub-totals by ",$P(^BRNSORT(BRNSORT,0),U)," and ",!?6,"total counts."
 . I '$D(^XTMP("BRNVL",BRNJOB,BRNBTH)) W !!,"NO DATA TO REPORT.",! D PAUSE^BRNU W:$D(IOF) @IOF
 ;
 I BRNCTYP'="D",BRNCTYP'="L" D PAUSE^BRNU W:$D(IOF) @IOF Q
 I $Y>(IOSL-4) D PAUSE^BRNU W @IOF
 ;
 I BRNCTYP="D" W ?6,"Detailed Listing containing"
 ;
 I BRNCTYP="L" D
 . W !?5,"PLEASE NOTE:  The first column of the delimited output will always"
 . W !?5,"              be the patient internal entry number which uniquely"
 . W !?5,"              identifies the patient.  The second column will always"
 . W !?5,"              be the request internal entry number which uniquely"
 . W !?5,"              identifies the disclosure request.",!
 . W ?6,"A File of records called ",BRNDELF," will be created."
 . W !?6,"Delimited output file will contain:"
 ;
 I '$D(^BRNRPT(BRNRPT,12)) D PAUSE^BRNU Q
 ;
 ; loop through print items and display them
 NEW BRNI,BRNCRIT
 S BRNI=0 F  S BRNI=$O(^BRNRPT(BRNRPT,12,BRNI)) Q:BRNI'=+BRNI  S BRNCRIT=$P(^BRNRPT(BRNRPT,12,BRNI,0),U) D
 . I $Y>(IOSL-4) D PAUSE^BRNU W:$D(IOF) @IOF
 . W !?6,$P(^BRNSORT(BRNCRIT,0),U)
 . I BRNCTYP="D" W "  (" S X=$O(^BRNRPT(BRNRPT,12,"B",BRNCRIT,"")) I X]"" W $P(^BRNRPT(BRNRPT,12,X,0),U,2),")"
 ;
 I $Y>(IOSL-4) D PAUSE^BRNU W:$D(IOF) @IOF
 I BRNCTYP="D" W !?10,"     TOTAL column width: ",BRNTCW
 ;
 Q:'$G(BRNSORT)
 I $Y>(IOSL-4) D PAUSE^BRNU W:$D(IOF) @IOF
 W !!,"Disclosure Requests will be SORTED by:  ",$P(^BRNSORT(BRNSORT,0),U),!
 I $Y>(IOSL-4) D PAUSE^BRNU W:$D(IOF) @IOF
 I $G(BRNSPAG) W !?6,"Each ",$P(^BRNSORT(BRNSORT,0),U)," will be on a separate page.",!
 ;
 I '$D(^XTMP("BRNVL",BRNJOB,BRNBTH)) W !!,"NO DATA TO REPORT.",!
 ;
 I BRNCTYP="L" D
 . I $D(BRNRCNT) W !!!,"Total Disclosure Requests:  ",BRNRCNT
 . W !,"Total Patients:  ",BRNPTCT
 ;
 Q
 ;
COUNT ;if COUNTING entries only   
 I $Y>(IOSL-5) D PAUSE^BRNU W:$D(IOF) @IOF
 W ?6,"Totals Displayed"
 I '$D(^XTMP("BRNVL",BRNJOB,BRNBTH)) W !!!,"NO DATA TO REPORT.",!
 W:$D(BRNRCNT) !!!?6,"Total COUNT of Disclosure Requests:  ",?34,BRNRCNT
 W !?6,"Total COUNT of Patients:  ",?34,BRNPTCT
 Q
 ;
WP ;EP - Entry point to print wp fields
 ; pass file in  BRNFILE, entry in BRNDA, subscript in BRNNODE
 NEW BRNRLX,BRNG1,BRNG,DIWL,DIWR,DIWF,X,Y,Z
 K ^UTILITY($J,"W")
 S BRNRLX=0
 S BRNG1=^DIC(BRNFILE,0,"GL"),BRNG=BRNG1_BRNDA_","_BRNNODE_",BRNRLX)",BRNGR=BRNG1_BRNDA_","_BRNNODE_",BRNRLX"
 S DIWL=1,DIWR=$P(^BRNRPT(BRNRPT,12,BRNI,0),U,2) F  S BRNRLX=$O(@BRNG) Q:BRNRLX'=+BRNRLX  D
 .S Y=BRNGR_",0)" S X=@Y D ^DIWP
 ;
 S Z=0 F  S Z=$O(^UTILITY($J,"W",DIWL,Z)) Q:Z'=+Z  S BRNPCNT=BRNPCNT+1,BRNPRNM(BRNPCNT)=^UTILITY($J,"W",DIWL,Z,0)
 S BRNPCNT=BRNPCNT+1
 K ^UTILITY($J,"W"),BRNNODE,BRNFILE,BRNDA
 Q
