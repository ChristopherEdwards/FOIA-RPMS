AQAOPR21 ; IHS/ORDC/LJF - PRINT REVIEW WORKSHEETS CONT. ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This is the main driver to loop through the selected occurrences and
 ;print the selected worksheets and/or summaries.  The DIP calls for
 ;the occ summary and occ worksheet are included here.  This rtn calls
 ;^AQAOPR22 to print the review worksheet.
 ; 
LOOP ; >> loop through patients selected and print
 S (AQAOCID,AQAOPAGE)=0
 F  S AQAOCID=$O(AQAOARR(AQAOCID)) Q:AQAOCID=""  D
 .S AQAOIFN=AQAOARR(AQAOCID) D ^AQAOPR22 ;print worksheet
 .I AQAOSUM=1 D SUM ;print summary
 .I AQAOWKS=1 D WKS ;print occ worksheet
 ;
END ; >>> eoj
 D KILL^AQAOUTIL Q
 ;
 ;
SUM ; >>> SUBRTN to print occurrence summary
 S L="",DIC="^AQAOC(",FLDS="[AQAO LONG DISPLAY]"
 S BY="@NUMBER",(TO,FR)=AQAOIFN,IOP=AQAODEV
 I $D(ZTQUEUED) S IOP="Q;"_AQAODEV,DQTIME="NOW"
 D EN1^DIP K IOP ;display occurrence
 I '$D(ZTQUEUED),'$D(AQAOSLV) D PRTOPT^AQAOVAR
 Q
 ;
 ;
WKS ; >>> SUBRTN to rpint occ worksheets
 S L="",DIC="^AQAOC(",FLDS="[AQAO AUTO WORKSHEET]"
 S BY="@NUMBER",(TO,FR)=AQAOIFN,IOP=AQAODEV
 I $D(ZTQUEUED) S IOP="Q;"_AQAODEV,DQTIME="NOW"
 D EN1^DIP K IOP ;display occurrence
 I '$D(ZTQUEUED),'$D(AQAOSLV) D PRTOPT^AQAOVAR
 Q
