BIREPP3 ;IHS/CMI/MWR - REPORT, PCV; AUG 10,2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT REPORT.
 ;
 ;
 ;----------
GETIMMS(BIBEGDT,BIENDDT,BICC,BIUP) ;EP
 ;---> Get Immunizations from V Files.
 ;---> Parameters:
 ;     1 - BIBEGDT (req) Begin Visit Date.
 ;     2 - BIENDDT (req) End Visit Date.
 ;     3 - BICC    (req) Current Community array.
 ;     4 - BIUP    (req) User Population/Group (r,i,u,a).
 ;
 ;---> Set begin and end dates for search through PATIENT File.
 ;
 Q:'$G(BIBEGDT)  Q:'$G(BIENDDT)
 ;---> Begin at earliest possible DOB (kids born the day after
 ;---> 5 years prior to the End Date).
 N N S N=($E(BIENDDT,1,3)-5)_$E(BIENDDT,4,7)
 F  S N=$O(^DPT("ADOB",N)) Q:(N>BIENDDT!('N))  D
 .S BIDFN=0
 .F  S BIDFN=$O(^DPT("ADOB",N,BIDFN)) Q:'BIDFN  D
 ..D CHKSET(BIDFN,.BICC,BIUP,BIBEGDT,BIENDDT)
 Q
 ;
 ;
 ;----------
CHKSET(BIDFN,BICC,BIUP,BIBEGDT,BIENDDT) ;EP
 ;---> Check if this patient fits criteria; if so, set DFN
 ;---> in ^TMP("BIREPQ1".
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BICC    (req) Current Community array.
 ;     3 - BIUP    (req) User Population/Group (r,i,u,a).
 ;     4 - BIBEGDT (req) Begin Visit Date.
 ;     5 - BIENDDT (req) End Visit Date.
 ;
 Q:'$G(BIDFN)
 Q:'$D(BICC)
 Q:'$D(BIUP)
 Q:'$G(BIBEGDT)
 Q:'$G(BIENDDT)
 ;
 ;---> Quit if patient not less than 60 months (5 yrs) old on the End Date.
 S BIAGE=$$AGE^BIUTL1(BIDFN,2,BIENDDT)
 Q:(BIAGE'?1N.N)  Q:(BIAGE>59)
 ;
 N BIHCF S BIHCF($G(DUZ(2)))=""
 ;---> Filter for standard Patient Population parameter.
 Q:'$$PPFILTR^BIREP(BIDFN,.BIHCF,BIENDDT,BIUP)
 ;
 ;---> Quit if Current Community doesn't match.
 Q:$$CURCOM^BIEXPRT2(BIDFN,.BICC)
 ;
 ;---> *** Okay, this patient is in the denominator.  *****************
 ;
 ;---> Get Age Groups string (12345) for this patient.
 N BIAGRPS S BIAGRPS=$$AGEGRP(BIAGE)
 ;
 ;---> Get Lastname,Firstname.
 N BIPNAME S BIPNAME=$$NAME^BIUTL1(BIDFN)
 ;
 ;---> Store in denominator total.
 N BIAGRP,I F I=1:1 S BIAGRP=$E(BIAGRPS,I) Q:'BIAGRP  D
 .S ^TMP("BIREPP1",$J,"TOTALPATS",BIAGRP)=$G(^TMP("BIREPP1",$J,"TOTALPATS",BIAGRP))+1
 ;
 ;---> Store patient for export (even if no PCV's).
 S ^TMP("BIREPP1",$J,"BIDFN",BIDFN,"EXPORT")=""
 ;
 ;---> Store patient for viewing Denominator.
 S ^TMP("BIDUL",$J,1,BIAGE,BIPNAME,BIDFN)=""
 ;
 ;---> RPC to gather Immunization History.
 N BI31,BIDE,BIRETVAL,BIRETERR,I S BI31=$C(31)_$C(31),BIRETVAL=""
 ;---> 25=CVX, 55=Vaccine Group IEN, 56=Date of Visit (Fileman), 65=Dose Override.
 F I=25,55,56,65 S BIDE(I)=""
 ;---> Fourth parameter=0: Do not return Skin Tests.
 ;---> Fifth parameter=0: Split out combinations as if given individually.
 D IMMHX^BIRPC(.BIRETVAL,BIDFN,.BIDE,0,0)
 ;
 ;---> If BIRETERR has a value, store it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 Q:BIRETERR]""
 Q:BIRETVAL["NO RECORDS"
 ;
 ;---> Set BIHX=to a valid Immunization History.
 N BIHX S BIHX=$P(BIRETVAL,BI31,1)
 ;
 ;---> Add this Patient's History to stats.
 N I,Y
 ;---> Loop through "^"-pieces of Imm History, getting data.
 F I=1:1 S Y=$P(BIHX,U,I) Q:Y=""  D
 .;
 .;---> Quit (don't count) if Visit was AFTER Quarter Ending Date.
 .N BIDATE S BIDATE=$P(Y,"|",4)
 .Q:(BIDATE>BIENDDT)
 .;
 .;---> Quit (don't count) if Vaccine Group is not Pneumo (IEN in ^BISERT=11).
 .Q:($P(Y,"|",3)'=11)
 .;
 .;---> Set CVX Code and Invalid Code (Dose Override).
 .N BICVX S BICVX=$P(Y,"|",2)
 .N BINVLD S BINVLD=$P(Y,"|",5) D
 ..I (BINVLD>0)&(BINVLD<9) S BINVLD=$$DOVER^BIUTL8(BINVLD,1) Q
 ..S BINVLD=""
 .;
 .;---> EXPORT, store data lines.
 .;---> Use "," for CSV delimiter in Export.
 .N Q,D S Q="""",D=Q_","_Q
 .N X S X=BICVX_D_$$SLDT1^BIUTL5($P(Y,"|",4))_D_BINVLD_D
 .;--->Add or update patient node for export.
 .N Y S Y=$G(^TMP("BIREPP1",$J,"BIDFN",BIDFN,"EXPORT"))
 .S ^TMP("BIREPP1",$J,"BIDFN",BIDFN,"EXPORT")=Y_X
 .;
 .;---> REPORT, store patient tallies.
 .;---> For each Age Group to which this patient belongs, update doses of PCV13 received.
 .Q:BICVX'=133
 .;
 .S Y=$G(^TMP("BIREPP1",$J,"BIDFN",BIDFN,BIAGRPS,"DOSES"))
 .S ^TMP("BIREPP1",$J,"BIDFN",BIDFN,BIAGRPS,"DOSES")=Y+1
 .;
 .;---> Do not include this dose in the Total PCV13 Doses Administered if it is not in
 .;---> the requested DATE RANGE.
 .Q:(BIDATE<BIBEGDT)  Q:(BIDATE>(BIENDDT+.9999))
 .;
 .;---> Update Total PCV13 Doses Administered.
 .N BIAGRP,I F I=1:1 S BIAGRP=$E(BIAGRPS,I) Q:'BIAGRP  D
 ..S ^TMP("BIREPP1",$J,"TOTALPCV13",BIAGRP)=$G(^TMP("BIREPP1",$J,"TOTALPCV13",BIAGRP))+1
 ;
 Q
 ;
 ;
TALLY ;EP
 ;---> Tally up the numbers of children in each age group who have received
 ;---> 1, 3, or 4 doses.
 ;
 N BIDFN S BIDFN=0
 F  S BIDFN=$O(^TMP("BIREPP1",$J,"BIDFN",BIDFN)) Q:'BIDFN  D
 .N BIAGRPS S BIAGRPS=0 S BIAGRPS=$O(^TMP("BIREPP1",$J,"BIDFN",BIDFN,BIAGRPS))
 .Q:'BIAGRPS
 .N BIDOSES S BIDOSES=$G(^TMP("BIREPP1",$J,"BIDFN",BIDFN,BIAGRPS,"DOSES"))
 .Q:'BIDOSES
 .N BIAGRP,I F I=1:1 S BIAGRP=$E(BIAGRPS,I) Q:'BIAGRP  D
 ..N Z S Z=$G(^TMP("BIREPP1",$J,"TALLY",1,BIAGRP))
 ..S ^TMP("BIREPP1",$J,"TALLY",1,BIAGRP)=Z+1
 ..Q:(BIDOSES=1)
 ..N Z S Z=$G(^TMP("BIREPP1",$J,"TALLY",3,BIAGRP))
 ..S ^TMP("BIREPP1",$J,"TALLY",3,BIAGRP)=Z+1
 ..Q:(BIDOSES=3)
 ..N Z S Z=$G(^TMP("BIREPP1",$J,"TALLY",4,BIAGRP))
 ..S ^TMP("BIREPP1",$J,"TALLY",4,BIAGRP)=Z+1
 ;
 Q
 ;
 ;
 ;----------
AGEGRP(BIAGE) ;EP
 ;---> Return Patient's Age GroupS.
 ;---> Parameters:
 ;     1 - BIAGE  (req) Patient's age in months.
 ;
 ;---> NOTE: All patients at this point fall into Age Group 1 (0-59 months).
 N X S X=1
 I BIAGE>1,BIAGE<24 S X=X_2
 I BIAGE>23,BIAGE<60 S X=X_3
 I BIAGE>5,BIAGE<12 S X=X_4
 I BIAGE>11,BIAGE<24 S X=X_5
 Q X
