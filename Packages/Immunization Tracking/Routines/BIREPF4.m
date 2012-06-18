BIREPF4 ;IHS/CMI/MWR - REPORT, FLU IMM; OCT 15, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  INFLUENZA IMM REPORT, GATHER/STORE PATIENTS.
 ;;  PATCH 1: Exclude patients whose Inactive Date=Not in Register.  CHKSET+31
 ;;  PATCH 2: Filter for Active Clinical, all ages, using $$ACTCLIN^BIUTL6 call.
 ;;           CHKSET+39
 ;
 ;
 ;----------
GETPATS(BIBEGDT,BIENDDT,BIAGRP,BICC,BIHCF,BICM,BIBEN,BIQDT,BIFH,BIYEAR,BIUP) ;EP
 ;---> Get patients from VA PATIENT File, ^DPT(.
 ;---> Parameters:
 ;     1 - BIBEGDT (req) Begin DOB for this group.
 ;     2 - BIENDDT (req) End DOB for this group.
 ;     3 - BIAGRP  (req) Node/number for this Age Group.
 ;     4 - BICC    (req) Current Community array.
 ;     5 - BIHCF   (req) Health Care Facility array.
 ;     6 - BICM    (req) Case Manager array.
 ;     7 - BIBEN   (req) Beneficiary Type array.
 ;     8 - BIQDT   (req) Quarter Ending Date.
 ;     9 - BIFH    (req) F=report on Flu Vaccine Group (default), H=H1N1 group.
 ;    10 - BIYEAR  (req) Report Year^m (if 2nd pc="m", then End Date=March 31 of
 ;                       the report year; otherwise End Date=Dec 31 of BIYEAR)
 ;    11 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 ;---> Set begin and end dates for search through PATIENT File.
 ;
 Q:'$G(BIBEGDT)  Q:'$G(BIENDDT)  Q:'$G(BIAGRP)  Q:'$G(BIYEAR)
 ;---> Start 1 day prior to Begin Date and $O into the desired DOB's.
 N N S N=BIBEGDT-1
 F  S N=$O(^DPT("ADOB",N)) Q:(N>BIENDDT!('N))  D
 .S BIDFN=0
 .F  S BIDFN=$O(^DPT("ADOB",N,BIDFN)) Q:'BIDFN  D
 ..D CHKSET(BIDFN,.BICC,.BIHCF,.BICM,.BIBEN,BIAGRP,BIQDT,BIFH,BIYEAR,BIUP)
 Q
 ;
 ;
 ;----------
CHKSET(BIDFN,BICC,BIHCF,BICM,BIBEN,BIAGRP,BIQDT,BIFH,BIYEAR,BIUP) ;EP
 ;---> Check if this patient fits criteria; if so, set DFN
 ;---> in ^TMP("BIREPF1".
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIAGRP (req) Node/number for this Age Group.
 ;     7 - BIQDT  (req) Quarter Ending Date.
 ;     8 - BIFH   (req) F=report on Flu Vaccine Group, H=H1N1 group.
 ;     9 - BIYEAR (req) Report Year^m (if 2nd pc="m", then End Date=March 31 of
 ;                       the report year; otherwise End Date=Dec 31 of BIYEAR)
 ;    10 - BIUP   (req) User Population/Group (Registered, Imm, User, Active).
 ;
 Q:'$G(BIDFN)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 Q:'$G(BIAGRP)
 Q:'$G(BIQDT)
 S:($G(BIFH)="") BIFH="F"
 Q:'$G(BIYEAR)
 Q:$G(BIUP)=""
 ;
 ;---> Quit if patient is not in the Register.
 Q:'$D(^BIP(BIDFN,0))
 ;
 ;---> Filter for standard Patient Population parameter.
 Q:'$$PPFILTR^BIREP(BIDFN,.BIHCF,BIQDT,BIUP)
 ;
 ;---> For first Age Group, 10-23m, filter by Active in Imm Register.
 ;---> Quit if patient became Inactive before the Quarter Ending Date.
 ;I BIAGRP=1 N X S X=$$INACT^BIUTL1(BIDFN) I X]"" Q:X<BIQDT
 ;
 ;---> For 18-49y Age Group, if this patient is High Risk for Flu set BIRISKI=1.
 N BIRISKI S BIRISKI=0
 ;---> Note: Third parameter=1 (retrieve Flu risk only).
 D:BIAGRP=4 RISK^BIDX(BIDFN,$E(BIQDT,1,3)_"0901",1,.BIRISKI)
 ;---> Uncomment next line to test High Risk.
 ;S:(BIDFN=30) BIRISKI=1  ;MWRZZZ
 ;---> If this patient is (18-49y) High Risk, change Age Group to 5.
 I BIRISKI S BIAGRP=5
 ;
 ;---> Quit if Current Community doesn't match.
 Q:$$CURCOM^BIEXPRT2(BIDFN,.BICC)
 ;
 ;---> Quit if Case Manager doesn't match.
 Q:$$CMGR^BIDUR(BIDFN,.BICM)
 ;
 ;---> Quit if Beneficiary Type doesn't match.
 Q:$$BENT^BIDUR1(BIDFN,.BIBEN)
 ;
 ;---> Store Patient in Age Group.
 S ^TMP("BIREPF1",$J,"PATS",BIAGRP,BIDFN)=""
 ;
 ;---> RPC to gather Immunization History.
 N BI31,BIDE,BIRETVAL,BIRETERR,I S BI31=$C(31)_$C(31),BIRETVAL=""
 ;---> 55=Vaccine Group IEN, 56=Date of Visit (Fileman), 65=Dose Override.
 F I=55,56,65 S BIDE(I)=""
 ;---> Fourth parameter=0: Do not return Skin Tests.
 ;---> Fifth parameter=0: Split out combinations as if given individually.
 D IMMHX^BIRPC(.BIRETVAL,BIDFN,.BIDE,0,0)
 ;
 ;---> If BIRETERR has a value, store it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 Q:BIRETERR]""
 ;
 ;---> Add refusals, if any.
 N Z D CONTRA^BIUTL11(BIDFN,.Z,1) I $O(Z(0)) D
 .;---> If this refusal is for an Influenza vaccine, count it.
 .N I F I=15,16,88,111,123,135 I $D(Z(I)) S BITMP("REFUSALS",BIDFN)=""
 ;
 ;---> Set BIHX=to a valid Immunization History.
 N BIHX S BIHX=$P(BIRETVAL,BI31,1)
 ;
 ;---> Add this Patient's History to stats.
 N I,Y
 ;---> Loop through "^"-pieces of Imm History, getting data.
 F I=1:1 S Y=$P(BIHX,U,I) Q:Y=""  D
 .;
 .;---> Set this immunization in the STATS array by:
 .;---> Vaccine Group (V), Dose# (D), and Age (A), and Current Season (C).
 .N A,C,D,Q,V
 .S A=BIAGRP,V=$P(Y,"|",2)
 .;
 .;---> Quit if this is not a Flu vaccine or H1N1.
 .I BIFH="H" Q:(V'=18)
 .;---> Default="F" (Flu).
 .I BIFH'="H" Q:(V'=10)
 .;I $G(BIFH)'="H" Q:(V'=18)
 .;
 .;---> Quit if this dose is marked INVALID.
 .I $P(Y,"|",4),$P(Y,"|",4)<9 Q
 .;
 .;---> Quit (don't count) if Visit was AFTER the Report Year End Date.
 .N BIDT S BIDT=$P(Y,"|",3)
 .;---> If the Report End Date is not March 31, then quit if visit is after
 .;---> the Quarter Ending Date (12/31 of the Report Year).
 .I $P(BIYEAR,U,2)'="m" Q:(BIDT>BIQDT)
 .;---> Quit if visit is after March Report End Date (following the Report Year).
 .Q:(BIDT>(($E(BIQDT,1,3)+1)_"0331"))
 .;
 .;---> If this was in the current season, C=1; otherwise C=0 (before this season).
 .D
 ..I BIDT<($E(BIQDT,1,3)_"0901") S C=0 Q
 ..S C=1
 .;
 .;---> Set Dose# (increment by 1's to assign highest/latest dose#).
 .S D=1,Q=0
 .F  Q:Q  D
 ..;---> Set: BIHX(Vaccine Grp, Current Season, Dose)
 ..I $D(BIHX(V,C,D)) S D=D+1 Q
 ..S BIHX(V,C,D)="",Q=1
 .;
 .;---> Set: BITMP(Vaccine Grp, Season, Dose, Age Grp)
 .N Z S Z=$G(BITMP("STATS",V,C,D,A)) S BITMP("STATS",V,C,D,A)=Z+1
 .;---> If Age Group 18-19y and pt is High Risk, set stat for Age Group 5.
 .;Q:((A'=4)!('BIRISKI))
 .;S Z=$G(BITMP("STATS",V,C,D,5)) S BITMP("STATS",V,C,D,5)=Z+1
 ;
 ;
 ;---> Next Section:
 ;---> If this patient has the minimum required immunizations for
 ;---> his/her Age Group, then increment by 1 the "Appro for Age"
 ;---> tally for that Age Group.
 ;---> The code examines Imm Hx array BIHX(VacGrp, Current Season, Dose#) for
 ;---> each patient.
 ;---> Each Quit represents a condition that a child in that age group
 ;---> must meet in order to be "appropriate for age."
 ;
 ;---> Following lines matrix: Vaccine Group, Dose#.
 ;
 ;---> X=1 is NOT Current/appropriate for age; X=2 IS Current/appropriate for age.
 N X
 ;---> For 6-23m old patients (BIAGRP=1).
 S X=1
 I BIAGRP=1 D  D STOR(BIDFN,BIQDT,X) Q
 .Q:'$D(BIHX(10))
 .;---> If patient has Flu, Current season, 2 doses; then he's appropriate.
 .I $D(BIHX(10,1,2)) D APPRO(BIAGRP) S X=2 Q
 .;---> If pt has Current season, 1 dose; Past season, 1 dose; then appropriate.
 .I $D(BIHX(10,1,1)),$D(BIHX(10,0,1)) D APPRO(BIAGRP) S X=2 Q
 ;
 ;---> For 2-4y old patients (BIAGRP=2).
 S X=1
 I BIAGRP=2 D  D STOR(BIDFN,BIQDT,X) Q
 .Q:'$D(BIHX(10))
 .;---> If patient has Flu, Current season, 2 doses; then he's appropriate.
 .I $D(BIHX(10,1,2)) D APPRO(BIAGRP) S X=2 Q
 .;---> If pt has Current season, 1 dose; Past season, 2 doses; then appropriate.
 .I $D(BIHX(10,1,1)),$D(BIHX(10,0,2)) D APPRO(BIAGRP) S X=2 Q
 ;
 S X=1
 ;---> For all other Age Groups.
 D  D STOR(BIDFN,BIQDT,X)
 .Q:'$D(BIHX(10))
 .;---> If patient has Flu, Current season 1 dose; then he's appropriate.
 .;---> Also, if this is 18-49 and the patient is High Risk set in Group 5.
 .I $D(BIHX(10,1,1)) D APPRO(BIAGRP) D:((BIAGRP=4)&BIRISKI) APPRO(5) S X=2 Q
 Q
 ;
 ;
 ;----------
APPRO(BIAGRP) ;EP
 ;---> Store Patient in Appropriate for Age Group.
 ;---> Parameters:
 ;     1 - BIAGRP (req) Node/number for this Age Group.
 ;
 ;---> Store Patient in Age Group.
 N Z S Z=$G(BITMP("STATS","APPRO",BIAGRP))
 S BITMP("STATS","APPRO",BIAGRP)=Z+1
 Q
 ;
 ;
 ;----------
STOR(BIDFN,BIQDT,BIVAL) ;EP
 ;---> Store in ^TMP for displaying List of Patients.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIQDT  (req) Quarter Ending Date.
 ;     3 - BIVAL  (opt) Value to set ^TMP(Pat...) node equal to.
 ;
 Q:'$G(BIDFN)  S:'$G(BIQDT) BIQDT=DT
 ;D UPDATE^BIPATUP(BIDFN,DT,,1)
 D STORE^BIDUR1(BIDFN,BIQDT,1,,$G(BIVAL))
 Q
