ABMDF27E ; IHS/ASDST/DMJ - Set HCFA1500 Print Array - Part 5 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**3,4,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM25331 - Put taxonomy code if NPI ONLY
 ; IHS/SD/SDR - v2.5 p12 - IM25352 - Included fix supplied by Walt Reich (PIMC)
 ;   Put space between anes. data for readability
 ; IHS/SD/SDR - v2.5 p13 - IM25899 - Alignment changes
 ; IHS/SD/SDR,AML - v2.5 p13 - NO IM - Change for satellite prov# in 24k
 ; IHS/SD/SDR,AML - abm*2.6*3 - NOHEAT - Correction to box 24K when NPI or not
 ; IHS/SD/SDR - abm*2.6*4 - HEAT12115 - Allow 5+ DX codes
 ;
 ; *********************************************************************
 ;
EMG ;EP for setting Emerg or Special Prog variable
 S (ABM,ABM("EPSDT"))=0
 F  S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,ABM)) Q:'ABM  D
 .S ABM("X")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,ABM,0),U)
 .Q:ABM("X")=""
 .I $P(^ABMDCODE(ABM("X"),0),U)["EPSDT"!($P(^(0),U))["FAMILY" S ABM("EPSDT")=1
 S ABM("EMG")=$S($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),U,5)="Y":1,1:0)
 Q
 ;
PROC ;EP for setting the procedure portion of the ABMF array
 ; input vars: ABMS(ABMS) - the procedure line in internal format
 ;             ABMS("I")  - the current line number
 ;
 ; output vars: ABMF(ABMS("I"))   - procedure line in external format
 ;              ABMF(ABMS("I")-1) - top line for extended descriptions
 ;
 K %DT
 S ABMFDT=$P(ABMS(ABMS),U,2)  ;Service date from
 S X=$P($P(ABMS(ABMS),U,2),"@")  ;Service date from
 D ^%DT
 S $P(ABMS(ABMS),U,2)=Y                 ; Service date from in FM Format
 S ABMTDT=$P(ABMS(ABMS),U,3)  ;Service date to
 S X=$P($P(ABMS(ABMS),U,3),"@")  ;Service date to
 D ^%DT
 S $P(ABMS(ABMS),U,3)=Y                 ; Service date to in FM format
 S ABMR(ABMS,ABMLN)=""
 S ABMR(ABMS,ABMLN)=$P(ABMS(ABMS),U,2,3) ; Form locator 24A
 ;check if time on charge (anes); if so, add as line 1
 I ABMFDT["@" D
 .S $P(ABMR(ABMS,ABMLN-1),U)="7Begin "_$TR($P(ABMFDT,"@",2),":")
 .S $P(ABMR(ABMS,ABMLN-1),U)=$P(ABMR(ABMS,ABMLN-1),U)_" End "_$TR($P(ABMTDT,"@",2),":")
 ;
 ; Set Place of service                 ; Form locator 24B 
 ;   21 if visit type is inpatient
 ;   24 if visit type is ambulatory surgery
 ;   23 if clinic is emergency medicine (code 30)
 ;   11 for all other cases
 I $P(ABMS(ABMS),U,10) S $P(ABMR(ABMS,ABMLN),U,3)=$P($G(^ABMDCODE($P(ABMS(ABMS),U,10),0)),U)
 E  D
 .S $P(ABMR(ABMS,ABMLN),U,3)=$S(ABMP("VTYP")=111!($G(ABMP("BTYP"))=111):21,ABMP("BTYP")=831:24,1:11)
 .;   if Place of service set to 11 check to see if pointer exists 
 .;   in Parameter file to Code file and use it
 .I $P(ABMR(ABMS,ABMLN),U,3)=11 D
 ..S ABMPTR=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),"^",6)
 ..S:ABMPTR="" ABMPTR=$P($G(^ABMDPARM(DUZ(2),1,3)),"^",6) Q:'ABMPTR
 ..Q:'$D(^ABMDCODE(ABMPTR,0))
 ..S $P(ABMR(ABMS,ABMLN),U,3)=$P(^ABMDCODE(ABMPTR,0),U)
 .I $P($G(^DIC(40.7,+ABMP("CLN"),0)),"^",2)=30 D
 ..S $P(ABMR(ABMS,ABMLN),U,3)=23
 ;
 ; Set CPT/HCPCS                        ; Form locator 24D
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,16)]"" D
 .S $P(ABMR(ABMS,ABMLN),U,5)=$P($$CPT^ABMCVAPI($P(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0),U,16),ABMP("VDT")),U,2)  ;CSV-c
 E  I $P($G(ABMS(ABMS)),U,4)]"" D  I 1
 .S $P(ABMR(ABMS,ABMLN),U,5)=" "_$P(ABMS(ABMS),U,4)
 .; If CPT code, and modifier exists, add it
 .S $P(ABMR(ABMS,ABMLN),U,5)=" "_$P(ABMR(ABMS,ABMLN),U,5)_$S($E($P(ABMS(ABMS),U,8))="#":" "_$P($P(ABMS(ABMS),U,8)," "),1:"")
 .S:$G(ABM("EPSDT")) $P(ABMR(ABMS,ABMLN),U,9)="X"  ; Form locator 24H
 .S:$G(ABM("EMG")) $P(ABMR(ABMS,ABMLN),U,4)="X"   ; Form locator 24C
 ;E  D  ;abm*2.6*7 HEAT30524
 ;start old code abm*2.6*8
 ;I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,16)]"" D  ;abm*2.6*7 HEAT30524
 ;.I $L($P(ABMS(ABMS),U,8))>16 D  Q
 ;..S ABMU("LNG")=60
 ;..S ABMU("TXT")=$P(ABMS(ABMS),U,8)
 ;..S ABMU=3
 ;..D LNG^ABMDWRAP
 ;..S ABMLND=ABMLN-1,J=0
 ;..F  S J=$O(ABMU(J)) Q:+J=0!(+J>2)  D
 ;...S $P(ABMR(ABMS,ABMLND),U)=$G(ABMU(J))
 ;...S ABMLND=ABMLND+1
 ;.K ABMU
 ;.S $P(ABMR(ABMS,ABMLN),U,5)=$P(ABMS(ABMS),U,8)
 ;end old code start new code
 I $L($P(ABMS(ABMS),U,8))>16,($E($P(ABMS(ABMS),U,8),1,2)="N4") D
 .S ABMU("LNG")=60
 .S ABMU("TXT")=$P(ABMS(ABMS),U,8)
 .S ABMU=3
 .D LNG^ABMDWRAP
 .S ABMLND=ABMLN-1,J=0
 .F  S J=$O(ABMU(J)) Q:+J=0!(+J>2)  D
 ..S $P(ABMR(ABMS,ABMLND),U)=$G(ABMU(J))
 ..S ABMLND=ABMLND+1
 .K ABMU
 E  S:($E($P(ABMS(ABMS),U,8),1,2)="N4") $P(ABMR(ABMS,ABMLN),U,5)=$P(ABMS(ABMS),U,8)
 ;end new code abm*2.6*8
 S ABMCORDX=$P(ABMS(ABMS),U,5)
 ;I +ABMCORDX>4,$G(ABMP("BDFN")) D  ;abm*2.6*4 HEAT12115
 I +ABMCORDX>8,$G(ABMP("BDFN")) D  ;abm*2.6*4 HEAT12115
 .S ABMCORDX=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,ABMCORDX,0)),"^",2)
 I $D(ABMP("FLAT")),$G(ABMP("BDFN")) D
 .N ABMDXCNT,ABMTMP
 .S ABMDXCNT=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,0)),U,4)
 .S:+ABMDXCNT>4 ABMDXCNT=4
 .F ABMTMP=1:1:ABMDXCNT S $P(ABMCORDX,",",ABMTMP)=ABMTMP
 ; Diagnosis code               Form locator 24E
 S $P(ABMR(ABMS,ABMLN),U,6)=$TR(ABMCORDX,",")
 ; Charges                      Form locator 24F
 S $P(ABMR(ABMS,ABMLN),U,7)=$P(ABMS(ABMS),U)
 ; Days or units                Form locator 24G
 S $P(ABMR(ABMS,ABMLN),U,8)=$P(ABMS(ABMS),U,6)
 ; Reserved for local use       Form locator 24K (1)
 I $P(ABMS(ABMS),"^",9)'="" D
 .S ABMLOCAL=$P(ABMS(ABMS),"^",9)
 .I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),"^",15)="MD" D
 ..S $P(ABMR(ABMS,ABMLN-1),U,3)=ABMLOCAL
 .K ABMLOCAL
 ;S:($P(ABMS(ABMS),U,11)&($G(ABMP("NPIS"))'="")&(ABMP("NPIS")'="N")) $P(ABMR(ABMS,ABMLN-1),U,3)=$P(ABMS(ABMS),U,9)  ;abm*2.6*3 NOHEAT
 ;S:($P(ABMS(ABMS),U,11)&($G(ABMP("NPIS"))'="")&(ABMP("NPIS")'="N")) $P(ABMR(ABMS,ABMLN-1),U,3)="ZZ "_$P(ABMS(ABMS),U,9)  ;abm*2.6*8 HEAT31586
 ;start new code abm*2.6*8 HEAT31586
  I $G(ABMP("EXP"))=27 D
 .S:+$G(ABMDUZ2)=0 ABMDUZ2=DUZ(2)
 .S ABMPQ=$S(ABMP("ITYPE")="R":"1C"_" ",ABMP("ITYPE")="D":"1D"_" ",$P($G(^ABMNINS(ABMDUZ2,ABMP("INS"),1,ABMP("VTYP"),1)),U)'="":$P($G(^ABMREFID($P($G(^ABMNINS(ABMDUZ2,ABMP("INS"),1,ABMP("VTYP"),1)),U),0)),U),1:"0B"_" ")
 I ($P(ABMS(ABMS),U,11)&($G(ABMP("NPIS"))'="")&(ABMP("NPIS")'="N")) D
 .S $P(ABMR(ABMS,ABMLN-1),U,2)=ABMPQ
 .S $P(ABMR(ABMS,ABMLN-1),U,3)=$P(ABMS(ABMS),U,9)
 ;end new code HEAT31586
 I $G(ABMP("ITYPE"))="R"&($G(ABMP("BTYP"))="831") S $P(ABMR(ABMS,ABMLN-1),U,3)=""
 S:$P(ABMS(ABMS),U,11) $P(ABMR(ABMS,ABMLN),U,11)=$P(ABMS(ABMS),U,11)  ;Form Locator 24K (2)
 K ABMS(ABMS),ABMPTR,ABMCORDX
 Q
