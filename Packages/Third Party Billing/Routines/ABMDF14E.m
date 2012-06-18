ABMDF14E ; IHS/ASDST/DMJ - Set HCFA1500 Print Array - Part 5 ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;02/26/96 3:55 PM
 ;
 ; IHS/DSD/LSL - 05/20/98 -  NOIS XIA-0398-200180
 ;               Can't get the right dental charges on bill with 00099 
 ;               HCPCS code.  Answer CPT code question in table
 ;               maintenance with CPT code and will print before any
 ;               other
 ; IHS/DSD/LSL - 05/22/98 -  NOIS NCA-0598-180077
 ;               If flat rate, corresponding dx should print all DX
 ;               in order  ie 1,2,3....
 ; IHS/ASDS/DMJ - 05/16/00 - V2.4 Patch 1 - NOIS HQW-0500-100040
 ;     Modified location code to check for satellite first.  If no
 ;     satellite, use parent.
 ; IHS/ASDS/LSL - 11/20/01 - V2.4 Patch 10 - NOIS PAB-1001-90056
 ;     Allow local HCPCS codes to print in 24D
 ; IHS/ASDS/LSL - 11/21/01 - V2.4 Patch 10 - NOIS OLC-1101-190067
 ;     When putting the dental prefix on dental codes, still need
 ;     to see tooth surface and op  site.
 ;
 ; IHS/SD/SDR - v2.5 p5 - 5/18/04 - Modified to put POS and TOS by line item
 ; IHS/SD/SDR - v2.5 p8 - task 57
 ;    Added code for MD and Rx number
 ; IHS/SD/SDR - v2.5 p10 - IM20197
 ;   Don't allow 2-line item to print on two pages
 ; IHS/SD/SDR - v2.5 p11 - IM22467
 ;   Removed splitting of block 24K (was printing provider number
 ;   one two lines)
 ;
 ; IHS/SD/SDR - v2.6 CSV
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
 S X=$P(ABMS(ABMS),U,2)                 ; Service date from
 D ^%DT
 S $P(ABMS(ABMS),U,2)=Y                 ; Service date from in FM Format
 S X=$P(ABMS(ABMS),U,3)                 ; Service date to
 D ^%DT
 S $P(ABMS(ABMS),U,3)=Y                 ; Service date to in FM format
 S ABMR(ABMS,ABMLN)=""
 S ABMR(ABMS,ABMLN)=$P(ABMS(ABMS),U,2,3) ; Form locator 24A
 ; Set Place of service                 ; Form locator 24B 
 ;   21 if visit type is inpatient
 ;   24 if visit type is ambulatory surgery
 ;   23 if clinic is emergency medicine (code 30)
 ;   11 for all other cases
 I $P(ABMS(ABMS),U,10) S $P(ABMR(ABMS,ABMLN),U,3)=$P($G(^ABMDCODE($P(ABMS(ABMS),U,10),0)),U)
 E  D
 .S $P(ABMR(ABMS,ABMLN),U,3)=$S(ABMP("VTYP")=111!($G(ABMP("BTYP"))=111):21,ABMP("VTYP")=831:24,1:11)
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
 ; Set Type of service                  ; Form locator 24C
 S $P(ABMR(ABMS,ABMLN),U,4)=$P(ABMS(ABMS),U,7)
 ; Set CPT/HCPCS                        ; Form locator 24D
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,16)]"" D
 .S $P(ABMR(ABMS,ABMLN),U,5)=$P($$CPT^ABMCVAPI($P(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0),U,16),ABMP("VDT")),U,2)  ;CSV-c
 E  I $P($G(ABMS(ABMS)),U,4)]"" D  I 1
 .S $P(ABMR(ABMS,ABMLN),U,5)=" "_$P(ABMS(ABMS),U,4)
 .; If CPT code, and modifier exists, add it
 .S $P(ABMR(ABMS,ABMLN),U,5)=" "_$P(ABMR(ABMS,ABMLN),U,5)_$S($E($P(ABMS(ABMS),U,8))="#":" "_$P($P(ABMS(ABMS),U,8)," "),1:"")
 .S:$G(ABM("EPSDT")) $P(ABMR(ABMS,ABMLN),U,9)="X"  ; Form locator 24H
 .S:$G(ABM("EMG")) $P(ABMR(ABMS,ABMLN),U,10)="X"   ; Form locator 24I
 E  D
 .I $L($P(ABMS(ABMS),U,8))>16 D  Q
 ..S ABMU("LNG")=16
 ..S ABMU("TXT")=$P(ABMS(ABMS),U,8)
 ..S ABMU=4
 ..D LNG^ABMDWRAP
 ..S ABMLND=ABMLN-1,J=0
 ..F  S J=$O(ABMU(J)) Q:+J=0!(+J>3)  D
 ...I J=2 S $P(ABMR(ABMS,ABMLND),U,5)=$G(ABMU(J))
 ...E  S $P(ABMR(ABMS,ABMLND),U)=$G(ABMU(J))
 ...S ABMLND=ABMLND+1
 ..K ABMU
 .S $P(ABMR(ABMS,ABMLN),U,5)=$P(ABMS(ABMS),U,8)
 S ABMCORDX=$P(ABMS(ABMS),U,5)
 I +ABMCORDX>4,$G(ABMP("BDFN")) D
 .S ABMCORDX=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,ABMCORDX,0)),"^",2)
 I $D(ABMP("FLAT")),$G(ABMP("BDFN")) D
 .N ABMDXCNT,ABMTMP
 .S ABMDXCNT=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,0)),U,4)
 .S:+ABMDXCNT>4 ABMDXCNT=4
 .F ABMTMP=1:1:ABMDXCNT S $P(ABMCORDX,",",ABMTMP)=ABMTMP
 ; Diagnosis code               Form locator 24E
 S $P(ABMR(ABMS,ABMLN),U,6)=ABMCORDX
 ; Charges                      Form locator 24F
 S $P(ABMR(ABMS,ABMLN),U,7)=$P(ABMS(ABMS),U)
 ; Days or units                Form locator 24G
 S $P(ABMR(ABMS,ABMLN),U,8)=$P(ABMS(ABMS),U,6)
 ; Reserved for local use       Form locator 24K
 I $P(ABMS(ABMS),"^",9)'="" D
 .S ABMLOCAL=$P(ABMS(ABMS),"^",9)
 .I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),"^",15)="RX" D
 ..S $P(ABMR(ABMS,ABMLN),U,12)=$P(ABMLOCAL,";;")  ;Prescription#
 .I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),"^",15)="MD" D
 ..S $P(ABMR(ABMS,ABMLN),U,12)=ABMLOCAL
 .K ABMLOCAL
 K ABMS(ABMS),ABMPTR,ABMCORDX
 Q
