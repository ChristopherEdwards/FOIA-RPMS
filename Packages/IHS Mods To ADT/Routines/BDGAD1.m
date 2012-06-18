BDGAD1 ; IHS/ANMC/LJF - A&D ADMISSIONS ;  [ 01/07/2004  1:05 PM ]
 ;;5.3;PIMS;**1003,1005,1010,1013**;MAY 28, 2004
 ;IHS/ITSC/LJF 06/03/2005 PATCH 1003 track multiple admits per patient
 ;IHS/OIT/LJF  12/29/2005 PATCH 1005 changed AGE^BGDF2 to official API
 ;cmi/anch/maw 12/18/2008 PATCH 1010 change set of ward to ?? in GATHER to quitting if now ward
 ;ihs/cmi/maw  09/13/2011 PATCH 1013 added code to filter day surgery in totals
 ;
 ;Variables defined in calling VA routines DGPMGL*
 ; RD = report date
 ; GL = 1 if recalculating
 ;
 ; IHS variables defined in calling routines:
 ; BDGFRM="D" for detailed, "S" for summary format
 ;
 NEW DGBEG,DGEND,BDGT
A ; -- main driver
 D INIT,LOOP                  ;admissions
 D ^BDGAD2                    ;ward transfers
 D ^BDGAD3                    ;service transfers
 D ^BDGAD4                    ;discharges
 I '$G(BDGREP) D ^BDGAD5      ;update patients remaining
 D QUIT Q
 ;
INIT ;--initialize variables
 S BDGT=RD,BDGFRM=$S($D(BDGFRM):BDGFRM,1:"")  ;rename VA variable
 S DGBEG=RD-.0001,DGEND=RD+.24                ;date range
 K ^TMP("BDGAD",$J)
 ;
 Q:$G(BDGREP)                ;don't initialize if reprint
 ; initialize files
 S WD=0 F  S WD=$O(^DIC(42,WD)) Q:'WD  D
 . Q:'$D(^BDGWD(WD))    ;not moved over
 . ;
 . I '$D(^BDGCWD(WD)) D   ;add ward for first time
 .. S ^BDGCWD(WD,0)=WD,^BDGCWD("B",WD,WD)=""
 .. S $P(^BDGCWD(0),U,3,4)=WD_U_($P(^BDGCWD(0),U,4)+1)
 . ;
 . S:'$D(^BDGCWD(WD,1,0)) ^BDGCWD(WD,1,0)="^9009016.21D"
 . S $P(^BDGCWD(WD,1,0),U,3,4)=BDGT_U_($P(^BDGCWD(WD,1,0),U,4)+1)
 . S ^BDGCWD(WD,1,BDGT,0)=BDGT
 . S ^BDGCWD(WD,1,BDGT,1,0)="^9009016.211P"
 ;
 S TS=0 F  S TS=$O(^DIC(45.7,TS)) Q:'TS  D
 . Q:$$GET1^DIQ(45.7,TS,9999999.03)'="YES"   ;not admitting service
 . ;
 . I '$D(^BDGCTX(TS,0)) D     ;add service for first time
 .. S ^BDGCTX(TS,0)=TS,^BDGCTX("B",TS,TS)=""
 .. S $P(^BDGCTX(0),U,3,4)=TS_U_($P(^BDGCTX(0),U,4)+1)
 . ;
 . S:'$D(^BDGCTX(TS,1,0)) ^BDGCTX(TS,1,0)="^9009016.61D"
 . S $P(^BDGCTX(TS,1,0),U,3,4)=BDGT_U_($P(^BDGCTX(TS,1,0),U,4)+1)
 . S ^BDGCTX(TS,1,BDGT,0)=BDGT
 Q
 ;
LOOP ;--loop admissions
 NEW DGDT,DFN,IFN
 S DGDT=DGBEG
 F  S DGDT=$O(^DGPM("AMV1",DGDT)) Q:'DGDT!(DGDT>DGEND)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV1",DGDT,DFN)) Q:'DFN  D
 .. S IFN=0 F  S IFN=$O(^DGPM("AMV1",DGDT,DFN,IFN)) Q:'IFN  D GATHER
 Q
 ;
GATHER ; gather info on admission and put counts into arrays
 NEW DATA,ADULT,WARD,SERV,TYPE,SERVN,NAME
 ;S WARD=$P($G(^DGPM(IFN,0)),U,6) I 'WARD S WARD="??"  ;cmi/maw 12/18/2008 orig line
 S WARD=$P($G(^DGPM(IFN,0)),U,6) I 'WARD Q  ;cmi/maw 12/18/2008 changed to quit
 S ADULT=$S($$AGE<$$ADULT^BDGPAR:0,1:1)               ;1=adult, 0=peds
 S SERV=$$ADMSRVN^BDGF1(IFN,DFN)                      ;service ien
 S SERVN=$$ADMSRV^BDGF1(IFN,DFN)                      ;service name
 ;S TYPE=$S(SERVN["OBSERVATION":"O",1:"I")             ;inpt vs observ ihs/cmi/maw 09/13/2011 orig
 S TYPE=$S(SERVN["OBSERVATION":"O",SERVN="DAY SURGERY":"D",1:"I")             ;inpt vs observ  09/13/2011 mod for ds
 S NAME=$$GET1^DIQ(2,DFN,.01)                         ;patient name
 ;
 S DATA=SERV_U_WARD
 ;IHS/OIT/LJF 12/29/2005 PATCH 1005 changed age call to official API
 ;I BDGFRM="D" S DATA=DATA_U_$$ADMPRV^BDGF1(IFN,DFN,"ADM")_U_$$AGE^BDGF2(DFN,+^DGPM(IFN,0))  ;add admitting provider and age at admission
 I BDGFRM="D" S DATA=DATA_U_$$ADMPRV^BDGF1(IFN,DFN,"ADM")_U_$$AGE^AUPNPAT(DFN,+^DGPM(IFN,0))  ;add admitting provider and age at admission
 ;
 ;  collect patient for report
 ;
 ;IHS/ITSC/LJF 6/3/2005 PATCH 1003
 I SERVN="NEWBORN" D
 . ;S ^TMP("BDGAD",$J,"ADMIT","N",NAME,DFN)=DATA
 . S ^TMP("BDGAD",$J,"ADMIT","N",NAME,DFN,IFN)=DATA
 ;E  S ^TMP("BDGAD",$J,"ADMIT",TYPE,NAME,DFN)=DATA
 E  S ^TMP("BDGAD",$J,"ADMIT",TYPE,NAME,DFN,IFN)=DATA
 ;
 Q:$G(BDGREP)                               ;reprint, not recalculating
 ;
 ; increment counts in ADT Census files
 S $P(^BDGCWD(WARD,1,BDGT,0),U,3)=$P($G(^BDGCWD(WARD,1,BDGT,0)),U,3)+1
 ;
 I SERV D                                       ;service zero nodes
 . I '$D(^BDGCWD(WARD,1,BDGT,1,SERV)) D
 .. S ^BDGCWD(WARD,1,BDGT,1,SERV,0)=SERV
 .. S $P(^BDGCWD(WARD,1,BDGT,1,0),U,3,4)=SERV_U_($P(^BDGCWD(WARD,1,BDGT,1,0),U,4)+1)
 . ;
 . I ADULT D  Q                                 ;adult admissions
 .. S $P(^BDGCWD(WARD,1,BDGT,1,SERV,0),U,3)=$P($G(^BDGCWD(WARD,1,BDGT,1,SERV,0)),U,3)+1
 .. S $P(^BDGCTX(SERV,1,BDGT,0),U,3)=$P($G(^BDGCTX(SERV,1,BDGT,0)),U,3)+1
 . ;
 . I 'ADULT D                                   ;peds admissions
 .. S $P(^BDGCWD(WARD,1,BDGT,1,SERV,0),U,13)=$P($G(^BDGCWD(WARD,1,BDGT,1,SERV,0)),U,13)+1
 .. S $P(^BDGCTX(SERV,1,BDGT,0),U,13)=$P($G(^BDGCTX(SERV,1,BDGT,0)),U,13)+1
 ;
 Q
 ;
QUIT ;--cleanup all
 L -^BDGCWD   ;unlock census file
 Q
 ;
AGE() ;--age at admit
 NEW X,X1,X2
 S X1=DGDT,X2=$P($G(^DPT(DFN,0)),U,3) D ^%DTC
 Q:'X "" Q X\365.25
 ;
