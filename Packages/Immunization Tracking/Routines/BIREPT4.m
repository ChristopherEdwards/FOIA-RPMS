BIREPT4 ;IHS/CMI/MWR - REPORT, TWO-YR-OLD RATES; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW TWO-YR-OLD IMMUNIZATION RATES REPORT, WRITE HEADERS, ETC.
 ;;  PATCH 1: Exclude patients whose Inactive Date=Not in Register.  CHKSET+35
 ;
 ;
 ;----------
GETPATS(BIBEGDT,BIENDDT,BICC,BIHCF,BICM,BIBEN,BIQDT,BIAGRPS,BISITE,BIUP) ;EP
 ;---> Get patients from VA PATIENT File, ^DPT(.
 ;---> Parameters:
 ;     1 - BIBEGDT (req) Begin DOB for this group.
 ;     2 - BIENDDT (req) End DOB for this group.
 ;     3 - BICC    (req) Current Community array.
 ;     4 - BIHCF   (req) Health Care Facility array.
 ;     5 - BICM    (req) Case Manager array.
 ;     6 - BIBEN   (req) Beneficiary Type array.
 ;     7 - BIQDT   (req) Quarter Ending Date.
 ;     8 - BIAGRPS (req) String of Age Groups (e.g., 3,5,7,16,19,24,36)
 ;     9 - BISITE  (req) Site IEN.
 ;     9 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 ;---> Set begin and end dates for search through PATIENT File.
 ;
 Q:'$G(BIBEGDT)  Q:'$G(BIENDDT)  Q:'$G(BIQDT)  Q:'$G(BIAGRPS)
 S:$G(BIUP)="" BIUP="u"
 ;
 ;---> Start 1 day prior to Begin Date and $O into the desired DOB's.
 N BIDOB S BIDOB=BIBEGDT-1
 F  S BIDOB=$O(^DPT("ADOB",BIDOB)) Q:(BIDOB>BIENDDT!('BIDOB))  D
 .S BIDFN=0
 .F  S BIDFN=$O(^DPT("ADOB",BIDOB,BIDFN)) Q:'BIDFN  D
 ..D CHKSET(BIDFN,.BICC,.BIHCF,.BICM,.BIBEN,BIDOB,BIQDT,.BIVAL,BIAGRPS,BIUP)
 ..;---> Set ^TMP("BIDUL",$J,CURCOM,1,HRCN,BIDFN)=$G(BIVAL) for Patient Roster.
 ..D:$G(BIVAL) STORE^BIDUR1(BIDFN,DT,9,,BIVAL,BISITE)
 Q
 ;
 ;
 ;----------
CHKSET(BIDFN,BICC,BIHCF,BICM,BIBEN,BIDOB,BIQDT,BIVAL,BIAGRPS,BIUP) ;EP
 ;---> Check if this patient fits criteria; if so, set DFN
 ;---> in ^TMP("BIREPT1".
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIDOB  (req) Patient's Date of Birth.
 ;     7 - BIQDT  (req) Quarter Ending Date.
 ;     8 - BIVAL  (ret) 1=Not appropriate/complete, 2=43133 complete.
 ;     9 - BIAGRPS (req) String of Age Groups (e.g., 3,5,7,16,19,24,36)
 ;     9 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;
 Q:'$G(BIDFN)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 I '$G(BIDOB) S BIDOB=$$DOB^BIUTL1(BIDFN)
 Q:'$G(BIQDT)
 Q:'$G(BIAGRPS)
 S:$G(BIUP)="" BIUP="u"
 ;
 ;---> Don't include this patient in Roster unless set below.
 S BIVAL=0
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
 N Z S Z=$G(BITMP("STATS","TOTLPTS")) S BITMP("STATS","TOTLPTS")=Z+1
 ;---> Store for Patient Report Roster (not yet determined if complete 43133).
 S BIVAL=1
 ;
 ;---> RPC to gather Immunization History.
 N BI31,BIDE,BIRETVAL,BIRETERR,I S BI31=$C(31)_$C(31),BIRETVAL=""
 ;---> 30=Vaccine IEN, 55=Vaccine Group IEN, 56=Date of Visit(Fileman),
 ;---> 65=Invalid Dose (1-4).
 F I=30,55,56,65 S BIDE(I)=""
 ;---> Fourth parameter=0: Do not return Skin Tests.
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
 ;---> *** Okay, add this Patient's History to stats.
 ;
 ;---> BIHIB local array by date gets built; if the first two were CVX 49's (IEN=127)
 ;---> then patient will only need 3 Hibs to be UTD.
 N BIHIB,BIROT,I,Y
 ;
 ;---> BIROT gets set=1 if there were 2 CVX 119's (IEN=225)--patient is UTD for Rota.
 S BIROT=0
 ;
 ;---> Loop through "^"-pieces of Imm History, getting data.
 F I=1:1 S Y=$P(BIHX,U,I) Q:Y=""  D
 .;
 .;---> BIIEN=Vaccine IEN, BIVGRP=Vaccine Group, BIVDAT=Visit Date, BINVLD=Invalid Code.
 .N BIAGE,BIDOSE,BIIEN,BINVLD,BIVDAT,BIVGRP,Q
 .S BIIEN=$P(Y,"|",2),BIVGRP=$P(Y,"|",3),BIVDAT=$P(Y,"|",4),BINVLD=$P(Y,"|",5)
 .;
 .;---> Quit if not Vaccine Group or Visit Date.
 .Q:'$G(BIVGRP)  Q:'$G(BIVDAT)
 .;
 .;---> Quit if this dose has been overrided as Invalid (1-4).
 .Q:(1234[+BINVLD)
 .;
 .;---> Quit if this imm was given after the Quarter Ending Date.
 .;---> NOTE: This will cause some patients to appear in the "NOT Current"
 .;---> group, even if they got caught up to date later.
 .Q:(BIVDAT>BIQDT)
 .;
 .;---> Quit if this Vaccine Group should not be included.
 .Q:'($$VGROUP^BIUTL2(BIVGRP,8))
 .;
 .;---> Set BIDOSE=Dose# (increment by 1's to assign highest/latest dose#)
 .S BIDOSE=1,Q=0
 .F  Q:Q  D
 ..I $D(BIHX(BIVGRP,BIDOSE)) S BIDOSE=BIDOSE+1 Q
 ..S BIHX(BIVGRP,BIDOSE)="",Q=1
 .;
 .;
 .;---> If this was a Hib, store it in local array for UTD eval.
 .I BIVGRP=3 S BIHIB(BIVDAT,BIIEN)=""
 .;
 .;---> If this was a Rotarix, increment its counter.
 .S:BIIEN=225 BIROT=BIROT+1
 .;
 .;---> Set this immunization in the STATS array for each Age (A)
 .;---> by which the patient had already received it (cumulative).
 .;W !,BIAGRPS R ZZZ
 .N J,K S J=1
 .F K=1:1 S BIAGE=$P(BIAGRPS,",",K) Q:'BIAGE  D
 ..;---> If patient received imm by BIAGE months on the previous iteration
 ..;---> of this loop (and J was set=0), then bypass call to PASTMTH
 ..;---> and simply set it for the higher BIAGE values, cumulatively.
 ..;---> (i.e., if patient received it by 3 months, then he also
 ..;--->  necessarily received it by 5 months, 7 months, etc.)
 ..D:J PASTMTH^BIAGE(BIVDAT,BIAGE,.BIDATE)
 ..;
 ..;---> Quit if BIAGE months prior to Visit Date is AFTER the DOB
 ..;---> (means patient was OLDER than BIAGE months when he received
 ..;---> the imm--did NOT receive the imm by BIAGE months).
 ..Q:BIDATE>BIDOB
 ..;
 ..;---> Patient received imm by BIAGE months, set in stats array.
 ..N Z S Z=$G(BITMP("STATS",BIVGRP,BIDOSE,BIAGE)) S BITMP("STATS",BIVGRP,BIDOSE,BIAGE)=Z+1
 ..S J=0
 ..S BIHX(BIVGRP,BIDOSE,BIAGE)=""
 ;
 ;
 ;---> Now calculate whether this patient needs 3 Hibs or 4 Hibs to be UTD.
 ;---> If first 2 Hibs=127 (CVX 49), then BIHIB2=2 and patient only needs 3 Hibs to be UTD.
 N BIHIB2,I,N S BIHIB2=0,N=0
 F I=1:1:2 S N=$O(BIHIB(N)) Q:'N  D
 .I $O(BIHIB(N,0))=127 S BIHIB2=BIHIB2+1
 ;
 ;---> Now calculate vaccine combination stats.
 ;---> NOTE: DO NOT GENERALIZE CODE BELOW (highly iterative).
 ;---> Relies on the following Vaccine Group IEN's in ^BISERT:
 ;---> DTP=1, OPV=2, HIB=3, HEPB=4, MMR=6, VAR=7, HEPA=9, FLU=10, PNE=11, ROT=15
 ;
 ;---> 1-DTP, 1-OPV, 1-HIB, 1-HEPB
 N K
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .;---> Matrix=Vaccine Group, Dose#, Age Group.
 .Q:'$D(BIHX(1,1,A))
 .Q:'$D(BIHX(2,1,A))
 .Q:'$D(BIHX(3,1,A))
 .Q:'$D(BIHX(4,1,A))
 .D COMBO("1|1^2|1^3|1^4|1",A)
 ;
 ;---> 4-DTP, 3-OPV, 1-MMR
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(1,4,A))
 .Q:'$D(BIHX(2,3,A))
 .Q:'$D(BIHX(6,1,A))
 .D COMBO("1|4^2|3^6|1",A)
 ;
 ;---> 4-DTP, 3-OPV, 1-MMR, 3-HIB
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(1,4,A))
 .Q:'$D(BIHX(2,3,A))
 .Q:'$D(BIHX(6,1,A))
 .;---> If you don't have 2 Hib 49's, then quit if you don't have 4 Hibs.
 .I BIHIB2<2 Q:'$D(BIHX(3,4,A))
 .;---> Okay, first 2 Hibs are 49's, quit if you don't have 3 Hibs.
 .Q:'$D(BIHX(3,3,A))
 .D COMBO("1|4^2|3^6|1^3|3",A)
 ;
 ;---> 4-DTP, 3-OPV, 1-MMR, 3-HIB, 3-HEPB
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(1,4,A))
 .Q:'$D(BIHX(2,3,A))
 .Q:'$D(BIHX(6,1,A))
 .I BIHIB2<2 Q:'$D(BIHX(3,4,A))
 .Q:'$D(BIHX(3,3,A))
 .Q:'$D(BIHX(4,3,A))
 .D COMBO("1|4^2|3^6|1^3|3^4|3",A)
 .;---> Store for Patient Report Roster (complete 43133).
 .;---> v8.5: No longer 43133; now 4313314 below.
 .;S BIVAL=2
 ;
 ;---> 4-DTP, 3-OPV, 1-MMR, 3-HIB, 3-HEPB, 1-VAR
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(1,4,A))
 .Q:'$D(BIHX(2,3,A))
 .Q:'$D(BIHX(6,1,A))
 .I BIHIB2<2 Q:'$D(BIHX(3,4,A))
 .Q:'$D(BIHX(3,3,A))
 .Q:'$D(BIHX(4,3,A))
 .Q:'$D(BIHX(7,1,A))
 .D COMBO("1|4^2|3^6|1^3|3^4|3^7|1",A)
 ;
 ;
 ;---> 4-DTP, 3-OPV, 1-MMR, 3-HIB, 3-HEPB, 1-VAR, 3-PNE
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(1,4,A))
 .Q:'$D(BIHX(2,3,A))
 .Q:'$D(BIHX(6,1,A))
 .I BIHIB2<2 Q:'$D(BIHX(3,4,A))
 .Q:'$D(BIHX(3,3,A))
 .Q:'$D(BIHX(4,3,A))
 .Q:'$D(BIHX(7,1,A))
 .Q:'$D(BIHX(11,3,A))
 .D COMBO("1|4^2|3^6|1^3|3^4|3^7|1^11|3",A)
 ;
 ;
 ;I BIDFN=119 X ^O
 ;---> 4-DTP, 3-OPV, 1-MMR, 3-HIB, 3-HEPB, 1-VAR, 4-PNE  vvv83
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(1,4,A))
 .Q:'$D(BIHX(2,3,A))
 .Q:'$D(BIHX(6,1,A))
 .I BIHIB2<2 Q:'$D(BIHX(3,4,A))
 .Q:'$D(BIHX(3,3,A))
 .Q:'$D(BIHX(4,3,A))
 .Q:'$D(BIHX(7,1,A))
 .Q:'$D(BIHX(11,4,A))
 .D COMBO("1|4^2|3^6|1^3|3^4|3^7|1^11|4",A)
 .;---> Store for Patient Report Roster (complete 4313314).
 .S BIVAL=2
 ;
 ;---> 4-DTP, 3-OPV, 1-MMR, 3-HIB, 3-HEPB, 1-VAR, 4-PNE, 1-HEPA
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(1,4,A))
 .Q:'$D(BIHX(2,3,A))
 .Q:'$D(BIHX(6,1,A))
 .I BIHIB2<2 Q:'$D(BIHX(3,4,A))
 .Q:'$D(BIHX(3,3,A))
 .Q:'$D(BIHX(4,3,A))
 .Q:'$D(BIHX(7,1,A))
 .Q:'$D(BIHX(11,4,A))
 .Q:'$D(BIHX(9,1,A))
 .D COMBO("1|4^2|3^6|1^3|3^4|3^7|1^11|4^9|1",A)
 ;
 ;---> 4-DTP, 3-OPV, 1-MMR, 3-HIB, 3-HEPB, 1-VAR, 4-PNE, 2-HEPA, 3-ROTA  vvv83
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(1,4,A))
 .Q:'$D(BIHX(2,3,A))
 .Q:'$D(BIHX(6,1,A))
 .I BIHIB2<2 Q:'$D(BIHX(3,4,A))
 .Q:'$D(BIHX(3,3,A))
 .Q:'$D(BIHX(4,3,A))
 .Q:'$D(BIHX(7,1,A))
 .Q:'$D(BIHX(11,4,A))
 .Q:'$D(BIHX(9,2,A))
 .;Q:'$D(BIHX(15,3,A))
 .;---> If you don't have 2 Rota 119's, then quit if you don't have 3 Rotas.
 .I BIROT<2 Q:'$D(BIHX(15,3,A))
 .D COMBO("1|4^2|3^6|1^3|3^4|3^7|1^11|4^9|2^15|3",A)
 ;
 ;---> 4-DTP, 3-OPV, 1-MMR, 3-HIB, 3-HEPB, 1-VAR, 4-PNE, 2-HEPA, 3-ROTA, 2-FLU  vvv83
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(1,4,A))
 .Q:'$D(BIHX(2,3,A))
 .Q:'$D(BIHX(6,1,A))
 .I BIHIB2<2 Q:'$D(BIHX(3,4,A))
 .Q:'$D(BIHX(3,3,A))
 .Q:'$D(BIHX(4,3,A))
 .Q:'$D(BIHX(7,1,A))
 .Q:'$D(BIHX(11,4,A))
 .Q:'$D(BIHX(9,2,A))
 .;Q:'$D(BIHX(15,3,A))
 .I BIROT<2 Q:'$D(BIHX(15,3,A))
 .Q:'$D(BIHX(10,2,A))
 .D COMBO("1|4^2|3^6|1^3|3^4|3^7|1^11|4^9|2^15|3^10|2",A)
 ;
 ;---> Re-evaluate Current vs. Non-current based on Hib and Rota regimens.
 ;---> If BIVAL=1,
 Q:BIVAL=1
 ;
 Q
 ;
 ;
 ;----------
COMBO(BICOMB,BIAGRP) ;EP
 ;---> Store Patient vaccine combination for Age Group.
 ;---> Parameters:
 ;     1 - BICOMB (req) Combination number.
 ;     1 - BIAGRP (req) Node/number for this Age Group.
 ;
 ;---> Store Patient in Age Group.
 N Z S Z=$G(BITMP("STATS",BICOMB,BIAGRP))
 S BITMP("STATS",BICOMB,BIAGRP)=Z+1
 Q
