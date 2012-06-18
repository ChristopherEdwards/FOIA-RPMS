ABMDPST1 ; IHS/SD/SDR - Pending Claims Status Report ; JUN 29, 2005
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
PRINT ;EP for printing data
 K ABM("LOCATION TEMP"),ABM("PS UPDATER TEMP"),ABM("VISIT TEMP")
 K ABM("CLINIC TEMP"),ABM("ACTIVE INSURER TEMP")
 S ABM("PG")=0
 D HDB
 S ABM("SUB CNT")=0
 S ABM("TOTAL CNT")=0
 S ABM("Z")="TMP(""ABM-ICS"","_$J
 S ABM="^"_ABM("Z")_")"
 I '$D(@ABM) Q
 F  S ABM=$Q(@ABM) Q:ABM'[ABM("Z")  D  G:$D(DTOUT)!$D(DUOUT)!$D(DIROUT) XIT
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)  W " (cont)"
 .S ABM("T")=$P(ABM,"ABM-ICS",2),ABM("TXT")=$P($P(ABM("T"),",",3,99),"""",2),ABM("TXT")=+$P(ABM("T"),",",3)_U_ABM("TXT")
 .S ABM("LOCATION NAME")=$P(ABM("TXT"),U,2)
 .S ABM("SORT")=$P(ABM("TXT"),U,3)
 .S ABM("PATIENT")=$P(ABM("TXT"),U,4)
 .S ABM("HRN")=$P(ABM("TXT"),U,5)
 .S ABM("CLAIM")=$P(ABM("TXT"),U,6)
 .S ABM("VISIT TYPE")=$P(ABM("TXT"),U,7)
 .S ABM("CLINIC")=$P(ABM("TXT"),U,8)
 .S ABM("CLINIC")=$S(ABM("CLAIM")'="":$E($P($G(^DIC(40.7,ABM("CLINIC"),0)),U),1,12),1:"UNDEFINED")
 .S ABM("PS REASON")=$P(ABM("TXT"),U,9)
 .S ABM("VISIT DATE")=$P(ABM("TXT"),U,10)
 .S ABM("I")=$P(ABM("TXT"),U,11)
 .S:ABM("I")="" ABM("I")="UNDEFINED"
 .S ABM("PS UPDATER")=$P(ABM("TXT"),U,12)
 .I ABM("PS UPDATER")="" S ABM("PS UPDATER")="UNDEFINED"
 .E  S ABM("PS UPDATER")=$P($G(^VA(200,ABM("PS UPDATER"),0)),U)
 .;
 .;DO SUB HEADERS
 .I $G(ABM("LOCATION TEMP"))'=ABM("LOCATION NAME") D:$G(ABM("LOCATION TEMP"))'="" SUBHDR,TOTHDR W !?3,"Visit Location: ",$G(ABM("LOCATION NAME")) S ABM("LOCATION TEMP")=ABM("LOCATION NAME")
 .I $G(ABM("PS UPDATER TEMP"))'=ABM("PS UPDATER") W !?6,"Status Updater: ",$G(ABM("PS UPDATER")) S ABM("PS UPDATER TEMP")=ABM("PS UPDATER")
 .I ABMY("SORT")="V" I $G(ABM("VISIT TEMP"))'=ABM("VISIT TYPE") D:$G(ABM("VISIT TEMP"))'="" SUBHDR W !?5,"Visit Type: "_$P(^ABMDVTYP(ABM("VISIT TYPE"),0),U) S ABM("VISIT TEMP")=ABM("VISIT TYPE")
 .I ABMY("SORT")="C" I $G(ABM("CLINIC TEMP"))'=ABM("CLINIC") D:$G(ABM("CLINIC TEMP"))'="" SUBHDR W !?5,"    Clinic: "_$G(ABM("CLINIC")) S ABM("CLINIC TEMP")=ABM("CLINIC")
 .I $G(ABM("ACTIVE INSURER TEMP"))'=$G(ABM("I")) W !?11,"Active Insurer: ",$P($G(^AUTNINS(ABM("I"),0)),U) S ABM("ACTIVE INSURER TEMP")=ABM("I")
 .W !!
 .W $E(ABM("PATIENT"),1,16)               ;pat name
 .W ?18,ABM("HRN")                        ;hrn
 .W ?26,ABM("CLAIM")                      ;claim number
 .W ?34,$$SDT^ABMDUTL(ABM("VISIT DATE"))  ;visit date
 .W ?46,ABM("CLINIC")                     ;clinic
 .K ^UTILITY($J,"W")
 .S DIWL=60,DIWR=79
 .S DIWF="WC19"
 .S X=ABM("PS REASON")                    ;reason
 .D ^DIWP
 .D ^DIWW
 .S ABM("SUB CNT")=$G(ABM("SUB CNT"))+1
 .S ABM("TOTAL CNT")=$G(ABM("TOTAL CNT"))+1
 D SUBHDR
 D TOTHDR
 W !!,"E N D  O F  R E P O R T"
 D PAZ^ABMDRUTL
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 W !?26,"Claim",?34,"Visit"
 W !?2,"Patient",?18,"HRN",?26,"Number",?34,"Date",?46,"Clinic",?60,"Reason"
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
SUBHDR Q:'ABM("SUB CNT")
 W !?27,"------"
 W !?16,"Subtotal:",?27,ABM("SUB CNT")
 S ABM("SUB CNT")=0
 Q
 ;
TOTHDR Q:'ABM("TOTAL CNT")
 W !?27,"------"
 W !?19,"Total:",?27,ABM("TOTAL CNT")
 S ABM("TOTAL CNT")=0
 Q
XIT ;EXIT POINT
 K ^TMP("ABM-ICS",$J)
 Q
