APCLV ; IHS/CMI/LAB - visit data ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/TUCSON/LAB - added G parameter to provider call
 ;
 ;
COMM(V,F) ;PEP ; given V as visit ien,  COMMUNITY - STATE,COUNTY,COMMUNITY codes of patient
 ;F="E":name of community, F="I":internal ien of community, F="C":stctycomm code
 G COMM^APCLV1
 ;
PCHART(P,L) ;PEP - returns chart at facility L
 ;FOR FORMAT SEE CHART
 G PCHART^APCLV1
CHART(V) ;PEP - returns ASUFAC_HRN ( 12 digits, HRN is left zero filled)
 ;V = visit ien, returns asufac_hrn for this visit
 ;if chart exists at Loc. of encounter it is returned
 ;if not, then chart at DUZ(2) is returned
 ;if none, then null returned
 G CHART^APCLV1
 ;
LOCENC(V,F) ;PEP - given visit ien V, return loc. of encounter in format F
 ;F="E":name of location , F="I":ien of location, F="C":asufac
 G LOCENC^APCLV1
 ;
VD(V,F) ;PEP - given visit ien in V, return date of visit in internal or external format
 ;F="I":internal fileman format, F="S":external slash date, F="E":external full (JAN 01, 1995)
 ;
 G VD^APCLV1
VDTM(V,F) ;PEP - given visit ien in V, return visit date and time in F format
 ;F="S":01/01/98 3:15pm, F="E":JAN 01, 1998 3:15PM, F="I":fileman internal format
 G VDTM^APCLV1
 ;
TIME(V,F) ;PEP - given visit ien in V, returns visit time of day i n format F
 ;F="E": form is 11:15   F="I" form is 1115 (fileman format), F="P" form in am/pm  11:15am
 G TIME^APCLV1
 ;
DOW(V,F) ;PEP - given V, visit ien and F, format returns DOW of visit
 ;in F="E":Monday, F="I":1
 G DOW^APCLV1
 ;
TYPE(V,F) ;PEP - given V, visit ien and F, format, returns type of visit
 ;F="I":internal set, F="E":external set
 G TYPE^APCLV1
 ;
SC(V,F) ;PEP - given V=visit ien and F=format, returns service category of visit
 ;F="I":internal set, F="E":external set
 G SC^APCLV1
CLINIC(V,F) ;PEP - given V is visit ien, F is format, returns clinic on visit
 ;F="E":clinic name, F="C":clinic code, F="I":internal ien of clinic
 G CLINIC^APCLV1
 ;
EM(V,F) ;PEP - given V, visit ien and F, format, returns eval&man code of visit
 ;F="I":internal ien of cpt code, F="E":des of cpt code, F="C":cpt code
 G EM^APCLV1
 ;
LS(V,F) ;PEP - given V, visit ien and F, format, returns level of servie of visit
 ;F="I":internal set, F="E":external set
 G LS^APCLV1
 ;
ADMSERV(V,F) ;PEP - return admitting service in Code, internal or external form
 G ADMSERV^APCLV1
DSCHSERV(V,F) ;PEP - return discharge service in format F
 G DSCHSERV^APCLV1
NLAB(V) ;PEP - returns # of labs on the visit V
 G NLAB^APCLV1
ADMTYPE(V,F) ;PEP - return admission type i format F
 ;I = internal format
 ;E = long name of the type
 ;C = coded value
 G ADMTYPE^APCLV1
DSCHTYPE(V,F) ;PEP - return discharge type in format F
 ;I - internal format
 ;E - external name
 ;C - coded value
 G DSCHTYPE^APCLV1
NRX(V) ;PEP - returns # of rxs on visit V
 G NRX^APCLV1
 ;
PRIMPROV(V,F) ;PEP - returns primary provider on that visit in F format
 ;F is defined as:
 ;I - returns ien of provider in file 200 or 6
 ;T - returns provider' initials
 ;A - returns internal set of affiliation (e.g. 1)
 ;B - returns external of affiliation (e.g. IHS)
 ;C - returns provider's code
 ;D - returns provider's discipline code (E.G. 01)
 ;E - returns provider's discipline in external format (PHYSICIAN)
 ;F - returns ien of provider's discipline (22)
 ;N - returns provider's name
 ;O - returns provider's affl_disc  (e.g. 101 for IHS nurse)
 ;P - returns provider's affl_disc_code (e.g. 101LAB for nurse Lori Ann Butcher
 ;G - returns the event date&time for this provider
 G PRIMPROV^APCLV06
 ;
SECPROV(V,F,N) ;PEP - returns secondary provider N in format F
 ; see primPROV for format definitions, N is the 1-N secondary providers, if you want an array of all secondary providers use SECPROVS EP.
 G SECPROV^APCLV06
 ;
PRIMPOV(V,F) ;PEP - returns primary pov on visit V in format F
 ;F is defined as
 ;I - ien of ICD9 code
 ;E - external of ICD9 (text)
 ;C - icd9 code
 ;A - APC recode
 ;D - cause of dx
 ;J - cause of injury
 ;P - place of injury
 ;N - provider narrative external text
 G PRIMPOV^APCLV07
 ;
SECPOV(V,F,N) ;PEP - returns secondary pov N in format F for visit V
 ;see primpov for definitions of F
 G SECPOV^APCLV07
 ;
PROC(V,F,N) ;PEP - returns procedure N in format F for visit V
 ;F is defined as
 ;I -ien of icd9 code (.01)
 ;E - external of icd code
 ;C- icd code
 ;P - CPT CODE
 ;T - CPT INTERNAL IEN
 ;D - date of proc/int fm format
 ;G - date of proc/ext format
 ;F - INFECTION Y/N
 ;R - PROV AFFL_DISC
 ;X - DX DONE FOR - N
 ;N - provider narrative
 G PROC^APCLV08
IMM(V,F,N) ;PEP - returns immunization done on visit V in format F number N
 ;F is defined as
 ;I - ien of immunization entry
 ;C - immunization code
 ;E - immunization name
 ;S - series
 G IMM^APCLV11
DENT(V,F,N) ;PEP - returns dental
 ;F is defined as
 ;I - ien of dental entry
 ;C - ada code
 ;E - ada name
 ;S - series
 G DENT^APCLV05
DSCHDATE(V,F) ;PEP - return discharge date in F format
 ;F="I":internal fileman format, F="S":external slash date, F="E":external full (JAN 01, 1995)
 ;
 G DSCHDATE^APCLV1
CONSULTS(V) ;PEP - return # of consults
 G CONSULTS^APCLV1
ATTPHY(V,F) ;PEP - return attending physician
 G ATTPHY^APCLV06
LOS(V) ;PEP - return length of stay
 G LOS^APCLV1
FACTX(V,F) ;PEP - return facility transferred to
 G FACTX^APCLV1
MIDWIFE(V) ;PEP - return midwifery code
 G MIDWIFE^APCLV06
ACTTIME(V) ;PEP - return activity time
 G ACTTIME^APCLV1
TRAVTIME(V) ;PEP - return travel time
 G TRAVTIME^APCLV1
CHSCOST(V) ;PEP - return CHS total cost
 G CHSCOST^APCLV1
PATIENT(V,F) ;PEP - return patient
 G PATIENT^APCLV1
DLM(V,F) ;PEP - return date last modified
 G DLM^APCLV1
DVEX(V,F) ;PEP - return date visit exported
 G DVEX^APCLV1
DWEX(V,F) ;PEP - return date visit exported to NDW (national data warehouse)
 G DWEX^APCLV1
CODT(V,F) ;PEP - return check out date&time
 G CODT^APCLV1
APDT(V,F) ;PEP - return appt date&time from visit
 G APDT^APCLV1
APWI(V,F) ;PEP - return walk-in/appt
 G APWI^APCLV1
OUTSL(V) ;PEP - returns outside location
 G OUTSL^APCLV1
 ;see programmer for a copy of documentation
ADMDX(V,F) ;PEP - return admitting dx
 G ADMDX^APCLV07
PCCVF(V,T,F,A) ;PEP return v file information
 I $G(T)="" Q 1  ;no type of data defined
 I '$G(V) Q 3  ;no visit ien passed
 I $G(F)="" Q 2  ;no format defined
 I '$D(^AUPNVSIT(V)) Q 4
 NEW APCLTYPE,X,APCLPROG
 S APCLTYPE=""
 F I=1:1 S X=$T(TVAL+I) Q:X=""!(APCLTYPE]"")  I $P(X,";;",2)=T S APCLTYPE=$P(X,";;",2),APCLPROG=$P(X,";;",3)
 I APCLTYPE="" Q 5  ;not valid type
 K APCLV
 D @APCLPROG
 Q ""
BMI(H,W,D) ;PEP - return BMI if passed Ht and Wt
 ;H - ht in inches
 ;W - wt in inches
 ;D - number of decimal digits to return, if null pass full BMI value and all decimal digits
 I $G(H)="" Q ""  ;no ht
 I $G(W)="" Q ""  ;no wt
 NEW %
 S W=W*.45359,H=(H*.0254),H=(H*H),%=(W/H)
 I $G(D) S %=$J(%,(D+3),D)  ;full length equal 2N1"." with D decimals
 Q %
PBMI(P,EDATE) ;PEP - return patient's most current BMI as of EDATE
 ;P - patient DFN
 ;EDATE - as of date in internal Fileman format if null DT is assumed
 ;return value:  will be a "^" pieced string with the following pieces:
 ;   1 - BMI value  (not rounded)
 ;   2 - HT value used  (not rounded)
 ;   3 - Date of HT value used in internal fileman format
 ;   4 - visit ien of visit on which HT found
 ;   5 - WT used (not rounded)
 ;   6 - date of weight used
 ;   7 - visit ien of visit on which weight found
 ;   8 - error/warning messages in "|" delimted format e.g. warning 1|warning 2
 ;       warnings:
 ;           PATIENT DFN INVALID - either P is null or P does not exist in AUPNPAT or DPT
 ;           NO WEIGHT FOUND ON OR PRIOR TO (edate) - no weight on file for
 ;               this patient on or prior to the value of EDATE
 ;           NO HEIGHT FOUND ON OR PRIOR TO (edate) - no height on file for
 ;               this patiet on or prior to the value of EDATE
 ;               
 ;               
 ;               
 ;NOTE:  any weight taken on a prenatal visit is excluded and a prior weight is used
 ;NOTE:  if you add warnings, please use the word WARNING (caps) in the error message
 ;NOTE:  pts <18 must have ht/wt on same day and within past year
 ;       pts >50 must have ht/wt within past 2 years
 ;       pts 19-50 must have ht/wt within past5 years
 ;
 G PBMI^APCLV2
APCWL(V) ;PEP - is this visit APC Workload Reportable
 ;note:  LOCATION OF ENCOUNTER NOT FIGURED IN HERE.
 G APCWL^APCLV1
TVAL ;
 ;;MEASUREMENT;;MEAS^APCLV01;;9000010.01
 ;;PROVIDER;;PROV^APCLV06;;9000010.06
 ;;POV;;POV^APCLV07;;9000010.07
