DG53426D ;ALB/AEG - DG*5.3*426 POST-INSTALLATION ;2-19-02
 ;;5.3;Registration;**426**;2-19-02
 ;
 ; This routine is a modified version of IVMCMD in that it calls a
 ; modified version of IVMCMD1 called DG53426E which only deletes the
 ; records from the ANNUAL MEANS TEST file (#408.31).  It does NOT 
 ; send a 'delete' bulletin/notification to the local mail group. It
 ; will create a case record in the IVM Patient file (#301.5) and it
 ; does call the means test event driver and will call the post-install
 ; version of DGMTR.
 ;
EN(MTIEN) ;
 ; This line tage will process an income test deletion request from 
 ; the post-installation portion of patch DG*5.3*426.
 ;
 ; Input - MTIEN = IEN of REQUIRED test to be deleted in file 408.31.
 ;
 ; Output(s):
 ;       Function Value: - 1 test deleted successfully.
 ;                         0 test not deleted.
 ;
 ; init variables
 N DFN,DGERR,DGLINK,DGNODE0,DGDOT,DGTOT,DGDONE
 S DGDONE=0
 ;
EN1 ; Get zeroth node of file 408.31 entry.
 S DGNODE0=$G(^DGMT(408.31,MTIEN,0))
 I 'DGNODE0 Q 1
 S DGDOT=$P($G(DGNODE0),U,1),DGTOT=$P($G(DGNODE0),U,19)
 S DFN=$P($G(DGNODE0),U,2),DGLINK=$P($G(^DGMT(408.31,MTIEN,2)),U,6)
 I DGTOT=2,DGLINK Q 0
 I DGTOT=1,DGLINK D  I $G(DGERR) Q 0
 .D DELETE(DGLINK,DFN,DGDOT) ; delete copay
 D DELETE(MTIEN,DFN,DGDOT)
 Q DGDONE
 ;
DELETE(MTIEN,DFN,DGDOT) ;delete a copay or MT
 ;
 ;Set DGMTP prior to deleting records
 S DGMTACT="DEL",DGMTI=MTIEN D PRIOR^DGMTEVT
 ; Individual annual Income array (DGINC)
 D ALL^DGMTU21(DFN,"VSC",DGDOT,"IR",MTIEN)
 ;
DEL22 ; Delete veteran, spouse, & dependent entries from the Income Relation
 ; (#408.22) file:
 ; 
 ; - Veteran #408.22 record IEN
 S DA=$G(DGINR("V")) D
 .Q:'DA
 .S DIK="^DGMT(408.22,"
 .L +^DGMT(408.22,DA):1
 .D ^DIK,IX1^DIK
 .L -^DGMT(408.22,DA)
 .K DA,DIK
 ;
 ; - Spouse 408.22 record
 S DA=$G(DGINR("S")) D
 .Q:'DA
 .S DIK="^DGMT(408.22,"
 .L +^DGMT(408.22,DA):1
 .D ^DIK,IX1^DIK
 .L -^DGMT(408.22,DA)
 .K DA,DIK
 ;
 ; - All Dependent Children entries in file 408.22
 S DGDEP=0
 F  S DGDEP=$O(DGINR("C",DGDEP)) Q:'DGDEP  D
 .S DA=$G(DGINR("C",DGDEP))
 .S DIK="^DGMT(408.22,"
 .L +^DGMT(408.22,DA):1
 .D ^DIK,IX1^DIK
 .K DA,DIK
 ;
DEL21 ; Delete veteran, spouse, & dependent children entries from the
 ; Individual Annual Income (#408.21) file:
 S DA=$G(DGINC("V")) D
 .Q:'DA
 .S DIK="^DGMT(408.21,"
 .L +^DGMT(408.21,DA):1
 .D ^DIK,IX1^DIK
 .L -^DGMT(408.21,DA)
 .K DA,DIK
 ;
 ; Spouse
 S DA=$G(DGINC("S")) D
 .Q:'DA
 .S DIK="^DGMT(408.21,"
 .L +^DGMT(408.21,DA):1
 .D ^DIK,IX1^DIK
 .L -^DGMT(408.21,DA)
 .K DA,DIK
 ;
 ; ALL Depn. Children 
 S DGDEP=0
 F  S DGDEP=$O(DGINC("C",DGDEP)) Q:'DGDEP  D
 .S DA=$G(DGINC("C",DGDEP)),DIK="^DGMT(408.21,"
 .L +^DGMT(408.21,DA):1
 .D ^DIK,IX1^DIK
 .L -^DGMT(408.21,DA)
 .K DA,DIK
 ;
 ; Logic for #408.12, #408.1275 & #408.13 file enties.
 D SETUPAR
 ;
 ; look for IVM Patient relation file entries.  If no entries in "AIVM"
 ; x-ref, no dependent changes are required.
 S DG12="" F  S DG12=$O(^DGPR(408.12,"AIVM",MTIEN,DG12)) Q:'DG12  D  Q:$D(DGERR)
 .; if any entry cannot be found in 408.12 set DGERR
 .I $G(^DGPR(408.12,+DG12,0))']"" D  Q
 ..S DGERR="" Q
 .;
 .; if only 1 record exists in the 408.1275 multiple then only 1 
 .; dependent to delete
 .I $P($G(^DGPR(408.13,+DG12,"E",0)),U,4)=1 D  Q
 ..;
 ..S DG13=$P($P($G(^DGPR(408.12,+DG12,0)),U,3),";")
 ..I $G(^DGPR(408.13,+DG13,0))']"" D  Q
 ...S DGERR="" Q
 ..;
 ..; Delete 408.12 & 408.13 records for dependent
 ..S DA=DG12,DIK="^DGPR(408.12," D ^DIK,IX1^DIK K DA,DIK
 ..S DA=DG13,DIK="^DGPR(408.13," D ^DIK,IX1^DIK K DA,DIK
 ..Q
 .;
 .; Delete #408.1275 multi. entry from dependent and change demo
 .; data in 408.12 & 408.13 back to VAMC values. OR delete 408.1275
 .; entry from inactivated VAMC dependent.
 .; if no entry found in multiple --- set DGERR
 .S DG121="",DG121=$O(^DGPR(408.12,"AIVM",MTIEN,+DG12,DG121))
 .; if no entry is found in multiple set DGERR
 .I $G(^DGPR(408.12,+DG12,"E",+DG121,0))']"" D  Q
 ..S DGERR="" Q
 .;
 .S DGVACMA=$P($G(^DGPR(408.12,+DG12,"E",+DG121,0)),U,2)
 .; Active depend?
 .I DGVACMA D
 ..S DR=".02////0",DA=+DG121,DA(1)=0
 ..S DIE="^DGPR(408.12,"_+DG12_",""E"","
 ..D ^DIE S DGVACMA=0 Q
 .;
 .S DA(1)=DG12,DA=DG121,DIK="^DGPR(408.12,"_DA(1)_",""E"","
 .D ^DIK K DA(1),DA,DIK
 .;
 .Q
 ;
 ; Complete the deletion of an income test.
 D EN^DG53426E
 ;
ENQ Q
 ;
 ;
SETUPAR ; Create data array DGMAR1() where
 ; 1 - Subscript is MT Changes Type (#408.42) file node where type
 ;     of change = Name, DOB, SSN, Sex, Relationship.
 ; 2 - 1st piece is #408.12 or #408.13 file.
 ; 3 - 2nd piece is #408.12 or #408.13 file field number.
 ;
 F DG41=4:1 S DG411=$P($T(TYPECH+DG41),";;",2) Q:DG411="QUIT"  D
 .S DGMAR($P(DG411,";"))=$P(DG411,";",2,3)
 K DG41,DG411
 Q
DELTYPE(DFN,MTDATE,TYPE) ;
 ; Will delete any primary test for patient (DFN) for same income
 ; year as MTDATE for test of type = TYPE
 ;
 Q:'$G(DFN)
 Q:'$G(MTDATE)
 Q:'$G(TYPE)
 N DGNODE,DGYEAR,RET
 S DGYEAR=$E(MTDATE,1,3)_1230.99999
 D
 .S DGNODE=$$LST^DGMTU(DGDFN,DGYEAR,TYPE)
 .Q:'+DGNODE
 .I $E($P(DGNODE,U,2),1,3)'=$E(YEAR,1,3) Q
 .; Don't delete auto created Rx copay tests - they are deleted
 .; by deleting the MT that they are linked to.
 .I TYPE=2,+$P($G(^DGMT(408.31,+DGNODE,2)),U,6) Q
 .I $P(DGNODE,U,5),$P(DGNODE,U,5)'=1 I $$EN(+MTNODE) D
 ..S RET=$$LST^DGMTU(DGDFN,DT,DGTYPE)
 ..I $E($P(RET,U,2),1,3)'=$E(YEAR,1,3) S RET=""
 ..D ADD^IVMCMB(DGDFN,DGTYPE,"DELETE PRMYTEST",$P(DGNODE,U,2),$P(DGNODE,U,4),$P(RET,U,4))
 Q
 ;
TYPECH ; Type of dependent change (#408.41/#408.42) file
 ;     1st piece - 408.42 table file node
 ;     2nd piece - file (#408.12 or 408.13)
 ;     3rd piece - 408.12 or 408.13 field
 ;;16;408.13;.01
 ;;17;408.13;.03
 ;;18;408.13;.09
 ;;19;408.13;.02
 ;;20;408.12;.02
 ;;QUIT
 Q
