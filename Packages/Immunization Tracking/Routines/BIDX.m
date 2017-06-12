BIDX ;IHS/CMI/MWR - RISK FOR FLU & PNEUMO, CHECK FOR DIAGNOSES.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**13**;AUG 01,2016
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CHECK FOR DIAGNOSES IN A TAXONOMY RANGE, WITHIN A GIVE DATE RANGE.
 ;;  FROM LORI BUTCHER, 9-18-05
 ;;  PATCH 5: New code to check for Smoking Health Factors.   HFSMKR+23
 ;;  PATCH 9: Changes to include Hep B Risk.  RISK+9, RISK+41
 ;;  PATCH 13: Changes to check for Flu High Risk.   RISK+25, HASDX+38
 ;
 ;
 ;----------
RISK(BIDFN,BIFDT,BIRSK,BIRISKI,BIRISKP,BIRISKH) ;EP Return High Risk Influenza & Pneumo.
 ;---> Determine if this patient is in the Pneumo Risk Taxonomy.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFDT   (opt) Forecast Date (date used for forecast).
 ;     3 - BIRSK   (opt) Risk Parameter: 0=none, 1=Hep B only, 2=Pneumo only,
 ;                       12=Hep B & Pneumo, 23=Pneumo only + Smoking, 123=all.
 ;                       4=Flu only.
 ;     4 - BIRISKI (ret) 1=Patient has Risk of Influenza; otherwise 0.
 ;     5 - BIRISKP (ret) 1=Patient has Risk of Pneumo; otherwise 0.
 ;     6 - BIRISKH (ret) 1=Patient has Risk of HEP B; otherwise 0.
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Seed new BIRISKH variable for Hep B risk.
 S BIRISKI=0,BIRISKP=0,BIRISKH=0
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 S BIRSK=+$G(BIRSK)
 ;
 Q:'$G(BIDFN)
 S:'$G(BIFDT) BIFDT=$G(DT)
 ;---> Patient age in years.
 N BIAGEY S BIAGEY=$$AGE^BIUTL1(BIDFN,1,BIFDT)
 ;
 ;
 ;********** PATCH 13, v8.5, AUG 01,2016, IHS/CMI/MWR
 ;---> Code to look for High Risk Flu
 I BIRSK=4 D  Q
 .Q:(BIAGEY<18)  Q:(BIAGEY>50)
 .S Y=+$$HASDX(BIDFN,"BI HIGH RISK FLU",2,BIBEGDT,BIFDT)
 .S:(Y>0) BIRISKI=1
 ;**********
 ;
 ;---> No High Risk computation under 19 years.
 Q:(BIAGEY<19)
 N Y
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Comment out Flu code since all ages are forecast for Flu.
 ;---> Check Influenza Risk (2 Flu Dx's over 3-year range).
 ;---> Flu now forecast for all.
 ;D:('BIRSK!(BIRSK=1))
 ;.Q:(BIAGEY>50)
 ;.S Y=+$$HASDX(BIDFN,"BI HIGH RISK FLU",2,BIBEGDT,BIFDT)
 ;.S:(Y>0) BIRISKI=1
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Check Hep B Risk (2 Diabetes Dx's from DOB to Forecast Date).
 D:(BIRSK[1)
 .Q:(BIAGEY>59)
 .S Y=+$$V2DM(BIDFN,,BIFDT)
 .S:Y BIRISKH=1
 ;**********
 ;
 N BIBEGDT S BIBEGDT=$$FMADD^XLFDT(BIFDT,-(3*365))
 ;
 ;---> Check Pneumo Risk (2 Pneumo Dx's over 3-year range).
 D:(BIRSK[2)
 .Q:(BIAGEY>64)
 .S Y=+$$HASDX(BIDFN,"BI HIGH RISK PNEUMO",2,BIBEGDT,BIFDT)
 .I Y S BIRISKP=1 Q
 .;
 .;---> Quit if site parameter says don't include Smoking.
 .Q:(BIRSK'[3)
 .S Y=+$$HASDX(BIDFN,"BI HIGH RISK PNEUMO W/SMOKING",2,BIBEGDT,BIFDT)
 .I Y S BIRISKP=1 Q
 .;
 .;---> Check for Smoking Health Factor in the last 2 years.
 .S BIRISKP=$$HFSMKR(BIDFN,BIFDT)
 ;
 Q
 ;
 ;
 ;----------
HASDX(BIDFN,BITAX,BINUM,BIBD,BIED) ;EP
 ;---> This call is made to determine if a patient (BIDFN) has had
 ;---> BINUM number of diagnoses within taxonomy BITAX during the
 ;---> time period BIBD to BIED.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient DFN.
 ;     2 - BITAX  (req) Name of the Taxonomy e.g. "BI HIGH RISK FLU"
 ;     3 - BINUM  (req) The number of diagnoses the patient has to have had.
 ;     4 - BIBD   (opt) Beginning date (earliest) date to search for diagnoses.
 ;                      If null, use patient's DOB.
 ;     5 - BIED   (opt) Date (latest) date to search for diagnoses.
 ;                      If null, use DT.
 ;
 ;  Return values:  1 if patient has had the diagnoses
 ;                  0 if patient has NOT had the diagnoses
 ;                 -1^error message   if error occurred
 ;
 ;  Example:  to find if patient has had at least 2 diagnoses in past 3 years
 ;           S X=$$HASDX^BIDX(40503,"BI HIGH RISK FLU",2,$$FMADD^XLFDT(DT,-(3*365)),DT)
 ;           I X=1 Then yes they had the diagnoses, I X=0 then no they didn't
 ;           to find if patient has ever had a diagnoses in the SURVEILLANCE DIABETES
 ;           taxonomy:  S X=$$HASDX^BIDX(dfn,"SURVEILLANCE DIABETES",1)
 ;
 ;
 I '$G(BIDFN) Q "-1^Patient DFN invalid"
 ;
 I $G(BIBD)="" S BIBD=$$DOB^AUPNPAT(BIDFN)
 I $G(BIED)="" S BIED=DT
 NEW BITAXI,BIIBD,BIIED,BISD,X,Y,I,P,R,C,BIREF
 S BITAXI=$O(^ATXAX("B",BITAX,0))
 I 'BITAXI Q "-1^Invalid Taxonomy name"
 S R=0  ;return value
 S BIIBD=9999999-BIBD  ;inverse of beginning date
 S BIIED=9999999-BIED  ;inverse of ending date
 S BISD=BIIED-1  ;start one day later for $O
 ;ihs/cmi/lab - added lines below for ICD10
 ;
 ;********** PATCH 13, v8.5, AUG 01,2016, IHS/CMI/MWR
 ;---> Code to prevent error out if atx_0510.11k missing.
 ;I $D(^ICDS(0)) D
 I $D(^ICDS(0)),$T(^ATXAPI)]"" D
 .;**********
 .K ^TMP($J,"BITAX")
 .S BIREF=$NA(^TMP($J,"BITAX"))
 .D BLDTAX^ATXAPI(BITAX,BIREF,BITAXI)
 S C=0  ;counter for diagnoses
 S X=0 F  S X=$O(^AUPNVPOV("AA",BIDFN,X)) Q:X=""!(X>BIIBD)!(C=BINUM)  D
 .S Y=0 F  S Y=$O(^AUPNVPOV("AA",BIDFN,X,Y)) Q:Y'=+Y!(C=BINUM)  D
 ..Q:'$D(^AUPNVPOV(Y,0))  ;bad xref
 ..S P=$P($G(^AUPNVPOV(Y,0)),"^")
 ..Q:P=""  ;bad entry
 ..;added lines below for ICD10
 ..I $D(^TMP($J,"BITAX")) Q:'$D(^TMP($J,"BITAX",P))
 ..I '$D(^TMP($J,"BITAX")) Q:'$$ICD^ATXCHK(P,BITAXI,9)  ;this diagnosis not in taxonomy
 ..S C=C+1  ;update counter as diagnosis found
 ..Q
 .Q
 K ^TMP($J,"BITAX")
 I C<BINUM Q 0  ;patient did not meet the required # of diagnoses
 Q 1
 ;
 ;
 ;----------
HFSMKR(BIDFN,BIFDT) ;EP
 ;---> Return 1 if Patient has Last Health Factor in the TOBACCO category
 ;---> with a date of <2 years.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient's IEN (DFN).
 ;     2 - BIFDT   (req) Forecast Date (date used for forecast).
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> New code to check for Smoking Health Factors.
 ;
 ;---> Return 0 if routine APCLAPIU is not in the namespace.
 ;---> APCLAPIU is from ;;2.0;IHS PCC SUITE;**2,6**;MAY 14, 2009.
 Q:('$L($T(^APCLAPIU))) 0
 Q:'$G(BIDFN) 0
 S:'$G(BIFDT) BIFDT=$G(DT)
 ;
 N Y S Y=$$LASTHF^APCLAPIU(BIDFN,"TOBACCO (SMOKING)",$$FMADD^XLFDT(BIFDT,-730),BIFDT)
 ;---> If there's a hit it looks like this:
 ;--->     3110815^HF: CURRENT SMOKER, SOME DAY^^2580^9000010.23^2, otherwise null.
 ;---> So, if there's a leading date, then patient has an HF "TOBACCO (SMOKING)" Category.
 ;---> Looking for these Health Factors:
 ;
 Q:(Y["CURRENT SMOKER, STATUS UNKNOWN") 1
 Q:(Y["CURRENT SMOKER, EVERY DAY") 1
 Q:(Y["CURRENT SMOKER, SOME DAY") 1
 Q:(Y["CESSATION-SMOKER") 1
 Q:(Y["HEAVY TOBACCO SMOKER") 1
 Q:(Y["LIGHT TOBACCO SMOKER") 1
 ;
 ;---> Patient does NOT have a SMOKER Health Factor 2 years prior to the Forecast Date.
 Q 0
 ;**********
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> New code from Lori Butcher to check for Diabetes (rtn: CIMZDMCK).
V2DM(P,BDATE,EDATE) ;EP - are there 2 visits with DM?
 ;P is Patient DFN
 ;BDATE  - beginning date to look default is DOB
 ;EDATE - end date to look default is DT
 I '$G(P) Q ""
 I '$D(^AUPNVSIT("AC",P)) Q ""  ;patient has no visits
 I '$G(BDATE) S BDATE=$$DOB^AUPNPAT(P)
 I '$G(EDATE) S EDATE=DT
 NEW T,BIREF,PDA,PIEN,CDX,VST,VDT,IBDATE,IEDATE,V,G  ;IHS/CMI/LAB/maw - modified and added lines to speed up the process
 ;K ^TMP($J,"A")
 ;S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 ;I '$D(^TMP($J,"A",1)) Q ""  ;no visits returned
 S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 ;IHS/CMI/LAB - added lines below for icd10
 ;MWRZZZ  COMMENT OUT NEXT LINE, ADD ONE AFTER.
 ;I $D(^ICDS(0)) D
 I $D(^ICDS(0)),$T(^ATXAPI)]""
 .K ^TMP($J,"BITAX")  ;IHS/CMI/LAB - clean out old nodes just in case
 .S BIREF=$NA(^TMP($J,"BITAX"))  ;IHS/CMI/LAB
 .D BLDTAX^ATXAPI("SURVEILLANCE DIABETES",BIREF,T)
 ;S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G>1)  S V=$P(^TMP($J,"A",X),U,5) D
 ;.Q:'$D(^AUPNVSIT(V,0))
 ;.Q:'$P(^AUPNVSIT(V,0),U,9)  ;0 DEPENDENT ENTRIES
 ;.Q:$P(^AUPNVSIT(V,0),U,11)  ;DELETED VISIT
 ;.Q:"SAHOR"'[$P(^AUPNVSIT(V,0),U,7)  ;ELIMINATE TELEPHONE CALLS, CHART REVIEWS, ETC
 ;.S (D,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(D)  I $D(^AUPNVPOV(Y,0)) D
 ;..S %=$P(^AUPNVPOV(Y,0),U)
 ;S (PDA,G)=0 F  S PDA=$O(^AUPNVPOV("AC",P,PDA)) Q:'PDA!(G>1)  D
 ;. S CDX=$P($G(^AUPNVPOV(PDA,0)),U)
 S IBDATE=9999999-BDATE
 S IEDATE=9999999-EDATE
 S G=0
 K V
 S PDA=IEDATE-1 F  S PDA=$O(^AUPNVPOV("AA",P,PDA)) Q:'PDA!(PDA>IBDATE)!(G>1)  D
 . S PIEN=0 F  S PIEN=$O(^AUPNVPOV("AA",P,PDA,PIEN)) Q:'PIEN  D
 .. S CDX=$P($G(^AUPNVPOV(PIEN,0)),U)
 .. Q:'CDX
 .. I $D(^TMP($J,"BITAX")) Q:'$D(^TMP($J,"BITAX",CDX))
 .. I '$D(^TMP($J,"BITAX")) Q:'$$ICD^ATXCHK(CDX,T,9)
 .. S VST=$P($G(^AUPNVPOV(PIEN,0)),U,3)
 .. Q:'VST  ;HAPPENS
 .. Q:'$D(^AUPNVSIT(VST,0))
 .. Q:"SAHOR"'[$P(^AUPNVSIT(VST,0),U,7)  ;ELIMINATE TELEPHONE CALLS, CHART REVIEWS, ETC
 .. I '$D(V(VST)) S V(VST)="",G=G+1
 K ^TMP($J,"BITAX")
 ;Q 1  ;for testing a positive hit on Diabetes.
 Q $S(G<2:"",1:1)
 ;**********
 ;
 ;----------
TEST ;
 ;D ^%T
 ;S P=0 F  S P=$O(^AUPNPAT(P)) Q:P'=+P  S X=$$HASDX(P,"BI HIGH RISK PNEUMO",2,3020101,DT) W ".",X
 ;S P=0 F  S P=$O(^AUPNPAT(P)) Q:P'=+P  S X=$$V2DM(P,,) I X S ^LORIHAS(P)="" W ".",P
 ;D ^%T
 ;Q
