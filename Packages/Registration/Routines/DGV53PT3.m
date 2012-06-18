DGV53PT3 ;ALB/MTC - MAS v5.3 Post Init Routine ; 07 JAN 93
 ;;5.3;Registration;;Aug 13, 1993
 ;
CON405 ;-- This routine will perform the conversion to file #200 for the
 ;   Patient Movement File (#405)
 ;
 N RECNUM,SEQ,NODE,MULT,PROV,PREC,TREC,PSAV,OK,REC,DGPMT,DATE
 ;-- set DGPMT to avoid setting x-refs in patient file
 S DGPMT=1
 ;-- get entry in File 43 for conversion of file 405
 D ADDPC^DGV53PT1(405)
 ;-- determine if conversion needs to be re-started.
 S PSAV=$O(^DG(43,1,"PCON","B",405,0)),PREC=$G(^DG(43,1,"PCON",+PSAV,0))
 ;-- quit if file is already converted
 G:$P(PREC,U,6)="Y" CON405Q
 ;-- create log file entry
 D NEWFILE^DGV53PT1(405)
 ;-- if record already present then re-start
 S OK=1 D REST405(PREC,PSAV)
 ;-- start of main loop
 F  S DATE=$O(^DGPM("ATT6",DATE)) Q:'DATE  S RECNUM=0 F  S RECNUM=$O(^DGPM("ATT6",DATE,RECNUM)) Q:'RECNUM  S TREC=TREC+1,REC=$G(^DGPM(RECNUM,0)) W:'(TREC#100) "." D UPDT
 ;-- enter completion time, mark conversion as completed
 D DONE^DGV53PT1(PSAV,TREC),COMFILE^DGV53PT1(405,OK)
CON405Q ;-- exit
 Q
 ;
DGPM08(RECNUM,PROV) ;-- process DGPM '.08' field of the 0 node
 ; INPUT : RECNUM - Record Number to process
 ;         PROV   - Current Provider Pointer
 ;
 N X,Y
 S X=$G(^DIC(16,+PROV,"A3"))
 I 'X S Y=">>> Primary Care Physician fld. (.08) for entry #"_RECNUM_" :'"_$P($G(^DIC(16,+PROV,0)),U)_"' could not be converted." S OK=0 D WRERROR^DGV53PT1(Y)
 S DR=".08////"_$S(X:X,1:"@"),DIE="^DGPM(",DA=RECNUM D ^DIE K DA,DIE,DR
 Q
 ;
DGPM19(RECNUM,PROV) ;-- process DGPM '.19' field of the 0 node
 ; INPUT : RECNUM - Record Number to process
 ;         PROV   - Current Provider Pointer
 ;
 N X,Y
 S X=$G(^DIC(16,+PROV,"A3"))
 I 'X S Y=">>> Attending Physician fld. (.19) for entry #"_RECNUM_" :'"_$P($G(^DIC(16,+PROV,0)),U)_"' could not be converted." S OK=0 D WRERROR^DGV53PT1(Y)
 S DR=".19////"_$S(X:X,1:"@"),DIE="^DGPM(",DA=RECNUM D ^DIE K DA,DIE,DR
 Q
 ;
REST405(PREC,PSAV) ;-- This tag will re-process the entry incase the conversion
 ;   needs to be re-started.
 ;  INPUT : PREC - 0 Node of entry in MAS Parameter File for file 405
 ;
 ;-- get starting point
 I '$P(PREC,U,2) D NOW^%DTC S $P(^DG(43,1,"PCON",PSAV,0),U,2)=%
 S STIME=$P(^DG(43,1,"PCON",PSAV,0),U,2),RECNUM=+$P(PREC,U,4),MULT=$P(PREC,U,8),NODE=$P(PREC,U,5),DATE=+$P(PREC,U,9),TREC=+$P(PREC,U,7),CURPT=$P(PREC,U,10)
 ;-- if no date then exit
 I 'DATE Q
 ;-- check if record was processed
 ;-- check if .08 field has been processed
 S X=$P($G(^DGPM(RECNUM,0)),U,8)
 I X,$P(PREC,U,10)=X,NODE=.08 D DGPM08(RECNUM,X)
 ;-- check if .19 field has been processed
 S X=$P($G(^DGPM(RECNUM,0)),U,19)
 I X,$P(PREC,U,10)=X,NODE=.19 D DGPM19(RECNUM,X)
 ;-- complete processing x-ref for date
 F  S RECNUM=$O(^DGPM("ATT6",DATE,RECNUM)) Q:'RECNUM  S REC=$G(^DGPM(RECNUM,0)) D UPDT
 Q
 ;
UPDT ;-- This function will update the file 43 and 405
 ;
 ;-- get provider from 0 node
 S X=$P(REC,U,8)
 ;-- save provider information from piece 8 of 0 node
 S ^DG(43,1,"PCON",PSAV,0)=405_U_STIME_U_U_RECNUM_U_.08_U_U_TREC_U_U_DATE_U_X
 ;-- update .08 field of node 0
 I X D DGPM08(RECNUM,+X)
 ;-- get provider information from 19th piece of 0 node
 S X=$P(REC,U,19)
 ;-- save provider information
 S ^DG(43,1,"PCON",PSAV,0)=405_U_STIME_U_U_RECNUM_U_.19_U_U_TREC_U_U_DATE_U_X
 ;-- update
 I X D DGPM19(RECNUM,+X)
 Q
 ;
