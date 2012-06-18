DGV53PT5 ;MTC/ALB - Provider Conversion Continued ; 21 JAN 93
 ;;5.3;Registration;;Aug 13, 1993
 ;
CON411 ;-- This routine will perform the conversion to file #200 for the
 ;   Scheduled Admission File (#41.1)
 ;
 N RECNUM,SEQ,NODE,MULT,PROV,PREC,TREC,PSAV,STIME,OK
 ;-- get entry in File 43 for conversion of file 41.1
 D ADDPC^DGV53PT1(41.1)
 ;-- determine if conversion needs to be re-started.
 S PSAV=$O(^DG(43,1,"PCON","B",41.1,0)),PREC=$G(^DG(43,1,"PCON",+PSAV,0))
 ;-- quit if file is already converted
 G:$P(PREC,U,6)="Y" CON411Q
 ;-- create entry in log file
 D NEWFILE^DGV53PT1(41.1)
 ;-- if record already present then re-start
 S OK=1 D REST411(PREC,PSAV)
 ;-- start of main loop
 F  S RECNUM=$O(^DGS(41.1,RECNUM)) Q:'RECNUM  S TREC=TREC+1 W:'(TREC#100) "." D
 . ;-- get provider
 . S PROV=$P($G(^DGS(41.1,RECNUM,0)),U,5)
 . ;-- save provider information from piece 5 of 0 node
 . S ^DG(43,1,"PCON",PSAV,0)=41.1_U_STIME_U_U_RECNUM_U_5_U_U_TREC_U_U_U_PROV
 . ;-- update 5 field of node 0
 . I PROV D DGS411(RECNUM,PROV)
 ;-- enter completion time, mark conversion as completed
 D DONE^DGV53PT1(PSAV,TREC),COMFILE^DGV53PT1(41.1,OK)
CON411Q ;-- exit
 Q
 ;
DGS411(RECNUM,PROV) ;-- process DGS '5' field of the 0 node
 ; INPUT : RECNUM - Record Number to process
 ;         PROV   - Current Provider Pointer
 ;
 N X,Y
 S X=$G(^DIC(16,+PROV,"A3"))
 I 'X S Y=">>> Provider fld. (5) for entry #"_RECNUM_" :'"_$P($G(^DIC(16,+PROV,0)),U)_"' could not be converted." S OK=0 D WRERROR^DGV53PT1(Y)
 S DR="5////"_$S(X:X,1:"@"),DIE="^DGS(41.1,",DA=RECNUM D ^DIE K DA,DIE,DR
 Q
 ;
REST411(PREC,PSAV) ;-- This tag will re-process the entry incase the conversion
 ;   needs to be re-started.
 ;  INPUT : PREC - 0 Node of entry in MAS Parameter File for file 41.1
 ;
 ;-- get starting point
 I '$P(PREC,U,2) D NOW^%DTC S $P(^DG(43,1,"PCON",PSAV,0),U,2)=%
 S STIME=$P(^DG(43,1,"PCON",PSAV,0),U,2),RECNUM=+$P(PREC,U,4),MULT=$P(PREC,U,8),NODE=$P(PREC,U,5),SEQ=+$P(PREC,U,9),TREC=+$P(PREC,U,7),CURPT=$P(PREC,U,10)
 I 'RECNUM Q
 ;-- check if provider field has been processed
 S X=$P($G(^DGS(41.1,RECNUM,0)),U,5)
 I X,$P(PREC,U,10)=X,NODE=5 D DGS411(RECNUM,X)
 Q
 ;
CON44 ;-- This routine will perform the conversion to file #200 for the
 ;   Hospital Location File (#44)
 ;
 N RECNUM,SEQ,NODE,MULT,PROV,PREC,TREC,PSAV,STIME
 ;-- get entry in File 43 for conversion of file 44
 D ADDPC^DGV53PT1(44)
 ;-- determine if conversion needs to be re-started.
 S PSAV=$O(^DG(43,1,"PCON","B",44,0)),PREC=$G(^DG(43,1,"PCON",+PSAV,0))
 ;-- quit if file is already converted
 G:$P(PREC,U,6)="Y" CON44Q
 ;-- if record already present then re-start
 D REST44(PREC,PSAV)
 ;-- start of main loop
 F  S RECNUM=$O(^SC(RECNUM)) Q:'RECNUM  S TREC=TREC+1 W:'(TREC#100) "." D
 . ;-- get provider
 . S PROV=$P($G(^SC(RECNUM,0)),U,13)
 . ;-- save provider information from piece 13 of 0 node
 . S ^DG(43,1,"PCON",PSAV,0)=44_U_STIME_U_U_RECNUM_U_16_U_U_TREC_U_U_U_PROV
 . ;-- update field 16 of node 0
 . I PROV D SC16(RECNUM,PROV)
 ;-- enter completion time, mark conversion as completed
 D DONE^DGV53PT1(PSAV,TREC)
CON44Q ;-- exit
 Q
 ;
SC16(RECNUM,PROV) ;-- process SC '16' field of the 0 node
 ; INPUT : RECNUM - Record Number to process
 ;         PROV   - Current Provider Pointer
 ;
 N X,Y
 S X=$G(^DIC(16,+PROV,"A3"))
 I 'X S Y=">>> Default Provider fld. (16) for entry #"_RECNUM_" :'"_$P($G(^DIC(16,+PROV,0)),U)_"' could not be converted." S OK=0 D WRERROR^DGV53PT1(Y)
 S DR="16////"_$S(X:X,1:"@"),DIE="^SC(",DA=RECNUM D ^DIE K DA,DIE,DR
 Q
 ;
REST44(PREC,PSAV) ;-- This tag will re-process the entry incase the conversion
 ;   needs to be re-started.
 ;  INPUT : PREC - 0 Node of entry in MAS Parameter File for file 44
 ;
 ;-- get starting point
 I '$P(PREC,U,2) D NOW^%DTC S $P(^DG(43,1,"PCON",PSAV,0),U,2)=%
 S STIME=$P(^DG(43,1,"PCON",PSAV,0),U,2),RECNUM=+$P(PREC,U,4),MULT=$P(PREC,U,8),NODE=$P(PREC,U,5),SEQ=+$P(PREC,U,9),TREC=+$P(PREC,U,7),CURPT=$P(PREC,U,10)
 I 'RECNUM Q
 ;-- check if provider field has been processed
 S X=$P($G(^SC(RECNUM,0)),U,13)
 I X,$P(PREC,U,10)=X,NODE=16 D SC16(RECNUM,X)
 Q
 ;
