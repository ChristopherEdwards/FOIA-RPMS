INHUSEQ2 ;DGH; 13 Jan 95 09:22;More SEQuence number protocol functions 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;Following functions are used when CHCS is originiating system for
 ;sequence number protocol. Originiating system need only send
 ;a message containing an MSH segment to initiate or to resynch
 ;the link.
INIT ;This entry point initializes seq. no. protocol. It creates
 ;a MSH with MSH-9 =0. It is called from a menu option.
 N INSEQ,SRC
 S INSEQ=0,SRC="Initialization message"
 D DEST Q
 ;
SYNCH ;This entry point resynches the link. It creates a MSH with
 ;MSH-9 = -1. It is called from a menu option.
 N INSEQ,SRC
 S INSEQ=-1,SRC="Re-synchronization message"
 D DEST Q
 ;
DEST ;Prompt for background process. The process must be inactive and
 ;must have a destination. Seq. No. Protocol is by destination.
 N DIC,X,Y,DEST,TT,DXS,ING,INUIF,MSH,INDELIM,INSUBDEL,INSUBCOM,BP,INREP,MSG,DST
 S DIC=4004,DIC(0)="AEZ",DIC("S")="I $P(^(0),U,7)" D ^DIC Q:Y<1
 S BP=+Y I $D(^INRHB("RUN","SRVR",BP)) S MSG="This process is active. You must shut this job down before proceeding." D DISP Q
 S DST=$P(Y(0),U,7) I '$D(^INRHD(DST)) S MSG="Destination does not exist" D DISP Q
 S DEST=$P(^INRHD(DST,0),U)
 ;Create MSH segment !!NOTE that MESSAGE TYPE field is null.
 S MESSID=$$MESSID^INHD
 S INDELIM=$$FIELD^INHUT(),INSUBDEL=$$COMP^INHUT(),INSUBCOM=$$SUBCOMP^INHUT(),INREP=$$REP^INHUT()
 S ING="INDATA"
 S MSH="MSH"_INDELIM_INSUBDEL_INREP_"~"_INSUBCOM
 S DXS="N X1 S %=$P($H,"","",2) S:%<60 %=60 S:$G(X)'=""S"" %=%\60*60 S:$G(X)=""H"" %=%\3600*3600 S X=DT_(%\60#60/100+(%\3600)+(%#60/10000)/100) S X=X,Y(1)=$G(X) S X=""TS"""
 N Y,X1 X DXS S X1=Y(1) S X=$$TRX^INHSG(X1,X,"O") S L1=X
 S $P(MSH,U,7)=L1,$P(MSH,U,10)=MESSID,$P(MSH,U,13)=INSEQ,$P(MSH,U,15)="AL"
 S @ING@(1)=MSH
 ;create entry in UIF, but don't set in output queue
 S INUIF=$$NEW^INHD(MESSID,DEST,SRC,ING,0,"O",1)
 I INUIF<0 N INSTERR S INSTERR="",MSG="Error creating entry in UIF" D ERROR^INHS("UIF creation failed in routine ^INHUSEQ2",2),DISP Q
 ;set into destination queue (required for sequence # protocol)
 S X=$$DSTQUE^INHUSEN3(INUIF,.INERR)
 I X S MSG="Error creating entry in queue" D ENT^INHE(INUIF,DEST,.INERR),DISP Q
 ;Now that entry is in "BP" queue, start background process
 S X=$$A^INHB(BP)
 I 'X S MSG="Background process failed to start" D DISP Q
 Q
 ;
DISP ;Display message to user
 W !?5,MSG S X=$$CR^INHU1 Q
 ;
 ;following functions are called from other routines
SEQ(GBL,SEQ,INERR) ;Return Sequence number from MSH
 ;;;;THIS FUNCTION MAY NOT BE NEEDED
 ;INPUT
 ;--GBL = global being checked, can be ^INTHU
 ;--------If numeric, assumed to be IEN for ^INTHU
 ;--------If non-numeric, assumed to be global reference
 ;RETURN
 ;0=success 1=failure
 N LCT,X,SEQ
 S X=$$VERIF^INHUSEN(GBL,.INMSH)
 I X S ERR(1)="Message does not have the MSH segment in the correct location" Q 1
 S INDELIM=$E(INMSH,4)
 S SEQ=+$P(INMSH,INDELIM,13)
 Q 0
 ;
 ;
EXPECT(GBL,EXPCT,STAT,ERR) ;Returns expected seq # and status from MSA
 ;INPUT
 ;--GBL = global being checked, can be ^INTHU
 ;--------If numeric, assumed to be IEN for ^INTHU
 ;--------If non-numeric, assumed to be global reference
 ;--EXPCT = Expected sequence #, MSA-5
 ;--STAT = Status, MSA-2
 ;--ERR = error message array
 ;RETURN
 ;0=success 1=error
 N MSA,MSH,LCT
 I GBL S LCT=0 D GETLINE^INHOU(GBL,.LCT,.MSH)
 I 'GBL S MSH=$G(@GBL@(1))
 I MSH'["MSH" S ERR(1)="Message does not have the MSH segment in the correct location" Q 1
 S INDELIM=$E(MSH,4)
 ;Check for MSA segment in line count subsequent to MSH
 I GBL D GETLINE^INHOU(GBL,.LCT,.MSA)
 I 'GBL S MSA=$G(@GBL@(2))
 I '$D(MSA) S ERR="Message does not have a MSA segment in the correct location" Q 1
 I MSA'["MSA" S ERR="Message does not have a MSA segment in the correct location" Q 1
 S STAT=$P(MSA,INDELIM,2),EXPCT=$P(MSA,INDELIM,5)
 Q 0
 ;
REQUE(INDSTR,INSEND,INERR) ;Requeue previously sent messages
 ;INPUT:
 ;INDSTR = (REQ) Destination of backgroundprocess
 ;INSEND = (REQ) Array of messages in format INSEND(SEQ)=UIF
 ;INERR = (OPT) Variable for error messages (PBR)
 ;OUTPUT:
 ;0=success 1=error
 N SEQ,P,H,UIF
 ;For sequenced message, priority and time to process don't matter
 S (P,H)=0
 F I=1:1:5 L +^INLHDEST(INDSTR):5 Q:$T
 E  S INERR="Unable to lock message queue ^INLHDEST("_$P(^INRHD(INDSTR,0),U)_") " Q 1
 S SEQ="" F  S SEQ=$O(INSEND(SEQ)) Q:'SEQ  D
 .S UIF=INSEND(SEQ)
 .S ^INLHDEST(INDSTR,P,H,UIF)=""
 L -^INLHDEST(INDSTR)
 Q 0
