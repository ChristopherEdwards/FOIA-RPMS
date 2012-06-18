BSDPOST ; IHS/ANMC/LJF - PIMS POSTINIT ;  [ 08/24/2004  11:32 AM ]
 ;;5.3;PIMS;**1001,1003,1004,1005**;MAY 28, 2004
 ; post init code for Scheduling data
 ;;IHS/ITSC/LJF 04/14/2005 PATCH 1003 added 1 BTS protocol name to end of routine
 ;              06/23/2005 PATCH 1003 added 1 APCH protocol name to end of routine
 ;              08/24/2005 PATCH 1004 added 4 BSDX (GUI Scheduling) protocols
 ;IHS/OIT/LJF   02/16/2006 PATCH 1005 added new BSDAM RS AT CHECKIN to protocol list
 ;                                    (documenting sequence number assignments)
 ;
 Q
 ;IHS/ITSC/WAR 8/21/03 new Xref coming in w/Pkg, now need to
ASTOP ;EP; -- reindex existing records for historic visits in EHR
 S DIK="^SC("
 S DIK(1)="8^ASTOP"
 D ENALL^DIK
 Q
 ;
 ;IHS/ITSC/WAR 10/17/03 added - updates the Sched ver# in pkg file
 ;IHS/ITSC/LJF 1/16/2004 added more updates
PKGFILE ;EP
 NEW VER,BDGV,BDGN,X,DA,DIC,Y,DIE,DR
 I $D(XPDNM) S VER=$$VER^XPDUTL(XPDNM)
 I $G(VER)]"" D
 .; update current version field
 .S BDGN=$O(^DIC(9.4,"C","SD",0)) Q:'BDGN
 .S ^DIC(9.4,BDGN,"VERSION")=VER
 .;
 .; clean up old 5.3 test versions
 .S BDGV=0 F  S BDGV=$O(^DIC(9.4,BDGN,22,"B",BDGV)) Q:BDGV=""  D
 ..I BDGV["5.3",BDGV'=5.3 D
 ...S DIE="^DIC(9.4,"_BDGN_",22,",DA(1)=BDGN,DR=".01///@"
 ...S DA=$O(^DIC(9.4,BDGN,22,"B",BDGV,0)) Q:'DA
 ...D ^DIE
 .;
 .; now add version multiple without test version #
 .S DIC="^DIC(9.4,"_BDGN_",22,",DIC(0)="L",X=5.3
 .S DIC("P")=$P(^DD(9.4,22,0),U,2)
 .S DIC("DR")="2///"_DT_";3///`"_DUZ,DA(1)=BDGN
 .D ^DIC
 ;
 D PATCHES^BSDPOST2   ;add patch history
 Q
 ;
AIHSDAM ;EP; -- creates xref AIHSDAM upon installation
 ;IHS/ITSC/WAR 8/19/2004 PATCH #1001 Next line REMd to allow a call
 ;  to this tag (from PATCH 1001 post-init rtn) to make sure every
 ;  site has run this sub-rtn w/o a problem.  See 16^BDGPOST...
 ;  ^BDGPOST(16) has already been set by another process.  Next line
 ;  was REMd for the above mentioned reason.
 ;Q:$D(^BDGX(16))   ;already done
 D BMES^XPDUTL("Creating AIHSDAM cross-reference on file 44...")
 ;
 NEW CLIN,DATE,PAT,MADE
 K ^SC("AIHSDAM")
 S CLIN=0 F  S CLIN=$O(^SC(CLIN)) Q:'CLIN  D
 . S DATE=2991000 F  S DATE=$O(^SC(CLIN,"S",DATE)) Q:'DATE  D
 .. I '$D(ZTQUEUED) W "."
 .. S PAT=0  F  S PAT=$O(^SC(CLIN,"S",DATE,1,PAT)) Q:'PAT  D
 ... S MADE=$P($G(^SC(CLIN,"S",DATE,1,PAT,0)),U,7)
 ... I MADE]"" S ^SC("AIHSDAM",CLIN,MADE,DATE,PAT)=""
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
LETTER ;EP; create Appointment Slip letter
 Q:$D(^VA(407.5,"B","APPOINTMENT SLIP"))   ;already in file
 D BMES^XPDUTL("Creating Appointment Slip Letter...")
 ;
 NEW IEN,DIC,DLAYGO,DD,DO,X,Y
 S DIC="^VA(407.5,",DLAYGO=407.5,DIC(0)="L",X="APPOINTMENT SLIP"
 S DIC("DR")="1///P;9999999.01///1"
 K DD,DO D FILE^DICN
 I Y<1 K X S X="  ***> Could not create letter; will need to be added manually" D MES^XPDUTL(.X) Q
 ;
 ; now add default text
 S IEN=+Y,^VA(407.5,IEN,1,0)="^407.52^1^1"
 S ^VA(407.5,IEN,1,1,0)="   Your next appointment in our clinic is as follows:"
 S ^VA(407.5,IEN,2,0)="^407.53^1^1"
 S ^VA(407.5,IEN,2,1,0)="To reschedule any appointments listed, please call our main appointment desk at XXX-XXXX."
 ;
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
MERG ;EP; Change Scheduling Merge routine in Package file
 NEW DIE,DA,DR,PKG,IEN
 D BMES^XPDUTL("Updating Merge routine for Scheduling...")
 ;
 ;  find package entry
 S PKG=$O(^DIC(9.4,"C","SD",0)) I 'PKG D MRGERR Q
 ;  find entry under Files Affected
 S IEN=$O(^DIC(9.4,PKG,20,0)) I 'IEN D MRGERR Q
 ;  make sure entry if so file 2 (^DPT)
 I $P($G(^DIC(9.4,PKG,20,IEN,0)),U)'=2 D MRGERR Q
 ;
 ; now update entry
 S DIE="^DIC(9.4,"_PKG_",20,",DA(1)=PKG,DA=IEN,DR="3///BSDMERG" D ^DIE
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
MRGERR ; process error message for package merge update
 K X S X=$$SP(10)_"Cannot find SD Package; update manually."
 D MES^XPDUTL(.X)
 Q
 ;
CLINIC ;EP; copy clinic parameters to new locations
 ; IHS fields that used to be in file 44 are now in 9009017.2
 ;
 Q:$D(^BDGX(2))    ;already done
 D BMES^XPDUTL("Copying IHS fields for each active clinic to new file...")
 NEW CLN,OLD,NODE,X,Y,Z
 S CLN=0 F  S CLN=$O(^SC(CLN)) Q:'CLN  D
 . ;
 . Q:'$$ACTV^BSDU(CLN,DT)         ;quit if not currently active
 . ;
 . ; stuff "ask check-in/check-out time to YES
 . NEW DIE,DA,DR
 . S DIE=44,DA=CLN,DR="24///1" D ^DIE
 . ;
 . ; if entry not in new file, add it
 . I '$D(^BSDSC(CLN)) D  I Y<1 Q
 .. NEW DIC,DLAYGO,X,DINUM,DD,DO
 .. S DIC="^BSDSC(",DLAYGO=9009017.2,(X,DINUM)=CLN,DIC(0)="L"
 .. D FILE^DICN
 . ;
 . ; now copy fields
 . S OLD=$G(^SC(CLN,9999999)) Q:OLD=""   ;quit if no data
 . ;
 . ;   move fields to new file and new piece
 . F NODE="2^5","6^3","7^2","9^9","13^8","14^13","15^14" D
 .. S $P(^BSDSC(CLN,0),U,$P(NODE,U,2))=$P(OLD,U,+NODE)
 . ;
 . ;   2 fields need set of codes converted Y/N to 1/0
 . I $P(OLD,U)]"" S $P(^BSDSC(CLN,0),U,4)=$S($P(OLD,U)="Y":1,1:0)
 . I $P(OLD,U,4)]"" S $P(^BSDSC(CLN,0),U,7)=$S($P(OLD,U,4)="Y":1,1:0)
 . ;
 . ;   merge med profile & apro into one new field
 . ;IHS/ITSC/WAR 2/3/04 need to init Z each time for "",0 and "N"
 . S Z=0
 . S X=$P(OLD,U,3),Y=$P($G(^SC(CLN,"PS")),U)
 . ;
 . ;IHS/ITSC/LJF 4/21/2004 old field had 0=yes; 1=no
 . ;I (X="Y"),(Y=1) S Z=3     ;both
 . ;I (X="Y"),(Y'=1) S Z=1    ;med profile only
 . ;I (X'="Y"),(Y=1) S Z=2    ;action profile only
 . I (X="Y"),(Y=0) S Z=3     ;both
 . I (X="Y"),(Y'=0) S Z=1    ;med profile only
 . I (X'="Y"),(Y=0) S Z=2    ;action profile only
 . ;
 . S $P(^BSDSC(CLN,0),U,6)=$S($G(Z):Z,1:0)
 . ;
 . ;   move default visit provider to provider multiple
 . S X=$P(OLD,U,8) I X,'$D(^SC(CLN,"PR","B",X)) D
 .. NEW DIC,DLAYGO,DA
 .. S DIC="^SC("_CLN_",""PR"",",DIC(0)="L",X="`"_X,DA(1)=CLN
 .. S DIC("DR")=".02///1",DIC("P")="44.1P" D ^DIC
 . ;
 . ;   copy overbook users
 . S OVB=0 F  S OVB=$O(^SC(CLN,"IHS OB",OVB)) Q:'OVB  D
 .. S NODE=$G(^SC(CLN,"IHS OB",OVB,0)) Q:NODE=""
 .. Q:$D(^BSDSC(CLN,1,"B",+NODE))    ;already there
 .. NEW DIC,DLAYGO,X,DA
 .. S DIC="^BSDSC("_CLN_",1,",DIC("P")="9009017.21P",DA(1)=CLN
 .. S DIC(0)="L",X="`"_(+NODE),DIC("DR")=".02///"_$P(NODE,U,2)
 .. D ^DIC
 ;
 ; reindex new file
 K X S X="  Reindexing new Cllinic Setup file..." D MES^XPDUTL(.X)
 NEW DIK S DIK="^BSDSC(" D IXALL^DIK
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
EVENT ;EP; build event driver menu based on protocols installed
 ; If you have the following installed, I will add them to event driver
 ; Called by EVENT^BSDPOST2 after ADT event driver updated
 ;
 D BMES^XPDUTL("Building Scheduling Event Driver...")
 NEW IEN,ITEM,BSDE
 S BSDE=$O(^ORD(101,"B","BSDAM APPOINTMENT EVENTS",0)) Q:'BSDE
 ;
 ; loop thru list of known protocols
 F BSDI=1:1:2 S ITEM=$P($T(PROT+BSDI),";;",2) D
 . I $D(^ORD(101,"B",ITEM)) D         ;if protocol exists
 .. S IEN=$O(^ORD(101,"B",ITEM,0)) Q:'IEN
 .. Q:$D(^ORD(101,BSDE,10,"B",IEN))   ;already added to event driver
 .. ;
 .. ; go ahead and add it
 .. S DIC="^ORD(101,"_BSDE_",10,",DIC(0)="L",DLAYGO=101.01
 .. S DA(1)=BSDE,DIC("P")="101.01PA",X=IEN
 .. S DIC("DR")="3///"_$P($T(PROT+BSDI),";;",3)
 .. K DD,DO D FILE^DICN
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
PROT ;; Protocols to add to event driver
 ;;BHL PYXIS SCHEDULING;;12;;
 ;;VEN PRINT PCC+ ENCOUNTER FORM;;15;;
 ;;BTS SCHEDULE A PATIENT (3M HDM);;51;;
 ;;APCH CHECK-IN PRINT PAT HS;;31;;
 ;;BSDX ADD APPOINTMENT;;10.2;;
 ;;BSDX CANCEL APPOINTMENT;;10.4;;
 ;;BSDX CHECKIN APPOINTMENT;;10.6;;
 ;;BSDX NOSHOW APPOINTMENT;;10.8;;
 ;;BSDAM RS AT CHECKIN;;13;;
