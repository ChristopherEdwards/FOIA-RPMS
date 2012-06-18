BMCAPI ; IHS/OIT/FCJ -API ADD,EDIT VIEW A NEW REFERRAL- PASSING PATIENT DFN ;          [ 10/20/2006  1:51 PM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**2,3**;JAN 09, 2006
 ;4.0*2 7/20/06 IHS/OIT/FCJ Added flg for closed ref, will no longer
 ;      display as a selection for adding a Secondary ref or modifying
 ;      added flg for display sec ref during sec ref data entry
 ; 4.0*3 5/16/07 multiple changes for testing closed ref, pat w/o ref, editing sec ref
 ; See ^BMCVDOC for system wide variables set by main menu
 ; Patient DFN is passed, BMCADD routine is called to ADD REF's
 ; Patient DFN is passed, BMCRDSP routine is called to DISPLAY REF's
 ; Patient DFN is passed, BMCMOD routine is called to EDIT REF's
 ; Security Key and Site Parameters are required to use options
 ;   BMCDFN=patient ien
 ;
ADD(BMCDFN) ;ENTRY POINT TO ADD A REFERRAL FOR A PATIENT
 D SECCHK
 D:'BMCQ ADD2
 D EOJ
 Q
 ;
ADD2 ;
 S BMCQ=0,BMCMODE="A",BMCLOOK=""
 S APCDOVRR=""
 D REFDISP^BMCADD
 D ASK^BMCADD
 D:'BMCQ GETDATE^BMCADD
 Q
 ;
ADDSEC(BMCDFN) ; ENTRY POINT TO ADD A SECONDARY REFERRAL
 D SECCHK
 I '$D(^BMCREF("AA",DFN)) W !,"PATIENT DOES NOT HAVE ANY REFERRALS." D EOJ Q
 D:'BMCQ ADDSEC2
 D EOJ
 Q
ADDSEC2 ;
 S Y=$P(^DPT(BMCDFN,0),U)
 S BMCAPI=1  ;4.0*2 7/20/06 IHS/OIT/FCJ ADDED FLG TO TST FOR CLOSED REF
 S BMCAPIS=1 ;4.0*2 7/20/06 IHS/OIT/FCJ ADDED FLG TO TST FOR SEC REF
 D PATLKUP^BMCLKID2
 Q:'Y
 I 'BMCRIEN W !,"Patient does not have any Active Referrals." Q   ;4.0*3 5/16/07 IHS/OIT/FCJ added
 S BMCMODE="A",BMCRIEN=BMCRIENT
 ;4.0*2 7/20/06 IHS/OIT/FCJ Cmmt out nxt 2 lns, flg added above
 ;I $P(^BMCREF(BMCRIEN,0),U,15)'="A" W !!,"This is a CLOSED referral, Please select another referral" G ADDSEC2
 ;I $P($G(^BMCREF(BMCRIEN,1)),U,1)'="" W !!,"Please select a PRIMARY referral" G ADDSEC2
 S BMCREC=^BMCREF(BMCRIEN,0),BMCRNUMB=$P(BMCREC,U,2),BMCRTYPE=$P(BMCREC,U,4)
 S BMCQ=0 D CALLIN^BMCADDS Q:BMCQ
 S BMCQ=0 D ADD^BMCADDS Q:BMCQ
 D MEDHX^BMCADDS
 Q
 ;
EDIT(BMCDFN) ;ENTRY POINT TO EDIT A REFERRAL
 D SECCHK
 D:'BMCQ EDIT2
 D EOJ
 Q
EDIT2 ;
 S Y=$P(^DPT(BMCDFN,0),U)
 I '$D(^BMCREF("AA",BMCDFN)) W !,"PATIENT DOES NOT HAVE ANY REFERRALS." Q
 S BMCAPI=1  ;4.0*2 7/20/06 IHS/OIT/FCJ ADDED FLG TO TST FOR CLOSED REF
 D PATLKUP^BMCLKID2
 Q:'Y
 I 'BMCRIEN  W !,"Patient does not have any Active Referrals." Q   ;4.0*3 5/16/07 IHS/OIT/FCJ added
 S BMCMODE="M"
 S (Y,BMCRDATE)=$P(^BMCREF(BMCRIEN,0),U),BMCRNUMB=$P(^(0),U,2)
 ;4.0*2 7/20/06 IHS/OIT/FCJ Cmmt out nxt ln, flg added added above
 ;I $P(^BMCREF(BMCRIEN,0),U,15)'="A" W !!,"This is a CLOSED referral, Please select another referral" G EDIT2
 D DD^%DT S BMCREC("REF DATE")=Y
 I $P($G(^BMCREF(BMCRIEN,1)),U)'="" D  Q     ;4.0*3 5/16/07 IHS/OIT/FCJ added edit for Sec Ref
 .S BMCSRIEN=BMCRIEN,BMCREC=^BMCREF(BMCSRIEN,0)
 .S BMCRIEN=$P(^BMCREF(BMCSRIEN,1),U,2)
 .D EDIT^BMCMODS,MEDHX^BMCMODS
 F  D TYPE^BMCMOD Q:BMCQ
 I BMCDTYPE=13 G EDIT2
 Q
 ;
VIEW(BMCDFN) ;ENTRY POINT TO VIEW A REFERRAL FOR A PATIENT
 D SECCHK I BMCQ D EOJ Q
 D VIEW2
 D EOJ
 Q
VIEW2 ;
 S Y=$P(^DPT(BMCDFN,0),U)
 I '$D(^BMCREF("AA",BMCDFN)) W !,"PATIENT DOES NOT HAVE ANY REFERRALS." Q
 D PATLKUP^BMCLKID2
 Q:'BMCRIENT  ;4.0*3 5/16/07 IHS/OIT/FCJ CHG TEST FOR Q
 D START2^BMCRDSP
 Q
 ;
SECCHK ;TEST FOR USER ASSIGNED BMCZEDIT KEY AND PARAMETERS
 I '$D(^BMCPARM(DUZ(2))) S BMCQ=1 W !,"RCIS parameters are not set up for this Facility" Q
 D:$G(BMCPARM)="" PARMSET^BMC
 S BMCQ=0
 I '$D(^DIC(19.1,"B","BMCZEDIT")) D  Q
 .S BMCQ=1
 .W !,"SECURITY KEY not found notify Site Manager"
 S BMCKEY=0
 S BMCKEY=$O(^DIC(19.1,"B","BMCZEDIT",BMCKEY))
 I '$D(^VA(200,DUZ,51,BMCKEY)) D  Q
 .S BMCQ=1 W !,"Person does not have Keys to use this option"
 Q
 ;
EOJ ;
 D ^BMCKILL
 D EN^XBVK("BMC")
 Q
