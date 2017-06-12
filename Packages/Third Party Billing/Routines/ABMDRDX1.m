ABMDRDX1 ; IHS/ASDST/DMJ - Billed DX List ;
 ;;2.6;IHS 3P BILLING SYSTEM;**14**;NOV 12, 2009;Build 238
 ;Original;TMD;
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;IHS/SD/SDR - 2.6*14 - Updated DX^ABMCVAPI call to be numeric
 ;IHS/SD/SDR - 2.6*14 - removed '9' from ICD9 in header
 ;IHS/SD/SDR - 2.6*14 - HEAT165197 - Shortened desc to 31 characters to stop wrapping
 ;
PRINT ;EP for printing data
 W:$D(ABM("PRINT",16)) @ABM("PRINT",16) S ABM("PG")=0 D HDB
 S ABM("O")=0 F  S ABM("O")=$O(^TMP("ABM-DX",$J,ABM("O"))) Q:ABM("O")=""  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .S ABM=$O(^TMP("ABM-DX",$J,ABM("O"),0)) Q:ABM=""  S ABM("T")=^(ABM)
 .I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 .D WRT
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIROUT))
 S ABM("T")=$G(^TMP("ABM-DX",$J))
 W !?41,"+=======+=============+"
 W !,"Primary Diagnosis Total",?43,$J($FN($P(ABM("T"),U),",",0),5),?51,$J($FN($P(ABM("T"),U,2),",",2),11)
 W !?41,"+=======+=============+"
 Q
 ;
WRT ;
 ;W !?2,$P($$DX^ABMCVAPI(ABM,ABM("D")),U,2),?10,$P($$DX^ABMCVAPI(ABM,ABM("D")),U,4)  ;CSV-c  ;abm*2.6*14 updated API call
 W !?2,$P($$DX^ABMCVAPI(+ABM,ABM("D")),U,2),?10,$E($P($$DX^ABMCVAPI(+ABM,ABM("D")),U,4),1,31)  ;CSV-c  ;abm*2.6*14 updated API call and HEAT165197
 W ?43,$J($FN($P(ABM("T"),U),",",0),5),?51,$J($FN($P(ABM("T"),U,2),",",2),11)
 W ?66,$J((100*$P(ABM("T"),U))\+^TMP("ABM-DX",$J),2),"%"
 Q
 ;
HD D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HDB S ABM("PG")=ABM("PG")+1,ABM("I")="" D WHD^ABMDRHD
 ;W !?2,"ICD9"  ;ABM*2.6*14 remove '9' so its good for both code sets
 W !?2,"ICD"  ;ABM*2.6*14
 W !?2,"Code",?14,"Diagnosis Description",?43,"Bills",?53,"Amount",?64,"Percent"
 W !,"+-------+--------------------------------+-------+-------------+-------+"
 Q
