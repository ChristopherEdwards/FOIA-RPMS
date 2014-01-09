DG53591B ;ALB/GN - DG*5.3*591 CLEANUP FOR PURGED DEPENDENT INCOME 2ND PASS; 3/17/04 12:26pm ; 7/26/04 10:55am
 ;;5.3;Registration;**591,1015**;Aug 13, 1993;Build 21
 Q
 ; 
 ; 1. Drive thru the INCOME RELATION file (#408.22) and look for recs
 ;    whose fields of MARRIED LAST CALENDAR YEAR #.05 and 
 ;    LIVED WITH PATIENT #.06 are flagged "Y".
 ; 2. Use the patient DFN to find the corresponding records in the
 ;    PATIENT RELATION file (#408.12).
 ; 3. Drive thru the Effective Date records multiple (#408.1275), in
 ;    reverse order and look for the first spouse rec that is flagged
 ;    as inactive and points to a MT that does not exist.
 ; 4. If found, delete this record.  Keep deleting record until a rec
 ;    is found that points to valid MT.
 ;
EN ; Entry to 2nd pass cleanup of dependent recs
 N DGMT,DGDFN,R21,DG22,LIV,MLY
 ;
 ;drive thru 408.22 per each DFN and look at each DFN in reverse order
 ;to get most recent info on Married last year & living with last year
 S DGDFN=0
 F  S DGDFN=$O(^DGMT(408.22,"B",DGDFN)) Q:'DGDFN  D  Q:ZTSTOP
 . Q:'$D(^DPT(DGDFN,0))
 . S DG22=""
 . F  S DG22=$O(^DGMT(408.22,"B",DGDFN,DG22),-1) Q:'+DG22  D
 . . S MLY=$P($G(^DGMT(408.22,DG22,0)),"^",5)      ;married last year?
 . . S LIV=$P($G(^DGMT(408.22,DG22,0)),"^",6)      ;living w/last yr?
 . . S R21=$P($G(^DGMT(408.22,DG22,0)),"^",2)      ;408.21 ien
 . . S DGMT=$P($G(^DGMT(408.22,DG22,"MT")),"^",1)  ;MT IEN
 . . Q:DGMT=""                                     ;bad MT=null, quit
 . . Q:$P($G(^DGMT(408.31,DGMT,0)),"^",23)'=1      ;not VAMC test,quit
 . . Q:$E(+$G(^DGMT(408.31,DGMT,0)),1,3)<303       ;skip < 2003
 . . Q:('MLY)!('LIV)!(R21="")
 . . Q:'$D(^DGMT(408.22,"AMT",DGMT,DGDFN,R21))
 . . D D40812(DGDFN,R21)
 . ;update last processed info
 . S $P(^XTMP(NAMSPC,0,0),U,7)=DGDFN
 . ;check for stop request after every 20 processed DFN recs
 . I QQ#20=0 D
 . . S:$$S^%ZTLOAD ZTSTOP=1
 . . I $D(^XTMP(NAMSPC,0,"STOP")) S ZTSTOP=1 K ^XTMP(NAMSPC,0,"STOP")
 ;
 ;set status
 I ZTSTOP D
 . S $P(^XTMP(NAMSPC,0,0),U,5,6)="STOPPED"_U_$$NOW^XLFDT
 E  D
 . S $P(^XTMP(NAMSPC,0,0),U,5,6)="COMPLETED"_U_$$NOW^XLFDT
 ;
 Q
 ;
D40812(DFN,R21) ;drive through 408.12 ien's and process spouse relation recs
 N R12,ENODE,EIEN,DA,TEXT,SSN
 Q:R21=""
 S R12=$P($G(^DGMT(408.21,R21,0)),"^",2)
 Q:R12=""
 Q:$P($G(^DGPR(408.12,R12,0)),"^",2)'=2         ;only process spouse
 ; drive through the Effective Date Multiple in ien reverse order
 S EIEN="A"
 F  S EIEN=$O(^DGPR(408.12,R12,"E",EIEN),-1) Q:'EIEN  D  Q:ZTSTOP
 . S SSN=$E(^DPT(DFN,0),1)_$E($P(^DPT(DFN,0),"^",9),6,9)
 . S IVMTOT=IVMTOT+1                            ;tot ien's read
 . S ENODE=$G(^DGPR(408.12,R12,"E",EIEN,0))
 . Q:+$P(ENODE,"^",2)                           ;active flag, quit
 . Q:'+$P(ENODE,"^",4)                          ;no MT ien, quit
 . Q:$D(^DGMT(408.31,$P(ENODE,"^",4),0))        ;ptr to valid MT, quit
 . ;
 . ; if inactive and does not point to a valid MT, delete this
 . ; effective date multiple rec from 408.1275
 . S DA=EIEN,DA(1)=R12,DIK="^DGPR(408.12,"_DA(1)_",""E"","
 . D:'TESTING ^DIK
 . Q:$G(^XTMP(NAMSPC,9999999999.40812,R12,EIEN,"DEL"))=ENODE
 . S ^XTMP(NAMSPC,9999999999.40812,R12,EIEN,"DEL")=ENODE
 . S IVMDPTR=IVMDPTR+1                  ;increment del 408.1275 recs
 . ;
 . ; add to detail XTMP for mail message
 . S TEXT=" SSN:"_SSN_"  Del eff date rec "
 . S TEXT=TEXT_$$FMTE^XLFDT(+ENODE,2)_"  data:"_R12_","_EIEN
 . S TEXT=TEXT_"="_ENODE_" <bad MT"
 . W:'$D(ZTQUEUED) !,TEXT
 . S ^XTMP(NAMSPC,"DET R12",DFN,R12)=TEXT
 ;
 ;update last processed info
 S $P(^XTMP(NAMSPC,0,0),U,2)=IVMTOT            ;last total recs read
 S $P(^XTMP(NAMSPC,0,0),U,8)=IVMDPTR           ;last del 408.1275 recs
 Q
