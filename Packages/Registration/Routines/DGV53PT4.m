DGV53PT4 ;MTC/ALB - Provider Conversion Continued ; 21 JAN 93
 ;;5.3;Registration;;Aug 13, 1993
 ;
CON457 ;-- This routine will perform the conversion to file #200 for the
 ;   Facility Treating Specialty (#45.7)
 ;
 N RECNUM,SEQ,NODE,MULT,PROV,PREC,TREC,PSAV,OK
 ;-- get entry in File 43 for conversion of file 45.7
 D ADDPC^DGV53PT1(45.7)
 ;-- determine if conversion needs to be re-started.
 S PSAV=$O(^DG(43,1,"PCON","B",45.7,0)),PREC=$G(^DG(43,1,"PCON",+PSAV,0))
 ;-- quit if file is already converted
 G:$P(PREC,U,6)="Y" CON457Q
 ;-- create entry in log file
 D NEWFILE^DGV53PT1(45.7)
 ;-- if record already present then re-start
 S OK=1 D REST457(PREC,PSAV)
 ;-- start of main loop
 F  S RECNUM=$O(^DIC(45.7,RECNUM)) Q:'RECNUM  S TREC=TREC+1 W:'(TREC#100) "." D
 . ;-- update 'PRO' mulitiple
 . S SEQ=0 F  S SEQ=$O(^DIC(45.7,RECNUM,"PRO",SEQ)) Q:'SEQ  D
 .. ;-- get provider
 .. S PROV=$P($G(^DIC(45.7,RECNUM,"PRO",SEQ,0)),U)
 .. ;-- save provider information
 .. S ^DG(43,1,"PCON",PSAV,0)=45.7_U_STIME_U_U_RECNUM_U_U_U_TREC_U_"PRO"_U_SEQ_U_PROV
 .. I PROV D DIC457(RECNUM,SEQ,PROV)
 ;-- update conversion entry in file 43
 D DONE^DGV53PT1(PSAV,TREC),COMFILE^DGV53PT1(45.7,OK)
CON457Q ;
 Q
DIC457(RECNUM,SEQ,PROV) ;-- process PTF 'PRO' multiple
 ; INPUT :RENUM - PTF Record Number to process
 ;        SEQ   - Sequence Number in 'PRO' multiple
 ;        PROV  - Current Provider Pointer
 ;
 N X,Y
 S X=$G(^DIC(16,+PROV,"A3"))
 I 'X S Y=">>> Provider fld. (10) for seq. #"_SEQ_" in entry #"_RECNUM_" :'"_$P($G(^DIC(16,+PROV,0)),U)_"' could not be converted." S OK=0 D WRERROR^DGV53PT1(Y)
 S DR=".01////"_$S(X:X,1:"@"),DIE="^DIC(45.7,"_RECNUM_",""PRO"",",DA(1)=RECNUM,DA=SEQ D ^DIE K DIE,DA,DR
 Q
 ;
REST457(PREC,PSAV) ;-- This tag will re-process the PTF entry incase the conversion
 ;   needs to be re-started.
 ;  INPUT : PREC - 0 Node of entry in MAS Parameter File for file 45.7
 ;          PSAV - IFN of the entry in file 43
 ;-- get starting point
 I '$P(PREC,U,2) D NOW^%DTC S $P(^DG(43,1,"PCON",PSAV,0),U,2)=%
 S STIME=$P(^DG(43,1,"PCON",PSAV,0),U,2),RECNUM=+$P(PREC,U,4),MULT=$P(PREC,U,8),NODE=$P(PREC,U,5),SEQ=+$P(PREC,U,9),TREC=+$P(PREC,U,7),CURPT=$P(PREC,U,10)
 I 'RECNUM,'SEQ Q
 ;-- check and process 'PRO' multiple
 S:SEQ X=$P($G(^DIC(45.7,RECNUM,"PRO",SEQ,0)),U)
 I SEQ,X,$P(PREC,U,10)=X D DIC457(RECNUM,SEQ,X)
 F  S SEQ=$O(^DIC(45.7,RECNUM,"PRO",SEQ)) Q:'SEQ  D
 . ;-- get provider
 . S PROV=$P($G(^DIC(45.7,RECNUM,"PRO",SEQ,0)),U)
 . ;-- save provider information
 . S ^DG(43,1,"PCON",PSAV,0)=45.7_U_STIME_U_U_RECNUM_U_U_U_TREC_U_"PRO"_U_SEQ_U_PROV
 . I PROV D DIC457(RECNUM,SEQ,PROV)
 Q
 ;
CON392 ;-- This routine will perform the conversion to file #200 for the
 ;   Benificiary Travel Claim File (#392)
 ;
 N RECNUM,SEQ,NODE,MULT,PROV,PREC,TREC,PSAV,STIME,OK
 ;-- get entry in File 43 for conversion of file 392
 D ADDPC^DGV53PT1(392)
 ;-- determine if conversion needs to be re-started.
 S PSAV=$O(^DG(43,1,"PCON","B",392,0)),PREC=$G(^DG(43,1,"PCON",+PSAV,0))
 ;-- quit if file is already converted
 G:$P(PREC,U,6)="Y" CON392Q
 ;-- create entry in log file
 D NEWFILE^DGV53PT1(392)
 ;-- if record already present then re-start
 S OK=1 D REST392(PREC,PSAV)
 ;-- start of main loop
 F  S RECNUM=$O(^DGBT(392,RECNUM)) Q:'RECNUM  S TREC=TREC+1 W:'(TREC#100) "." D
 . ;-- get provider
 . S PROV=$P($G(^DGBT(392,RECNUM,"A")),U)
 . ;-- save provider information from piece 1 of "A" node
 . S ^DG(43,1,"PCON",PSAV,0)=392_U_STIME_U_U_RECNUM_U_"A"_U_U_TREC_U_U_U_PROV
 . ;-- update 41 field of node "A"
 . I PROV D DGBT392(RECNUM,PROV)
 ;-- enter completion time, mark conversion as completed
 D DONE^DGV53PT1(PSAV,TREC),COMFILE^DGV53PT1(392,OK)
CON392Q ;-- exit
 Q
 ;
DGBT392(RECNUM,PROV) ;-- process ^DGBT field 41
 ; INPUT : RECNUM - Record Number to process
 ;         PROV   - Current Provider Pointer
 ;
 N X,Y
 Q:'PROV
 S X=$G(^DIC(16,+PROV,"A3"))
 I 'X S Y=">>> Authorizing Person fld. (41) for entry #"_RECNUM_" :'"_$P($G(^DIC(16,+PROV,0)),U)_"' could not be converted." S OK=0 D WRERROR^DGV53PT1(Y)
 S DR="41////"_$S(X:X,1:"@"),DIE="^DGBT(392,",DA=RECNUM D ^DIE K DA,DIE,DR
 Q
 ;
REST392(PREC,PSAV) ;-- This tag will re-process the entry incase the conversion
 ;   needs to be re-started.
 ;  INPUT : PREC - 0 Node of entry in MAS Parameter File for file 392
 ;
 ;-- get starting point
 I '$P(PREC,U,2) D NOW^%DTC S $P(^DG(43,1,"PCON",PSAV,0),U,2)=%
 S STIME=$P(^DG(43,1,"PCON",PSAV,0),U,2),RECNUM=+$P(PREC,U,4),MULT=$P(PREC,U,8),NODE=$P(PREC,U,5),SEQ=+$P(PREC,U,9),TREC=+$P(PREC,U,7),CURPT=$P(PREC,U,10)
 I 'RECNUM Q
 ;-- check if provider field has been processed
 S X=$P($G(^DGBT(392,RECNUM,"A")),U)
 I X,$P(PREC,U,10)=X D DGBT392(RECNUM,X)
 Q
 ;
