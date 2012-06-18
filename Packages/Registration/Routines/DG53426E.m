DG53426E ;ALB/AEG - DG*5.3*426 POST-INSTALLATION;2-19-02
 ;;5.3;Registration;**426**;2-19-02
 ;
 ; This routine is a modified version of IVMCMD1.  It deletes records
 ; from the Annual Means Test file #08.31.  It opens a case record in
 ; the IVM Patient file (#301.5), calls the means test event driver, &
 ; calls DGMTR
 ;
EN ; This entry point is called from DG53426D & contans calls  that are 
 ; responsible for completing the deletion of an income test.
 ;
 D DEL31(MTIEN)
 S DGDONE=1
 ;
 D OPEN(DFN,DGDOT)
 ; Call the Means test event driver
 D EVNT
 ; Call DGMTR if deleted means test.
 I $G(DGTOT)=1 D
 .S DGMSGF=1
 .D EN^DGMTR
 ; cleanup the partition
 D CLEAN
 ;
ENQ Q
 ;
DEL31(MTIEN) ; delete 408.31 entry
 ; mtien - means test file pointer
 ;
 N DA,DIK
 S DA=MTIEN,DIK="^DGMT(408.31,"
 D ^DIK
 Q
 ;
OPEN(DFN,DGDOT) ; Open IVM patient file case record.
 ;
 ; input(s) DFN - Pointer to patient file.
 ;          DGDOT - Date of Means test to be deleted.
 ;
 N DA,DR,DIE
 S DA=$O(^IVM(301.5,"APT",+DFN,+$$LYR^DGMTSCU1(DGDOT),0))
 I $G(^IVM(301.5,+DA,0))']"" G OPENQ
 S DR=".04////0",DIE="^IVM(301.5,"
 D ^DIE
 K ^IVM(301.5,+DA,1)
OPENQ Q
 ;
EVNT ; Call the Means test event driver
 S DGMTYPT=DGTOT D QUE^DGMTR
 Q
 ;
CLEAN ; Cleanup the partition and quit
 K DA,DFN,DGINC,DGINR,DGMTA,DGMTACT,DGMTI,DGMTP
 K DGMTYPT,DIE,DIK,DR,DG12,DG121,DG13,DG41,DG411
 K DGMAR1,DGDEP,DGFILE,DGNODE,DGOLD
 K DGPAT,DGTEXT,DGVACMA
 Q
