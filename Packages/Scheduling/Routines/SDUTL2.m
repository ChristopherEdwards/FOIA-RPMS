SDUTL2 ;ALB/CAW - Misc. utilities ; 7/12/00 1:05pm [ 04/15/2004  1:15 PM ]
 ;;5.3;Scheduling;**20,71,132,149,175,193,220,258**;Aug 13, 1993
 ;IHS/ANMC/LJF  8/15/2001 bypass checking for HCFA occupation class
 ;
 ;
FYNUNK(SD) ; return YES, NO, UNKNOWN
 ;  input:               SD=internal piece
 ; output:   [returned]  Y=YES, N=NO, U=UNKNOWN
 Q $S(SD="Y":"YES",SD="N":"NO",SD="U":"UNKNOWN",1:"")
 ;
FMT(DFN) ; return current status of means test in external form
 ; input:                DFN=ifn of patient
 ; ouput:    [returned]  MT^SMT^LST
 ;           MT=external format of current status
 ;           SMT=shortened format of current staus
 ;           LST=date of last test
 ;
 N X,Y
 S X=$$LST^DGMTU(DFN)
 S Y=$P(X,U,4),Y=$S(Y["B":"CAT "_Y,Y["A":"COPAY EX",Y["C":"COPAY REQ",Y["G":"GMT COPAY REQ",Y["R":"REQ",Y["P":"PEND ADJ",Y["N":"NOT REQ",1:"")
 Q $P(X,U,3)_U_Y_U_$P(X,U,2)
 ;
FCO(DFN) ; return current status of copay test in external form
 ; input:                DFN=ifn of patient
 ; ouput:    [returned]  COT^SCOT^LST
 ;           COT=external format of current status
 ;           SCOT=shortened format of current staus
 ;           LST=date of last test
 ;
 N X,Y
 S X=$$LST^DGMTU(DFN,"",2)
 S Y=$P(X,U,4),Y=$S(Y["E":"EXEMPT",Y["M":"NON-EXEMPT",Y["I":"INCOMPLETE",Y["L":"NO LONGER APPL.",1:"")
 Q $P(X,U,3)_U_Y_U_$P(X,U,2)
 ;
XMY(GROUP,SDUZ,SDPOST) ; -- set up XMY for mail group members
 ; input: GROUP := mail group efn [required]
 ;         SDUZ := send to current user [ 0|no ; 1|yes] [optional]
 ;       SDPOST := send to postmaster if XMY is undefined
 ;                 [ 0|no ; 1|yes] [optional]
 ; output:  XMY := array of users
 ;        XMDUZ := message sender set postmaster
 ;
 N I K XMY
 I '$D(SDUZ) N SDUZ S SDUZ=1
 I '$D(SDPOST) N SDPOST S SDPOST=1
 S XMY("G."_$P($G(^XMB(3.8,GROUP,0)),U))=""
 I SDUZ,DUZ S XMY(DUZ)=""
 ; makes sure it gets sent to someone
 I '$D(XMY),SDPOST S XMY(.5)=""
 ; make postmaster the sender so it will show up as new to DUZ
 S XMDUZ=.5
 Q
 ;
SCREEN(Y,SDDT) ; -- screen called when entering a provider in the
 ; DEFAULT PROVIDER field (#16) or PROVIDER field (#.01) of the PROVIDER
 ; multiple (#2600) in the HOSPITAL LOCATION file (#44).
 ;
 ; Selects active providers with an active entry in the NEW PERSON 
 ; file (#200) for PERSON CLASS.
 ;
 ; INPUT:  Y = ien of file 200
 ;         SDDT = today's date
 ; OUTPUT: 1 to select; 0 to not select
 ;
 S:'+$G(SDDT) SDDT=DT I '+$G(Y) Q 0
 N SDINACT,SDT,SDY S SDY=0
 ; check if provider active
 S SDINACT=$G(^VA(200,+Y,"PS"))
 Q:'$S(SDINACT']"":1,'+$P(SDINACT,"^",4):1,DT<+$P(SDINACT,"^",4):1,1:0) SDY
 S SDT=+$P($G(^VA(200,+Y,0)),U,11)
 Q $S('SDT:1,(SDT<DT):0,1:1)   ;IHS/ANMC/LJF 8/15/2001 bypass HCFA class
 Q:$S('SDT:0,(SDT<DT):1,1:0) 0
 I $$GET^XUA4A72(Y,SDDT)>0 S SDY=1
 Q SDY
 ;
HELP(SDDT) ; -- executable help called when entering a provider in the
 ; DEFAULT PROVIDER field (#16) or PROVIDER field (#.01) of the PROVIDER
 ; multiple (#2600) in the HOSPITAL LOCATION file (#44), the PROVIDER
 ; (#.01) field of the V PROVIDER file (#9000010.06), or in the
 ; PROVIDER prompt of the Check-out screen.  display active providers
 ; with an active entry in the NEW PERSON file (#200) for PERSON CLASS.
 ;
 ; INPUT:  SDDT = today's date
 ; OUTPUT: display of active providers with an active entry in the NEW
 ;         PERSON file (#200) for PERSON CLASS
 ;
 S:'+$G(SDDT) SDDT=DT
 N D,DO,DIC,X
 S X="??",DIC="^VA(200,",DIC(0)="EQ",D="B"
 S DIC("S")="I $$SCREEN^SDUTL2(Y,SDDT)"
 D IX^DIC
 Q 
 ;
SCAN(SDINDEX,SDBEG,SDEND,SDCB,SDFN,SDIR) ; -- api to invoke scan
 N SDQID
 D OPEN^SDQ(.SDQID)
 D INDEX^SDQ(.SDQID,SDINDEX,"SET")
 IF SDINDEX="PATIENT/DATE"!(SDINDEX="PATIENT") D PAT^SDQ(.SDQID,SDFN,"SET")
 IF SDINDEX="PATIENT/DATE"!(SDINDEX="DATE/TIME") D DATE^SDQ(.SDQID,SDBEG,SDEND,"SET")
 D SCANCB^SDQ(.SDQID,SDCB,"SET")
 D ACTIVE^SDQ(.SDQID,"TRUE","SET")
 D SCAN^SDQ(.SDQID,SDIR)
 D CLOSE^SDQ(.SDQID)
SCANQ Q
 ;
MHCLIN(SDCL,SDSC) ;;Determines if Mental health Clinic requiring GAF
 ;;This will be a supported call
 ;;Determines whether the clinic passed is a Mental Health clinic that requires Gaf 
 ;;Input - SDCL = Clinic IEN
 ;;        SDSC = DSS Stop Code [Optional]
 ;;               For Visit File entries where the Clinic IEN is not available
 ;;               but the DSS identifier is.
 ;;
 ;;Output - 1 = Mental health clinic requiring a Gaf
 ;;         0 = Not a clinic requiring a Gaf
 N SDNOGAF,SDSTOP,SDCS,SDMH
 S SDNOGAF="526,527,528,530,533,536,537,542,545,546,565,566,573,574,579"
 ;; Get either the Clinic IEN or the Clinic Stop code
 I $G(SDCL) D
 . S SDSTOP=$P($G(^SC(SDCL,0)),"^",7)
 E  D
 . S SDSTOP=$G(SDSC)
 ;
 ;IHS/ITSC/WAR 4/15/04 Mod to handle 2 digit clinic codes (STOP CODES)
 ;       starting with the number 5
 ;S SDCS=$P($G(^DIC(40.7,+SDSTOP,0)),"^",2),SDMH=$S(SDNOGAF[SDCS:0,$E(SDCS)=5:1,1:0)
 S SDCS=$P($G(^DIC(40.7,+SDSTOP,0)),"^",2)
 I $L(SDCS)=2 Q 0
 S SDMH=$S(SDNOGAF[SDCS:0,$E(SDCS)=5:1,1:0)
 ;IHS/ITSC/WAR 4/15/04 end
 Q SDMH
 ;
NEWGAF(DFN) ;;Determine if new GAF Score needed
 ;;This will be a supported call
 ;;Determines if a new Gaf is required for a patient and retrieves previous Gaf data
 ;; If patient is deceased, returns a 0, no new GAF required
 ;;
 ;;Input - Patient IEN
 ;;Output:
 ;;       piece 1 = -1 if New Gaf needed and no previous data
 ;;               = 1 if New Gaf needed and previous data exists
 ;;               = 0 if no New Gaf needed and previous exists
 ;;       piece 2 = previous Gaf score
 ;;       piece 3 = previous Gaf date
 ;;       piece 4 = previous Gaf Providers IEN
 ;;
 N SDGAF,SDGAFDT,VADM
 ;
 S SDGAF=$$RET^YSGAF(DFN)
 ;; Check for deceased patient.
 D DEM^VADPT
 Q:+$G(VADM(6)) "0^"_SDGAF_"^1"
 D KVAR^VADPT
 ;
 Q:SDGAF=-1 -1
 S X1=$P(SDGAF,"^",2),X2=90 D C^%DTC
 Q $S(DT>X:1,1:0)_"^"_SDGAF
 ;
GAFCM() ;;
 N DIR,DIRUT
 S DIR("A",1)="But a new GAF Score is needed for this patient!"
 S DIR("A")="Are you sure you want to bypass the check out screen? "
 S DIR("B")="No",DIR(0)="YA" W ! D ^DIR
 Q +$G(Y)
COLLAT(SDEC) ;Determines if patient has a collateral eligibility status
 ;
 ;  INPUT:  SDEC = patient eligibility status
 ;
 ; OUTPUT:  1 = collateral patient
 ;          0 = non-collateral patient
 ;
 Q:$G(SDEC)="" 0
 I $$GET1^DIQ(8,SDEC,8,"I")=13 Q 1
 Q 0
 ;
ELSTAT(DA) ;Retrieve patient eligibility status
 ;
 ;  INPUT:  DA = patient IEN
 ;
 ; OUTPUT:  
 ;    Function Value - returns the internal entry number for patient's
 ;           eligibility status.
 ;
 Q:$G(DA)="" ""
 Q $$GET1^DIQ(2,DA,.361,"I")
