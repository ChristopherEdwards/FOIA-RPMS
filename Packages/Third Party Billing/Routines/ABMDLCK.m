ABMDLCK ; IHS/ASDST/DMJ - Eligibility Checker ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ;This rtn expects that ABMVDFN, the visit file ien be defined
 ;It also uses DFN - Patient DFN & ABMVDT - Visit date
 ;This rtn returns eligibility info in the array ABML.  The array has
 ;the following format (approximately)
 ;
 ;ABML(PRIORITY,INSIEN)=D^I^TYPE^SDATE^EDATE^UBILL
 ;ABML(PRIORITY,INSIEN,"COV",CTIEN)=COV
 ;PRIORITY  =  Priority of the coverage
 ;INSIEN    =  IEN from the Insurer file
 ;TYPE      =  One letter code M=Medicare, D=Medicaid, P=Private, 
 ;             R=Railroad ret, N=Non-ben, I=Indian, A=Accident (or tort)
 ;             W=Workman's comp
 ;D         =  IEN from Medicaid ins file if Medicaid, else nul
 ;I         =  subfile ien from ins file, a date for medicaid
 ;CTIEN     =  IEN from Coverage Type file
 ;COV       =  A or B if the type is Medicare
 ;SDATE     =  Start date
 ;EDATE     =  End Date.  These 2 fields are for elig change during inpt
 ;UBILL     =  Code for NO ELIGIBILITY FOUND     44=Unbillable Visit
 ;
 ;Required input variables:  ABMVDFN or (DFN and ABMVDT)
 ;ABMVDFN      The PCC Visit file ien
 ;DFN          Patient file ien
 ;ABMVDT       (Visit) date in Fileman internal format
 ;
 ;Output
 ;ABML array.  It must be passed by reference
 ;
 ; *********************************************************************
 ; IHS/SD/SDR - 12/7/2004 - V2.5 P7 - Made change so if inpatient and
 ;     the clinic is pharmacy it will change the clinic to general.  This
 ;     is a new issue with Pharmacy 7.
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM19399
 ;    Added code to look at new worker's comp file for eligibility
 ;
 ; *********************************************************************
 ;
ELG(ABMVDFN,ABML,DFN,ABMVDT) ;EP Entry point - Eligibility checker
 N ABM,COV,ACCDENT,ABMPRVTI,ABMCLN,ABMCDFN,D1,Y,ABMVT
 K ABMNOELG
 K AUPNCPT
 S DFN=$G(DFN)
 S ABMVDT=$G(ABMVDT)
 I ABMVDFN_DFN="" K ABML Q
 I ABMVDFN,'$D(^AUPNVSIT(ABMVDFN)) D  Q
 .S ABML("ERROR")="NOT A VALID VISIT IEN"
 I DFN,'$D(^DPT(DFN)) D  Q
 .S ABML("ERROR")="NOT A VALID PATIENT NUMBER"
 I ABMVDFN D
 .S Y=^AUPNVSIT(ABMVDFN,0)
 .S:'DFN DFN=$P(Y,U,5)
 .S ABMCLN=$P(Y,U,8)
 .S SERVCAT=$P(Y,U,7)
 .I ("IDH"[$G(SERVCAT)),(ABMCLN=39) S ABMCLN=1
 .S:+$G(ABMP("CDFN")) ABMCLN=$$GET1^DIQ(9002274.3,ABMP("CDFN"),.06,"I")
 .S:'ABMVDT ABMVDT=+Y\1
 .S ABMCDFN=$O(^ABMDCLM(DUZ(2),"AV",ABMVDFN,""))
 .I '$D(ABMDISDT) D
 ..S I=$O(^AUPNVINP("AD",ABMVDFN,0))
 ..S ABMDISDT=$S(I]"":$P(^AUPNVINP(I,0),U,1),1:0)
 S ABMDISDT=$G(ABMDISDT)
 K ABML
 ; Check if visit after Date of Death
 ; 41 ; Visit date after date of death
 I $D(^DPT(DFN,.35)),$P(^(.35),U,1)]"",$P(^(.35),U,1)<$P(ABMVDT,".",1) S ABMNOELG=41 Q
 S Y=^AUPNPAT(DFN,0)
 ;In ver 1.6 this var would be 0 if piece 21 was blank
 S ABM("EMPLOYED")=+$P(Y,U,21)
 I ABM("EMPLOYED")=3 S ABM("EMPLOYED")=0
 S ABM("PRIMARY")=$P(Y,U,25)
 ;WRKC - Workman's comp
 ;AA   - Accident or tort
 ;5    - Private insurance
 ;3    - Railroad ret
 ;2    - Medicare
 ;4    - Medicaid
 ;6    - non-ben
 F ABM("PROC")="WRKC","AA","5^ABMDLCK2",3,2,"4^ABMDLCK2","6^ABMDLCK2" D
 .S (ABM("COV"),ABM("MDFN"))=""
 .K ABM("FLG"),ABM("XIT")
 .D @ABM("PROC")
 I $D(ABML(1)) D
 .I $O(ABML(1,$O(ABML(1,"")))) D
 ..S P=96
 ..F  S P=$O(ABML(P),-1) Q:'P  D
 ...S I=0
 ...F  S I=$O(ABML(P,I)) Q:'I  D
 ....I I'=ABM("PRIMARY") D
 .....M ABML(P+1,I)=ABML(P,I)
 .....K ABML(P,I)
 G XIT
 ;
2 ; Medicare Elig Chk
 K ABM("XIT")
 S ABM("PRI")=$S(ABM("EMPLOYED")=5:1,1:3)
 S ABM("TYP")="M"
 D PRIO
 ;After setting priority we check medicare eligibility file
 Q:'$D(^AUPNMCR(DFN,0))
 S ABM("INS")=$$MCRIEN(ABMVDT)
 I '+ABM("INS") S ABME(166)="" Q
 K ABM("REC")
 I '+$O(^AUPNMCR(DFN,11,0)) D  Q
 .D CHK^ABMDLCK1
 .I $G(ABM("XIT")) D UNCHK^ABMDLCK2
 ;Node 11 has the Medicare Part A and/or B eligibility
 S ABMELGDT=0
 S ABM("MDFN")=0
 F  S ABM("MDFN")=$O(^AUPNMCR(DFN,11,ABM("MDFN"))) Q:'ABM("MDFN")  D 23
 I 'ABMELGDT D  Q
 .I '$D(ABML(ABM("PRI"),ABM("INS"))) D
 ..I '$D(ABML(99,ABM("INS"))) D
 ...S $P(ABML(99,ABM("INS")),U)=$G(DFN)
 ...S $P(ABML(99,ABM("INS")),U,2)=$G(ABM("MDFN"))
 ...S $P(ABML(99,ABM("INS")),U,3)="M"
 ..S $P(ABML(99,ABM("INS")),U,6)=34
 E  I $D(ABML(ABM("PRI"),ABM("INS"))),ABM("PRI")<97 D
 .K ABML(99,ABM("INS"))
 K COV
 I $G(ABM("XIT")) D UNCHK^ABMDLCK2 Q
 I $G(ABM("XIT"))="A" K ABML(ABM("PRI"),ABM("INS"),"COV",ABM("CV"))
 Q
 ;
MCRIEN(X) ;EP - determine medicare fi on visit date
 N I,Y
 S Y=0
 S I=0
 F  S I=$O(^AUTNINS(2,12,I)) Q:'I  D
 .S ABM0=^AUTNINS(2,12,I,0)
 .Q:'$P(ABM0,"^",2)
 .Q:$P(ABM0,"^",2)>X
 .I $P(ABM0,"^",3),$P(ABM0,"^",3)<X Q
 .S Y=I
 I 'Y S Y=$O(^AUTNINS("B","MEDICARE",0))
 Q Y
 ;
23 ;
 S ABM("REC")=^AUPNMCR(DFN,11,ABM("MDFN"),0)
 I $P(ABM("REC"),U,1)>$P($S(ABMDISDT:ABMDISDT,1:ABMVDT),".",1) Q
 I $P(ABM("REC"),U,2)]"" Q:$P(ABM("REC"),U,2)<$P(ABMVDT,".",1)
 S ABMELGDT=1
 S COV=$P(ABM("REC"),U,3)
 ;For A or B get ien from ^AUTTPIC file
 I COV]"" S ABM("COV")=$O(^AUTTPIC("AC",ABM("INS"),COV,""))
 E  S ABM("COV")=""
 D CHK^ABMDLCK1
 ; This block will never get called as ABM("MSUP") never gets set.
 ; It should be fixed of removed for the next version.
 ; It is trying to address ; 38 ; Medicare eligible; but also mcr suppl
 I '$D(ABML(ABM("PRI"),ABM("INS"))),$D(ABM("MSUP")) D
 .S ABM=0
 .F  S ABM=$O(ABM("MSUP",ABM)) Q:'ABM  D
 ..Q:'$D(ABML(4,ABM))
 ..S ABML(99,ABM)=ABML(4,ABM)
 .. S $P(ABML(99,ABM("INS")),U,6)=38
 ..S CV=0
 ..F  S CV=$O(ABML(4,ABM,"COV",CV)) Q:'CV  D
 ...S ABML(99,ABM,"COV",CV)=ABML(4,ABM,"COV",CV)
 ..K ABML(4,ABM)
 .K ABM("MSUP")
 K CV
 Q
 ;
3 ; RailRoad Elig Chk
 K ABM("XIT")
 S ABM("PRI")=$S(ABM("EMPLOYED")=5:1,1:3)
 S ABM("TYP")="R"
 D PRIO
 Q:'$D(^AUPNRRE(DFN,0))
 S ABM("INS")=$O(^AUTNINS("B","RAILROAD RETIREMENT",""))
 I '+ABM("INS") S ABME(168)="" Q
 K ABM("REC")
 I '+$O(^AUPNRRE(DFN,11,0)) D CHK^ABMDLCK1 Q
 K ABMGOOD
 S ABM("MDFN")=0
 F  S ABM("MDFN")=$O(^AUPNRRE(DFN,11,ABM("MDFN"))) Q:'ABM("MDFN")  D
 .D 33
 I '$G(ABMGOOD) D
 .S $P(ABML(99,ABM("INS")),"^",6)=35
 I $G(ABM("XIT")) D UNCHK^ABMDLCK2
 K COV
 Q
 ;
33 ;
 S ABM("REC")=^AUPNRRE(DFN,11,ABM("MDFN"),0)
 ; 35 ; RailRoad coverage; visit outside eligibility dates
 I $P(ABM("REC"),U,1)>$P($S(ABMDISDT:ABMDISDT,1:ABMVDT),".",1) Q
 I $P(ABM("REC"),U,2)]"",$P(ABM("REC"),U,2)<$P(ABMVDT,".",1) Q
 S ABMGOOD=1
 S COV=$P(ABM("REC"),U,3)
 I COV]"" S ABM("COV")=$O(^AUTTPIC("AC",ABM("INS"),COV,""))
 E  S ABM("COV")=""
 D CHK^ABMDLCK1
 Q
 ;
WRKC ;Workman's comp
 S ABM("EMPL REL")=0
 Q:$S(ABM("EMPLOYED")=0:1,ABM("EMPLOYED")=5:1,1:0)
 Q:'$G(ABMVDFN)
 N ABMLW
 K ABM("XIT")
 S ABM("TYP")="W"
 S ABM=0
 F  S ABM=$O(^AUPNVPOV("AD",ABMVDFN,ABM)) Q:'ABM  D  Q:$D(ABMLW)
 .;Check if POV employment related
 .Q:$P($G(^AUPNVPOV(ABM,0)),U,7)'=4
 .S ABM("EMPL REL")=1
 .S ABM("PRI")=1
 .;19th piece of pat file is employer
 .S Y=$P($G(^AUPNPAT(DFN,0)),U,19)
 .I Y,$G(^AUPNWC(DFN,0))'="" D  ;entry in 9000042-Workman's Comp
 ..S ABMWCIEN=0
 ..F  S ABMWCIEN=$O(^AUPNWC(DFN,11,ABMWCIEN)) Q:+ABMWCIEN=0  D  Q:$D(ABMLW)
 ...S ABMWEFDT=$P($G(^AUPNWC(DFN,11,ABMWCIEN,0)),U,12)
 ...S ABMWEXDT=$P($G(^AUPNWC(DFN,11,ABMWCIEN,0)),U,13)
 ...I ABMWEFDT>$P($S(ABMDISDT:ABMDISDT,1:ABMVDT),".",1) Q
 ...I ABMWEXDT'="",ABMWEXDT<$P(ABMVDT,".",1) Q
 ...S ABM("INS")=$P($G(^AUPNWC(DFN,11,ABMWCIEN,0)),U,10),ABMLW=1
 .Q:$D(ABMLW)
 .I Y,$P($G(^AUTNEMPL(Y,0)),U,8) D  Q:$D(ABMLW)
 ..S ABM("INS")=$P(^AUTNEMPL(Y,0),U,8)
 ..S Y=$P($G(^AUTNINS(ABM("INS"),1)),U,7)
 ..;Piece 7 is status field: 0=UNSELECTABLE, 4=UNBILLABLE
 ..I Y]"","04"'[Y S ABMLW=1
 Q:'ABM("EMPL REL")
 I $G(ABMLW),($G(ABM("INS"))'="") D  Q
 .D CHK^ABMDLCK1
 .I $G(ABM("XIT")) D UNCHK^ABMDLCK2
 ;Go on and look further if not found yet.
 S ABM("INS")=$O(^AUTNINS("B","WORKMEN'S COMP",0))
 Q:'ABM("INS")
 ;This is looking at the workmen's comp field of the Medicaid mult
 S ABM=0
 F  S ABM=$O(^AUTNINS(ABM("INS"),13,ABM)) Q:'ABM  I $P(^(ABM,0),U,3) S ABM("INS")=$P(^(0),U,3) Q
 D CHK^ABMDLCK1
 I $G(ABM("XIT")) D UNCHK^ABMDLCK2
 Q
 ;
AA ;Automobile accident or other accident or tort related.
 N V
 K ABM("XIT")
 S ABM("TYP")="A"
 S V=0,ACCDENT=0
 Q:'$G(ABMVDFN)
 ;Quit if this is a workman's comp case
 I ABM("EMPL REL"),$D(ABML(1)),$P(ABML(1,$O(ABML(1,0))),U,3)="W" D  Q
 .S ACCDENT=1
 .K ABM("INS")
 F  S V=$O(^AUPNVPOV("AD",ABMVDFN,V)) Q:'V  D  Q:ACCDENT
 .I $P(^AUPNVPOV(V,0),U,11)]"" S ACCDENT=1
 Q:'ACCDENT                  ;Not accident related
 Q:'$D(^AUPNPRVT(DFN))   ;No accident insurance
 S ABM("PRI")=1
 S D1="@",ACCDENT=0               ;@ Collates before all X-refs
 F  S D1=$O(^AUPNPRVT(DFN,11,D1),-1) Q:'D1  D
 .Q:$P($G(^AUPNPRVT(DFN,11,D1,0)),U)=""
 .I $$ACCREL(D1) D
 ..Q:ABMVDT<$P(ABMPRVTI,U,6)!(($P(ABMPRVTI,U,7)]"")&(ABMVDT>$P(ABMPRVTI,U,7)))
 ..S ACCDENT=1
 ..S ABM("INS")=$P(ABMPRVTI,U)
 ..S ABM("MDFN")=D1
 ..D PRIO
 ..D CHK^ABMDLCK1
 ..I $G(ABM("XIT")) D UNCHK^ABMDLCK2
 ..I $D(ABML(ABM("PRI"),ABM("INS"))) S ABMLX(ABM("INS"),ABM("PRI"))=""
 Q
 ;
ACCREL(D1) ;EP - Ext func to determine if ins is accident or tort related
 N RELPT
 S ABMPRVTI=$G(^AUPNPRVT(DFN,11,D1,0))
 S RELPT=$P(ABMPRVTI,U,5)
 Q:'RELPT 0
 I $P(^AUTTRLSH(RELPT,0),U,4) Q 1
 Q 0
 ;
PRIO ;SET PRIORITY
 F  D  Q:'$D(ABML(ABM("PRI")))
 .Q:'$D(ABML(ABM("PRI")))
 .S ABM("PRI")=ABM("PRI")+1
 Q
 ;
XIT K ABM,ABMLX
 Q
