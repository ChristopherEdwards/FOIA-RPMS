BWMDEX2 ;IHS/CIA/DKM - Data transforms for extract;21-Mar-2011 14:15;PLS
 ;;2.0;WOMEN'S HEALTH;**9,11,12**;MAY 16, 1996
 ; Returns CDC export version
CDCVER(BWSITE) ; EP
 N X
 S:'$G(BWSITE) BWSITE=DUZ(2)
 S X=$P($G(^BWSITE(BWSITE,0)),U,18)
 Q $S(X:X,1:41)
 ; Convert FM date to CDC format
 ; BWLN = Format type
 ;        6: 6-bytes (MMYYYY)
 ;        8: 8-bytes (MMDDYYYY) (default)
CDCDT(BWDT,BWLN) ;
 S:BWDT BWDT=BWDT+17000000
 Q $S(BWDT:$E(BWDT,5,$G(BWLN,8))_$E(BWDT,1,4),1:"")
 ; Return data from specified node and piece
PC(BWN,BWP,BWT) ;
 Q $$PC^BWMDEX(.BWN,.BWP,.BWT)
 ; ===========================
 ; Patient Demographics
 ; ===========================
 ; Return unique patient id
 ; Assigns one if this has not already been done.
PATID() N X
 S X=$$CDCID^BWUTL1(BWDFN)
 I '$L(X) D
 .D CDCID^BWPATE(BWDFN)
 .S X=$$CDCID^BWUTL1(BWDFN)
 Q X
 ; Returns DOB
DOB() Q $$CDCDT($$DOB^BWUTL1(BWDFN))
 ; Return record identifier for this procedure.
 ; First digit is 1 for pap, 2 for mam.
 ; Second digit is one's digit of the year.
 ; Last 4 digits are the 1-10000 digits of the accession.
RECID() N X,Y
 S Y=$$PC(0,1),X=$P(Y,"-",2)
 Q $S($E(Y)="P":1,1:2)_$E(Y,4)_$E(X,$L(X)-3,$L(X))
 ; Return state of residence (FIPS)
STRES() N X
 S X=$P($G(^DPT(BWDFN,.11)),U,5)
 Q $S(X:$P(^DIC(5,X,0),U,3),1:"")
 ; Return 5 digit zipcode
ZIP() N X
 S X=$E($$ZIP^BWUTL1(BWDFN),1,5)
 Q $S(X:X,1:"")
 ; Return FIPS code for screening state
STSCR(BWSITE) ;
 Q $P($G(^BWSITE($G(BWSITE,DUZ(2)),0)),U,11)
 ; Return FIPS code for screening county
CNTYSCR(BWSITE) ;
 N X
 S X=$P($G(^BWSITE($G(BWSITE,DUZ(2)),0)),U,16)
 Q $S(X>0:X,1:999)
 ; Return screening city
CITY(BWSITE) ;
 Q $P($G(^AUTTLOC($G(BWSITE,DUZ(2)),0)),U,13)
 ; Return race as a string of CDC race codes
 ; BWVER = CDC version # (defaults to current)
RACE(BWVER) ;
 N BWRACE,BWRSLT,I
 D RACEGET(.BWRACE)
 S BWRSLT="",I=0
 S:'$G(BWVER) BWVER=$$CDCVER
 F  S I=$O(BWRACE(I)) Q:'I  D
 .S BWRACE=$O(^BWRACE(I,1,"AC",BWVER,0))
 .I BWRACE,BWRSLT'[BWRACE S BWRSLT=BWRSLT_BWRACE
 Q BWRSLT
 ; Check for specific racial origin
 ; BWRC = IEN of race file entry
 ; Returns: 1 = yes, 2 = no, 3 = unknown
RACECHK(BWRC) ;
 N BWRACE
 D RACEGET(.BWRACE)
 Q $S('$D(BWRACE):3,$D(BWRACE(BWRC)):1,1:2)
 ; Load race IENs into array
RACEGET(BWRACE) ;
 N I
 K BWRACE
 S I=0
 F  S I=$O(^BWP(BWDFN,2,I)) Q:'I  S BWRACE(+^(I,0))=""
 ; If no race designated then infer from tribal affiliation
 I '$D(BWRACE) D
 .S I=+$P($G(^AUPNPAT(BWDFN,11)),U,8)
 .S I=$S(I:+$O(^BWRACE("C",I,0)),1:7)
 .; bw patch 10 - remove default race value of '5'/if unknown blank fill
 .I 'I Q
 .S BWRACE(I)=""
 Q
 ; Returns ethnicity code
 ; Assumes the IENs of file 10.2 are constant.
HISPANIC() ; EP
 N X
 S X=$P(^BWP(BWDFN,0),U,9)
 Q $S('X:2,X=1:1,X=2:2,1:3)
 ; Determine Bethesda System used
 ; BWPDT = Date of Procedure (defaults to BWDT)
 ; BWSITE = Site to check (defaults to DUZ(2))
 ; Returns 1: 1991 system; 2: 2001 system
BSU(BWPDT,BWSITE) ;
 N X
 I $G(BWMAM)!$G(BWCBE) Q ""
 I $$PC("all.5.03")=4!($$PC("all.5.03")=5),'$G(BWPDT) Q ""
 S X=$P($G(^BWSITE($G(BWSITE,DUZ(2)),.51)),U,2)
 S BWDT=$G(BWPDT,$G(BWDT))
 Q $S('X:1,BWDT<X:1,1:2)
 ; Return the dx workup (PAP and MAM)
 ; BWFLG = If zero, forces result to 2
 ; 1 = planned; 2 = unplanned; 3 = undetermined
WKUP(BWFLG) ;
 N X
 S BWFLG=+$G(BWFLG,1),X=$S('BWFLG:2,1:$$PC(2,20))
 I BWFLG,$G(BWPAP),$$PRESLT=11 S X=3
 I BWFLG,$G(BWMAM),$$MRESLT=10 S X=3
 Q $S(X:X,1:2)
 ; Find the last procedure within time window
 ; BWPT  = Procedure type(s) to find (separate by ^)
 ; BWDT1 = Ending date for search
 ; BWDT2 = Beginning date for search (defaults to BWDT1 - 1 year)
 ; Return IEN of last procedure, or 0 if none found.
FINDLAST(BWPT,BWDT1,BWDT2) ; EP
 N X,Y,Z
 S:'$D(BWDT2) BWDT2=$$FMADD^XLFDT(BWDT1,-366)
 F X=1:1:$L(BWPT,U) S BWPT(+$P(BWPT,U,X))=""
 S X=0
 F  S X=$O(^BWPCD("C",BWDFN,X)) Q:'X  D
 .S Y=^BWPCD(X,0),Z=$P(Y,U,12)
 .I $D(BWPT(+$P(Y,U,4))),Z<BWDT1,Z>BWDT2 S Z(Z)=X
 S Z=$O(Z(""),-1)
 Q $S(Z:Z(Z),1:0)
 ; ===========================
 ; Breast exam
 ; ===========================
 ; Breast symptoms
BRSYMP() Q $S('BWMAM&'BWCBE:3,$$PC(2,35):$$PC(2,35),1:3)
 ; Clinical breast exam results
 ; Also sets:
 ; CBEAB = abnormal flag
 ; CBEDT = abnormal date
CBE() ; EP
 Q:'$G(BWMAM)&'$G(BWCBE) 3
 N BWCBEDX,BWCBEDT
 I $G(BWMAM) S BWCBEDX=$$PC(2,32),BWCBEDT=$$PC(2,33)
 E  S BWCBEDX=$P($G(^BWDIAG(+$$PC(0,5),0)),U,27),BWCBEDT=BWDT
 S:BWCBEDX BWCBEDX=+$P($G(^BWCBE(BWCBEDX,0)),U,2)
 I $G(BWMAM) D
 .S BWDATA("CBEAB")=$$PC(16,7)
 .I BWDATA("CBEAB")="",BWCBEDX D
 ..Q:BWCBEDX=3
 ..Q:BWCBEDX=4
 ..S BWDATA("CBEAB")=1
 E  D
 .I $L($$PC(16,7)) S BWDATA("CBEAB")=$$PC(16,7)
 .E  I $L($$PC(2,38)) S BWDATA("CBEAB")=$$PC(2,38)
 .E  S BWDATA("CBEAB")=$S(BWCBEDX<1:"",BWCBEDX<3:1,1:"")
 ; if a value is set in 2.38, use as OVERRIDE for default
 ;I 'BWDATA("CBEAB"),$$PC(2,38) S BWDATA("CBEAB")=$$PC(2,38)
 S BWDATA("CBEDT")=$S(BWDATA("CBEAB"):$$CDCDT(BWCBEDT),1:"")
 Q BWCBEDX
 ; ===========================
 ; PAP
 ; ===========================
 ; PAP specimen adequacy (CDC 5.0 and above)
 ; Need to code for Bethesda 2001 and collected after 10/01/02.
SAPT() N BWSAPT
 I $G(BWMAM)!$G(BWCBE) Q ""
 S BWSAPT=$$PC(.3)
 I BWSAPT=2,$$BSU=2 S BWSAPT=1    ; code 2 only for Bethesda 1991
 I BWDT>3020930,'$L(BWSAPT) S BWSAPT=4  ; default to 4
 Q BWSAPT
 ; Find previous PAP
 ; Returns 1 if found, 2 if not, 3 if not PAP.
 ; Sets PAPDT
PPREV() Q:'BWPAP 3
 N X
 S X=$G(^BWPCD(+$$FINDLAST(1,BWDT,0),0))
 S BWDATA("PAPDT")=$$CDCDT($P(X,U,12),6)
 Q $S($L(X):1,1:2)
 ; PAP result code
 ; Sets the following:
 ;  POTHR = PAP result text
 ;  PDT   = Date of screening pap
 ;  PPAY  = Paid
 ;  PABN  = Abnormal PAP
 ;  PRES  = PAP result code
PRESLT() N BWRESN,BWBSU,BWCODE,BWTEXT
 I 'BWPAP Q ""
 I $G(BWMAM)!$$PC(2,33)!BWCBE Q ""
 Q:$D(BWDATA("PRES")) BWDATA("PRES")
 S BWRESN=+$$PC(0,5)
 I 'BWRESN S BWCODE=11,BWDATA("PWKUP")=3,BWBSU=0
 E  S BWCODE="",BWTEXT=$P($G(^BWDIAG(BWRESN,0)),U),BWBSU=$$BSU
 I BWBSU=1 D
 .S BWCODE=$P($G(^BWDIAG(BWRESN,0)),U,24)
 .S:BWCODE=7 BWDATA("POTHR")=BWTEXT
 .S BWDATA("PABN")=$S(BWCODE=14:1,1:3456[BWCODE)
 I BWBSU=2 D
 .S BWCODE=$P($G(^BWDIAG(BWRESN,1)),U)
 .S:BWCODE=8 BWDATA("POTHR")=BWTEXT
 .S BWDATA("PABN")=4567[BWCODE
 S:(BWCODE<9)!(BWCODE>10) BWDATA("PDT")=$$CDCDT(BWDT)
 I $L($$PC(2,38)) S BWDATA("PPAY")=$$PC(2,38)
 E  S BWDATA("PPAY")=$S(BWCODE<9:1,BWCODE>13:1,BWCODE>11:2,1:"")
 ; IF a value is present in 2.38, OVERRIDE accordingly (NBCCEDP PAID)
 ;I 'BWDATA("PPAY") S BWDATA("PPAY")=$$PC(2,38)
 S BWDATA("PRES")=BWCODE
 Q BWCODE
 ; ===========================
 ; Colposcopy
 ; ===========================
 ; Return piece from 0-node of colposcopy
COLPPC(BWP) ;
 S:'$D(BWDATA("COLP")) BWDATA("COLP")=$$COLP0^BWUTL4(BWIEN)
 Q $P(BWDATA("COLP"),U,BWP)
 ; Colposcopy Impression (No Biopsy)
 ; Return: 1 = Yes, 2 = No
CONOBX() Q $S($$WKUP'=1:"",$$COLPPC(4)=37:1,1:2)
 ; Colposcopy w/Biopsy
 ; Return: 1 = Yes, 2 = No
COLPBX() Q $S($$WKUP'=1:"",$$COLPPC(4)=2:1,1:2)
 ; Colposcopy final dx
 ; Sets the following:
 ;  CPSTG = final stage
 ;  CPDX  = diagnosis text
COLPDX() Q:$$WKUP'=1 ""
 N BWDX,X
 S BWDX=$$PC(0,33)
 S:'BWDX BWDX=$$COLPPC(5)
 S X=$G(^BWDIAG(+BWDX,0))
 S BWDX=$P(X,U,26)
 S:BWDX=6 BWDATA("CPSTG")=$$COLPPC(31)
 S:BWDX=7 BWDATA("CPDX")=$P(X,U)
 Q BWDX
 ; ===========================
 ; Mammography
 ; ===========================
 ; Find previous MAM
 ; Returns 1 if found, 2 if not, 3 if not MAM.
 ; Sets MAMDT
MPREV() Q:'BWMAM&'BWCBE 3
 N X
 S X=$G(^BWPCD(+$$FINDLAST("25^26^28",BWDT,0),0))
 S BWDATA("MAMDT")=$$CDCDT($P(X,U,12),6)
 Q $S($L(X):1,1:2)
 ; MAM Result Code
 ; Sets the following:
 ;  MABN = Abnormal mammogram
 ;  MDT  = Date of MAM
 ;  MPAY = MAM paid
 ;  MRES = MAM result code
MRESLT() N BWCODE,BWRESN,BWMPAY
 Q:'$G(BWMAM) $S(BWFMT=2:8,BWFMT=3:8,1:"")
 Q:$D(BWDATA("MRES")) BWDATA("MRES")
 S BWDATA("MABN")=0,BWRESN=+$$PC(0,5)
 S BWCODE=$S(BWRESN:$P(^BWDIAG(BWRESN,0),U,25),1:10),BWMPAY=$S(BWCODE=12:2,1:"")
 S BWDATA("MABN")=$S(654[BWCODE:1,1:0)
 S:(BWCODE<8)!(BWCODE>9) BWDATA("MDT")=$$CDCDT(BWDT)
 S:$$PC(0,3)<$P($G(^BWSITE(DUZ(2),0)),U,17) BWMPAY=1
 ;I BWMPAY>1 D
 ;.N BWAGE
 ;.S BWAGE=$$AGE^AUPNPAT(BWDFN)
 ;.I (BWAGE<50)!(BWAGE>65) S BWAGE=$R(100)
 ;.E  S BWAGE=1
 ;.S BWMPAY=$S(BWAGE<26:1,1:2)
 ; If BWCODE IS 8 (Not needed) or 12 (Done recently elsewhewre), blank fill the MDE
 I BWCODE=8!(BWCODE=12)!(BWCODE=9) S BWCODE=""
 I $L($$PC(2,38)) S BWDATA("MPAY")=$$PC(2,38)
 E  S BWDATA("MPAY")=1  ;$S(BWMPAY:BWMPAY,1:1)
 ; CHECK FIELD 2.38 - IF DEFINED USE VALUE DEFINED IN 2.38 AS OVERRIDE
 ;I '$G(BWDATA("MPAY")) S BWDATA("MPAY")=$$PC(2,38)
 S BWDATA("MRES")=BWCODE
 Q BWCODE
 ; Returns true if diagnostic procedure was paid
DXPAID() Q $S($L($$PC(16,6)):$$PC(16,6),$L($$PC(15,9)):$$PC(15,9),$$PC(2,22)=1:1,1:2)
 ; Conversion for Indication for Mammogram
MIND() ;
 N BWRESN
 ; If this is a pap smear, return '5 (Cervical record only, breast services not done.)
 I $G(BWPAP) Q 5
 I $G(BWCBE),'$G(BWMAM) Q 4
 S BWRESN=+$$PC(0,5)
 S BWCODE=$S(BWRESN:$P(^BWDIAG(BWRESN,0),U,25),1:10)
 ; If the result code is '8' (Not needed), and there is a CBE, set the BWCODE to 4 (Initial mammogram not done...) and return the value
 ; set "Indication for Initial mammogram) to 4 (Initial mammogram not done..)
 I BWCODE=8,$$PC(2,32) S BWCODE=4 Q BWCODE
 ; If the result code is '9' (Needed but not performed at this visit), set Indication for initial mammogram to '4'
 I BWCODE=9 S BWCODE=4 Q BWCODE
 ; If the result code is '8' and there was no CBE, set BWCODE to 5 (Cervical Record only, breast services not done.)
 S BWCODE=$S(BWRESN=8:5,BWRESN=12:3,1:"")
 I 'BWCODE S BWCODE=$$PC(16,1)
 ; If there is still no code defined, and this is a 'Mammogram Screening', return 1 - for 'Routine Screening Mammogram'.
 I 'BWCODE,BWMAM S BWCODE=1
 I 'BWCODE S BWCODE=9
 Q BWCODE
 ;
 ; Conversion for Indication for Pap Smear
PIND() ;
 ; If this is a mammogram, return '5 (Breast Record only, cervical services not done)
 I $G(BWMAM) Q 5
 I $G(BWCBE),'$G(BWMAM) Q 5
 I BWPAP,$$PC(15,1) Q $$PC(15,1)
 I BWPAP Q 1
 Q 9
 ;
 ; HPV dx
 ; Sets the following:
 ;  HPVD = HPV Date
 ;  HPVP  = HPV Paid by NBCCEDP funds
HPVDX() ;
 N HPVIDT,HPVIEN,HPVDT,HPVIEN,HPVCDT,X,HPV15,HPVRIEN,HPVDX,DTXT,HPVCHK,X1,HPVSTAT
 S HPVIDT=$O(^BWPCD("AHPV",BWIEN,0)) Q:'HPVIDT 3
 S HPVFMDT=9999999-HPVIDT
 S HPVCDT=$$CDCDT(HPVFMDT,8) S BWDATA("HPVD")=HPVCDT
 S HPVIEN=$O(^BWPCD("AHPV",BWIEN,HPVIDT,0)) ;S BWDATA("HPVP")=$S($$PC(2,38):$$PC(2,38),1:1) Q 9
 I '$D(^BWPCD(HPVIEN)) S BWDATA("HPVP")=$S($$PC(2,38):$$PC(2,38),1:2) Q 9
 S HPV15=$G(^BWPCD(HPVIEN,2))
 ; IF HPV test present, default to 1
 ; if HPV test not present, default to 2
 ; override with what is in NBCCEDP PAID
 S BWDATA("HPVP")=$P(HPV15,U,38) I 'BWDATA("HPVP") S BWDATA("HPVP")=$S($$PC(2,38):$$PC(2,38),1:1)
 S HPVRIEN=$P(^BWPCD(HPVIEN,0),U,5)
 S X=$G(^BWDIAG(+HPVRIEN,0)),X1=$G(^BWDIAG(+HPVRIEN,1))
 ; Convert 'Detected' into POSITIVE (cdc value = 1)
 ; Convert 'Not Detected' into NEGATIVE (cdc value = 2)
 ; If the value is error/disregard, convert value to 'UNKNOWN' (cdc value = 9)
 S DTXT=$P(X,U)
 S HPVCHK=$S(DTXT="Detected":1,DTXT="Not Detected":2,DTXT="Error/Disregard":9,1:"")
 I HPVCHK'="" S HPVDX=HPVCHK Q HPVDX
 S HPVDX=$P(X1,U,2)
 S:HPVDX="" HPVDX=9
 Q HPVDX
 ;
 ; Screen logic for field mam.10.04 (Final Imaging outcome)
MAM1004() ;
 N MAM1001,MAM1002,MAM1003
 I $$PC("all.6.08")'=1 Q ""
 I BWDT<3090101 Q 0
 S MAM1001=$$PC("mam.10.01"),MAM1002=$$PC("mam.10.02"),MAM1003=$$PC("mam.10.03")
 ;I ((MAM1001="")!(MAM1001=2)),((MAM1002="")!(MAM1002=2)),((MAM1003="")!(MAM1003=2)) Q 0
 I MAM1001=1!(MAM1002=1)!(MAM1003=1) Q 1
 Q 0
 ; Specimen Type
SPECTYP() ;
 N DEFSTYP
 I $G(BWCBE)!$G(BWMAM) Q ""
 ; if Bethesda system used is 'Bethesda 1991' specimen type should be blank.
 I $$PC("all.5.05")=1 Q ""
 I $$PC(.3,2)'="" Q $$PC(.3,2)
 S DEFSTYP=$$GET1^DIQ(9002086.02,$G(DUZ(2)),.24,"I") I DEFSTYP Q DEFSTYP
 ; If there was not a value in the specimen type field, and there is no default defined, return 1 - Conventional
 Q 1
MAM1005() ;
 Q 1
 N RES
 S RES=0
 I $$MAM1004(),$$PC("mam.10.04"),$$PC("mam.10.04")'=8 S RES=1
 ;Q:$$PC("mam.10.01")=1!($$PC("mam.10.02")=1)!($$PC("mam.10.03")=1) 1
 Q RES
