AQAOPC24 ; IHS/ORDC/LJF - PRINT OCC BY INDICATOR W/ ICD ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains an entry point called by ^AQAOPC22 to print the
 ;summary page for the trending report by dx and procedure.
 ;
SUMMARY ;ENTRY POINT to print summary page(s)
 ;called by ^AQAOPC22
 I $D(AQAODLM) D HDGDLM I 1
 E  D HDG
 ;
 F I="D","P","V","F" Q:AQAOSTOP=U  D
 .W !!,"Subtotals by ",$S(I="F":"FINDING",I="V":"PROVIDER CODE",I="D":"DIAGNOSIS",1:"PROCEDURE"),": "
 .S AQAOSUB=0 I '$D(AQAOXSN) D SUM1 Q  ;no spec sort
 .F  S AQAOSUB=$O(^TMP("AQAO",$J,I,AQAOSUB)) Q:AQAOSUB=""  Q:AQAOSTOP=U  D
 ..W !!,AQAOSUB,":",! D SUM1
 Q
 ;
SUM1 ; >> SUBRTN to loop thru subtotals
 S AQAOX=0
 F  S AQAOX=$O(^TMP("AQAO",$J,I,AQAOSUB,AQAOX)) Q:AQAOX=""  Q:AQAOSTOP=U  D
 .I $D(AQAODLM) D  Q
 ..W AQAODLM,AQAOX,AQAODLM,^TMP("AQAO",$J,I,AQAOSUB,AQAOX),! ;print counts
 .W ?28,AQAOX,?70,^TMP("AQAO",$J,I,AQAOSUB,AQAOX),! ;print counts
 .I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 Q
 ;
 ;
HDG2 ; >> SUBRTN for second half of heading2    
 S X="(SUMMARY PAGE with STATISTICS)" W ?AQAOIOMX-$L(X)/2,X
 W !?AQAOIOMX-$L(AQAORG)/2,AQAORG,!,AQAOLINE,!
 Q
 ;
 ;
HDGDLM ; >> SUBRTN to print summary page(s) in ASCII format
 W !!!,"**SUMMARY DATA**" I AQAODESC]"" W !!,AQAODESC
 S X=^AQAO(2,AQAOIND,0) W !!,$P(X,U),AQAODLM,$P(X,U,2) ;ind # and name
 I $P(X,U,5)]"" W AQAODLM,"THRESHOLD/TRIGGER:  ",$P(X,U,5),"%"
 W !,"TOTAL OCCURRENCES FOR DATE RANGE:",AQAODLM,AQAOCNT
 W AQAODLM,"DENOMINATOR:  ______",AQAODLM,"SOURCE: ___________________"
 Q
 ;
 ;
HDG ;heading for paper prints
 D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 I AQAODESC]"" W !!?AQAOIOMX-$L(AQAODESC)/2,AQAODESC
 S X=^AQAO(2,AQAOIND,0) W !!,$P(X,U),?10,$P(X,U,2) ;ind # and name
 I $P(X,U,5)]"" W ?55,"THRESHOLD/TRIGGER:  ",$P(X,U,5),"%"
 W !,"TOTAL OCCURRENCES FOR DATE RANGE:  ",AQAOCNT
 W !,"                     DENOMINATOR:  ______"
 W "  SOURCE: _____________________________"
 Q
