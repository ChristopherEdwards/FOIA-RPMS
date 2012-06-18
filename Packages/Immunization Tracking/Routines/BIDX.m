BIDX ;IHS/CMI/MWR - RISK FOR FLU & PNEUMO, CHECK FOR DIAGNOSES.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CHECK FOR DIAGNOSES IN A TAXONOMY RANGE, WITHIN A GIVE DATE RANGE.
 ;;  FROM LORI BUTCHER, 9-18-05
 ;
 ;
 ;----------
RISK(BIDFN,BIFDT,BIFOP,BIRISKI,BIRISKP) ;EP Return High Risk Influenza & Pneumo.
 ;---> Determine if this patient is in the Pneumo Risk Taxonomy.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFDT   (opt) Forecast Date (date used for forecast).
 ;     3 - BIFOP   (opt) 0=Retrieve both, 1=retrieve Flu only, 2=Pneumo only.
 ;     4 - BIRISKI (ret) 1=Patient has Risk of Influenza; otherwise 0.
 ;     5 - BIRISKP (ret) 1=Patient has Risk of Pneumo; otherwise 0.
 ;
 S BIRISKI=0,BIRISKP=0
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 S BIFOP=+$G(BIFOP)
 ;
 Q:'$G(BIDFN)
 S:'$G(BIFDT) BIFDT=$G(DT)
 ;---> Patient age in years.
 N BIAGEY S BIAGEY=$$AGE^BIUTL1(BIDFN,1,BIFDT)
 ;
 ;---> No High Risk computation under 19 years.
 Q:(BIAGEY<19)
 ;
 N BIBEGDT S BIBEGDT=$$FMADD^XLFDT(BIFDT,-(3*365))
 ;
 N Y
 ;---> Check Influenza Risk (2 Flu Dx's over 3-year range).
 D:('BIFOP!(BIFOP=1))
 .Q:(BIAGEY>50)
 .S Y=+$$HASDX(BIDFN,"BI HIGH RISK FLU",2,BIBEGDT,BIFDT)
 .S:(Y>0) BIRISKI=1
 ;
 ;---> Check Pneumo Risk (2 Pneumo Dx's over 3-year range).
 D:('BIFOP!(BIFOP=2))
 .Q:(BIAGEY>64)
 .S Y=+$$HASDX(BIDFN,"BI HIGH RISK PNEUMO",2,BIBEGDT,BIFDT)
 .I (Y>0) S BIRISKP=1 Q
 .;
 .;---> Quit if site parameter says don't include Smoking.
 .Q:($$RISKP^BIUTL2(BIDUZ2)'=3)
 .S Y=+$$HASDX(BIDFN,"BI HIGH RISK PNEUMO W/SMOKING",2,BIBEGDT,BIFDT)
 .I (Y>0) S BIRISKP=1 Q
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
 NEW BITAXI,BIIBD,BIIED,BISD,X,Y,I,P,R,C
 S BITAXI=$O(^ATXAX("B",BITAX,0))
 I 'BITAXI Q "-1^Invalid Taxonomy name"
 S R=0  ;return value
 S BIIBD=9999999-BIBD  ;inverse of beginning date
 S BIIED=9999999-BIED  ;inverse of ending date
 S BISD=BIIED-1  ;start one day later for $O
 S C=0  ;counter for diagnoses
 S X=0 F  S X=$O(^AUPNVPOV("AA",BIDFN,X)) Q:X=""!(X>BIIBD)!(C=BINUM)  D
 .S Y=0 F  S Y=$O(^AUPNVPOV("AA",BIDFN,X,Y)) Q:Y'=+Y!(C=BINUM)  D
 ..Q:'$D(^AUPNVPOV(Y,0))  ;bad xref
 ..S P=$P($G(^AUPNVPOV(Y,0)),"^")
 ..Q:P=""  ;bad entry
 ..Q:'$$ICD^ATXCHK(P,BITAXI,9)  ;this diagnosis not in taxonomy
 ..S C=C+1  ;update counter as diagnosis found
 ..Q
 .Q
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
 ;---> Return 0 if routine APCHSMU is not in the namespace.
 Q:('$L($T(^APCHSMU))) 0
 ;
 ;---> Return 0 if patient does not have these Health Factors.
 ;N Y S Y=$$LASTHF^APCHSMU(BIDFN,"TOBACCO","N")
 N Y S Y=$$LASTHF^APCHSMU(BIDFN,"TOBACCO (SMOKING)","N")
 Q:((Y'["CURRENT SMOKER")&(Y'["CURRENT SMOKELESS")&(Y'["TOBACCO READINESS TO QUIT")) 0
 ;
 S Y=$$LASTHF^APCHSMU(BIDFN,"TOBACCO","D")
 Q:'Y 0  Q:'$G(DT) 0
 ;
 ;---> Return 0 if Smoker Health Factor is more than 2 years old.
 Q:($$FMDIFF^XLFDT(BIFDT,Y)>730) 0
 ;
 ;---> Patient has SMOKER Health Factor in last 2 years.
 Q 1
 ;
 ;
 ;----------
TEST ;
 S X=$$HASDX(40503,"SURVEILLANCE DIABETES",1,3050914,3050914)
 W !,X
 Q
