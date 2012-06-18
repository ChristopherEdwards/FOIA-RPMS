AUPNPAT ; IHS/CMI/LAB - POST SELECTION SETS FOR PATIENT LOOKUP ; [ 09/13/06  2:13 PM ]
 ;;99.1;IHS DICTIONARIES (PATIENT);**8,9,10,17**;JUN 13,2003
 ;
 ; This routine sets standard patient variables
 ;IHS/SET/GTH AUPN*99.1*8 10/04/2002 Removed all refs to AUPN*93.2*3.
START ;
 S:$D(X) AUPNPATX=X
 S AUPNPAT=+Y
 S AUPNSEX=$P(^DPT(AUPNPAT,0),U,2),AUPNDOB=$P(^(0),U,3),AUPNDOD="" S:$D(^(.35)) AUPNDOD=$P(^(.35),U,1)
 S X2=AUPNDOB,X1=$S('AUPNDOD:DT,AUPNDOD:AUPNDOD,1:DT)
 D ^%DTC
 S AUPNDAYS=X
 ;S X="BEHOPTCX" X ^%ZOSF("TEST") I $T D SETCTX^BEHOPTCX(+AUPNPAT)
 K X,X1,X2
 S:$D(AUPNPATX) X=AUPNPATX
 K %T,%Y,AUPNPATX
 S DFN=AUPNPAT
 S SSN=$$SSN(AUPNPAT)
 S AGE=$$AGE(AUPNPAT)
 S DOB=$$DOB(AUPNPAT)
 S SEX=$$SEX(AUPNPAT)
 Q
 ;
KILL ;PEP - KILL VARIABLES SET BY THIS ROUTINE
 K AUPNPAT,AUPNSEX,AUPNDOB,AUPNDOD,AUPNDAYS
 K AGE,DFN,DOB,SEX,SSN
 Q
 ;
 ;  NOTE TO PROGRAMMERS:
 ;   All parameters are required, except the Format parameter ("F").
 ;   The default for the Format parameter is the internal format of
 ;   the returned value.
 ;
AGE(DFN,D,F) ;PEP - Given DFN, return Age.
 ;return age on date d in format f (defaults to DT and age in years)
 Q $$AGE^AUPNPAT3(DFN,$G(D),$G(F))
 ;
BEN(DFN,F) ;PEP - returns classifications/beneficiary in format F.
 Q $$BEN^AUPNPAT3(DFN,$G(F))
 ;
BENYN(DFN) ;PEP - Return BEN/Non-BEN Status.
 Q $$BEN^AUPNPAT1(DFN)
 ;
CDEATH(DFN,F) ;PEP - returns Cause of Death in F format
 Q $$CDEATH^AUPNPAT3(DFN,$G(F))
 ;
COMMRES(DFN,F) ;PEP - Given DFN, return comm of res in F format
 Q $$COMMRES^AUPNPAT3(DFN,$G(F))
 ;
DEC(PID) ;PEP - RETURN DECRYPTED PATIENT IDENTIFIER
 G DEC^AUPNPAT4
 ;----------
ENC(DFN) ;PEP
 G ENC^AUPNPAT4
 ;----------
DOB(DFN,F) ;PEP - Given DFN, return Date of Birth according to F.
 Q $$DOB^AUPNPAT3(DFN,$G(F))
 ;
DOD(DFN,F) ;PEP - Given DFN, return Date of Death in FM format.
 Q $$DOD^AUPNPAT3(DFN,$G(F))
 ;
ELIGSTAT(DFN,F) ;PEP - returns eligibility status in F format
 Q $$ELIGSTAT^AUPNPAT3(DFN,$G(F))
 ;
HRN(DFN,L,F) ;PEP
 ;f patch 4 05/08/96
 Q $$HRN^AUPNPAT3(DFN,L,$G(F))
 ;
MCD(P,D) ;PEP - Is patient P medicaid eligible on date D?
 Q $$MCD^AUPNPAT2(P,D)
 ;
MCDPN(P,D,F) ;PEP - return medicaid plan name for patient P on date D in form F.
 Q $$MCDPN^AUPNPAT2(P,D,$G(F))
 ;
MCR(P,D) ;PEP - Is patient P medicare eligible on date D?
 Q $$MCR^AUPNPAT2(P,D)
 ;
PI(P,D) ;PEP - Is patient P private insurance eligible on date D?
 Q $$PI^AUPNPAT2(P,D)
 ;
PIN(P,D,F) ;PEP - return private insurer name for patient P on date D in form F.
 Q $$PIN^AUPNPAT2(P,D,$G(F))
 ;
SEX(DFN) ;PEP - Given DFN, return Sex.
 Q $$SEX^AUPNPAT3(DFN)
 ;
SSN(DFN) ;PEP - Given DFN, return SSN.
 Q $$SSN^AUPNPAT3(DFN)
 ;
TRIBE(DFN,F) ;PEP - Given DFN, return Tribe in F format
 Q $$TRIBE^AUPNPAT3(DFN,$G(F))
 ;
 ;Begin New Code;IHS/SET/GTH AUPN*99.1*8 10/04/2002
RR(P,D) ;PEP -  Is patient P railroad eligible on date D?
 Q $$RRE^AUPNPAT2(P,D)
 ;End New Code;IHS/SET/GTH AUPN*99.1*8 10/04/2002
