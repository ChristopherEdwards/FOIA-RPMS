SDM1A ;SF/GFT,ALB/TMP - MAKE APPOINTMENT ; 07 Jun 2001  7:36 PM [ 03/08/2004  10:21 AM ]
 ;;5.3;Scheduling;**26,94,155,206,168,223,241,263,1005,1012,1013**;Aug 13, 1993
 ;IHS/ANMC/LJF 07/06/2000 hard set of date appt made now includes time
 ;             12/13/2000 added clear display of appt just made
 ;             06/22/2001 added call to create xref on date appt made
 ;IHS/OIT/LJF  12/30/2005 PATCH 1005 enhanced OTHER INFO help text
 ;             01/06/2006 PATCH 1005 fixed code so OTHER INFO always set correctly
 ;cmi/flag/maw 05/14/2010 PATCH 1012 RQMT129, increased length of OTHER INFO
 ;
OK I $D(SDMLT) D ^SDM4 Q:X="^"!(SDMADE=2)
 S ^SC(SC,"ST",$P(SD,"."),1)=S,^DPT(DFN,"S",SD,0)=SC,^SC(SC,"S",SD,0)=SD S:'$D(^DPT(DFN,"S",0)) ^(0)="^2.98P^^" S:'$D(^SC(SC,"S",0)) ^(0)="^44.001DA^^" L
S1 L ^SC(SC,"S",SD,1):5 G:'$T S1 F SDY=1:1 I '$D(^SC(SC,"S",SD,1,SDY)) S:'$D(^(0)) ^(0)="^44.003PA^^" S ^(SDY,0)=DFN_U_(+SL) L  Q
 I SM S ^("OB")="O" ;NAKED REFERENCE - ^SC(IFN,"S",Date,1,SDY,"OB")
 I $D(^SC(SC,"RAD")),^("RAD")="Y"!(^("RAD")=1) S ^SC("ARAD",SC,SD,DFN)=""
 S SDINP=$$INP^SDAM2(DFN,SD)
 ;-- added sub-category
 S COV=3,SDYC="",COV=$S(COLLAT=1:1,1:3),SDYC=$S(COLLAT=7:1,1:"")
 S:SD<DT SDSRTY="W"
 I $G(BSDSRFU) S SDSRFU=1  ;cmi/maw 6/8/2010 PATCH 1012 followup indicator
 ;
 ;S ^DPT(DFN,"S",SD,0)=SC_"^"_$$STATUS(SC,SDINP,SD)_"^^^^^"_COV_"^^^^"_SDYC_"^^^^^"_SDAPTYP_U_$G(SD17)_"^^"_DT_"^^^^^"_$G(SDXSCAT)_U_$P($G(SDSRTY),U,2)_U_$$NAVA^SDMANA(SC,SD,$P($G(SDSRTY),U,2))          ;IHS/ANMC/LJF 7/06/2000
 S ^DPT(DFN,"S",SD,0)=SC_"^"_$$STATUS(SC,SDINP,SD)_"^^^^^"_COV_"^^^^"_SDYC_"^^^^^"_SDAPTYP_U_$G(SD17)_"^^"_$$NOW^XLFDT_"^^^^^"_$G(SDXSCAT)_U_$P($G(SDSRTY),U,2)_U_$$NAVA^SDMANA(SC,SD,$P($G(SDSRTY),U,2))  ;IHS/ANMC/LJF 7/06/2000
 ;
 S ^DPT(DFN,"S",SD,1)=$G(SDDATE)_U_$G(SDSRFU)
 ;xref DATE APPT. MADE field
 D
 .N DIV,DA,DIK
 .S DA=SD,DA(1)=DFN,DIK="^DPT(DA(1),""S"",",DIK(1)=20 D EN1^DIK
 .Q
 K:$D(^DPT(DFN,"S",SD,"R")) ^("R") K:$D(^DPT("ASDCN",SC,SD,DFN)) ^(DFN)
 S SDRT="A",SDTTM=SD,SDPL=SDY,SDSC=SC D RT^SDUTL
 ;
 ;W !,"   ",+SL,"-MINUTE APPOINTMENT MADE" K SDINP   ;IHS/ANMC/LJF 12/13/2000
 D APPT^BSDU2(DFN,SC,SD,+SL) K SDINP                 ;IHS/ANMC/LJF 12/13/2000
 D XREFC^BSDDAM(SC,SD,SDY) ;ihs/cmi/maw 07/19/2011 patch 1013 doesn't look like this is set if OTHER INFO set to NO
 ;confirm request type & follow-up indicator
 I $D(SDSRTY(0)) D CONF(.SDSRTY,.SDSRFU,DFN,SD,SC) W !
 I $P(SD,".")'>DT,$D(^DPT(DFN,.321)) D EN1^SDM3
 ;
 ;Wait List SD*5.3*263
 I '$D(SDWLLIST) D ^SDWLR
 ;
ORD S %=2 W !,"WANT PATIENT NOTIFIED OF LAB,X-RAY, OR EKG STOPS" D YN^DICN I '% W !,"  Enter YES to notify patient on appt. letter of LAB, X-RAY, or EKG stops" G ORD
 I '(%-1) D ORDY^SDM3
OTHER R !,"  OTHER INFO: ",D:DTIME I D["^" W !,*7,"'^' not allowed - hit return if no 'OTHER INFO' is to be entered" G OTHER
 ;I $L(D)>150 D MSG^SDMM G OTHER  ;cmi/maw 05/14/2010 PATCH 1012 RQMT129 inclreased length of OTHER INFO orig line
 I $L(D)>155 D MSG^SDMM G OTHER  ;cmi/maw 05/14/2010 PATCH 1012 RQMT129 inclreased length of OTHER INFO  
 ;
 ;IHS/OIT/LJF 12/30/2005 PATCH 1005 enhanced help text and removed old MSM restriction on global length
 ;I D]"",D?."?"!(D'?.ANP) W "  ENTER LAB, SCAN, ETC." G OTHER
 I D]"",D?."?"!(D'?.ANP) W !!,"Enter the Reason for the Appointment.  May be up to 155 characters long (no semi-colons or colons).",! G OTHER
 ;I $L(^SC(SC,"S",SD,1,SDY,0))+$L(D)+$L(DT)+$S($D(DUZ):$L(DUZ),1:0)>250 D MSG^SDMM G OTHER
 ;
 ;IHS/OIT/LJF 01/06/2006 PATCH 1005 naked reference not always set correctly
 ;S $P(^(0),"^",4)=D,$P(^(0),U,6,7)=$S($D(DUZ):DUZ,1:"")_U_DT ;NAKED REFERENCE - ^SC(IFN,"S",Date,1,SDY,0)    ;IHS/ANMC/LJF 7/06/2000
 ;S $P(^(0),"^",4)=D,$P(^(0),U,6,7)=$S($D(DUZ):DUZ,1:"")_U_$$NOW^XLFDT D XREFC^BSDDAM(SC,SD,SDY)               ;IHS/ANMC/LJF 7/06/2000; 6/22/2001
 S $P(^SC(SC,"S",SD,1,SDY,0),"^",4)=D,$P(^(0),U,6,7)=$S($D(DUZ):DUZ,1:"")_U_$$NOW^XLFDT D XREFC^BSDDAM(SC,SD,SDY) ;IHS/OIT/LJF 01/06/2006 PATCH 1005
 ;
XR I $S('$D(^SC(SC,"RAD")):1,^("RAD")="Y":0,^("RAD")=1:0,1:1) S %=2 W !,"WANT PREVIOUS X-RAY RESULTS SENT TO CLINIC" D YN^DICN G:'% HXR I '(%-1) S ^SC("ARAD",SC,SD,DFN)=""
SDMM S SDEMP=0 I COLLAT=7 S:SDEC'=SDCOL SDEMP=SDCOL G OV
 D ELIG^VADPT I $O(VAEL(1,0))>0 D ELIG^SDM4:"369"[SDAPTYP S SDEMP=$S(SDDECOD:SDDECOD,1:SDEMP)
OV Q:$D(SDZM)  K SDQ1,SDEC,SDCOL I +SDEMP S $P(^SC(SC,"S",SD,1,SDY,0),"^",10)=+SDEMP
 S SDMADE=1 D EVT Q
HXR W !,"  Enter YES to have previous XRAY results sent to the clinic" G XR
 Q
CS S SDCS=+$P(^SC(+SC,0),"^",7) I $S('$D(^DIC(40.7,SDCS,0)):1,'$P(^(0),"^",3):0,1:$P(^(0),"^",3)'>DT) W !!,*7,"** WARNING - CLINIC HAS AN INVALID OR INACTIVE STOP CODE!!!",!!
 S SDCS=+$P(^SC(+SC,0),"^",18) I $S('SDCS:0,'$D(^DIC(40.7,SDCS,0)):1,'$P(^(0),"^",3):0,1:$P(^(0),"^",3)'>DT) W !!,*7,"** WARNING - CLINIC HAS AN INVALID OR INACTIVE CREDIT STOP CODE!!!",!!
 K SDCS Q
 ;
STATUS(SDCL,SDINP,SDT) ; -- determine status for NEW appts
 Q $S(SDINP]"":SDINP,$$CHK(.SDCL,.SDT):"NT",1:"")
 ;
CHK(SDCL,SDT) ; -- should appt be NT'ed
 ; -- non-count clinic check := don't NT appt
 ; -- appt update executed   := need to NT appt
 ; -- otherwise              := don't NT appt
 Q $S($P($G(^SC(SDCL,0)),U,17)="Y":0,$D(^SDD(409.65,"AUPD",$P(SDT,"."))):1,1:0)
 ;
EVT ; -- separate tag if need to NEW vars
 D MAKE^SDAMEVT(DFN,SD,SC,SDY,0)
 Q
 ;
REQ(SDT) ; -- which is required check in(CI) or out(CO)
 Q $S($$REQDT()>SDT:"CI",1:"CO")
 ;
REQDT() ; -- co required date
 Q $S($P(^DG(43,1,"SCLR"),U,23):$P(^("SCLR"),U,23),1:2931001)
 ;
COCMP(DFN,SDT) ; -- date CO completed
 Q $P($G(^SCE(+$P($G(^DPT(DFN,"S",SDT,0)),U,20),0)),U,7)
 ;
CI(SDCL,SDT,SDDA,SDACT) ; -- ok to update DPT
 N C
 I '$$CHK(.SDCL,.SDT) G CIQ
 I $$REQ(SDT)'="CI" G CIQ
 I SDACT="SET",$D(^DPT(+^SC(SDCL,"S",SDT,1,SDDA,0),"S",SDT,0)),$P(^(0),U,2)="NT" S $P(^(0),U,2)=""
 I SDACT="KILL" S C=$G(^SC(SDCL,"S",SDT,1,SDDA,"C")) I $D(^DPT(+$G(^(0)),"S",SDT,0)),$P(^(0),U,2)="",'$P(C,U,3) S $P(^(0),U,2)="NT"
CIQ Q
 ;
CO(SDCL,SDT,SDDA,SDACT) ; -- ok to update DPT
 N DFN,C
 I '$$CHK(.SDCL,.SDT) G COQ
 I $$REQ(.SDT)'="CO" D  G COQ
 .I SDACT="SET",$D(^DPT(+^SC(SDCL,"S",SDT,1,SDDA,0),"S",SDT,0)),$P(^(0),U,2)="NT" S $P(^(0),U,2)=""
 .I SDACT="KILL" S C=$G(^SC(SDCL,"S",SDT,1,SDDA,"C")) I $D(^DPT(+$G(^(0)),"S",SDT,0)),$P(^(0),U,2)="",'C S $P(^(0),U,2)="NT"
 S DFN=+^SC(SDCL,"S",SDT,1,SDDA,0)
 D UPD(.DFN,.SDT,$$COCMP(.DFN,.SDT),$S(SDACT="SET":X,1:""))
COQ Q
 ;
UPD(DFN,SDT,SDCOCMP,SDCODT) ; -- update status
 N Y
 I $D(^DPT(DFN,"S",SDT,0)) S Y=$P(^(0),U,2) D
 .I 'SDCOCMP!('SDCODT) S:Y="" $P(^DPT(DFN,"S",SDT,0),U,2)="NT" Q
 .S:Y="NT" $P(^DPT(DFN,"S",SDT,0),U,2)=""
 Q
 ;
OE(SDOE,SDACT) ; -- called by x-ref on co completed field(#.07) in ^SCE
 N Y S Y=^SCE(SDOE,0)
 I $P(Y,U,8)'=1 G OEQ
 I $$REQ(+Y)'="CO" G OEQ
 I '$$CANT(+$P(Y,U,2),+Y,SDOE),'$$CHK(+$P(Y,U,4),+Y) G OEQ
 D UPD(+$P(Y,U,2),+Y,$S(SDACT="SET":X,1:""),$P($G(^SC(+$P(Y,U,4),"S",+Y,1,+$P(Y,U,9),"C")),U,3))
OEQ Q
 ;
CONF(SDSRTY,SDSRFU,DFN,SDT,SC) ;Confirm scheduling request type
 ;Input: SDSRTY=request type
 ;Input: SDSRFU=follow-up indicator
 ;Input: DFN=patient ien
 ;Input: SDT=appointment date/time
 ;Input: SC=clinic ifn
 ;
 N DIR,DIE,DA,DR,SDX,SDY,X,Y
 S DIR(0)="Y",DIR("B")="YES"
 S DIR("A")="THIS APPOINTMENT IS MARKED AS '"_SDSRTY(0)_"', IS THIS CORRECT"
 W ! D ^DIR Q:$D(DTOUT)!$D(DUOUT)
 I 'Y S SDX='SDSRTY,SDX(0)=$$TXRT(.SDX) W !!,"THIS APPOINTMENT HAS NOW BEEN MARKED AS '"_$S('SDSRTY:"",1:"NOT ")_"NEXT AVAILABLE'."
 ;S DIR("A")="THIS APPOINTMENT IS DEFINED AS '"_$S(SDSRFU:"FOLLOW-UP",1:"OTHER THAN FOLLOW-UP")_"', OK"
 ;W ! D ^DIR Q:$D(DTOUT)!$D(DUOUT)
 ;I 'Y S SDY='SDSRFU W "  (changed)"
 Q:'$D(SDX)  S DR=""
 I $D(SDX) S DR="25///^S X=$P(SDX,U,2);26///^S X=$$NAVA^SDMANA(SC,SDT,$P(SDX,U,2))"
 ;I $D(SDY) S:$L(DR) DR=DR_";" S DR=DR_"26///^S X=SDY"
 S DA=SDT,DA(1)=DFN
 S DIE="^DPT(DA(1),""S""," D ^DIE
 Q
 ;
TXRT(SDSRTY)    ;Transform request type
 ;Input: SDSRTY=variable to return request type (pass by reference)
 ;Output: external text for SDSRTY(0)
 I SDSRTY S SDSRTY=SDSRTY_U_"N" Q "NEXT AVAILABLE"
 S SDSRTY=SDSRTY_U_"O" Q "NOT NEXT AVAILABLE"
 ;
CANT(DFN,SDT,SDOE) ;Determine if clinic appt. has been marked "NT"
 ;Output: '1' if appt. points to encounter and is marked "NT", otherwise '0'
 N SDAPP S SDAPP=$G(^DPT(DFN,"S",SDT,0))
 Q:$P(SDAPP,U,20)'=SDOE 0
 Q $P(SDAPP,U,2)="NT"
 ;
 ; -- Variable doc for above tags
 ;     SDCL := file 44 ien
 ;      SDT := appt date/time
 ;      DFN := file 2 ien
 ;     SDDA := ^SC(SDCL,"S",SDT,1,SDDA,0)
 ;    SDACT := current x-ref action 'set' or 'kill' 
 ;  SDCOCMP := check out completed date
 ;   SDCODT := check out date/time
 ;     SDOE := Outpatient Encounter ien
 ;    SDINP := inpatient status ('I' or null)    
