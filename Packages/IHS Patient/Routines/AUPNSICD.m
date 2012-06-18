AUPNSICD ; IHS/CMI/LAB - Screen Purpose of Visit/ICD9 codes 24-MAY-1993 ; 
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;IHS/TUCSON/LAB - added checks for filegram and CHS, do not
 ;execute screen if in chs or filegrams 03/18/96 PATCH 4
 I $$CHK(Y)
 Q:$D(^ICD9(Y))
 Q
CHK(Y) ; SCREEN OUT E CODES AND INACTIVE CODES
 NEW A,I,D,%
 S %=$$ICDDX^ICDCODE(Y)  ;CSV
 I $E($P(%,U,2),1)="E" Q 0  ;no E codes
 I $D(DIFGLINE) Q 1
 I $D(ACHSDIEN) Q 1
 I $G(DUZ("AG"))'="I" Q 1
 ;use date if available
 S D=""
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .I $P(^AUPNVSIT(APCDVSIT,0),U,7)="H",$$DSCHDATE^APCLV(APCDVSIT)]"" S D=$$DSCHDATE^APCLV(APCDVSIT) Q
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 I D="" S D=$G(APCDDATE)
 I D="" S D=DT
 S %=$$ICDDX^ICDCODE(Y,D)  ;CSV
 I $$VERSION^XPDUTL("BCSV")]"",'$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 I $$VERSION^XPDUTL("BCSV")]"" G CSEX
 S A=$P($G(^ICD9(Y,9999999)),U,4),I=$P(^ICD9(Y,0),U,11)
 I D]"",I]"",D>I Q 0
 I D]"",A]"",D<A Q 0
 ;
CSEX ; IF 'USE WITH SEX' FIELD HAS A VALUE CHECK THAT VALUE AGAINST AUPNSEX
 I '$D(AUPNSEX) Q 1
 ;I $P(^ICD9(Y,0),U,10)]"",$P(^ICD9(Y,0),U,10)'=AUPNSEX Q 0
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
 ;
CPT ;EP - screen on CPT from V CPT .01 and V Procedure
 ;note:  DATE ADDED in the CPT table reflects the date the code was added to the local table and thus can't be used.  It should be the date added to the CPT file, AFTER CSV will be able to use it
 I $$CHKCPT(Y)
 Q:$D(^ICPT(Y))
 Q
 ;
CHKCPT(Y) ;check CPT for valid date, inactive flag
 I $D(APCDOVR) Q 1  ;override for something
 I $D(DIFGLINE) Q 1  ;if in MFI accept all cpt codes
 I $D(ACHSDIEN) Q 1  ;if in CHS link accept all cpt codes
 I $G(DUZ("AG"))'="I" Q 1  ;if not an IHS facility accept all cpt codes
 NEW A,I,D,%
 ;get date if available
 S D=""
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .I $P(^AUPNVSIT(APCDVSIT,0),U,7)="H",$$DSCHDATE^APCLV(APCDVSIT)]"" S D=$$DSCHDATE^APCLV(APCDVSIT) Q
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 ;check date if have date
 I D="" S D=$G(APCDDATE)
 I D="" S D=DT
 ;
 S %=$$CPT^ICPTCOD(Y,D)
 I $$VERSION^XPDUTL("BCSV")]"" Q $P(%,U,7)
 S A="",I=$P(^ICPT(Y,0),U,7)
 I D]"",I]"",D>I Q 0
 Q 1
 ;I D]"",A]"",D<A Q 0
 ;
 ;
ICDOPCHK ;EP called from input tx on V PROCEDURE .01 SCREEN OUT E CODES AND INACTIVE CODES
 I $$CHKOP(Y)
 Q:$D(^ICD0(Y))
 Q
 ;
CHKOP(Y) ;
 ;new subroutine for CSV
 I $D(DIFGLINE) Q 1  ;in MFI
 I $D(ACHSDIEN) Q 1  ;in CHS
 I $G(DUZ("AG"))'="I" Q 1   ;not IHS
 NEW A,I,D,%
 S D=""
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .I $P(^AUPNVSIT(APCDVSIT,0),U,7)="H",$$DSCHDATE^APCLV(APCDVSIT)]"" S D=$$DSCHDATE^APCLV(APCDVSIT) Q
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 ;check date if have date
 I D="" S D=$G(APCDDATE)
 I D="" S D=DT
 S %=$$ICDOP^ICDCODE(Y,D)
 I $$VERSION^XPDUTL("BCSV")]"",'$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 I $$VERSION^XPDUTL("BCSV")]"" G OPSEX
 S A="",I=$P(^ICD0(Y,0),U,11)
 I D]"",I]"",D>I Q 0
 I D]"",A]"",D<A Q 0
OPSEX ; IF 'USE WITH SEX' FIELD HAS A VALUE CHECK THAT VALUE AGAINST AUPNSEX
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
 ;
CHKFH(Y) ; SCREEN OUT E CODES AND INACTIVE CODES
 I $D(DIFGLINE) Q 1  ;take whatever mfi gives us
 NEW A,I,D,%
 S %=$$ICDDX^ICDCODE(Y)  ;CSV
 S A=0 D
 .I $E($P(%,U,2),1,3)="V16" S A=1
 .I $E($P(%,U,2),1,3)="V17" S A=1
 .I $E($P(%,U,2),1,3)="V18" S A=1
 .I $E($P(%,U,2),1,3)="V19" S A=1
 I 'A Q 0
 S D=$G(APCDDATE)
 I D="" S D=DT
 S %=$$ICDDX^ICDCODE(Y,D)
 I $$VERSION^XPDUTL("BCSV")]"" Q $P(%,U,10)
 S A=$P($G(^ICD9(Y,9999999)),U,4),I=$P(^ICD9(Y,0),U,11)
 I D]"",I]"",D>I Q 0
 I D]"",A]"",D<A Q 0
 Q 1
 ;
CHKE ;EP - ECODE SCREEN
 I $$CHKE1(Y)
 Q:$D(^ICD9(Y))
 Q
CHKE1(Y) ; SCREEN OUT E CODES AND INACTIVE CODES
 NEW A,I,D,%
 S %=$$ICDDX^ICDCODE(Y)  ;CSV
 I $E($P(%,U,2),1)'="E" Q 0  ;only E codes
 I $D(DIFGLINE) Q 1
 I $D(ACHSDIEN) Q 1
 ;use date if available
 S D=""
 I $G(APCDVSIT),$D(^AUPNVSIT(APCDVSIT)) D
 .I $P(^AUPNVSIT(APCDVSIT,0),U,7)="H",$$DSCHDATE^APCLV(APCDVSIT)]"" S D=$$DSCHDATE^APCLV(APCDVSIT) Q
 .S D=$P($P(^AUPNVSIT(APCDVSIT,0),U),".")
 I D="" S D=$G(APCDDATE)
 I D="" S D=DT
 S %=$$ICDDX^ICDCODE(Y,D)  ;CSV
 I $$VERSION^XPDUTL("BCSV")]"",'$P(%,U,10) Q 0  ;STATUS IS INACTIVE
 I $$VERSION^XPDUTL("BCSV")]"" G CSEXE
 S A=$P($G(^ICD9(Y,9999999)),U,4),I=$P(^ICD9(Y,0),U,11)
 I D]"",I]"",D>I Q 0
 I D]"",A]"",D<A Q 0
 ;
CSEXE ; IF 'USE WITH SEX' FIELD HAS A VALUE CHECK THAT VALUE AGAINST AUPNSEX
 I '$D(AUPNSEX) Q 1
 I $P(%,U,11)]"",$P(%,U,11)'=AUPNSEX Q 0
 Q 1
FHCHK ;PEP - called from input tx on FAMILY HISTORY .01 field
 ;screen out all codes but V16-V19 and make sure it is active as of date being entered
 ;IHS/CMI/LAB - AUPN*99.1*7 - begin mods 02/15/2002
 I $$CHKFH(Y)
 Q:$D(^ICD9(Y))
 Q
