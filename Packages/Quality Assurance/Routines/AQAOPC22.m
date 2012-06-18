AQAOPC22 ; IHS/ORDC/LJF - PRINT OCC BY INDICATOR W/ ICD ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is the main driver to print the trending report by diagnosis
 ;and procedure.
 ;
INIT ; >>> initialize variables
 I AQAOTYPE="L",IOT'="HFS" D
 .S (AQAOIOMX,X)=132 X ^%ZOSF("RM") ;lstng needs 132col
 D INIT^AQAOUTIL S AQAOHCON="Patient"
 S AQAOTY="OCCURRENCES BY INDICATOR WITH DX/PROCEDURES"
 S AQAORG=$E(AQAOBD,4,5)_"/"_$E(AQAOBD,6,7)_"/"_$E(AQAOBD,2,3)_" to "
 S AQAORG=AQAORG_$E(AQAOED,4,5)_"/"_$E(AQAOED,6,7)_"/"_$E(AQAOED,2,3)
 K ^TMP("AQAO",$J)
 ;
MAIN ; >>> main calls
 I '$D(^TMP("AQAOPC2",$J)) D HEADING^AQAOUTIL,HDG1 W !!,"NO DATA FOR DATE RANGE SPECIFIED",!! G END ;no entries
 D LISTING
 I AQAOSTOP'=U D SUMMARY^AQAOPC24
 ;
 ;
END ; >>> eoj
 I $D(AQAODLM) W !!,*7,"*** STOP CAPTURE NOW! ***",!
 I AQAOTYPE="L",IOT'="HFS" S X=IOM X ^%ZOSF("RM") ;reset right margin
 D ^%ZISC I '$D(ZTQUEUED) D PRTOPT^AQAOVAR
 K ^TMP("AQAOPC2",$J),^TMP("AQAO",$J) D KILL^AQAOUTIL
 Q
 ;
 ;
LISTING ; >> SUBRTN to print occurrence listing if selected
 I $D(AQAODLM),AQAOTYPE="L" D DLMHDG I 1 ;print heading
 E  I AQAOTYPE="L" D HEADING^AQAOUTIL,HDG1
 ;
 S AQAOSUB=0 I '$D(AQAOXSN) D LIST2 Q  ;no spec sorts
 F  S AQAOSUB=$O(^TMP("AQAOPC2",$J,AQAOSUB)) Q:AQAOSUB=""  Q:AQAOSTOP=U  D LIST2 ;spec review sort
 Q
 ;
 ;
LIST2 ; >> SUBRTN to print occ for each AQAOSUB
 I AQAOSUB'=0 W:AQAOTYPE="L" !!?AQAOIOMX-$L(AQAOSUB)/2,AQAOSUB,!
 S AQAODT=0
 F  S AQAODT=$O(^TMP("AQAOPC2",$J,AQAOSUB,AQAODT)) Q:AQAODT=""  Q:AQAOSTOP=U  D
 .S AQAON=0
 .F  S AQAON=$O(^TMP("AQAOPC2",$J,AQAOSUB,AQAODT,AQAON)) Q:AQAON=""  Q:AQAOSTOP=U  D
 ..S AQAOSTR=$G(^AQAOC(AQAON,0)) ;basic occ data
 ..I AQAOTYPE="L" D
 ...I '$D(AQAODLM),($Y>(IOSL-2)) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1
 ...S Y=AQAODT X ^DD("DD") I $D(AQAODLM) S Y=$P(Y,",")_" "_$P(Y,",",2)
 ...I $D(AQAODLM) W !,$P(AQAOSTR,U),AQAODLM,Y,AQAODLM ;case&date ASCII
 ...E  W !,$P(AQAOSTR,U),?9,Y ;print case & date
 ...K ^UTILITY("DIQ1",$J) S DIC="^AQAOC(",DA=AQAON,DR=".025" D EN^DIQ1
 ...W:'$D(AQAODLM) ?22
 ...W ^UTILITY("DIQ1",$J,9002167,AQAON,.025) ;age at time of occ
 ...W:$D(AQAODLM) AQAODLM W:'$D(AQAODLM) ?30
 ...W $P(^DPT($P(^AQAOC(AQAON,0),U,2),0),U,2) ;patient's sex
 ..;
 ..D FINDING
 ..;print last finding
 ..I AQAOTYPE="L" W:$D(AQAODLM) "," W:'$D(AQAODLM) ?35
 ..I AQAOTYPE="L" W AQAOF,$S($D(AQAODLM):AQAODLM,AQAOS="":"",1:" / "),AQAOS
 ..;increment count for this finding
 ..I AQAOF]"" S ^TMP("AQAO",$J,"F",AQAOSUB,AQAOF)=$G(^TMP("AQAO",$J,"F",AQAOSUB,AQAOF))+1
 ..;
 ..D ICDPRINT^AQAOPC23 ;print all icd codes defined for occ
 Q
 ;
 ;
FINDING ; >> SUBRTN to find last finding to date for occ
 S (AQAOF,AQAOS)="" ;initialize finding & stage to null
 S X=$P($G(^AQAOC(AQAON,"FINAL")),U,4) ;if final finding at closure
 S Y=$P($G(^AQAOC(AQAON,"FINAL")),U,2) ;final review stage
 I X]"" S AQAOF=$P(^AQAO(8,X,0),U,2) S:Y]"" AQAOS=$P(^AQAO(7,Y,0),U,2) Q
 S (X,Y)=0 F  S X=$O(^AQAOC(AQAON,"REV",X)) Q:X'=+X  S Y=X
 I Y>0 D  Q  ;else get finding for last review
 .S X=$P(^AQAOC(AQAON,"REV",Y,0),U,5) S:X]"" AQAOF=$P(^AQAO(8,X,0),U,2)
 .S X=$P(^AQAOC(AQAON,"REV",Y,0),U) S:X]"" AQAOS=$P(^AQAO(7,X,0),U,2)
 ;           ;else get initial finding
 S X=$P($G(^AQAOC(AQAON,1)),U,5) S:X]"" AQAOF=$P(^AQAO(8,X,0),U,2)
 S X=$P($G(^AQAOC(AQAON,1)),U,3) S:X]"" AQAOS=$P(^AQAO(7,X,0),U,2)
 Q
 ;
 ;
HDG1 ; >> SUBRTN for second half of heading
 S X="(OCCURRENCE LISTINGS)" W ?AQAOIOMX-$L(X)/2,X
 W !?AQAOIOMX-$L(AQAORG)/2,AQAORG,!,AQAOLINE
 W !,"Case #",?9,"Occ Date",?23,"Age",?29,"Sex",?34,"Fndg/Stg"
 W ?45,"Prov",?53,"Diagnoses",?92,"Procedures"
 W !,AQAOLINE,!
 I AQAODESC]"" W !?AQAOIOMX-$L(AQAODESC)/2,AQAODESC,!
 Q
 ;
 ;
DLMHDG ; >> SUBRTN for ASCII heading for listing portion
 W !!!!,"***OCCURRENCE LISTINGS WITH ICD CODES***",!,AQAORG,!
 W !,"Printed by ",AQAODUZ," Printed on " S %H=$H D YX^%DTC W Y
 I AQAODESC]"" W !,AQAODESC,!
 F I="Case #","Occ Date","Age","Sex","Finding","Stage" W I,AQAODLM
 F I="Provider","DX code","DX narrative","Procedure code","Procedure narrative" W I,AQAODLM
 Q
