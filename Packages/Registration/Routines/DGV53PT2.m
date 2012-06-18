DGV53PT2 ;MTC/ALB - Provider Conversion Continued ; 21 JAN 93
 ;;5.3;Registration;;Aug 13, 1993
 ;
CON2 ;-- This routine will perform the conversion to file #200 for the
 ;   Patient file (#2)
 ;
 N RECNUM,SEQ,NODE,MULT,PROV,PREC,TREC,PSAV,OK
 ;-- Init section for other changes to the Patient File
 D OTHINIT
 ;-- get entry in File 43 for conversion of file 2
 D ADDPC^DGV53PT1(2)
 ;-- determine if conversion needs to be re-started.
 S PSAV=$O(^DG(43,1,"PCON","B",2,0)),PREC=$G(^DG(43,1,"PCON",+PSAV,0))
 ;-- quit if file is already converted
 G:$P(PREC,U,6)="Y" CON2Q
 ;-- create entry in conversion log
 D NEWFILE^DGV53PT1(2)
 ;-- if record already present then re-start
 S OK=1 D REST2(PREC,PSAV)
 ;-- start of main loop
 F  S RECNUM=$O(^DPT(RECNUM)) Q:'RECNUM  S TREC=TREC+1 W:'(TREC#100) "." D
 . ;-- get provider from .104 node
 . S PROV=$P($G(^DPT(RECNUM,.104)),U)
 . ;-- save provider information from .104 node
 . S ^DG(43,1,"PCON",PSAV,0)=2_U_STIME_U_U_RECNUM_U_.104_U_U_TREC_U_U_U_PROV
 . ;-- update .104 node
 . I PROV D DPT104(RECNUM,+PROV)
 . ;-- get provider information from .1041 node
 . S PROV=$P($G(^DPT(RECNUM,.1041)),U)
 . ;-- save provider information from .1041 node
 . S ^DG(43,1,"PCON",PSAV,0)=2_U_STIME_U_U_RECNUM_U_.1041_U_U_TREC_U_U_U_PROV
 . ;-- update .1041 node
 . I PROV D DPT1041(RECNUM,PROV)
 . ;-- call to process other Patient File changes
 . D OTHER(RECNUM)
 ;-- enter completion time, mark conversion as completed
 D DONE^DGV53PT1(PSAV,TREC),COMFILE^DGV53PT1(2,OK)
 ;-- Post section for other Patient File changes
 D OTHPST
CON2Q ;-- exit
 Q
DPT104(RECNUM,PROV) ;-- process DPT '.104' node
 ; INPUT : RECNUM - Record Number to process
 ;         PROV   - Current Provider Pointer
 ;
 N X,Y
 S X=$G(^DIC(16,+PROV,"A3"))
 I 'X S Y=">>> Provider fld. (.104) for entry #"_RECNUM_" :'"_$P($G(^DIC(16,+PROV,0)),U)_"' could not be converted." S OK=0 D WRERROR^DGV53PT1(Y)
 S DR=".104////"_$S(X:X,1:"@"),DIE="^DPT(",DA=RECNUM D ^DIE K DA,DIE,DR
 Q
 ;
DPT1041(RECNUM,PROV) ;-- process DPT '.1041' node
 ; INPUT : RECNUM - Record Number to process
 ;         PROV   - Current Provider Pointer
 ;
 N X,Y
 S X=$G(^DIC(16,+PROV,"A3"))
 I 'X S Y=">>> Attending Physician fld. (.1041) for entry #"_RECNUM_" :'"_$P($G(^DIC(16,+PROV,0)),U)_"' could not be converted." S OK=0 D WRERROR^DGV53PT1(Y)
 S DR=".1041////"_$S(X:X,1:"@"),DIE="^DPT(",DA=RECNUM D ^DIE K DA,DIE,DR
 Q
 ;
REST2(PREC,PSAV) ;-- This tag will re-process the PTF entry incase the conversion
 ;   needs to be re-started.
 ;  INPUT : PREC - 0 Node of entry in MAS Parameter File for file 2
 ;
 ;-- get starting point
 I '$P(PREC,U,2) D NOW^%DTC S $P(^DG(43,1,"PCON",PSAV,0),U,2)=%
 S STIME=$P(^DG(43,1,"PCON",PSAV,0),U,2),RECNUM=+$P(PREC,U,4),MULT=$P(PREC,U,8),NODE=$P(PREC,U,5),SEQ=+$P(PREC,U,9),TREC=+$P(PREC,U,7),CURPT=$P(PREC,U,10)
 I 'RECNUM Q
 ;-- check if .104 node has been processed
 S X=$P($G(^DPT(RECNUM,.104)),U)
 I X,$P(PREC,U,10)=X,NODE=.104 D DPT104(RECNUM,X)
 ;-- check if .1041 node has been processed
 S X=$P($G(^DPT(RECNUM,.1041)),U)
 I X,$P(PREC,U,10)=X,NODE=.1041 D DPT1041(RECNUM,X)
 Q
 ;
OTHER(DFN) ;-- This routines is used to call other Patient File conversion
 ;   routines.
 ;      INPUT : DFN - Current Patient being processed
 ;
 ;-- Rob W. changes
 D TOTVAAMT^DGYPREG(DFN,1)
 D CFL^DGYPREG(DFN,1)
 D MAKEZIP4^DGYPREG5(DFN)
 D DISPZIP^DGYPREG5(DFN)
 ;
 Q
 ;
OTHINIT ;-- This routine will init other changes for the Patient file outside
 ;   the Provider conversion.
 ;
 ;-- Rob W. changes
 D INITLOOP^DGYPREG
 ;
 Q
 ;
OTHPST ;-- This routine will perform any post Patient File loop changes that
 ;   other packages require.
 ;
 ;-- Rob W. changes
 D ENDLOOP^DGYPREG3
 ;
 Q
 ;
