BIREPQ4 ;IHS/CMI/MWR - REPORT, QUARTERLY IMM; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  QUARTERLY IMM REPORT, GATHER/STORE PATIENTS.
 ;
 ;
 ;----------
GETPATS(BIBEGDT,BIENDDT,BIAGRP,BICC,BIHCF,BICM,BIBEN,BIQDT,BIHPV,BIUP) ;EP
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
 ;     9 - BIHPV   (req) 1=Include Varicella & Pneumo.
 ;    10 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 ;---> Set begin and end dates for search through PATIENT File.
 ;
 Q:'$G(BIBEGDT)  Q:'$G(BIENDDT)  Q:'$G(BIAGRP)
 ;---> Start 1 day prior to Begin Date and $O into the desired DOB's.
 N N S N=BIBEGDT-1
 F  S N=$O(^DPT("ADOB",N)) Q:(N>BIENDDT!('N))  D
 .S BIDFN=0
 .F  S BIDFN=$O(^DPT("ADOB",N,BIDFN)) Q:'BIDFN  D
 ..D CHKSET(BIDFN,.BICC,.BIHCF,.BICM,.BIBEN,BIAGRP,BIQDT,BIHPV,BIUP)
 Q
 ;
 ;
 ;----------
CHKSET(BIDFN,BICC,BIHCF,BICM,BIBEN,BIAGRP,BIQDT,BIHPV,BIUP) ;EP
 ;---> Check if this patient fits criteria; if so, set DFN
 ;---> in ^TMP("BIREPQ1".
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIAGRP (req) Node/number for this Age Group.
 ;     7 - BIQDT  (req) Quarter Ending Date.
 ;     8 - BIHPV  (req) 1=Include Varicella & Pneumo.
 ;     9 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 Q:'$G(BIDFN)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 Q:'$G(BIAGRP)
 Q:'$G(BIQDT)
 Q:'$D(BIHPV)
 Q:$G(BIUP)=""
 ;
 ;---> Filter for standard Patient Population parameter.
 Q:'$$PPFILTR^BIREP(BIDFN,.BIHCF,BIQDT,BIUP)
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
 S ^TMP("BIREPQ1",$J,"PATS",BIAGRP,BIDFN)=""
 ;
 ;---> RPC to gather Immunization History.
 N BI31,BIDE,BIRETVAL,BIRETERR,I S BI31=$C(31)_$C(31),BIRETVAL=""
 ;---> 30=Vaccine IEN, 55=Vaccine Group IEN, 56=Date of Visit(Fileman),
 ;---> 65=Invalid Dose (1-4).
 F I=30,55,56,65 S BIDE(I)=""
 ;---> Fourth parameter=0: Do not return Skin Tests.
 ;---> Fifth parameter=0: Split out combinations as if given individually.
 D IMMHX^BIRPC(.BIRETVAL,BIDFN,.BIDE,0,0)
 ;
 ;---> If BIRETERR has a value, store it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 Q:BIRETERR]""
 ;
 ;---> Add refusals, if any.
 N Z D CONTRA^BIUTL11(BIDFN,.Z,1) I $O(Z(0)) S BITMP("REFUSALS",BIDFN)=""
 ;
 ;---> Set BIHX=to a valid Immunization History.
 N BIHX S BIHX=$P(BIRETVAL,BI31,1)
 ;
 ;---> Add this Patient's History to stats.
 N BIHIB,BIPCV,I,Y
 ;
 ;---> Loop through "^"-pieces of Imm History, getting data.
 F I=1:1 S Y=$P(BIHX,U,I) Q:Y=""  D
 .;
 .;---> BIIEN=Vaccine IEN, BIVGRP=Vaccine Group, BIVDAT=Visit Date, BINVLD=Invalid Code.
 .N BIDOSE,BIIEN,BINVLD,BIVDAT,BIVGRP,Q
 .S BIIEN=$P(Y,"|",2),BIVGRP=$P(Y,"|",3),BIVDAT=$P(Y,"|",4),BINVLD=$P(Y,"|",5)
 .;
 .;---> Quit (don't count) if Visit was AFTER Quarter Ending Date.
 .Q:(BIVDAT>BIQDT)  Q:'$G(BIVGRP)
 .;
 .;---> Quit if this dose has been overrided as Invalid (1-4).
 .Q:(1234[+BINVLD)
 .;
 .;---> Set this immunization in the STATS array by: Vaccine Group, Dose#, and Age Group.
 .;---> Set Dose# (increment by 1's to assign highest/latest dose#).
 .N Q S BIDOSE=1,Q=0
 .F  Q:Q  D
 ..I $D(BIHX(BIVGRP,BIDOSE)) S BIDOSE=BIDOSE+1 Q
 ..S BIHX(BIVGRP,BIDOSE)="",Q=1
 .;
 .N Z S Z=$G(BITMP("STATS",BIVGRP,BIDOSE,BIAGRP))
 .S BITMP("STATS",BIVGRP,BIDOSE,BIAGRP)=Z+1
 .;
 .;---> If this was a Hib or PCV, store it in local array for UTD eval:
 .;---> BIHIB(age_in_mths,IEN_of_vaccine)
 .I BIVGRP=3 S BIHIB($$AGE^BIUTL1(BIDFN,2,BIVDAT),BIIEN)=""
 .I BIVGRP=11 S BIPCV($$AGE^BIUTL1(BIDFN,2,BIVDAT),BIIEN)=""
 ;
 ;
 ;---> Now check whether the first 2 Hibs were Hibs=127; if so, BIH127=2.
 N BIH127,I,N S BIH127=0,N=""
 F I=1:1:2 S N=$O(BIHIB(N)) Q:'N  D
 .I $O(BIHIB(N,0))=127 S BIH127=BIH127+1
 ;
 ;
 ;---> Now calculate Hib Need (BIHNEED).
 N BIHNEED
 D
 .;---> If patient is 1st age group, need 1 Hib.
 .I BIAGRP=1 S BIHNEED=1 Q
 .;---> If patient is 2nd age group, need 2 Hibs.
 .I BIAGRP=2 S BIHNEED=2 Q
 .;
 .I BIAGRP=3 D  Q
 ..;---> If patient is 3rd age group:
 ..;---> If at least 2 Hibs recvd at 7 mths or greater, then need only 2 Hibs.
 ..I $$NEED(.BIHIB,7,2) S BIHNEED=2 Q
 ..;---> If patient rcvd 2 127's, then need only 2 Hibs.
 ..I BIH127=2 S BIHNEED=2 Q
 ..;---> Otherwise, 3rd group needs 3 Hibs.
 ..S BIHNEED=3
 .;
 .;
 .;---> BIAGRP must =4, 5, or 6.
 .;---> If at least 1 Hib recvd at 15 mths or greater, then need only 1 Hib.
 .I $$NEED(.BIHIB,15,1) S BIHNEED=1 Q
 .;
 .;---> If at least 2 Hibs recvd at 12 mths or greater, then need only 2 Hibs.
 .I $$NEED(.BIHIB,12,2) S BIHNEED=2 Q
 .;
 .;---> If at least 3 Hibs recvd at 7 mths or greater, then need only 3 Hibs.
 .I $$NEED(.BIHIB,7,3) S BIHNEED=3 Q
 .;
 .;---> If patient rcvd at least 2 127's, then need only 3 Hibs.
 .I BIH127=2 S BIHNEED=3 Q
 .;
 .;---> Otherwise, 4th-6th group needs 4 Hibs.
 .S BIHNEED=4
 ;
 ;
 ;---> Now calculate PCV Need (BIPNEED).
 N BIPNEED
 D
 .;---> If patient is 1st age group, need 1 PCV.
 .I BIAGRP=1 S BIPNEED=1 Q
 .;---> If patient is 2nd age group, need 2 PCVs.
 .I BIAGRP=2 S BIPNEED=2 Q
 .;
 .I BIAGRP=3 D  Q
 ..;---> If patient is 3rd age group:
 ..;---> If at least 2 PCVs recvd at 7 mths or greater, then need only 2 PCVs.
 ..I $$NEED(.BIPCV,7,2) S BIPNEED=2 Q
 ..;---> Otherwise, 3rd group needs 3 PCVs.
 ..S BIPNEED=3
 .;
 .;
 .;---> BIAGRP must =4, 5, or 6.
 .;---> If at least 1 PCV recvd at 15 mths or greater, then need only 1 PCV.
 .I $$NEED(.BIPCV,15,1) S BIPNEED=1 Q
 .;
 .;---> If at least 2 PCVs recvd at 12 mths or greater, then need only 2 PCVs.
 .I $$NEED(.BIPCV,12,2) S BIPNEED=2 Q
 .;
 .;---> If at least 3 PCVs recvd at 7 mths or greater, then need only 3 PCVs.
 .I $$NEED(.BIPCV,7,3) S BIPNEED=3 Q
 .;
 .;---> Otherwise, 4th-6th group needs 4 Hibs.
 .S BIPNEED=4
 ;
 ;
 ;---> Next Section:
 ;---> If this patient has the minimum required immunizations for
 ;---> his/her Age Group, then increment by 1 the "Appro for Age"
 ;---> tally for that Age Group.
 ;---> The code examines Imm Hx array BIHX(VacGrp,Dose#) for each patient.
 ;---> Each Quit represents a condition that a child in that age group
 ;---> must meet in order to be "appropriate for age."
 ;
 ;---> Following lines matrix: Vaccine Group, Dose#.
 ;---> Relies on the following Vaccine Group IEN's in ^BISERT:
 ;---> DTP=1, OPV=2, HIB=3, HEPB=4, MMR=6, VAR=7, HEPA=9, FLU=10, PCV=11, ROT=15
 ;
 N X S X=1
 I BIAGRP=1 D  D STOR(BIDFN,BIQDT,X) Q
 .Q:'$D(BIHX(1,1))
 .Q:'$D(BIHX(2,1))
 .Q:'$D(BIHX(3,BIHNEED))
 .Q:'$D(BIHX(4,1))
 .;Q:'$D(BIHX(15,1))  ;Rotavirus, "not at this time" says Ros Singleton, 4-24-07
 .Q:(($G(BIHPV))&('$D(BIHX(11,BIPNEED))))
 .D APPRO(BIAGRP) S X=2
 ;
 I BIAGRP=2 D  D STOR(BIDFN,BIQDT,X) Q
 .Q:'$D(BIHX(1,2))
 .Q:'$D(BIHX(2,2))
 .Q:'$D(BIHX(3,BIHNEED))
 .Q:'$D(BIHX(4,2))
 .;Q:'$D(BIHX(15,2))
 .Q:(($G(BIHPV))&('$D(BIHX(11,BIPNEED))))
 .D APPRO(BIAGRP) S X=2
 ;
 I BIAGRP=3 D  D STOR(BIDFN,BIQDT,X) Q
 .Q:'$D(BIHX(1,3))
 .Q:'$D(BIHX(2,2))
 .Q:'$D(BIHX(3,BIHNEED))
 .Q:'$D(BIHX(4,2))
 .;Q:'$D(BIHX(15,3))
 .Q:(($G(BIHPV))&('$D(BIHX(11,BIPNEED))))
 .D APPRO(BIAGRP) S X=2
 ;
 I BIAGRP=4 D  D STOR(BIDFN,BIQDT,X) Q
 .Q:'$D(BIHX(1,3))
 .Q:'$D(BIHX(2,2))
 .Q:'$D(BIHX(3,BIHNEED))
 .Q:'$D(BIHX(4,2))
 .Q:'$D(BIHX(6,1))
 .;Q:'$D(BIHX(15,3))
 .Q:(($G(BIHPV))&('$D(BIHX(11,BIPNEED))))
 .Q:(($G(BIHPV))&('$D(BIHX(7,1))))
 .D APPRO(BIAGRP) S X=2
 ;
 I BIAGRP=5 D  D STOR(BIDFN,BIQDT,X) Q
 .Q:'$D(BIHX(1,4))
 .Q:'$D(BIHX(2,3))
 .Q:'$D(BIHX(3,BIHNEED))
 .Q:'$D(BIHX(4,3))
 .Q:'$D(BIHX(6,1))
 .;Q:'$D(BIHX(15,3))
 .Q:(($G(BIHPV))&('$D(BIHX(11,BIPNEED))))
 .Q:(($G(BIHPV))&('$D(BIHX(7,1))))
 .D APPRO(BIAGRP) S X=2
 ;
 I BIAGRP=6 D  D STOR(BIDFN,BIQDT,X) Q
 .Q:'$D(BIHX(1,4))
 .Q:'$D(BIHX(2,3))
 .Q:'$D(BIHX(3,BIHNEED))
 .Q:'$D(BIHX(4,3))
 .Q:'$D(BIHX(6,1))
 .;Q:'$D(BIHX(15,3))
 .Q:(($G(BIHPV))&('$D(BIHX(11,BIPNEED))))
 .Q:(($G(BIHPV))&('$D(BIHX(7,1))))
 .;Q:(($G(BIHPV))&('$D(BIHX(9,1))))  ;Never include Hep A.
 .D APPRO(BIAGRP) S X=2
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
 D UPDATE^BIPATUP(BIDFN,DT,,1)
 D STORE^BIDUR1(BIDFN,BIQDT,1,,$G(BIVAL))
 Q
 ;
 ;
NEED(BIARR,BIAGE,BIREQ) ;EP
 ;---> Return 1 if BIARRay contains required number of doses (BIREQ) after BIAGE.
 ;---> Parameters:
 ;     1 - BIARR  (req) Array contains doses of vaccine in question.
 ;     2 - BIAGE  (req) Age in months after which doses need to have been received.
 ;     3 - BIREQ  (req) Required number of doses received after BIAGE.
 ;
 ;---> If at least 2 Hibs recvd at 12 mths or greater, then need only 2 Hibs.
 N M,N S M=0,N=""
 F  S N=$O(BIARR(N)) Q:N=""  S:(N'<BIAGE) M=M+1
 I M'<BIREQ Q 1
 Q 0
