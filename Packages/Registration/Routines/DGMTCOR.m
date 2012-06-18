DGMTCOR ;ALB/CAW,SCG - Check Copay Test Requirements ; 03/03/03 8:15am
 ;;5.3;Registration;**21,45,182,290,305,330,344,495**;Aug 13, 1993
 ;IHS/ANMC/LJF 8/24/2000 added quit; called by xref in file 2
 ;
 ;A patient may apply for a copay test under the following conditions:
 ;  - Applicant is a veteran
 ;  - Applicant's primary or other eligibility does NOT contain
 ;    - Service Connected 50% to 100% or
 ;    - Aid and Attendance or
 ;    - Housebound or
 ;    - VA Pension
 ;  - Primary Eligibility is NSC
 ;    - who has NOT been means tested
 ;    - who claims exposure to agent orange or ionizing radiation
 ;    - who is eligible for medicaid
 ;  - Applicants who have answered 'no' to Receiving A&A, HB, or Pension
 ;  - Applicants who have previously qualified and applied for a copay 
 ;      exemption, still qualify and have NOT been copay tested in the
 ;      past year
 ;  - Applicants who are not currently a DOM patient or inpatient
 ;      (they are temporarily exempt from copay testing) DG*5.3*290
 ;
 ; Input  -- DFN     Patient IEN
 ;           DGADDF  Means Test Add Flag (optional)
 ; Output -- DGMTCOR  Copay Test Flag
 ;                   (1 if eligible and 0 if not eligible)
 ;
 ;
EN ;
 Q:$$IHS^BDGF   ;IHS/ANMC/LJF 8/24/2000
 Q:$G(VAFCA08)=1
 N DGMTI,DGMTYPT,DGMDOD
 D ON^DGMTCOU G:'Y ENQ
 S DGRGAUTO=1 ;possible change in cp status w/o call to cp event driver
 D CHK
 ;
 Q:($G(DGWRT)=8)!($G(DGWRT)=9)   ;brm;quit if inpatient or dom;DG*5.3*290
 S IVMZ10F=+$G(IVMZ10F)
 I 'DGMTCOR,'$G(DGADDF),'$G(DGMDOD),'IVMZ10F D NLA
 I DGMTCOR,'$G(DGADDF),'$G(DGMDOD) D INC
 I DGRGAUTO&'$G(DGADDF) D QREGAUTO ;if cp event driver not fired off & NOT a new means test
 ;
ENQ Q
 ;
CHK N STATUS,ELIG,ELIGIEN,DGNODE,DGMDOD,DGMTDT
 S DGMTCOR=1,DGMT="",DGMTYPT=2
 I $P($G(^DPT(DFN,"VET")),U,1)'="Y" S DGMTCOR=0,DGWRT=1 G CHKQ ;NON-VET
 ;Added with DG*5.3*344
 S DGMTI="",DGMTI=+$$LST^DGMTU(DFN)
 S:DGMTI DGMTDT=$P($G(^DGMT(408.31,DGMTI,0)),U)
 S DGMDOD=$P($G(^DPT(DFN,.35)),U)
 I 'DGMTI,$G(DGMDOD) S DGMTCOR=0 Q
 I DGMDOD,(DGMTCOR),(DGMTDT>(DGMDOD-1)) S DGMTCOR=0 G CHKQ
 ;
 S DGMTI=0 I '$P($G(^DPT(DFN,.36)),U) S DGMTCOR=0,DGWRT=2 G CHKQ
 I +$G(DGMDOD) S DGNOCOPF=1
 ;
 ;This doesn't work! The "AEL" x-ref not there when changing the primary
 ;eligibility! Problem with order that the cross-references are called
 ;in, DGMTR is called before the "AEL" x-ref is set!
 ;F  S DGMTI=$O(^DPT("AEL",DFN,DGMTI)) Q:'DGMTI  S DGMTE=$P($G(^DIC(8,DGMTI,0)),U,9) I "^1^2^4^15^"[("^"_DGMTE_"^") S DGMTCOR=0,DGWRT=3 G CHKQ
 ;
 ;
 S ELIG=$P($G(^DPT(DFN,.36)),"^") I ELIG S DGMTE=$P($G(^DIC(8,ELIG,0)),U,9) I "^1^2^4^15^"[("^"_DGMTE_"^") S DGMTCOR=0,DGWRT=3 G CHKQ
 S ELIGIEN=0 F  S ELIGIEN=$O(^DPT(DFN,"E",ELIGIEN)) Q:'ELIGIEN  S ELIG=$P($G(^DPT(DFN,"E",ELIGIEN,0)),"^") I ELIG  S DGMTE=$P($G(^DIC(8,ELIG,0)),U,9) I "^1^2^4^15^"[("^"_DGMTE_"^") S DGMTCOR=0,DGWRT=3 G CHKQ
 S DGNODE=$$LST^DGMTU(DFN),DGMTI=+DGNODE
 ;brm added next 3 lines for DG*5.3*290
 N DGDOM,DGDOM1,VAHOW,VAROOT,VAINDT,VAIP,VAERR,NOW
 D DOM^DGMTR I $G(DGDOM) S DGMTCOR=0,DGRGAUTO=0,DGWRT=8 Q        ;DOM
 D IN5^VADPT I $G(VAIP(1))'="" S DGMTCOR=0,DGRGAUTO=0,DGWRT=9 Q  ;INP
 I DGMTI,'$$OLD^DGMTU4($P(DGNODE,"^",2)) S STATUS=$P($G(^DGMT(408.31,+DGMTI,0)),U,3) I STATUS'="3" S DGMTCOR=0,DGWRT=4 G CHKQ
 S DGNODE=$G(^DPT(DFN,.362))
 I DGMTCOR,$P(DGNODE,U,12)["Y" S DGMTCOR=0,DGWRT=5 G CHKQ ;A&A
 I DGMTCOR,$P(DGNODE,U,13)["Y" S DGMTCOR=0,DGWRT=6 G CHKQ ;HB
 I DGMTCOR,$P(DGNODE,U,14)["Y" S DGMTCOR=0,DGWRT=7 G CHKQ ;PENSION
CHKQ Q
 ;
NLA ; Change Status to NO LONGER APPLICABLE - if appropriate
 ;
 N DGCS,DGMTI,DGMT0,DGINI,DGINR,DGVAL,DGFL,DGFLD,DGIEN,DGMTACT,TDATE
 S DGMTI=+$$LST^DGMTU(DFN,"",2) Q:'DGMTI!($P($G(^DGMT(408.31,DGMTI,0)),U,3)=10)
 S DGMT0=$G(^DGMT(408.31,DGMTI,0)) Q:'DGMT0
 S DGCS=$P(DGMT0,U,3)
 S TDATE=+DGMT0
 S DGMTACT="STA" D PRIOR^DGMTEVT
 ;
 D SAVESTAT^DGMTU4(DGMTI)
 ;
 S DGFL=408.31,DGIEN=DGMTI
 S DGFLD=.03 I DGCS]"" S DGVAL=DGCS D KILL^DGMTR
 S DGVAL=10,$P(^DGMT(408.31,DGMTI,0),"^",3)=DGVAL D SET^DGMTR
 S DGFLD=.17,DGVAL=DT,$P(^DGMT(408.31,DGMTI,0),"^",17)=DT D SET^DGMTR
 W:'$G(DGMTMSG)&'$D(ZTQUEUED) !,"COPAY TEST NO LONGER APPLICABLE"
 D GETINCOM^DGMTU4(DFN,TDATE)
 S DGMTYPT=2 D QUE^DGMTR
 S DGRGAUTO=0
NLAQ Q
 ;
INC ;Update copay status to 'INCOMPLETE' if applicable OR restore completed test
 N DGMTACT,DGMTI,DGFL,DGFLD,DGIEN,DGMTP,DGVAL,DGMT0,AUTOCOMP,ERROR
 S AUTOCOMP=0
 S DGMTI=+$$LST^DGMTU(DFN,"",2)
 D
 .Q:'DGMTI
 .I ($P($G(^DGMT(408.31,DGMTI,0)),U,3)'=10) S AUTOCOMP=1 Q
 .S DGMT0=$G(^DGMT(408.31,DGMTI,0)),DGCS=$P(DGMT0,U,3)
 .Q:'DGMT0
 .S DGMTACT="STA" D PRIOR^DGMTEVT
 .S AUTOCOMP=$$AUTOCOMP^DGMTR(DGMTI)
 .W:'AUTOCOMP&'$G(DGMTMSG)&'$D(ZTQUEUED) !,"COPAY EXEMPTION TEST UPDATED TO INCOMPLETE"
 .W:AUTOCOMP&'$G(DGMTMSG)&'$D(ZTQUEUED) !,"COPAY EXEMPTION TEST UPDATED TO ",$$GETNAME^DGMTH($P($G(^DGMT(408.31,DGMTI,0)),"^",3))
 .S DGMTYPT=2 D QUE^DGMTR
 .S DGRGAUTO=0
 ;
 I $G(IVMZ10)'="UPLOAD IN PROGRESS",$G(DGQSENT)'=1,'AUTOCOMP,'$$OPEN^IVMCQ2(DFN),'$$SENT^IVMCQ2(DFN) D QRYQUE2^IVMCQ2(DFN,$G(DUZ),0,$G(XQY)) S DGQSENT=1 I '$D(ZTQUEUED),'$G(DGMSGF) W !!,"Financial query queued to be sent to HEC..."
 ;
INCQ Q
 ;
QREGAUTO ;Queues off test done by IB recalculating CP status
 ;  Input: DFN
 ;  Action: Possible update of Copay Status
 ;
 Q:'$D(^IBA(354.1,"APIDT",DFN,1))  ;No action if no status on file
 S ZTDESC="CHECK PATIENT FILE CHANGES VS CP STATUS",ZTDTH=$H,ZTRTN="REGAUTO^IBARXEU5",ZTSAVE("DFN")="",ZTIO=""
 D ^%ZTLOAD
 K ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 Q
