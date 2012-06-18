ABMDTX2 ; IHS/ASDST/DMJ - PT 3 OF CLAIM EXPORT PROGRAM ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;IHS/ADC/KML - 03/16/98 - return global reference name 
 ;              from ^TMP to ^ABPVDATA 
 ;IHS/ADC/LSL - 03/24/98 - Also add if bill is cancelled don't
 ;              send out or mark as transferred.
 ;
START K ^ABPVDATA ; transient global
 I '$D(ABMP("AUTO")) U IO(0) W !!,"Generating Private Insurance Claim Export Records:  ",!
 S ABM("CNT")=0
 D ^ABMDTX3
 S ^ABPVDATA(0)=$P(^AUTTLOC(DUZ(2),0),U,10)_U_$P(^DIC(4,DUZ(2),0),U)_U_$S(ABM("REDO"):ABM("ADFN"),1:DT)_U_ABM("FDT")_U_ABM("EDT")_U_ABM("LREC")_U_(ABM("CNT")/2)
 S ABM("REC")=^ABPVDATA(0)
 I '$D(ABMP("AUTO")) U IO(0) W $$EN^ABMVDF("IOF") D HEADER U IO
 S ABMJDT=$$JDT^XBFUNC(DT)            ; Todays julian date
 S XBFN="ABPV"_$P(ABM("REC"),U)_"."_ABMJDT  ; File name
 S ABM("IO")=IO,ABM("IO0")=IO(0),XBGL="ABPVDATA",XBTLE="3P AO EXPORT"
 I $P($G(^ABMDPARM(DUZ(2),1,2)),U,2),'$D(ABMP("AUTO")) S XBMED=$P(^(2),U,2)
 D ^XBGSAVE S IO=ABM("IO"),IO(0)=ABM("IO0") I XBFLG S ABM("XIT")=6 Q
 S DIE="^ABMDAOTX(DUZ(2),",DA=ABM("ADFN"),DR=".02////"_(ABM("CNT")/2)_";.04////"_ABM("AMT") D ^ABMDDIE
 S ABM("TDFN")=0 F  S ABM("TDFN")=$O(^TMP("ABMDTX",$J,"EXP",ABM("TDFN"))) Q:'ABM("TDFN")  D
 .S DA=ABM("TDFN"),DIE="^ABMDTXST(DUZ(2),",DR=".06////"_DT_";.07///@" D ^ABMDDIE
 S ABM("BDFN")=0 F  S ABM("BDFN")=$O(^TMP("ABMDTX",$J,ABM("BDFN"))) Q:'ABM("BDFN")  D
 .S DIE="^ABMDBILL(DUZ(2),",DA=ABM("BDFN")
 .S DR=".18////"_ABM("ADFN")_";.16///@" D ^ABMDDIE
 .Q:$P(^ABMDBILL(DUZ(2),ABM("BDFN"),0),"^",4)="C"
 .Q:$P(^ABMDBILL(DUZ(2),ABM("BDFN"),0),"^",4)="X"  ;Don't send cancelled bills. 
 .S DR=".04////T" D ^ABMDDIE
 Q:$D(ABMP("AUTO"))  Q:'$G(ABMP("TLIST"))
 W !!,"Printing Area Office Tracking System Transmittal List....."
 D OPEN^ABMDTX I $G(POP) S ABM("XIT")=1 Q
 U IO D WRT^ABMDTX0
 I $D(ABM("PRINT",16)) D 10^ABMDR16
 W $$EN^ABMVDF("IOF") D HEADER
 Q
 ;
HEADER F I=1:1:70 W "*"
 W !,"*",?12,"BILLING CLAIM EXPORT REPORT",?69,"*",!
 S X="FOR "_$P(^DIC(4,DUZ(2),0),U,1) W "*",?70-$L(X)/2,X,?69,"*",!
 S Y=$S(ABM("REDO"):ABM("ADFN"),1:DT) X ^DD("DD") W "*",?70-$L(Y)/2,Y,?69,"*",! F I=1:1:70 W "*"
 W !!?10,"FACILITY CODE = ",?40,$P(ABM("REC"),U,1)
 W !,?10,"DATE EXPORT CREATED = " S Y=$P(ABM("REC"),U,3) X ^DD("DD") W ?40,Y
 W !,?10,"BEGINNING CLAIM DATE = " S Y=$P(ABM("REC"),U,4) X ^DD("DD") W ?40,Y
 W !,?10,"ENDING CLAIM DATE = " S Y=$P(ABM("REC"),U,5) X ^DD("DD") W ?40,Y
 W !,?10,"NUMBER OF CLAIM RECORDS = ",?40,$P(ABM("REC"),U,7),!!
 F I=1:1:70 W "*"
 Q
