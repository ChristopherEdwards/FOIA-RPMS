ABMDLCK1 ; IHS/ASDST/DMJ - check visit for elig - CONT'D ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;;Y2K/OK - IHS/ADC/JLG 12-18-97
 ;Original;TMD;
 ; Code has been added to use the billing limit from the parameters file
 ; if no back billing limit has been set for the insurer.  ;JLG 4/8/98
 ;
 ; IHS/DSD/JLG - 6/29/1999 - NOIS HQW-0798-100082 Patch 3 #4
 ;    Modified to capture reason for ineligibility, for programmers use
 ;
 ; IHS/DSD/MRS - 8/27/1999 - NOIS XAA-0899-200058 Patch 3 #13
 ;    Modified to prevent generating out-patient claims for Medicare
 ;    with Part A only
 ;
 ; IHS/ASDS/LSL - 06/26/2001 - V2.4 Patch 9 - NOIS HQW-0798-100082
 ;    Modified to expand no eligibility found.  Reasons 42-58 can be
 ;    found in this routine. Changes are not documented inside routine.
 ;    I will take responsibility for the entire routine for patch 9.
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM19802
 ;   Fixed check for error 56 (user would get error if any provider met
 ;   criteria
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20771
 ;   Added check for outpatient visit and patient has MCR Part A only
 ;
 ; *********************************************************************
 ;
CHK ;EP for setting elig hit
 N V,X,X1,X2,ABMNON,INSM
 ; If node 2 in the insurer file is missing no entry in ABML
INS2 ;
 S ABM("INS2")=$G(^AUTNINS(ABM("INS"),2))
 I ABM("INS2")="" D  Q
 .S $P(ABML(99,ABM("INS")),U,6)=42
 .S ABM("XIT")=1
 ;
 ; This is checking for insurer merged to another.  It keeps looping
 ; until if finds an insurer that has not been merged to another.  If it
 ; ever finds the "merged to" insurer is one that was previously found
 ; as "merged from" it quits and there is no entry in ABML.
 ;
 Q:$D(INSM(ABM("INS")))
 S INSM(ABM("INS"))=""
 I $P(ABM("INS2"),U,7)]"" D  G INS2
 .S ABM("INS")=$P(ABM("INS2"),U,7)
 Q:$D(ABMLX(ABM("INS")))
 ; Piece 7 is the status field.  No entry in ABML if status unbillable
 ; 43 ; Insurer designated as unbillable
 I $P($G(^AUTNINS(ABM("INS"),1)),U,7)=4 S $P(ABML(99,ABM("INS")),U,6)=43 Q
 ;
 ; Check both the default in the parameter file & in the insurer file
 ; for backbill limit.  Use the one from the insurer file if it exists.
 ;
 N ABMDBBL,ABMBBL
 S ABMDBBL=$P(^ABMDPARM(DUZ(2),1,0),U,16)
 S ABMBBL=$S($P(ABM("INS2"),U,4):$P(ABM("INS2"),U,4),1:ABMDBBL)
 I ABMBBL>0 D  I ABMVDT<X S ABMNON="B-BBL" G CHK2
 .S X1=DT
 .S X2=0-(ABMBBL*30.417)
 .D C^%DTC
 S:'$D(ABMVT) ABMVT=$$VTYP^ABMDVCK1(ABMVDFN,$G(SERVCAT),ABM("INS"),$G(ABMCLN))
 S V=$G(^ABMNINS(DUZ(2),ABM("INS"),1,+ABMVT,0))
 ;
 ; V is the Visit type multiple of the insurer file, p 7 billable
 ; If not billable set ABMNON
 ;
 I ABMVT,$P(V,U,7)="N" S ABMNON="UB-VT"
 I ABMVT,$P(V,U,14)>ABMVDT D
 .S ABMNON="BF-SD"
 .I '$O(ABML(ABM("PRI")),-1) S ABM("BEFSD")=1
 ;
 ; billing start date later than visit date & this insurer is primary
 G CHK2:'$G(ABMCLN)         ;Jmp to CHK2 if no clinic
 I $P(ABM("INS2"),U,5)="O",$P(^DIC(40.7,ABMCLN,0),U,2)'=56 S ABMNON="OD-ND"
 ;
 ; ABM("INS2") is node 2 of insurer file. Checking dental billing status
 ; In piece 5 O means only dental billable, U means dental unbillable
 ; Clinic stop 56 is dental, 39 is pharmacy
 E  I $P(^DIC(40.7,ABMCLN,0),U,2)=56,$P(ABM("INS2"),U,5)="U" S ABMNON="UB-D"
 E  I $P(^DIC(40.7,ABMCLN,0),U,2)=39,$P(ABM("INS2"),U,3)="U" S ABMNON="UB-P"
 S ABM=0
 F  S ABM=$O(^AUTNINS(ABM("INS"),17,ABM)) Q:'ABM  D  Q:$D(ABMNON)
 .I +^AUTNINS(ABM("INS"),17,ABM,0)=ABMCLN S ABMNON="UB-CL"
CHK2 ;
 ;
 N T,P,SDT,EDT
 S (SDT,EDT)=""
 I ABM("TYP")?1(1"M",1"R"),$D(ABM("REC")) D
 .;check if patient only has part A; mark as unbillable if outpatient
 .S ABMCB="M"
 .S:$$PARTB^ABMDSPLB(DFN,ABMVDT) ABMCB=1
 .I $G(ABMCB)="M",($G(ABMP("VTYP"))'=111)&($G(ABMVT)'=111) S ABMNON="UB-PA"
 .Q:ABM("REC")<ABMVDT&((ABMDISDT<$P(ABM("REC"),U,2))!'$P(ABM("REC"),U,2))
 .S SDT=$S(ABMVDT<ABM("REC"):+ABM("REC"),1:"")
 .S EDT=$S($P(ABM("REC"),U,2)<ABMDISDT:$P(ABM("REC"),U,2),1:"")
 E  I ABM("TYP")="D" D
 .Q:ABM("NDFN")=""
 .Q:ABM("NDFN")<ABMVDT&((ABMDISDT<$P(ABM("SUB"),U,2))!'$P(ABM("SUB"),U,2))
 .S SDT=$S(ABMVDT<ABM("NDFN"):ABM("NDFN"),1:"")
 .S EDT=$S($P(ABM("SUB"),U,2)<ABMDISDT:$P(ABM("SUB"),U,2),1:"")
 S T=$S(ABM("TYP")'="P":ABM("TYP"),$$ACCREL^ABMDLCK(ABM("MDFN")):"A",1:"P")
 I ABM("PRIMARY")=ABM("INS"),$P($G(ABML(1,+$O(ABML(1,"")))),U,3)'?1(1"W",1"A") S ABM("PRI")=1
 E  I ABM("PRIMARY")=ABM("INS"),T="A" S ABM("PRI")=1
 N UBILL
 I $D(ABMNON) D
 .I ABMNON="UB-VT" S UBILL=44 Q   ;Unbillable visit type
 .I ABMNON="B-BBL" S UBILL=45 Q   ;Before back billing limit
 .I ABMNON="OD-ND" S UBILL=46 Q   ;Non dental visit for dental ins.
 .I ABMNON="BF-SD" S UBILL=47 Q   ;Before billing start date
 .I ABMNON="UB-D" S UBILL=48 Q    ;Dental not billable
 .I ABMNON="UB-P" S UBILL=49 Q    ;Pharmacy not billable
 .I ABMNON="UB-CL" S UBILL=50 Q   ;Clinic not billable
 .I ABMNON="UB-PA" S UBILL=28 Q  ;outpatient with MCR part A only
 I +$G(UBILL) D
 .S $P(ABML(99,ABM("INS")),"^",6)=UBILL
 .S ABM("XIT")=1
 S ABML(ABM("PRI"),ABM("INS"))=$S(T="D":ABM("MDFN"),1:"")_U_$S(T="D":ABM("NDFN"),T="W"&($G(ABMWCIEN)):ABMWCIEN,1:ABM("MDFN"))_U_T_U_SDT_U_EDT_U_$G(UBILL)
 I ABMVDFN D
 .S ABM=""
 .F  S ABM=$O(^AUPNVPRV("AD",ABMVDFN,ABM)) Q:'ABM  D  Q:$$PRVX^ABMDLCK3(P)
 ..S P=+^AUPNVPRV(ABM,0)
 .I '$G(ABM("PRV")) D  Q:'ABM("ORDPRV")
 ..S:'$D(ABM("ORDPRV")) ABM("ORDPRV")=$$ORPHAN^ABMDVCK2(ABMVDFN)
 ..S:'ABM("ORDPRV") ABMNON="NO-VP",$P(ABML(99,ABM("INS")),U,6)=56
 ; 56 ; Missing provider not allowed
 I $D(ABMNON) S ABM("XIT")=1 Q
 Q:'ABM("COV")
 S ABM("CV")=$O(ABML(ABM("PRI"),ABM("INS"),"COV",""))
 S:ABM("CV")="" ABM("CV")=$O(ABML(99,ABM("INS"),"COV",""))
 S ABML(ABM("PRI"),ABM("INS"),"COV",ABM("COV"))=$G(COV)
 Q:'$G(ABMVDFN)!'$G(ABMCLN)
 ;
 ; The code below here is checking to see if this visit is not 
 ; covered.  If not priority is changed to 99.
 ;
 Q:$G(ABM("EMPL REL"))=1          ;This is for workmans comp
 S:'$D(ABMVT) ABMVT=$$VTYP^ABMDVCK1(ABMVDFN,$G(SERVCAT),ABM("INS"),$G(ABMCLN))
 Q:ABMVT=111                      ;If hospitalization
 Q:'$D(^AUTTPIC(ABM("COV")))
 Q:$G(COV)="A"
 ;
 ; This is checking to see if provider class is not covered
 ; Loops thru until it finds a provider not in the unbillable list
 ; or to the end of list.
 ; ABM("FLG") is set to 1 if provider not covered
 ; Provider not in coverage file means billable
 ; If BUB=B
 ;  CPT code in one range is billable and done
 ;  CPT code not in all ranges is billable
 ; If BUB=U
 ;  all CPT codes in a range unbillable
 ;  one CPT codes out of all ranges is billable
 ;
 N BUB,INRANGE,OUTOFRNG
 S ABM("PRV")=0
 S ABM=""
 F  S ABM=$O(^AUPNVPRV("AD",ABMVDFN,ABM)) Q:'ABM  D  Q:'ABM("FLG")
 .S P=$P(^AUPNVPRV(ABM,0),U)
 .I $$PRVX^ABMDLCK3(P) D
 ..I $D(^AUTTPIC(ABM("COV"),15,ABM("PRV"))) D
 ...S BUB=$P(^AUTTPIC(ABM("COV"),15,ABM("PRV"),0),U,2)
 ...I BUB="" S ABM("FLG")=1,$P(ABML(99,ABM("INS")),U,6)=55 Q
 ...S ABM("FLG")=$$PROVSPEC^ABMDLCK3(ABM("COV"),ABM("PRV"),BUB)
 ...I ABM("FLG")=1 S $P(ABML(99,ABM("INS")),U,6)=51 Q
 ..E  D
 ...I $P($G(ABML(99,ABM("INS"))),U,6)=51!($P($G(ABML(99,ABM("INS"))),U,6)=56) K ABML(99,ABM("INS"))
 ...S ABM("FLG")=0    ; Set to zero if not in list
 .E  S ABM("FLG")=1,$P(ABML(99,ABM("INS")),U,6)=56     ;Set if default non covered provider
 ; If there are not entries in the V prov file same as flagging all
 ; providers unbillable
 I $G(ABM("FLG"),1),'$$ORPHAN^ABMDVCK2(ABMVDFN) D  Q
 .S ABM("XIT")=1
 I $D(^AUTTPIC(ABM("COV"),11,ABMCLN,0)) D  Q
 .S ABM("XIT")=1
 .S $P(ABML(99,ABM("INS")),U,6)=57
 S ABM("POV")=0,ABM("FLG")=0
 ;
 ; This code is checking to see if the coverage type represented by
 ; the ien ABM("COV") covers the POV for this visit.  If it is not
 ; covered ABM("FLG") is set and UNCHK is run.
 ;
 S ABM=""
 F  S ABM=$O(^AUPNVPOV("AD",ABMVDFN,ABM)) Q:'ABM  D  Q:'ABM("FLG")
 .S ABM("POV")=$P(^AUPNVPOV(ABM,0),U)
 .; Code to handle messed up .01 field in V POV file
 .I 'ABM("POV") S:ABM("FLG")=0 ABM("FLG")=-1 Q
 .I $D(^AUTTPIC(ABM("COV"),13,ABM("POV"))) S ABM("FLG")=1 Q
 .E  S ABM("FLG")=0     ;Set to 0 if not in list
 Q:ABM("FLG")<1
 I ABM("FLG") D
 .S ABM("XIT")=11
 .S $P(ABML(99,ABM("INS")),U,6)=58
 Q
 ; ABM("XIT") serves as a flag that the priority needs to be 99
