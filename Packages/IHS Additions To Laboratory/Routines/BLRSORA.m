BLRSORA ;VA/DRH/DALISC - HIGH/LOW VALUE TASKED REPORT ;2/19/91  11:42 ;
 ;;5.2;LAB SERVICE;**1038**;NOV 01, 1997;Build 6
 ;
EEP ; EP - Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ; Cloned from the LR*5.2*1030 LRSORA routine
 ;
 ; This version is designed to be tasked.  It will REJECT interactive reporting.
 ;
BEGIN ; EP - Beginning
 I $D(ZTQUEUED)<1 D  Q
 . W !!,?4,"This report can only be run from TASKMAN."
 . D PRESSKEY^BLRGMENU(9)
 S:$D(ZTQUEUED) ZTREQ="@"
 ;
GETPARAM ; EP - Get the parameters from the IHS LAB SUPERVISOR TASKED REPORTS PARAMETERS (#90475.7) file
 NEW GPD0,GPD1,LRCNT,LRPTS,LREND,LRLONG,LRSDT,LREDT,LRTW
 ;
 S (GPD0,GPD1)=1
 ;
 D INIT,GDT,GAA,GLRT
 I LREND<1 D
 . D SORTBY,SELLOC,GDV
 . S IOP="`"_$G(^BLRLSRP(GPD0,2,GPD1,5))
 . S %ZIS="Q"
 . S ZTSAVE("LR*")=""
 . S ZTSAVE("GP*")=""
 . D EN^XUTMDEVQ("RUN^BLRSORA","TASKED IHS LAB HIGH/LOW VALUE REPORT",.ZTSAVE,.%ZIS)
 S LREND=1
 D STOP
 Q
 ;
SORTBY ; EP - Determine SORT BY parameter
 NEW SORTBY
 ;
 S SORTBY=$P($G(^BLRLSRP(GPD0,2,GPD1,3)),U)
 S LRSRT=$S($L(SORTBY):SORTBY,1:"P")
 Q
 ;
SELLOC ; EP - Get Locations from 90475.7, if they exist
 S LRLCS=0
 Q:$D(^BLRLSRP(GPD0,2,GPD1,4,0))<1     ; Retrun if no entries
 ;
 NEW LOCIEN,LOCSUB,LOCSUBAB,CNTLOC
 ;
 S (CNTLOC,LOCSUB)=0
 F  S LOCSUB=$O(^BLRLSRP(GPD0,2,GPD1,4,LOCSUB))  Q:LOCSUB<1  D
 . S LOCIEN=$G(^BLRLSRP(GPD0,2,GPD1,4,LOCSUB,0))
 . S LOCSUBAB=$$GET1^DIQ(44,LOCIEN,"ABBREVIATION")
 . Q:$L(LOCSUBAB)<1
 . ;
 . S CNTLOC=CNTLOC+1
 . S LRLCS=CNTLOC
 . S LRLCS(LOCSUBAB)=LOCIEN
 I $G(LRLCS) S LRLCS("NO ABRV")=""
 Q
 ;
RUN ;
 K ^TMP("LR",$J)
 S:$D(ZTQUEUED) ZTREQ="@" U IO
 S (LRPAG,LREND)=0,$P(LRDASH,"-",IOM)="-"
 K %DT S X=$P(LRSDT,"."),%DT="X" D ^%DT,DD^LRX S LRSDAT=Y
 K %DT S X=LREDT,%DT="X" D ^%DT,DD^LRX S LREDAT=Y
 S LRHDR2="For date range: "_LREDAT_" to "_LRSDAT
 D:'LREND START^LRSORA2
 D:$D(ZTQUEUED) STOP
 Q
STOP ;
 D STOP^LRSORA0
 Q
GAA ; EP - Get Accession Areas
 S LRAA=0
 Q:$D(^BLRLSRP(GPD0,2,GPD1,1,0))<1
 ;
 NEW GAAD2,GLRAA,GLRAAAB
 ;
 S GAAD2=0
 F  S GAAD2=$O(^BLRLSRP(GPD0,2,GPD1,1,GAAD2))  Q:GAAD2<1  D
 . S GLRAA=$G(^BLRLSRP(GPD0,2,GPD1,1,GAAD2,0))
 . S GLRAAAB=$$GET1^DIQ(68,GLRAA,"ABBREVIATION")
 . Q:$L(GLRAAAB)<1
 . ;
 . S LRAA(GLRAAAB)=GLRAA
 . S LRAA=GLRAA
 ;
 Q
GLRT ; EP - Get LaboRatory Tests
 K LRTST
 I $D(^BLRLSRP(GPD0,2,GPD1,2,0))<1 D  Q      ; Skip if no tests defined
 . W !!,"No Tests Defined in the IHS LAB SUPERVISOR TASKED REPORTS PARAMETERS dictionary"
 . W !,?4,"for the IHS Lab tasked version of 'Search for high/low values of a test'."
 . W !!
 . S LREND=1
 ;
 NEW CHAR,CNT,F60DNIEN,F60IEN,F60NAME,GPD3,GPD4,I,IEN,OPERATOR,OPNAME,OPVAL,STR,VALUE
 ;
 S (CNT,GPD3)=0
 F  S GPD3=$O(^BLRLSRP(GPD0,2,GPD1,2,GPD3))  Q:GPD3<1  D
 . S IEN=GPD3_","_GPD1_","_GPD0
 . S F60IEN=$$GET1^DIQ(90475.723,IEN,"Laboratory Tests","I")
 . S F60NAME=$$GET1^DIQ(90475.723,IEN,"Laboratory Tests")
 . S F60DNIEN=$$GET1^DIQ(60,F60IEN,400,"I")
 . S GPD4=0
 . F  S GPD4=$O(^BLRLSRP(GPD0,2,GPD1,2,GPD3,1,GPD4))  Q:GPD4<1  D
 .. S IEN=GPD4_","_GPD3_","_GPD1_","_GPD0
 .. S OPERATOR=$$GET1^DIQ(90475.7231,IEN,"Operator","I")
 .. S OPNAME=$$GET1^DIQ(90475.7231,IEN,"Operator")
 .. S VALUE=$$GET1^DIQ(90475.7231,IEN,"Value","I")
 .. Q:OPERATOR=""!($L(VALUE)<1)!(OPERATOR>3)
 .. ;
 .. S OPVAL=$S(OPERATOR=0:"<",OPERATOR=1:">",OPERATOR=2:"=",OPERATOR=3:"[")
 .. ;
 .. S CNT=CNT+1
 .. S STR="I $D(^("_F60DNIEN_"))"
 .. S STR=STR_" S LRVX=$P(^("_F60DNIEN_"),U),LRVX=$S(LRVX?1A.E:LRVX,""<>""[$E(LRVX):$E(LRVX,2,$L(LRVX)),1:LRVX)"
 .. S STR=STR_" I LRVX"_OPVAL_VALUE
 .. S LRTST(CNT,1)=STR
 .. S LRTST(CNT,2)=F60NAME_"^^"_OPNAME_" "_VALUE
 .. S LRTST(CNT,3)=F60DNIEN_"^"
 ;
 Q:CNT<1
 ;
 S LRTST=CNT
 S LRTST(0)="A"
 F I=2:1:CNT S LRTST(0)=$G(LRTST(0))_"!"_$C(64+I)
 Q
 ;
 Q
 ;
GTSC ;
 S LRA=1
 F I=0:0 D @$S(LRA=2:"SPEC",LRA=3:"CND",LRA=4:"GV",1:"TST") Q:LRA=0
 Q
 ;
TST ;
 K DIC S DIC="^LAB(60,",DIC(0)="AEMOQ"
 S DIC("S")="I $P(^(0),U,5)[""CH"",""BO""[$P(^(0),U,3)" D ^DIC
 S LRA=$S(Y>0:2,1:0)
 S:X["^" LREND=1
 I Y>0 S $P(LRTST(LRTST,3),"^",1)=$P($P(^LAB(60,+Y,0),U,5),";",2)
 I  S $P(LRTST(LRTST,2),"^",1)=$P(Y,"^",2)
 Q
 ;
SPEC ;
 S LRCNT=LRCNT+1
 K DIC S DIC="^LAB(61,",DIC(0)="AEMOQ"
 S DIC("A")="Select SPECIMEN/SITE: ANY// " D ^DIC
 S:Y<1 $P(LRTST(LRTST,3),"^",2)="",$P(LRTST(LRTST,2),"^",2)=""
 S LRA=$S(X["^":1,1:3)
 I Y>0 S $P(LRTST(LRTST,3),"^",2)=+Y,$P(LRTST(LRTST,2),"^",2)=$P(Y,"^",2)
 Q
 ;
CND ;
 W !,"Select CONDITION: " R X:DTIME S:'$T X="^"
 D @$S(X?1.N1":"1.N:"RNG",1:"GC") Q
RNG ;
 N Y
 S LRV=+$P(X,":",1),LRV2=+$P(X,":",2),LRA=0
 S:LRV>LRV2 X=LRV,LRV=LRV2,LRV2=X
 S $P(LRTST(LRTST,2),U,3)="BETWEEN "_LRV_" AND "_LRV2
 S X=$P(LRTST(LRTST,3),U,1)
 S Y="I $D(^("_X
 S Y=Y_")) S LRVX=$P(^("_X
 S Y=Y_"),U),LRVX=$S(LRVX?1A.E:LRVX,"
 S Y=Y_"""<>""[$E(LRVX):$E(LRVX,2,$L(LRVX)),1:LRVX)"
 S LRTST(LRTST,1)=Y_" I LRVX>"_LRV_",LRVX<"_LRV2
 D ASPC Q
GC ;
 S DIC="^DOPT(""DIS"",",DIC(0)="EMQZ",DIC("S")="I $L($P(^(0),U,2))"
 D ^DIC K DIC
 S LRA=$S(X["^":2,Y<0:3,1:4) D:X["?" HLP1 W:'$L(X) " ??" Q:Y<0
GV ;
 N LY,ALPHA,DEC,II,TT
 W !,"Enter VALUE: "
 R X:DTIME S:'$T X="^"
 S LRA=$S(X["^":3,"?"[X:4,1:0)
 W:X="" " ??" D:X["?" HLP2 Q:LRA
 S:"<>"[$P(Y(0),U,2) X=+X
 S $P(LRTST(LRTST,2),"^",3)=$P(Y(0),"^",1)_" "_X
 ;
 ; determine if entered value is alphanumeric
 S (ALPHA,DEC)=0
 F II=1:1 S TT=$E(X,II) Q:TT=""  D  Q:ALPHA
 . I TT?1N Q
 . I TT?1"." S DEC=DEC+1 S:DEC>1 ALPHA=1 Q
 . S ALPHA=1
 I X="""""" S ALPHA=0 ;ADDED FOR LR*5.2*357
 ;
 S LY="I $D(^("_$P(LRTST(LRTST,3),U)
 S LY=LY_")) S LRVX=$P(^("
 S LY=LY_$P(LRTST(LRTST,3),U)
 S LY=LY_"),U),LRVX=$S(LRVX?1A.E:LRVX,"
 S LY=LY_"""<>""[$E(LRVX):$E(LRVX,2,$L(LRVX)),1:LRVX) I LRVX"
 S LRTST(LRTST,1)=LY_$P(Y(0),U,2)_$S(ALPHA:""""_X_"""",1:X) D ASPC Q
ASPC ;
 S:$L($P(LRTST(LRTST,3),U,2)) LRTST(LRTST,1)=LRTST(LRTST,1)_",$P(^(0),U,5)="_$P(LRTST(LRTST,3),U,2) Q
 ;
INIT ; EP - Initialization
 S LRCNT=0
 S LRPTS=0
 S U="^"
 S LREND=0
 S LRLONG=0
 S LRSDT="TODAY"
 S LREDT="T-1"
 S LRTW=.00001
 S:'$D(DTIME) DTIME=300
 Q
 ;
GDT ;
 NEW DTRANGE,GOBACK
 ;
 S DTRANGE=+$$GET1^DIQ(90475.72,GPD1_","_GPD0,"Date Range","I")
 S GOBACK=$S(DTRANGE=1:7,DTRANGE=2:30,DTRANGE=3:365,1:1)
 S:DTRANGE=3 LRLONG=1
 S LREDT=$$HTFM^XLFDT(+$H-GOBACK)
 S LRSDT=$$DT^XLFDT_".5"
 S LRHDR2="For date range: "_$$FMTE^XLFDT(LREDT,"5DZ")_" to "_$$FMTE^XLFDT(LRSDT,"5DZ")
 Q
 ;
GSLOG ; EP - Get Search LOGic
 ; Note that if the Search logic fields are null, cannot run the report.  Skip
 I +$O(^BLRLSRP(GPD0,2,GPD1,2,0))<1 D  Q
 . W !!,"Search logic fields in 90745.7 are empty."
 . W !!,"Cannot do report."
 . S LREND=1
 ;
 S:LRTST=1 LRTST(0)="A" D:LRTST>1 EN^LRSORA1 S:LRTST<1 LREND=1 Q
 ;
GDV ;
 S %ZIS="Q" D ^%ZIS K %ZIS I POP S LREND=1 Q
 I $D(IO("Q")) K IO("Q") S (LRQUE,LREND)=1,ZTRTN="RUN^LRSORA",ZTDESC="Lab Special Report",ZTSAVE("LR*")="" D ^%ZTLOAD
 Q
HLP1 ;
 W !,"A VALUE RANGE may also be entered (value:value).",!,"  For Example, 100:200 will search for values between 100 and 200.",!
 Q
HLP2 ;
 W !,"Enter a value for the comparison:  "
 W $P(LRTST(LRTST,2),U,1)," ",$P(Y(0),U,1)_" _____."
 Q
XX ;
WAIT K DIR S DIR(0)="E" D ^DIR S:($D(DUOUT))!($D(DTOUT)) LREND=1
 Q
