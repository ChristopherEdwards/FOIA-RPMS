BSDU ; IHS/ANMC/LJF - IHS UTILITY CALLS-CLINIC INFO ;  [ 01/06/2005  11:39 AM ]
 ;;5.3;PIMS;**1001,1010,1011,1012**;APR 26, 2002
 ;
 ;cmi/flag/maw 10/29/2009 PATCH 1011 added calls for TAXONOMY, GETTAX, TAX
 ;
CLINIC(BSDTNI,BSDNALL,BSDDIV) ;EP; get clinic choices-includes principal clinic groups ;IHS/ITSC/LJF 4/21/2004
 ; if BSDTNI=1 array is VAUTC(clinic name)=ien
 ; if BSDTNI=2 array is VAUTC(clinic ien)=name
 ; if BSDNALL is set to 1, don't ask for all clinics or expand principal cln
 ; if BSDDIV is set to 1, assume DIV is set for division and don't ask again;IHS/ITSC/LJF
 K BSDQ
 ;
 ;IHS/ITSC/LJF 4/21/2004 don't ask division if already known
 ;D ASK2^SDDIV I Y<0 S BSDQ="" Q
 K VAUTD
 I $G(BSDDIV) D                         ;division assumed
 . I '$D(DIV) Q                         ;no division variable set
 . I DIV="" S VAUTD=1 Q                 ;already set to all divisions
 . S VAUTD=0,VAUTD(DIV)=$$DIVNM(DIV)    ;division already set
 I '$D(VAUTD) D ASK2^SDDIV I Y<0 S BSDQ="" Q
 ;I $D(BSDNALL) S VAUTNALL=""
 I $G(BSDNALL) S VAUTNALL=""
 ;IHS/ITSC/LJF 4/21/2004
 ;
 ;cmi/maw 10/15/2009 PATCH 1011 ask for taxonomy here
 N BSDTAX
 I $G(BSDTAXYN) D
 . I $$READ^BDGF("Y","Would you like a preexisting Clinic Taxonomy?","NO") D
 .. S BSDTAX=$$GETTAX(BSDTNI)
 .. I $G(BSDTAX) S Y=1,VAUTC=0
 I '$G(BSDTAX) S VAUTNI=BSDTNI D CLINIC^VAUTOMA I Y<0 S BSDQ="" Q
 ;S VAUTNI=BSDTNI D CLINIC^VAUTOMA I Y<0 S BSDQ="" Q  cmi/maw 10/15/2009 orig line
 I '$G(BSDTAX),$O(VAUTC(""))]"" D
 . Q:$$READ^BDGF("Y","Would you like to save this clinic list as a Taxonomy?","NO")'=1
 . N BSDTAXE
 . D TAX(.VAUTC,BSDTNI)
 . S Y=1
 ;
 I '$D(BSDNALL) D EXPNDPC(BSDTNI,.VAUTC)
 Q
 ;
EXPNDPC(BSDTNI,ARRAY) ;EP; expands array if any are principal clinics  
 NEW X,Z,Y
 S X=0 F  S X=$O(ARRAY(X)) Q:X=""  D
 . S Y=$S(BSDTNI=1:ARRAY(X),1:X)
 . S Z=0 F  S Z=$O(^SC("AIHSPC",Y,Z)) Q:Z=""  D
 .. I BSDTNI=1 S ARRAY($P(^SC(Z,0),U))=Z
 .. I BSDTNI=2 S ARRAY(Z)=$P(^SC(Z,0),U)
 Q
 ;
PCASK(BSDTNI,BSDTYPE) ;EP; get provider or team (with associated clinics)
 ; if BSDTNI=1 array is VAUTC(clinic name)=ien
 ; if BSDTNI=2 array is VAUTC(clinic ien)=name
 ; BSDTYPE="V" for provider or "T" for team
 NEW DIC,VAUTSTR,VAUTVB,VAUTNI
 K BSDQ,BSDTT,VAUTC
 S DIC=$S(BSDTYPE="V":"^VA(200,",1:"^BSDPCT(")
 S VAUTSTR=$S(BSDTYPE="V":"provider",1:"team")
 S VAUTVB="BSDTT",VAUTNI=2
 I BSDTYPE="V" S DIC("S")="I $$SCREEN^DGPMDD(Y,"""",DT)"
 I BSDTYPE="T" S DIC("S")="I $P($G(^BSDPCT(+Y,0)),U,3)="""""
 D FIRST^VAUTOMA I Y<0 S BSDQ="" Q
 ;
 NEW X,Y S X=0 F  S X=$O(BSDTT(X)) Q:'X  D
 . S Y=X_U_BSDTT(X) D FINDCL(Y,BSDTYPE,BSDTNI)
 S VAUTC=BSDTT
 Q
 ;
FINDCL(BSDX,TYPE,MODE) ;EP; -- sets array of clinics for provider or team
 ; returns BSDCL array with clinic name and then ien
 ; BSDX=IEN of provider or team ^ provider or team name
 ; TYPE="V" for provider; "T" for team
 ;
 ;IHS/ITSC/WAR 2/12/03 P50 per Linda LJF41
 ;K VAUTC   ;IHS/ITSC/LJF 1/22/2003 do not wipe out VAUTC between calls from PCASK
 I TYPE="V" D CLN(+BSDX,MODE) Q   ;for provider sort
 ;
 ; for team sort
 ;7/18/2002 WAR - next section per LJF18
 ;IHS/ANMC/LJF 7/5/2002 changed all BDG to BSD in next 3 lines
 NEW BSDP
 S BSDP=0 F  S BSDP=$O(^BSDPCT(+BSDX,1,BSDP)) Q:'BSDP  D
 . D CLN($P(^BSDPCT(+BSDX,1,BSDP,0),U),MODE)
 ;IHS/ANMC/LJF 7/5/2002 end of fix
 Q
 ;
CLN(SUB2,MODE) ; sets clinic array based on provider
 NEW X
 S X=0
 F  S X=$O(^SC("AIHSDPR",SUB2,X)) Q:'X  D
 . I MODE=1 S VAUTC($$GET1^DIQ(44,X,.01))=X
 . I MODE=2 S VAUTC(X)=$$GET1^DIQ(44,X,.01)
 Q
 ;
DIV() ;EP; -- returns division ien for user
 ;Q +$O(^DG(40.8,"C",DUZ(2),0))  ;cmi/maw 10/1/2009 patch 1011 orig line
 Q +$O(^DG(40.8,"AD",DUZ(2),0))  ;cmi/maw 10/1/2009 patch 1011 for station number
 ;
DIVNM(D) ;EP; -- returns division name for division sent
 NEW X S X=$$GET1^DIQ(40.8,+$G(D),.01) S:X="" X="UNKNOWN DIVISION" Q X
 ;
DIVC(CLINIC) ;EP; -- returns division for clinic
 Q $$GET1^DIQ(44,+CLINIC,3.5,"I")
 ;
FAC(CLINIC) ;EP; -- returns institution for clinic based on division
 NEW X S X=$$DIVC(CLINIC)
 Q $S(+X:$$GET1^DIQ(40.8,+X,.07,"I"),1:"")
 ;
ACTV(CLINIC,DATE) ;PEP; -- returns 1 if clinic is active for date
 I $$GET1^DIQ(44,CLINIC,2,"I")'="C" Q 0   ;not a clinic
 Q $S($P($G(^SC(CLINIC,"I")),U)="":1,$P(^("I"),U)>DATE:1,$P(^("I"),U,2)="":0,$P(^("I"),U,2)'>DATE:1,1:0)
 ;
INACTMSG() ;EP; -- returns message to display if clinic inactivated
 ; called by code that sets DIC("W")
 Q "NEW BSDMSG S BSDMSG=$S($$ACTV^BSDU(+Y,DT):"""",1:"" *inactivated on ""_$$INACTVDT^BSDU(+Y)) W BSDMSG"
 ;
INACTVDT(CLINIC) ;PEP; -- returns date clinic was inactivated
 Q $$GET1^DIQ(44,+CLINIC,2505)
 ;
PRV(CLINIC) ;EP; -- returns default provider for clinic
 ; Y returns as ien^provider name
 NEW X,Y
 S X=0 F  S X=$O(^SC(CLINIC,"PR",X)) Q:'X  D
 . I $P($G(^SC(CLINIC,"PR",X,0)),U,2)=1 S Y=+^SC(CLINIC,"PR",X,0)
 I $G(Y) S Y=Y_U_$$GET1^DIQ(200,Y,.01)
 I '$G(Y) S Y="0^UNAFFILIATED CLINICS"
 Q $G(Y)
 ;
TEAM(CLINIC) ;EP; -- returns team associated with this clinic
 ; Y returns as ien^team name
 NEW X,Y
 ;  first find default provider entry for clinic
 S X=$$PRV(CLINIC) I 'X Q X
 ;  then find provider's team (assumes only on one)
 S Y=$O(^BSDPCT("AB",+X,0)) I 'Y Q "0^UNAFFILIATED CLINICS"
 ;  return team ien ^ team name
 ;Q Y_U_$$GET1^DIQ(9009017.5,Z,.01)
 Q Y_U_$$GET1^DIQ(9009017.5,Y,.01)   ;IHS/ITSC/LJF 4/23/2004 PATCH #1001
 ;
OWNER(CLINIC,USER) ;EP
 ; -- returns 1 if user is clinic's owner or no owners assigned
 I $D(^XUSEC("SDZAC",DUZ)) Q 1       ;let app coordinators in
 NEW X S X=+$$GET1^DIQ(44,CLINIC,1916,"I")          ;princ clinic
 I '$O(^BSDSC(CLINIC,2,0)),'$O(^BSDSC(X,2,0)) Q 1   ;no owners; unlocked
 I $D(^BSDSC("AB",USER,CLINIC)) Q 1  ;user is one of the owners
 I $D(^BSDSC("AB",USER,X)) Q 1       ;user is owner of princ clinic
 Q 0
 ;
OVRBKUSR(DUZ,CLINIC) ;EP; returns 1 if user has overbook access to clinic
 Q $S($D(^XUSEC("SDOB",DUZ)):1,$D(^BSDSC("AOV",DUZ,CLINIC)):1,$D(^BSDSC("AOV",DUZ,+$$PC(CLINIC))):1,1:0)
 ;
MOVBKUSR(DUZ,CLINIC) ;EP; returns 1 if user has master overbook access to clinic
 Q $S($D(^XUSEC("SDMOB",DUZ)):1,$$OBLEVL(DUZ,CLINIC)="M":1,$$OBLEVL(DUZ,+$$PC(CLINIC))="M":1,1:0)
 ;
OBLEVL(DUZ,CLINIC) ;EP; returns M or R as overbok level for user for clinic
 NEW X S X=$O(^BSDSC("AOV",DUZ,CLINIC,0)) I 'X Q ""
 Q $P($G(^BSDSC(CLINIC,1,X,0)),U,2)
 ;
PRIN(CLINIC) ;PEP -- returns name of clinic's principal clinic
 NEW X S X=$$GET1^DIQ(44,+CLINIC,1916)
 Q $S(X]"":X,1:"UNAFFILIATED CLINICS")
 ;
PC(CLINIC) ;PEP; -- returns IEN for clinic's principal clinic
 Q +$$GET1^DIQ(44,CLINIC,1916,"I")
 ;
CLNCODE(CLINIC) ;PEP -- returns clinic code number and name
 ; if you want only the code, add + to the result
 NEW X S X=$$GET1^DIQ(44,+CLINIC,8,"I") I 'X Q "??"
 Q $$GET1^DIQ(40.7,X,1)_" - "_$$GET1^DIQ(40.7,X,.01)
 ;
CONF() ;EP; -- returns confidential warning
 Q "Confidential Patient Data Covered by Privacy Act"
 ;
NONCOUNT(CLINIC) ;EP; --returns statement if non-count clinic
 NEW X,Y
 S X=$$GET1^DIQ(44,CLINIC,2502) I X'="YES" Q ""
 S Y=$$GET1^DIQ(44,CLINIC,2502.5)
 S X="Non-Count Clinic, "_$S(Y="YES":"",1:"NOT ")
 S X=X_"included on File Room List"
 Q X
 ;
DOW(CLINIC) ;EP; -- returns list of days clinic meets
 ; borrowed code from VA routine SDCP
 NEW DOW,L,M,DAYS,X,Y
 F L=0:1:6 F M=DT-.1:0 S M=$O(^SC(CLINIC,"T"_L,M)) Q:M=""  I $D(^(M,1)) S:^(1)]"" DOW(L+1)="" Q:^(1)]""  K DOW(L+1)
 F L=DT-.1:0 S L=$O(^SC(CLINIC,"T",L)) Q:L=""  S X=L D DW^%DTC I '$D(DOW(Y+1)),$D(^SC(CLINIC,"OST",L,1)),^(1)["[" S DOW(Y+1)=""
 S DAYS="" F M=1:1:7 I $D(DOW(M)) S DAYS=DAYS_$S(DAYS'="":",",1:"")_$P("SU^MO^TU^WE^TH^FR^SA",U,M)
 Q DAYS
 ;
HSPRINT(CLINIC,MODE) ;EP; -- returns data on printing HS and its type
 ; MODE="I" for return internal values
 NEW X,Y
 S MODE=$G(MODE)
 S X=$$GET1^DIQ(9009017.2,CLINIC,.04,"I") S:X="" S=0
 S Y=$$GET1^DIQ(9009017.2,CLINIC,.05,MODE)
 Q $S(MODE="I":X_U_Y,X=1:"YES, "_Y,1:"NO")
 ;
GREETING(LETTER,PAT) ;EP; -- returns letter salutation
 NEW LINE
 S LINE="Dear "
 ;
 I $$GET1^DIQ(407.5,LETTER,9999999.01)="YES",$$AGE^AUPNPAT(PAT)<18 D
 . S LINE=LINE_"Parents of "
 ;
 E  I $$GET1^DIQ(9009020.2,$$DIV,.07)'="YES" D
 . S LINE=LINE_$S($$SEX^AUPNPAT(PAT)="M":"Mr. ",1:"Ms. ")
 ;
 ;S LINE=LINE_$$NAMEPRT^BDGF2(PAT,1)  ;add printable name
 S LINE=LINE_$$NAMEPRT^BDGF2(PAT,1)_","  ;add printable name; IHS/ITSC/WAR 7/8/2004 PATCH #1001
 Q LINE
 ;
LEGEND(ARRAY) ;EP; -- returns legend explaining month-at-a-glance display   
 S ARRAY(1)="FOR CLINIC AVAILABILITY PATTERNS:"
 S ARRAY(2)=$$PAD("  0-9 and j-z",15)_" --denote available slots where j=10,k=11...z=26"
 S ARRAY(3)=$$PAD("  A-W",15)_" --denote overbooks with A being the first slot to be overbooked"
 S ARRAY(4)=$$SP(18)_"and B being the second for that same time, etc."
 S ARRAY(5)=$$PAD("  *,$,!,@,#",15)_" --denote overbooks or appts. that fall outside of a clinic's"
 S ARRAY(6)=$$SP(18)_"regular hours" Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
GETTAX(TNI) ;-- get taxonomy name
 S DIC="^ATXAX(",DIC(0)="AEMQZ",DIC("A")="Select Taxonomy: ",DIC("S")="I $P(^(0),U,15)=44"
 D ^DIC
 I Y<0 Q ""
 N TDA,CNT,DATA
 S CNT=0
 S TDA=0 F  S TDA=$O(^ATXAX(+Y,21,TDA)) Q:'TDA  D
 . S CNT=CNT+1
 . S DATA=$G(^ATXAX(+Y,21,TDA,0))
 . I TNI=2 S VAUTC(DATA)=$P($G(^SC(DATA,0)),U)
 . I TNI=1 S VAUTC($P($G(^SC(DATA,0)),U))=DATA
 K DIC
 Q +$G(Y)
 ;
TAX(ARRAY,TNI) ;-- get taxonomy name
 N TAXE
 S DLAYGO=9002226,ATXFLG=1
 S DIC="^ATXAX(",DIC(0)="AEMQLZ",DIC("A")="Taxonomy Name: "
 D ^DIC
 Q:Y<0
 S TAXE=+Y
 N FDA,FIENS,FERR
 S FIENS=TAXE_","
 S FDA(9002226,FIENS,.02)="PIMS Report Clinic Taxonomy"
 S FDA(9002226,FIENS,.09)=DT
 S FDA(9002226,FIENS,.15)=44
 D FILE^DIE("K","FDA","FERR(1)")
 N BDA
 S BDA=0 F  S BDA=$O(ARRAY(BDA)) Q:BDA=""  D
 . N AFDA,AFIENS,AFERR
 . S AFIENS="+2,"_TAXE_","
 . S AFDA(9002226.02101,AFIENS,.01)=$S(TNI=1:$O(^SC("B",BDA,0)),1:BDA)
 . D UPDATE^DIE("","AFDA","AFIENS","AFERR(1)")
 . S MARK=$G(AFIENS(2))
 Q
 ;
