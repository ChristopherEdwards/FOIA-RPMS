BLRRLICD ;ihs/cmi/maw - BLRRL Screen ICD based on Implementation Date ;  19-Mar-2015 09:22 ; MAW
 ;;5.2;IHS LABORATORY;**1034**;NOV 01, 1997;Build 88
 ;
 I $$CHK(Y)
 Q:$D(^ICD9(Y))
 Q
IMP(D) ;PEP - which coding system should be used:
 ;RETURN IEN of entry in ^ICDS
 ;1 = ICD9
 ;30 = ICD10
 ;will need to add subroutines for ICD11 when we have that.
 I $G(D)="" S D=DT
 NEW X,Y,Z
 I '$O(^ICDS("F",80,0)) Q 1
 S Y=""
 S X=0 F  S X=$O(^ICDS("F",80,X)) Q:X'=+X  D
 .I $P(^ICDS(X,0),U,4)="" Q   ;NO IMPLEMENTATION DATE?? SKIP IT
 .S Z($P(^ICDS(X,0),U,4))=X
 ;now go through and get the last one before it imp date is greater than the visit date
 S X=0 F  S X=$O(Z(X)) Q:X=""  D
 .I D<X Q
 .I D=X S Y=Z(X) Q
 .I D>X S Y=Z(X) Q
 I Y="" S Y=$O(Z(0)) Q Z(Y)
 Q Y
IMPOP(D) ;PEP - which coding system should be used:
 ;RETURN IEN of entry in ^ICDS
 ;1 = ICD9
 ;30 = ICD10
 ;will need to add subroutines for ICD11 when we have that.
 I $G(D)="" S D=DT
 NEW X,Y,Z
 I '$O(^ICDS("F",80.1,0)) Q 2
 S Y=""
 S X=0 F  S X=$O(^ICDS("F",80.1,X)) Q:X'=+X  D
 .I $P(^ICDS(X,0),U,4)="" Q   ;NO IMPLEMENTATION DATE?? SKIP IT
 .S Z($P(^ICDS(X,0),U,4))=X
 ;now go through and get the last one before it imp date is greater than the visit date
 S X=0 F  S X=$O(Z(X)) Q:X=""  D
 .I D<X Q
 .I D=X S Y=Z(X) Q
 .I D>X S Y=Z(X) Q
 I Y="" S Y=$O(Z(0)) Q Z(Y)
 Q Y
 ;
CHK(Y) ;EP - SCREEN OUT E CODES AND INACTIVE CODES
 NEW A,I,D,%
 I $G(DUZ("AG"))'="I" Q 1
 ;use date if available
 ;get visit date if known, if not known, use DT to determine whether to use
 ;ICD9 vs ICD10
 S D=""
 S D=$P($G(LRCDT),".")
 I D="" S D=DT
 I '$G(AUPNSEX) S AUPNSEX=$G(SEX)
 S I=$$IMP(D)  ;get ien of coding system
 S %=$$ICDDX^ICDEX(Y,D,,"I") I 1
 I $P(%,U,20)]"",$P(%,U,20)'=I Q 0   ;not correct coding system
 S I="CHKDX"_I
 G @I
 ;Q
CHKDX1 ;CODING SYSTEM 1 - ICD9
 I $E($P(%,U,2),1)="E" Q 0  ;no E codes
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 ;
CSEX ; IF 'USE WITH SEX' FIELD HAS A VALUE CHECK THAT VALUE AGAINST AUPNSEX
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
 ;
CHKDX30 ;coding system 30 - ICD10
 I $E($P(%,U,2),1)="V" Q 0  ;no codes V00-Y99 per Leslie Racine.
 I $E($P(%,U,2),1)="W" Q 0
 I $E($P(%,U,2),1)="X" Q 0
 I $E($P(%,U,2),1)="Y" Q 0
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 ;
CSEX30 ; IF 'USE WITH SEX' FIELD HAS A VALUE CHECK THAT VALUE AGAINST AUPNSEX
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
CPT ;EP - screen on CPT from V CPT .01 and V Procedure
 ;note:  DATE ADDED in the CPT table reflects the date the code was added to the local table and thus can't be used.  It should be the date added to the CPT file, AFTER CSV will be able to use it
 I $$CHKCPT(Y)
 Q:$D(^ICPT(Y))
 Q
 ;
CHKCPT(Y) ;check CPT for valid date, inactive flag
 I $G(DUZ("AG"))'="I" Q 1  ;if not an IHS facility accept all cpt codes
 NEW A,I,D,%
 ;get date if available
 S D=""
 ;check date if have date
 I D="" S D=$P($G(LRCDT),".")
 I D="" S D=DT
 ;
 S %=$$CPT^ICPTCOD(Y,D)
 I $$VERSION^XPDUTL("BCSV")]"" Q $P(%,U,7)
 S A="",I=$P(^ICPT(Y,0),U,7)
 I D]"",I]"",D>I Q 0
 Q 1
 ;
 ;
ICDOPCHK ;EP called from input tx on V PROCEDURE .01 SCREEN OUT E CODES AND INACTIVE CODES
 I $$CHKOP(Y)
 Q:$D(^ICD0(Y))
 Q
 ;
CHKOP(Y) ;EP
 ;new subroutine for CSV
 I $G(DUZ("AG"))'="I" Q 1   ;not IHS
 ;use date if available
 ;get visit date if known, if not known, use DT to determine whether to use
 ;ICD9 vs ICD10
 NEW A,I,D,%
 S D=$P($G(LRCDT),".")
 I D="" S D=DT
 S I=$$IMPOP(D)  ;get ien of coding system
 S %=$$ICDOP^ICDEX(Y,D,,"I")
 I $P(%,U,15)]"",$P(%,U,15)'=I Q 0   ;not correct coding system
 S I="CHKOP"_I G @I
 ;Q
CHKOP2 ;CODING SYSTEM 2 - ICD9
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
OPSEX ; IF 'USE WITH SEX' FIELD HAS A VALUE CHECK THAT VALUE AGAINST AUPNSEX
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
 ;
CHKOP31 ;coding system 31 - ICD10
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 ;
CSEX31 ; IF 'USE WITH SEX' FIELD HAS A VALUE CHECK THAT VALUE AGAINST AUPNSEX
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
CHKFH(Y) ;EP - SCREEN OUT E CODES AND INACTIVE CODES
 I $D(DIFGLINE) Q 1  ;take whatever mfi gives us
 NEW A,I,D,%
 S D=""
 S D=$P($G(LRCDT),".")
 I D="" S D=DT
 S I=$$IMP(D)  ;get ien of coding system
 S %=$$ICDDX^ICDEX(Y,D,,"I")
 I $P(%,U,20)]"",$P(%,U,20)'=I Q 0   ;not correct coding system
 S I="CHKFH"_I G @I
 ;
CHKFH1 ;
 S A=0 D
 .I $E($P(%,U,2),1,3)="V16" S A=1
 .I $E($P(%,U,2),1,3)="V17" S A=1
 .I $E($P(%,U,2),1,3)="V18" S A=1
 .I $E($P(%,U,2),1,3)="V19" S A=1
 .I $P(%,U,2)=".9999" S A=1
 I 'A Q 0
 I $$VERSION^XPDUTL("BCSV")]"" Q $P(%,U,10)
 S A=$P($G(^ICD9(Y,9999999)),U,4),I=$P(^ICD9(Y,0),U,11)
 I D]"",I]"",D>I Q 0
 I D]"",A]"",D<A Q 0
 Q 1
CHKFH30 ;
 S A=0 D
 .I $E($P(%,U,2),1,3)="Z80" S A=1
 .I $E($P(%,U,2),1,3)="Z81" S A=1
 .I $E($P(%,U,2),1,3)="Z82" S A=1
 .I $E($P(%,U,2),1,3)="Z83" S A=1
 .I $E($P(%,U,2),1,3)="Z84" S A=1
 .I $P(%,U,2)="ZZZ.999" S A=1
 I 'A Q 0
 I $$VERSION^XPDUTL("BCSV")]"" Q $P(%,U,10)
 S A=$P($G(^ICD9(Y,9999999)),U,4),I=$P(^ICD9(Y,0),U,11)
 I D]"",I]"",D>I Q 0
 I D]"",A]"",D<A Q 0
 Q 1
CHKE ;EP - ECODE SCREEN
 I $$CHKE1(Y)
 Q:$D(^ICD9(Y))
 Q
CHKE1(Y) ;EP SCREEN OUT E CODES AND INACTIVE CODES
 NEW A,I,D,%
 I $G(DUZ("AG"))'="I" Q 1
 ;use date if available
 ;get visit date if known, if not known, use DT to determine whether to use
 ;ICD9 vs ICD10
 S D=""
 S D=$P($G(LRCDT),".")
 I D="" S D=DT
 S I=$$IMP(D)  ;get ien of coding system
 S %=$$ICDDX^ICDEX(Y,D,,"I")
 I $P(%,U,20)]"",$P(%,U,20)'=I Q 0   ;not correct coding system
 S I="CHKEX"_I G @I
 ;Q
CHKEX1 ;CODING SYSTEM 1 - ICD9
 I $E($P(%,U,2),1)'="E" Q 0  ;only E codes
 I $$VERSION^XPDUTL("BCSV")]"",'$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 I $$VERSION^XPDUTL("BCSV")]"" G CSEX
 S A=$P($G(^ICD9(Y,9999999)),U,4),I=$P(^ICD9(Y,0),U,11)
 I D]"",I]"",D>I Q 0
 I D]"",A]"",D<A Q 0
 Q 1
 ;
CHKEX30 ;coding system 30 - ICD10
 NEW J
 S J=0
 I $E($P(%,U,2),1)="V" S J=1  ;only codes V00-Y99 per Leslie Racine.
 I $E($P(%,U,2),1)="W" S J=1
 I $E($P(%,U,2),1)="X" S J=1
 I $E($P(%,U,2),1)="Y" S J=1
 I 'J Q 0
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 Q 1
FHCHK ;PEP - called from input tx on FAMILY HISTORY .01 field
 ;screen out all codes but V16-V19 and make sure it is active as of date being entered
 ;IHS/CMI/LAB - AUPN*99.1*7 - begin mods 02/15/2002
 I $$CHKFH(Y)
 Q:$D(^ICD9(Y))
 Q
EOP ;
 S AUPNQ=0
 NEW DIR
 NEW DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR K DIR
 I $D(DUOUT) S AUPNQ=1 Q
 W:$D(IOF) @IOF
 Q
 ;
PLACE ;EP - ECODE SCREEN
 I $$CHKPL(Y)
 Q:$D(^ICD9(Y))
 Q
CHKPL(Y) ; SCREEN OUT E CODES AND INACTIVE CODES
 NEW A,I,D,%
 I $G(DUZ("AG"))'="I" Q 1
 ;use date if available
 ;get visit date if known, if not known, use DT to determine whether to use
 ;ICD9 vs ICD10
 S D=""
 S D=$P($G(LRCDT),".")
 I D="" S D=DT
 ;;S D=3140101
 S I=$$IMP(D)  ;get ien of coding system
 S %=$$ICDDX^ICDEX(Y,D,,"I")
 I $P(%,U,20)]"",$P(%,U,20)'=I Q 0   ;not correct coding system
 S I="CHKPL"_I G @I
 ;Q
CHKPL1 ;CODING SYSTEM 1 - ICD9
 I $E($P(%,U,2),1,4)'="E849" Q 0  ;only place of occurence
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 Q 1
 ;
CHKPL30 ;coding system 30 - ICD10
 NEW J
 S J=0
 I $E($P(%,U,2),1,3)="Y92" S J=1  ;only codes XXX per Leslie Racine.
 I 'J Q 0
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 Q 1
RFB ;EP - ECODE SCREEN
 I $$CHKRFB(Y)
 Q:$D(^ICD9(Y))
 Q
CHKRFB(Y) ; SCREEN Z18-Z18.9
 NEW A,I,D,%
 I $G(DUZ("AG"))'="I" Q 1
 ;use date if available
 ;get visit date if known, if not known, use DT to determine whether to use
 ;ICD9 vs ICD10
 S D=""
 S D=$P($G(LRCDT),".")
 I D="" S D=DT
 S I=$$IMP(D)  ;get ien of coding system
 I I'=30 Q 0
 S %=$$ICDDX^ICDEX(Y,D,,"I")
 I $P(%,U,20)'=I Q 0   ;not correct coding system
 S I="CHKRFB"_I G @I
 ;Q
CHKRFB1 ;CODING SYSTEM 1 - ICD9
 ;
CHKRFB30 ;coding system 30 - ICD10
 NEW J
 S J=0
 I $E($P(%,U,2),1,3)="Z18" S J=1  ;only codes Z18 per Leslie Racine.
 I 'J Q 0
 I '$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 Q 1
CONC(IN) ;PEP - called to return ICD codes for a snomed concept ID
 ;Input
 ; OUT - Output variable/global to return information in (VAR)
 ;  IN - P1 - The Concept Id to look up
 ;     - P2 (Optional) - The code set Id (default SNOMED '36')
 ;     - P3 (Optional) - Snapshot Date to check (default DT)
 ;     - P4 (Optional) - LOCAL - Pass 1 to perform local listing, otherwise leave
 ;                       blank for remote listing
 ;     - P5 (Optional) - DEBUG - Pass 1 to display debug information
 ;     - P6 (Optional) - Patient DFN (currently not in use) 11/4/14
 ;
 ;Output
 ; Function returns - [1]^[2]^[3]^[4]
 ; [1] - Description Id of Fully Specified Name
 ; [2] - Fully Specified Name
 ; [3] - Description Id of Preferred Term
 ; [4] - Preferred Term
 ; [5] - Mapped ICD Values (based on P3 Snapshot Date)
 ; [6] - Mapped ICD9 Values
 NEW AUPNP,AUPNIN1,AUPNV,AUPND,AUPNI,AUPNIMP,AUPNZ,AUPNY,AUPNDFN
 S AUPNDFN=$P(IN,U,6)  ;PATIENT DFN - MAY BE USED IN THE FUTURE
 S AUPNIN1=$P(IN,U,1,5)  ;value to pass to BSTS
 S AUPND=$P(IN,U,3) S:AUPND="" AUPND=DT  ;DATE FOR CODES
 S AUPNV=$$CONC^BSTSAPI(AUPNIN1)
 ;GET ICD CODES FROM 5TH PIECE
 S AUPNI=$P(AUPNV,U,5)  ;ICD CODES RETURNED
 I AUPNI="" S $P(AUPNV,U,5)=$$UNCODE(AUPND) Q AUPNV   ;if there are no icd codes pass back the uncoded in 5th piece
 ;PARSE OUT ALL CODES AND SET TO UNCODED IF IT FAILS INPUT TRANSFORM OF .01 OF V POV
 S AUPNIMP=$$IMP(AUPND)  ;ICD IMPLEMENTATION
 F AUPNZ=1:1 S AUPNY=$P(AUPNI,";",AUPNZ) Q:AUPNY=""  D
 .I AUPNY'["." S AUPNY=AUPNY_".",$P(AUPNI,";",AUPNZ)=AUPNY
 .S AUPNP=$$ICDDX^ICDEX(AUPNY,AUPND,,"E")
 .I $P(AUPNP,U,1)="-1" S $P(AUPNI,";",AUPNZ)=$$UNCODE(AUPND) Q  ;NOT AN ICD CODE
 .I '$P(AUPNP,U,10) S $P(AUPNI,";",AUPNZ)=$$UNCODE(AUPND) Q  ;INACTIVE AS OF AUPND
 .Q
 S $P(AUPNV,U,5)=AUPNI
 Q AUPNV
UNCODE(D) ;
 I $G(D)="" S D=DT
 NEW I
 S I=$$IMP(D)
 Q $S(I=30:"ZZZ.999",1:".9999")
 ;
