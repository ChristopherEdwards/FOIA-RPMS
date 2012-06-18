BPMPTR ;IHS/PHXAO/AEF - FIND POINTERS TO FILE ENTRY
 ;;1.0;IHS PATIENT MERGE;;MAR 01, 2010
 ;IHS/OIT/LJF 11/15/2006 routine originated from Phoenix Area Office
 ;                       changed namespace from BZXM to BPM
 ;                       changed code dealing with DUZ(2) global subscripts
 ;;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;THIS ROUTINE SEARCHES THE RPMS DATABASE FOR ALL POINTERS POINTING TO 
 ;;THE SPECIFIED ENTRY IN THE SPECIFIED FILE.  A REPORT OF THESE
 ;;POINTERS IS PRINTED.  THIS ROUTINE CAN TAKE A LONG TIME TO RUN AND 
 ;;USE A LOT OF PAPER.
 ;;    
 ;;Reading the output from right to left, the right-most column is
 ;;the IEN or pointer value, the next column to the left is the DA,
 ;;the next one to the left is the DA(1), next is DA(2)...  In some
 ;;cases, the left-most column will be the DUZ(2).
 ;;  
 ;;$$END
 ;
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
EN ;EP -- MAIN ENTRY POINT
 ;
 N FILE,TITLE,VAL,ZTDESC,ZTRTN,ZTSAVE
 ;
 D ^XBKVAR
 D HOME^%ZIS
 ;
 D DESC
 ;
 D FILE(.FILE)
 S FILE=+FILE
 Q:'FILE
 ;
 D VAL(.VAL)
 S VAL=+VAL
 Q:'VAL
 ;
 S ZTRTN="DQ^BPMPTR"
 S ZTDESC="POINTER REPORT"
 S ZTSAVE("FILE")=""
 S ZTSAVE("VAL")=""
 D QUE(ZTRTN,.ZTSAVE,ZTDESC)
 Q
DQ ;EP -- QUEUED JOB ENTRY POINT
 ;
 ;      INPUT:
 ;      FILE  =  POINTED TO FILE
 ;      VAL   =  POINTER VALUE TO FIND
 ;
 D ^XBKVAR
 ;     
 Q:'FILE
 Q:'VAL
 D FIND(FILE,VAL)
 K FILE,VAL
 D ^%ZISC
 Q
FIND(FILE,VAL) ;EP
 ;----- FIND POINTERS TO FILE
 ;      LOOPS THROUGH EACH POINTER FILE IN "PT" NODE OF DD
 ;
 N CNT,OUT,PAGE,PFILE,PFLD,TCNT
 ;
 S PAGE=0
 S OUT=0
 ;
 D HDR(FILE,VAL,.PAGE,.OUT)
 Q:$G(OUT)
 ;
 S CNT=0
 S TCNT=0
 ;
 S PFILE=0
 F  S PFILE=$O(^DD(FILE,0,"PT",PFILE)) Q:PFILE'>0  D  Q:OUT
 . S PFLD=0
 . F  S PFLD=$O(^DD(FILE,0,"PT",PFILE,PFLD)) Q:'PFLD  D  Q:OUT
 . . D PTR(FILE,VAL,PFILE,PFLD,.TCNT,.CNT,.PAGE,.OUT)
 ;
 W !,TCNT," POINTERS FOUND"
 Q
PTR(FILE,VAL,PFILE,PFLD,TCNT,CNT,PAGE,OUT) ;
 ;----- LOOK AT POINTER FIELDS
 ;      FOR ONE INDIVIDUAL POINTER FILE
 ;      
 ;      INPUT:
 ;      FILE   =  FILE BEING POINTED TO
 ;      VAL    =  POINTER INTERNAL VALUE TO FIND
 ;      PFILE  =  FILE DOING THE POINTING
 ;      PFLD   =  POINTER FIELD
 ;
 N GR,DUZ2,L,LVL,TXT
 ;
 D LVL(FILE,PFILE,PFLD,.LVL,.TXT)
 S GR=$P(LVL($O(LVL(9999),-1)),U,3)
 S GR=$G(^DIC(GR,0,"GL"))
 D L(GR,.LVL,.L)
 D LOOP(GR,VAL,FILE,.L,TXT,.TCNT,.CNT,.PAGE,.OUT)
 Q
LOOP(GR,VAL,FILE,L,TXT,TCNT,CNT,PAGE,OUT) ;
 ;----- RECURSIVE CODE TO LOOP THROUGH SUBFILE LEVELS AND FIND POINTER 
 ;      VALUE
 ;
 ;      INPUT:
 ;      GR  =  GLOBAL ROOT OF TOP LEVEL FILE DOING THE POINTING
 ;      L   =  ARRAY CONTAINING SUBFILE INFORMATION
 ;      VAL =  POINTER INTERNAL VALUE TO FIND
 ;
 ;
 N D,GBL,GBLD,PVAL
 ;
 S CNT=$G(CNT)+1
 I $Y>(IOSL-5) D HDR(FILE,VAL,.PAGE,.OUT)
 Q:OUT
 W !!,CNT_".",?5,TXT
 I GR']"" D  Q
 . W !?5,"<FILE CORRUPTED!!!>"
 ;
 I GR["DUZ(2)" D  Q
 . S GBLD=$P(GR,"DUZ(2)")
 . S DUZ2=0
 . S GBLD=GBLD_DUZ2_")"
 . F  S DUZ2=$O(@GBLD) Q:'DUZ2  D  Q:OUT
 . . S $P(L(0),U,4)=""
 . . S GBLD=$P(GR,"DUZ(2)")_DUZ2_")"
 . . D L1
 . S DUZ2=DUZ(2)
 ;
L1 ;
 S L=""
 F  Q:+L<0  S L=$O(L(L)) Q:L']""  D L2  Q:+L<0  Q:OUT
 Q
L2 ;
 ;
 Q:+L<0
 Q:OUT
 S GBL=U_$P(L(L),U,3)_+$P(L(L),U,4)_")"
 S D(L)=$O(@GBL)
 I '+D(L) S $P(L(L),U,4)="" S L=L-1 G L2
 S $P(L(L),U,4)=D(L)
 Q:$O(L(L))
 S GBL=U_$P(L(L),U,3)_+$P(L(L),U,4)_","_$P($P(L(0),U),";")_")"
 S PVAL=$P($G(@GBL),U,$P($P(L(0),U),";",2))
 I +PVAL=VAL D
 . I $P(PVAL,";",2)]"",$P(PVAL,";",2)'=$P(^DIC(FILE,0,"GL"),U,2) Q
 . D WRITE(PVAL,.L,.TCNT,FILE,.PAGE,.OUT)
 G L2
 Q
WRITE(VAL,L,TCNT,FILE,PAGE,OUT) ;
 ;----- WRITE RESULTS
 ;
 N X
 W !
 I $G(DUZ2) D
 . I $Y>(IOSL-5) D HDR(FILE,VAL,.PAGE,.OUT)
 . Q:OUT
 . W "     "_DUZ2
 Q:OUT
 S X=""
 F  S X=$O(L(X)) Q:X']""  D  Q:OUT
 . I $Y>(IOSL-5) D HDR(FILE,VAL,.PAGE,.OUT)
 . Q:OUT
 . W "     "_$P(L(X),U,4)
 Q:OUT
 W "     "_VAL
 S TCNT=$G(TCNT)+1
 Q
LVL(FILE,PFILE,PFLD,LVL,TXT) ;
 ;----- SET UP LVL ARRAY CONTAINING POINTER FIELDS
 ;
 ;      RETURNS LVL ARRAY AND TXT VARIABLE
 ;
 ;      SETS LVL ARRAY:
 ;      LVL(CNT)=TEXT^DX^SUBFILE#^UPFILE#^GLOBLOC
 ;      WHERE: DX      = THE "D" LEVEL AS IN D0,D1,D2,D3...
 ;             GLOBLOC = SUBSCRIPT;NODE I.E., 1;0
 ;      EXAMPLE:   
 ;      LVL(0)="PATIENT field (#.01)^4^^.01^0;1"
 ;      LVL(1)="PATIENT sub-field (#50.806)^3^50.806^50.805^1;0"
 ;      LVL(2)="IV DRUG sub-field (#50.805)^2^50.805^50.803^2;0"
 ;      LVL(3)="DATE sub-field (#50.803)^1^50.803^50.8^2;0"
 ;      LVL(4)="IV STATS File (#50.8)^0^50.8"
 ;
 N CNT,FLD,I,N,SFILE,SS,UP,X
 K LVL
 ;
 S TXT=""
 S CNT=0
 S LVL(0)=$P($G(^DD(PFILE,PFLD,0)),U)_" field (#"_PFLD_")"_U_0_U_U_PFLD_U_$P($G(^DD(PFILE,PFLD,0)),U,4)
 S $P(LVL(0),U,5)=$$NP($P(LVL(0),U,5))
 S SFILE=PFILE
 F  D  Q:'UP
 . S UP=$G(^DD(SFILE,0,"UP"))
 . Q:'UP
 . S CNT=CNT+1
 . S X=$P($G(^DD(SFILE,0)),U)
 . S X=$P(X,"SUB-FIELD")_"sub-field (#"_SFILE_")"
 . S FLD=$O(^DD(UP,"SB",SFILE,0))
 . I FLD']"" D  Q
 . . W !!?5,"<<< MISSING DATA IN '^DD("_UP_","_"""SB"""_","_SFILE_",0)' NODE! >>>"
 . . S SFILE=UP
 . S SS=$P(^DD(UP,FLD,0),U,4)
 . S LVL(CNT)=X_U_U_SFILE_U_UP_U_SS
 . S $P(LVL(CNT),U,5)=$$NP($P(LVL(CNT),U,5))
 . S SFILE=UP
 S I=""
 F  S I=$O(LVL(I)) Q:I']""  D
 . S $P(LVL(I),U,2)=(0-(I-(CNT+1)))
 . S X=$P(LVL(I),U)
 . S TXT=TXT_$S(TXT]"":" of the ",1:"")_X
 S CNT=CNT+1
 S LVL(CNT)=$O(^DD(SFILE,0,"NM",""))_" File (#"_SFILE_")"_U_0_U_SFILE
 S TXT=TXT_" of the "_$P(LVL(CNT),U)
 Q
L(GR,LVL,L) ;
 ;----- SET UP L(X) ARRAY
 ;
 ;      L ARRAY CONTAINS NODE, PIECE, AND SUBFILE SUBSCRIPT LEVEL DATA
 ;      WHERE POINTER VALUE IS STORED
 ;      PIECE 1 = NODE;PIECE
 ;      PIECE 2 = "D" LEVEL, I.E., D0,D1,D2,D3...
 ;      PIECE 3 = SUBSCRIPT LEVELS
 ;      
 ;      EXAMPLE:
 ;      L(0)="0;1^D(0)^PS(50.8,"
 ;      L(1)="2;0^D(1)^PS(50.8,D(0),2,"
 ;      L(2)="2;0^D(2)^PS(50.8,D(0),2,D(1),2,"
 ;      L(3)="1;0^D(3)^PS(50.8,D(0),2,D(1),2,D(2),1,"
 ;
 N LASTL
 ;
 S L=0
 F  S L=$O(LVL(L)) Q:'L  D
 . Q:LVL(L)'["sub-field"
 . S L($P(LVL(L),U,2))=$P(LVL(L),U,5)_U_"D("_$P(LVL(L),U,2)_")"
 S L(0)=$P(LVL(0),U,5)_U_"D(0)"_U_$P(GR,U,2)
 ;
 S $P(L(0),U,3)=$P(GR,U,2)
 S L=0
 F  S L=$O(L(L)) Q:L']""  D
 . S GR=GR_$P(L(L-1),U,2)_","_$P($P(L(L),U),";")_","
 . S $P(L(L),U,3)=$P(GR,U,2)
 . S LASTL=L
 Q
 ;
FILE(FILE) ;
 ;----- PROMPT FOR FILE CONTAINING THE POINTED TO ENTRY
 ;
 N DIC,DTOUT,DUOUT,X,Y
 ;
 S FILE=0
 S DIC="^DIC("
 S DIC(0)="AEMQ"
 S DIC("A")="Select 'POINTED TO' file: "
 S DIC("B")="VA PATIENT"
 S DIC("?")="The file that is being pointed to by other files"
 D ^DIC
 I $D(DTOUT)!($D(DUOUT))!(+Y'>0) Q
 S FILE=+Y
 Q
 ;
VAL(VAL) ;
 ;----- PROMPT FOR POINTER VALUE
 ;
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 ;
 S VAL=0
 S DIR(0)="N"
 S DIR("A")="Select INTERNAL POINTER VALUE to find"
 S DIR("?")="EXAMPLE: Patient DFN"
 D ^DIR
 I $D(DTOUT)!($D(DUOUT))!($D(DIRUT))!(+Y'>0) Q
 S VAL=+Y
 Q
 ;
QUE(ZTRTN,ZTSAVE,ZTDESC) ;
 ;----- QUEUEING CODE
 ;
 N %ZIS,IO,POP,ZTIO,ZTSK
 S %ZIS="Q"
 D ^%ZIS
 Q:POP
 I $D(IO("Q")) D  Q
 . K IO("Q")
 . S ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL
 . D ^%ZTLOAD
 . I $G(ZTSK) W !,"Task #",$G(TASK)," queued"
 D @ZTRTN
 Q
 ;
HDR(FILE,VAL,PAGE,OUT) ;
 ;----- WRITE HEADER
 ;
 N DIR,DIRUT,DTOUT,DUOUT,I,X,Y
 ;
 I $E(IOST)="C",$G(PAGE) D
 . S DIR(0)="E"
 . D ^DIR
 . K DIR
 . I 'Y S OUT=1
 Q:OUT
 ;
 S PAGE=$G(PAGE)+1
 W @IOF
 W !,"Pointers to IEN #"_VAL_" in the "_$P(^DIC(FILE,0),U)_" file #"_FILE
 W !?49,$$NOW
 W "   PAGE ",PAGE
 W !
 F I=1:1:IOM W "-"
 W !
 Q
NP(X) ;----- PUT QUOTES AROUND ALPHA NODE
 ;
 ;     INPUT:
 ;     X  =  NODE;PIECE, I.E., SCLR;13
 ;
 N N,Y
 S Y=X
 S N=$P(Y,";")
 I N'=+N D
 . S N=""""_N_""""
 . S $P(Y,";")=N
 Q Y
NOW() ;
 ;----- RETURNS TODAY'S DATE/TIME
 ;
 N %,%H,%I,X
 D NOW^%DTC
 S Y=DT
 X ^DD("DD")
 Q Y_" "_$E($P(%,".",2),1,2)_":"_$E($P(%,".",2),3,4)
