DGV53PT6 ;ALB/MTC - MAS v5.3 Post Init Routine ; 07 JAN 93
 ;;5.3;Registration;;Aug 13, 1993
 ;
 ;
CON45 ;-- This routine will perform the conversion to file #200 for the
 ;   PTF file (#45)
 ;
 N RECNUM,SEQ,NODE,MULT,PROV,PREC,TREC,PSAV,OK
 ;-- get entry in File 43 for conversion of file 45
 D ADDPC^DGV53PT1(45)
 ;-- determine if conversion needs to be re-started.
 S PSAV=$O(^DG(43,1,"PCON","B",45,0)),PREC=$G(^DG(43,1,"PCON",+PSAV,0))
 ;-- quit if file is already converted
 G:$P(PREC,U,6)="Y" CON45Q
 ;-- create entry in log file
 D NEWFILE^DGV53PT1(45)
 ;-- if record already present then re-start
 S OK=1 D REST45(PREC,PSAV)
 ;-- start of main loop
 F  S RECNUM=$O(^DGPT(RECNUM)) Q:'RECNUM  S TREC=TREC+1 W:'(TREC#100) "." D
 . ;-- get provider
 . S PROV=$P($G(^DGPT(RECNUM,70)),U,15)
 . ;-- save provider information
 . S ^DG(43,1,"PCON",PSAV,0)=45_U_STIME_U_U_RECNUM_U_70_U_U_TREC_U_U_U_PROV
 . ;-- update 70 node
 . I PROV D PTF70(RECNUM,PROV)
 . ;-- update <501> mulitiple
 . S SEQ=0 F  S SEQ=$O(^DGPT(RECNUM,"M",SEQ)) Q:'SEQ  D
 .. ;-- get provider
 .. S PROV=$P($G(^DGPT(RECNUM,"M",SEQ,"P")),U,5)
 .. ;-- save provider information
 .. S ^DG(43,1,"PCON",PSAV,0)=45_U_STIME_U_U_RECNUM_U_"P"_U_U_TREC_U_"M"_U_SEQ_U_PROV
 .. I PROV D PTFMP(RECNUM,SEQ,PROV)
 ;-- update conversion entry in file 43
 D DONE^DGV53PT1(PSAV,TREC),COMFILE^DGV53PT1(45,OK)
CON45Q ;
 Q
PTF70(RECNUM,PROV) ;-- process PTF '70' node
 ; INPUT : RECNUM - PTF Record Number to process
 ;         PROV   - Current Provider Pointer
 ;
 N X,Y
 S X=$G(^DIC(16,+PROV,"A3"))
 I 'X S Y=">>> Provider fld. (79.1) for entry #"_RECNUM_" :'"_$P($G(^DIC(16,+PROV,0)),U)_"' could not be converted." S OK=0 D WRERROR^DGV53PT1(Y)
 S DR="79.1////"_$S(X:X,1:"@"),DIE="^DGPT(",DA=RECNUM D ^DIE K DA,DIE,DR
 Q
 ;
PTFMP(RECNUM,SEQ,PROV) ;-- process PTF '501' multiple
 ; INPUT :RENUM - PTF Record Number to process
 ;        SEQ   - Sequence Number in <501> multiple
 ;        PROV  - Current Provider Pointer
 ;
 N X,Y
 S X=$G(^DIC(16,+PROV,"A3"))
 I 'X S Y=">>> <501> #"_SEQ_" Provider fld. (24) for entry #"_RECNUM_" :'"_$P($G(^DIC(16,+PROV,0)),U)_"' could not be converted." S OK=0 D WRERROR^DGV53PT1(Y)
 S DR="24////"_$S(X:X,1:"@"),DIE="^DGPT("_RECNUM_",""M"",",DA(1)=RECNUM,DA=SEQ D ^DIE K DIE,DA,DR
 Q
 ;
REST45(PREC,PSAV) ;-- This tag will re-process the PTF entry incase the conversion
 ;   needs to be re-started.
 ;  INPUT : PREC - 0 Node of entry in MAS Parameter File for file 45
 ;          PSAV - IFN of the entry in file 43
 ;-- get starting point
 I '$P(PREC,U,2) D NOW^%DTC S $P(^DG(43,1,"PCON",PSAV,0),U,2)=%
 S STIME=$P(^DG(43,1,"PCON",PSAV,0),U,2),RECNUM=+$P(PREC,U,4),MULT=$P(PREC,U,8),NODE=$P(PREC,U,5),SEQ=+$P(PREC,U,9),TREC=+$P(PREC,U,7),CURPT=$P(PREC,U,10)
 I 'RECNUM,'SEQ Q
 ;-- check if 70 node has been processed
 S X=$P($G(^DGPT(RECNUM,70)),U,15)
 I X,$P(PREC,U,10)=X,RECNUM,'NODE,'MULT,'SEQ D PTF70(RECNUM,X)
 ;-- check and process <501> multiple
 S:SEQ X=$P($G(^DGPT(RECNUM,"M",SEQ,"P")),U,5)
 I SEQ,X,$P(PREC,U,10)=X D PTFMP(RENUM,SEQ,X)
 F  S SEQ=$O(^DGPT(RECNUM,"M",SEQ)) Q:'SEQ  D
 . ;-- get provider
 . S X=$P($G(^DGPT(RECNUM,"M",SEQ,"P")),U,5)
 . ;-- save provider information
 . S ^DG(43,1,"PCON",PSAV,0)=45_U_STIME_U_U_RECNUM_U_"P"_U_U_TREC_U_"M"_U_SEQ_U_X
 . I X D PTFMP(RECNUM,SEQ,X)
 Q
 ;
