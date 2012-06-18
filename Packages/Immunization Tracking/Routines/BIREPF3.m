BIREPF3 ;IHS/CMI/MWR - REPORT, FLU IMM; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW INFLUENZA IMMUNIZATION REPORT.
 ;
 ;
 ;----------
AGETOT(BILINE,BICC,BIHCF,BICM,BIBEN,BIYEAR,BIPOP,BIFH,BIUP) ;EP
 ;---> Write Age Total line.
 ;---> Parameters:
 ;     1 - BILINE (req) Line number in ^TMP Listman array.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIYEAR (req) Report Year^m (if 2nd pc="m", then End Date=March 31 of
 ;                      the report year; otherwise End Date=Dec 31 of BIYEAR)
 ;     7 - BIPOP  (ret) BIPOP=1 if error.
 ;     8 - BIFH   (opt) F=report on Flu Vaccine Group (default), H=H1N1 group.
 ;     9 - BIUP   (req) User Population/Group (Registered, Imm, User, Active).
 ;
 S BIPOP=0
 S:($G(BIFH)="") BIFH="F"
 S:$G(BIUP)="" BIUP="u"
 ;---> Check for required Variables.
 I '$G(BIYEAR) D ERRCD^BIUTL2(679,.X) D WRITERR^BIREPF2(BILINE,X) S BIPOP=1 Q
 N BIQDT S BIQDT=(BIYEAR-1700)_1231
 ;
 ;---> Gather and sort patients.
 N N S N=0
 F I="10-23","24-59","60-215","216-599","600-779","780-1500" D
 .;---> For each age range, get Begin and End Dates (DOB's).
 .D AGEDATE^BIAGE(I,BIQDT,.BIBEGDT,.BIENDDT)
 .;---> Leave an Age Group=5 for High Risk (subset of Group 4
 .S N=N+1 S:(N=5) N=6
 .D GETPATS^BIREPF4(BIBEGDT,BIENDDT,N,.BICC,.BIHCF,.BICM,.BIBEN,BIQDT,BIFH,BIYEAR,BIUP)
 ;
 ;---> Count patients.
 N BIAGRP,BITOT S BITOT=0
 F I=1:1:7 D
 .N M,N S M=0,N=0,BIAGRP(I)=0
 .F  S N=$O(^TMP("BIREPF1",$J,"PATS",I,N)) Q:'N  D
 ..;---> Yes, now include Age Group 5 (18-49 High Risk) in Totals.
 ..;S BIAGRP(I)=BIAGRP(I)+1 S:(I'=5) BITOT=BITOT+1
 ..S BIAGRP(I)=BIAGRP(I)+1 S BITOT=BITOT+1
 .S BITMP("STATS","TOTAL",I)=BIAGRP(I)
 S BITMP("STATS","TOTAL","ALL")=BITOT
 ;
 ;---> Write Age Totals line.
 ;N X S X=" # in Age |"
 N X S X=" Denominator |"
 ;X ^O
 F I=1:1:7 S X=X_$J($G(BIAGRP(I)),6)_"  "
 S X=$E(X,1,$L(X)-2)_" |"_$J(BITOT,7)
 D WRITE(.BILINE,X)
 D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 Q
 ;
 ;
 ;----------
VGRP(BILINE,BIVGRP,BIYEAR) ;EP
 ;---> Write Stats lines for each Vaccine Group.
 ;---> Parameters:
 ;     1 - BILINE (req) Line number in ^TMP Listman array.
 ;     2 - BIVGRP (req) IEN of Vaccine Group.
 ;     3 - BIYEAR (req) Report Year.
 ;
 ;---> Write a line for each Dose of this Vaccine Group.
 ;N BIDOSE,BIMAXD S BIMAXD=$$VGROUP^BIUTL2(BIVGRP,6)
 N BIDOSE,BIMAXD S BIMAXD=1
 ;---> For H1N1 Report display 2 doses.
 S:BIVGRP=18 BIMAXD=2
 F BIDOSE=1:1:BIMAXD D
 .;
 .;---> *** WRITE DOSE 1 LINE:
 .;---> BIX=text of the line to write.
 .;---> Write the Dose#-Vaccine Group in left margin.
 .N BIX S BIX="   "_BIDOSE_"-"_$$VGROUP^BIUTL2(BIVGRP,5)
 .S BIX=$$PAD^BIUTL5(BIX,13)_"|"
 .;
 .;---> Now loop through the Age Groups, concating subtotals.
 .N BIAGRP,BISUBT S BISUBT=0
 .F BIAGRP=1:1:7 D
 ..;---> BITMP(Vaccine Grp, CURRENT Season, Dose, Age Grp)
 ..N Y S Y=+$G(BITMP("STATS",BIVGRP,1,BIDOSE,BIAGRP))
 ..;---> Write stats for each Age Group, but don't include 5 in total.
 ..;S BIX=BIX_$J(Y,6)_"  " S:(BIAGRP'=5) BISUBT=BISUBT+Y
 ..;---> Yes, now include Age Group 5 (18-49 High Risk) in Totals.
 ..S BIX=BIX_$J(Y,6)_"  " S BISUBT=BISUBT+Y
 .;
 .S BIX=$E(BIX,1,$L(BIX)-2)_" |"_$J(BISUBT,7)
 .D WRITE(.BILINE,BIX)
 .I BIDOSE=1 D MARK^BIW(BILINE,BIMAXD+2,"BIREPF1")
 .;
 .;---> *** NOW WRITE PERCENTAGES LINE:
 .;---> BIX=text of the line to write.
 .;---> Write "YYYY Season" in left margin.
 .S:'$G(BIYEAR) BIYEAR="YYYY"
 .K BIX N BIX S BIX=" "_+BIYEAR_" Season "
 .S BIX=$$PAD^BIUTL5(BIX,13)_"|"
 .;
 .;---> Now loop through the Age Groups, writing percentages.
 .F BIAGRP=1:1:7 D
 ..;---> BITMP(Vaccine Grp, CURRENT Season, Dose, Age Grp)
 ..N Y S Y=$G(BITMP("STATS",BIVGRP,1,BIDOSE,BIAGRP)) S:Y="" Y=0
 ..N Z S Z=$G(BITMP("STATS","TOTAL",BIAGRP)) S:'Z Y=0,Z=1
 ..S BIX=BIX_"   "_$J((100*Y/Z),3,0)_"% "
 .;
 .;---> Now write total percentage.
 .N Y S Y=BISUBT S:Y="" Y=0
 .N Z S Z=$G(BITMP("STATS","TOTAL","ALL")) S:'Z Y=0,Z=1
 .S BIX=$$PAD^BIUTL5(BIX,69)_"|    "_$J((100*Y/Z),3,0)_"%"
 .D WRITE(.BILINE,BIX)
 .;---> If H1N1, write final line (since we won't write a "Fully Immunized" row).
 .D:BIVGRP=18 WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 ;
 ;---> Do not write for H1N1 (since we won't write a "Fully Immunized" row).
 D:BIVGRP'=18 WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 Q
 ;
 ;
 ;----------
APPROP(BILINE) ;EP
 ;---> Write Appropriate for Age lines.
 ;---> Parameters:
 ;     1 - BILINE (req) Line number in ^TMP Listman array.
 ;
 ;---> Numbers of appropriate line.
 ;N BITOT,X S BITOT=0,X=" Appropriate |"
 N BITOT,X S BITOT=0,X="    Fully    |"
 F BIAGRP=1:1:7 D
 .N Y S Y=$G(BITMP("STATS","APPRO",BIAGRP)) S:Y="" Y=0
 .;---> Yes, now include Age Group 5 (18-49 High Risk) in Totals.
 .;S X=X_$J(Y,6)_"  " S:(BIAGRP'=5) BITOT=BITOT+Y
 .S X=X_$J(Y,6)_"  " S BITOT=BITOT+Y
 ;
 S X=$E(X,1,$L(X)-2) S X=$$PAD^BIUTL5(X,69)_"|"_$J(BITOT,7)
 D WRITE(.BILINE,X)
 D MARK^BIW(BILINE,3,"BIREPF1")
 ;
 ;---> Percentage of appropriate line.
 ;S X="   for Age   |",BITOT=0
 S X="  Immunized  |",BITOT=0
 F BIAGRP=1:1:7 D
 .N Y S Y=$G(BITMP("STATS","APPRO",BIAGRP)) S:Y="" Y=0
 .N Z S Z=$G(BITMP("STATS","TOTAL",BIAGRP)) S:'Z Y=0,Z=1
 .N BIPERC S BIPERC="   "_$J((100*Y/Z),3,0)_"%"
 .S X=X_BIPERC_" " S:(BIAGRP'=5) BITOT=BITOT+Y
 ;
 N Y S Y=BITOT S:Y="" Y=0
 N Z S Z=$G(BITMP("STATS","TOTAL","ALL")) S:'Z Y=0,Z=1
 ;S X=$E(X,1,$L(X)-2)_"|    "_$J((100*Y/Z),3,0)_"%"
 S X=$E(X,1,$L(X)-1) S X=$$PAD^BIUTL5(X,69)_"|    "_$J((100*Y/Z),3,0)_"%"
 D WRITE(.BILINE,X)
 D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIREPF1",$G(BIVAL),$G(BIBLNK))
 Q
