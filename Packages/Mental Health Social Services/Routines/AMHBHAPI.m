AMHBHAPI ; IHS/CMI/LAB - BH API'S ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
RX(RETVAL) ;EP - TO RETURN PHARMACY SYSTEM
 ;RETVAL - 0 if site is not running RPMS pharmacy
 ;         ien of pharmacy system file
 S RETVAL=+$P($G(^AMHSITE(DUZ(2),0)),U,34)
 ;
TIUF(RETVAL,FILE,IEN,WPFIELD) ;EP - TO RETURN FIELD NUMBER FOR WP
 ;RETVAL - 0 - use word processing field for edit
 ;         or
 ;         field number to use for the TIU Document
 ;         or
 ;         -1^error message - error, could not determine value
 ;
 I '$G(FILE) S RETVAL="-1^FILE NUMBER NOT PASSED" Q
 I '$D(^DD(FILE)) S RETVAL="-1^FILE NUMBER INVALID" Q
 ;new record - return TIU field
 I '$G(IEN) S RETVAL=$O(^AMHTIUF("AC",FILE,WPFIELD,0)) Q  ;new record so TIU
 NEW G,R S G=^DIC(FILE,0,"GL")
 S R=G_"IEN)"
 I '$D(@R) S RETVAL=$O(^AMHTIUF("AC",FILE,WPFIELD,0)) Q  ;new record always use TIU
 NEW N,S
 S N=$P($P(^DD(FILE,WPFIELD,0),U,4),";",1)
 S S=G_"IEN,N,0)"
 I '$O(@S) S RETVAL=$O(^AMHTIUF("AC",FILE,WPFIELD,0)) Q  ;no word processing text
 S RETVAL=0
 Q
 ;
TESTTIUF ;
 D TIUF(.AMHVAL,9002011,1249,3101)
 Q
TESTIEN ;
 D TIUIEN(.AMHVAL,9002011,10000,1108)
 Q
TIUIEN(RETVAL,FILE,IEN,TIUFIELD) ;EP - API to return TIU Document ien from FILE,FIELD
 ;Input:  FILE - file number
 ;        IEN - ien of entry in file named in FILE
 ;        TIUFIELD - field number for the TIU field
 ;
 ;Return Values:  if error:  -1^ERROR DESCRIPTION
 ;                or
 ;                0 if TIU field is blank
 ;                or
 ;                ien of TIU document from TIU field^TIU DOCUMENT TITLE^TIU DOCUMENT DATE/TIME
 ;
 I '$G(FILE) S RETVAL="-1^FILE NUMBER NOT PASSED" Q
 I '$D(^DD(FILE)) S RETVAL="-1^FILE NUMBER INVALID" Q
 I $G(IEN)="" S RETVAL="-1^IEN NOT PASSED" Q
 I $G(TIUFIELD)="" S RETVAL="-1^TIU FIELD NOT PASSED" Q
 NEW AMHTIUD
 S AMHTIUD=$$VALI^XBDIQ1(FILE,IEN,TIUFIELD)
 I AMHTIUD="" S RETVAL=0 Q
 S RETVAL=AMHTIUD_U_$$VAL^XBDIQ1(8925,AMHTIUD,.01)_U_$$VAL^XBDIQ1(8925,AMHTIUD,1301)
 Q
 ;
TESTV ;
 D TIUVISIT(.AMHVAL,65498,3060221.12,2522,2,14,1)
 W !,AMHVAL
 Q
TIUVISIT(RETVAL,DFN,DATE,LOCATION,TOC,CLINIC,PROVIDER) ;EP - API to create or find a visit
 ;input parameters:    DFN - DFN of Patient
 ;                     DATE - date and time of visit IN internal FM format
 ;                     LOCATION - IEN of location of encounter from LOCATION file
 ;                     TOC - ien of MHSS type of contact 
 ;                     CLINIC - ien from clinic stop fle
 ;                     PROVIDER - ien of primary provider
 ;
 ;error codes:    0^error message     
 ;
 ;RETVAL:  IEN of VISITS FOUND or error code
 ;         If more than one visit found then pass back list 1234^2345^1919
 ;         
 I '$G(DFN) S RETVAL="0^INVALID DFN VALUE" Q
 I '$D(^AUPNPAT(DFN)) S RETVAL="0^INVALID DFN VALUE" Q
 I '$G(DATE)="" S RETVAL="0^DATE OF VISIT INVALID" Q
 I '$D(DT) D ^XBKVAR
 S AUPNTALK=""
 NEW X,%DT,Y S X=DATE,%DT="TRXN" D ^%DT S X=Y I X=-1 S RETVAL="0^"_DATE_"^DATE INVALID FOR PATIENT,CANNOT CREATE VISIT .01 VALUE" Q
 S Y=DFN D ^AUPNPAT
 S X=$P(DATE,".",1)
 D VSIT01^AUPNVSIT
 I '$D(X) S RETVAL="0^"_DATE_"^DATE INVALID FOR PATIENT,CANNOT CREATE VISIT .01 VALUE" Q
 I $G(LOCATION)="" S RETVAL="0^LOCATION OF ENCOUNTER MISSING" Q
 I '$D(^AUTTLOC(LOCATION)) S RETVAL="0^LOCATION OF ENCOUNTER INVALID" Q
 I '$G(TOC) S RETVAL="0^TYPE OF CONTACT MISSING" Q
 I '$D(^AMHTSET(TOC)) S RETVAL="0^TYPE OF CONTACT INVALID" Q
 I '$G(CLINIC) S RETVAL="0^CLINIC STOP MISSING" Q
 I '$D(^DIC(40.7,CLINIC,0)) S RETVAL="0^CLINIC STOP INVALID" Q
 ;I '$G(PROVIDER) S RETVAL="0^PRIMARY PROVIDER IEN MISSING" Q
 I $G(PROVIDER),'$D(^VA(200,PROVIDER,0)) S RETVAL="0^PRIMARY PROVIDER IEN MISSING" Q
 ;have good data, now create or get visit
 D BSD I AMHERR]"" S RETVAL="0^PCC Visit not created" Q
 I '$G(AMHVSIT) W !!,"Visit not created...notify supervisor." Q
 S RETVAL=AMHVSIT
 Q
BSD ;
 ;if non-interactive use BSDAPI4 and always force an add
 ;in interative mode display to user for selection
 K AMHIN ;clean out array
 I '$P($G(^AMHSITE(DUZ(2),0)),U,33) S AMHIN("FORCE ADD")=1
 ;I $D(ZTQUEUED) S AMHIN("FORCE ADD")=1
 S AMHIN("VISIT DATE")=DATE
 D GETTYPE
 S AMHIN("VISIT TYPE")=AMHTYPE
 S AMHIN("PAT")=DFN
 S AMHIN("SITE")=LOCATION
 ;determine service category based on type of contact
 S AMHIN("SRV CAT")=$P(^AMHTSET(TOC,0),U,3)
 S AMHIN("CLINIC CODE")=CLINIC
 I $G(PROVIDER) S AMHIN("PROVIDER")=PROVIDER
 S AMHIN("APCDCAF")="R"
 S AMHIN("TIME RANGE")=-1
 S AMHIN("USR")=DUZ
BSDADD1 ;
 K APCDALVR
 K AMHV
 D GETVISIT^APCDAPI4(.AMHIN,.AMHV)
 S AMHERR=$P(AMHV(0),U,2)
 I AMHERR]"" Q  ;errored
 I $P(AMHV(0),U)=1 S V=$O(AMHV(0)) I AMHV(V)="ADD" S AMHVSIT=V Q
 ;since more than one passed back GIVE THEM BACK TO THE CALLER SO THEY CAN CHOOSE
 S X=0,C=0 F  S X=$O(AMHV(X)) Q:X=""  S C=C+1 S $P(AMHVSIT,U,C)=X
 Q
GETTYPE ;get type of visit - use loc current type or affiliation of provider
 S AMHTYPE=$S($P($G(^AMHSITE(DUZ(2),0)),U,2)]"":$P(^(0),U,2),1:"") Q:AMHTYPE]""
 S X=$P($G(^APCCCTRL(LOCATION,0)),U,4) I X]"" S AMHTYPE=X Q  ;use pcc master control for site of loc of enc ihs/tucson/lab 11/30/95 patch 1
 S X=$$VALI^XBDIQ1(200,PROVIDER,9999999.01) I X S AMHTYPE=$S(X=1:"I",X=2:"C",X=3:"T",X=8:"6",1:"") I AMHTYPE]"" Q
 S X=$P($G(^APCCCTRL(DUZ(2),0)),U,4) I X]"" S AMHTYPE=X Q  ;use pcc master control
 S AMHTYPE="I" ;default to I if can't determine
 Q
