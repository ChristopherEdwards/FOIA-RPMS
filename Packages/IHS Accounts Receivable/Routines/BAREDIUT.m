BAREDIUT ; IHS/SD/LSL - UTILITY FOR TANSPORT FILE ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,21**;OCT 26,2005
 ;;
 ; IHS/ASDS/LSL - 09/11/01 - V1.5 Patch 2 - NOIS CXX-0501-110014
 ;     Allow deletion of ERA Import files
 ;
 ; IHS/SD/LSL - 09/18/03 - V1.7 Patch 4 - HIPAA
 ; 
 ; IHS/SD/LSL - 06/23/04 - V1.8 Patch 1 - IM13589
 ;     ERA file listing not working
 ;
 ;IHS/SD/LSL - 08/3/04 - V1.8 Patch 1 - IM14472
 ;     lengthen filename to 50 characters
 ;     FIELD CROSS REFERENCE CHANGED TO 80
 ;     POST ROUTINE RE-INDEXS RECORDS 
 ;
 ; *********************************************************************
 ;
PRTVARA(TRDA) ; EP
 ; PRINT POSTING VARIABLES BY VARIABLE NAME ALPHABETICAL
 S VAR=""
 F  S VAR=$O(^BAREDI("1T",TRDA,10,"D",VAR)) Q:VAR=""  D
 . S SEGDA=0
 . F  S SEGDA=$O(^BAREDI("1T",TRDA,10,"D",VAR,SEGDA)) Q:SEGDA'>0  D
 .. S SEGNM=$$VAL^XBDIQ1(90056.0101,"TRDA,SEGDA",.01)
 .. S ELMDA=0
 .. F  S ELMDA=$O(^BAREDI("1T",TRDA,10,"D",VAR,SEGDA,ELMDA)) Q:ELMDA'>0  D
 ... K ELM
 ... D ENP^XBDIQ1(90056.0102,"TRDA,SEGDA,ELMDA",".01;.02","ELM(")
 ... W !,VAR,?12,SEGNM,?25,ELM(.01),?35,ELM(.02)
 Q
 ; *********************************************************************
 ;
PRTVARS(TRDA) ; EP
 ; PRINT POSTING VARIABLES BY SEGMENT ORDER
 S SEGNM="",SEGLNM=""
 F  S SEGNM=$O(^BAREDI("1T",TRDA,10,"B",SEGNM)) Q:SEGNM=""  D
 . S SEGDA=$O(^BAREDI("1T",TRDA,10,"B",SEGNM,0))
 . Q:'SEGDA
 . I '$D(^BAREDI("1T",TRDA,10,SEGDA,10,"C")) Q
 . S SEQDA=0
 . F  S SEQDA=$O(^BAREDI("1T",TRDA,10,SEGDA,10,"AC",SEQDA)) Q:SEQDA'>0  D
 .. S ELMDA=$O(^BAREDI("1T",TRDA,10,SEGDA,10,"AC",SEQDA,0))
 .. K ELM
 .. D ENP^XBDIQ1(90056.0102,"TRDA,SEGDA,ELMDA",".01;.02;.08","ELM(")
 .. I '$L(ELM(.08)) Q
 .. W !
 .. W:SEGNM'=SEGLNM SEGNM
 .. W ?20,ELM(.01),?30,ELM(.02),?65,ELM(.08)
 .. S SEGLNM=SEGNM
 Q
 ; *********************************************************************
 ;
VIEW(TRDA,IMPDA) ; EP
 ; Browse an Import
 I '$G(TRDA) S TRDA=$$GET1^DIQ(90056.02,IMPDA,.03,"I")
 Q:$G(TRDA)=""
 Q:$G(IMPDA)=""
 S BARIMP=$$GET1^DIQ(90056.02,IMPDA,.01)
 D VIEWR^XBLM("PRINT^BAREDIUT(TRDA,IMPDA)","VIEW IMPORT: "_BARIMP)
 Q
 ; *********************************************************************
 ;
RECPRT(RECDA) ;
 ; print an import record and its elements
 ; note SEQ in elements 1,2,3,4 .. may not be the
 ; the same as ELMDA , as SEQ=ELMDA(.03)
 ; use 'ac' index to look up element by sequence
 ;
 ; pull in the record and converted elements
 K REC
 D ENP^XBDIQ1(90056.0202,"IMPDA,RECDA",".01:99","REC(")
 I '$D(ALL),REC(.02)=PRVB S BARQUIT=0
 I '$D(ALL),REC(.02)=PRVE S BARQUIT=1
 I '$D(ALL),REC(.02)=TRLB S BARQUIT=0
 I '$D(ALL),REC(.02)="PLB" S BARQUIT=0
 Q:BARQUIT
 W !!,"*",REC(.02),?10,REC(.03)
 F SEQ=1:1 Q:'$D(REC(10,SEQ))  D
 . Q:REC(10,SEQ)=""
 . S PATH=REC(.04)
 . S TRDA=+PATH
 . S SEGDA=$P(PATH,",",2)
 . S ELMDA=$$ELMSEQDA(TRDA,SEGDA,SEQ)
 . S X=$$VAL^XBDIQ1(90056.0102,"TRDA,SEGDA,ELMDA",.02)
 . W !,$E(X,1,25),?27,REC(10,SEQ)
 Q
 ; *********************************************************************
 ;
PRINT(TRDA,IMPDA) ; EP
 ; Print records of import IMPDA
 Q:$G(TRDA)=""
 Q:$G(IMPDA)=""
 I 'TRDA S TRDA=$$GET1^DIQ(90056.02,IMPDA,.03,"I")
 Q:$G(TRDA)=""
 K ^TMP($J,"REC")
 ; pull provider start & end records
 K TR
 D ENP^XBDIQ1(90056.01,TRDA,".04;.05;.06","TR(")
 S PRVB=TR(.04)
 S PRVE=TR(.05)
 S TRLB=TR(.06)
 S BARQUIT=0
 D ENPM^XBDIQ1(90056.0202,"IMPDA,0",.01,"^TMP($J,""REC"",")
 S RECDA=0
 F  S RECDA=$O(^TMP($J,"REC",RECDA)) Q:RECDA'>0  D RECPRT(RECDA)
 Q
 ; *********************************************************************
 ;
ELMSEQDA(TRDA,SEGDA,SEQ) ; EP
 ; return ELMDA given TRDA,SEGDA, SEQ
 N X
 S X=$O(^BAREDI("1T",TRDA,10,SEGDA,10,"AC",SEQ,0))
 ;
END ;
 Q X
 ; *********************************************************************
 ;
CLAIMS(IMPDA) ; EP
 ; Print the Claims in a transport for posting
 S CLMDA=0
 F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA)) Q:CLMDA'>0  D
 . K CLM
 . D ENP^XBDIQ1(90056.0205,"IMPDA,CLMDA",".01:.09","CLM(")
 . K ADJ
 . D ENPM^XBDIQ1(90056.0208,"IMPDA,CLMDA,0",".01:.05","ADJ(")
 Q
 ; *********************************************************************
 ;
STRIP(XX) ; EP
 ; Strip training spaces
 N L S L=$L(XX)
 F I=L:-1:1 S X=$E(XX,I) Q:X'=" "  S XX=$E(XX,1,I-1)
 Q XX
 ; *********************************************************************
 ;
DELIMP ; EP
 ; Delete an Import
 K DIC,DR,DA
 W !!,"This is to delete ERA Imports",!
 S DIC=90056.02
 S DIC(0)="AEQM"
 S DIC("W")="W ?35,$P(^(0),U,5)"
 D ^DIC
 I Y'>0 D  Q
 . W !!,"None Chosen",!
 . K DIR
 . S DIR("A")="<CR> - Continue"
 . S DIR(0)="E"
 . D ^DIR
 S IMPDA=+Y
 K IMP
 D ENP^XBDIQ1(90056.02,IMPDA,".01:.07","IMP(")
 W !!,"IMPORT:",?15,IMP(.01)
 W !,"EDI:",?15,IMP(.03),?40,"ERA:",?55,IMP(.05)
 W !,"BATCH:",?15,IMP(.06),?40,"ITEM:",?55,IMP(.07),!!
 K DIR
 S DIR(0)="Y"
 S DIR("B")="N"
 D ^DIR
 K DIR
 I 'Y W !!,IMP(.01),"   NOT DELETED  ",! G DELIMP
 K DA,DR,DIE
 S DIDEL=90056.02
 S DIE=$$DIC^XBDIQ1(90056.02)
 S DR=".01///@"
 S DA=IMPDA
 D ^DIE
 W !!,IMP(.01),"   DELETED",!
 G DELIMP
 ; *********************************************************************
 ;
FNAME ; EP
 ; Select a file (directory can be pre-loaded into XBDIR)
 K DIR
 ;
FNAME1 ;
 S XBFN=""
 ;S DIR(0)="FO^1:30"
 S DIR(0)="FO^1:50"               ;IM14472
 S DIR("A")="File Name "
 D ^DIR
 K DIR
 Q:$G(DTOUT)
 Q:Y["^"
 Q:Y=""
 Q:Y=" "  ;IHS/SD/TPF 10/4/2011 BAR*1.8*21 ERROR DURING TESTING
 I Y?.N,$D(XBFL(Y)) S DIR("B")=XBFL(Y) G FNAME1
 I Y["*" D  G FNAME
 . K XBFL
 . S X=$$LIST^%ZISH(XBDIR,Y,.XBFL)
 . ;F XBI=1:1 Q:'$D(XBFL(XBI))  W !?5,XBI,?10,XBFL(XBI) I '(XBI#20) R X:DTIME
 . S XBI="" F  S XBI=$O(XBFL(XBI)) Q:XBI=""!($G(X)=U)  W !?5,XBI,?10,XBFL(XBI) I '(XBI#20) R X:DTIME  ;IM13589
 S XBFN=Y
 Q
