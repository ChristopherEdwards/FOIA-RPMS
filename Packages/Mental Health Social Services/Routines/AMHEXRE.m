AMHEXRE ; IHS/CMI/LAB - REDO A PREVIOUS MHSS EXPORT ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
START ;
 S AMHO("RUN")="REDO" ;     Let ^AMHEXDI know this is a 'REDO'
 D ^AMHEXDI ;           
 I AMH("QFLG") D EOJ W !!,"Bye",!! Q
 D INIT ;               Get Log entry to redo
 I AMH("QFLG") D EOJ W !!,"Bye",!! Q
 D QUEUE^AMHEXDI
 I AMH("QFLG") D EOJ W !!,"Bye",!! Q
 I $D(AMHO("QUEUE")) D EOJ W !!,"Okay your request is queued!",!! Q
 ;
EN ;EP FROM TASKMAN
 S AMHCNT=$S('$D(ZTQUEUED):"X AMHCNT1  X AMHCNT2",1:"S AMHCNTR=AMHCNTR+1"),AMHCNT1="F AMHCNTL=1:1:$L(AMHCNTR)+1 W @AMHBS",AMHCNT2="S AMHCNTR=AMHCNTR+1 W AMHCNTR,"")"""
 D NOW^%DTC S AMH("RUN START")=%,AMH("MAIN TX DATE")=$P(%,".") K %,%H,%I
 I AMH("QFLG") D:$D(ZTQUEUED) ABORT D EOJ Q
 S AMH("BT")=$HOROLOG
 D PROCESS ;            Generate transactions
 I AMH("QFLG") W:'$D(ZTQUEUED) !!,"Abnormal termination!  QFLG=",AMH("QFLG") D:$D(ZTQUEUED) ABORT D EOJ Q
 D ^AMHEXRLG ;                Update Log entry
 I AMH("QFLG") W:'$D(ZTQUEUED) !!,"Log error! ",AMH("QFLG") D:$D(ZTQUEUED) ABORT D EOJ Q
 D:'$D(ZTQUEUED) RUNTIME^AMHEXEOJ
 I AMH("QFLG") W:'$D(ZTQUEUED) !!,"Tape creation error! QFLG=",AMH("QFLG") D:$D(ZTQUEUED) ABORT D EOJ Q
 D:'$D(ZTQUEUED) CHKLOG ;             See if Log needs cleaning
 D RESETV ;             Reset RECORDs processed in Log
 D TAPE ; Write transactions to tape
 I '$D(ZTQUEUED)  S DIR(0)="E",DIR("A")="DONE--Press enter to continue" K DA D ^DIR K DIR
 D EOJ
 K AMH
 Q
 ;
PROCESS ;
 K ^AMHXLOG(AMH("RUN LOG"),51)
 S (AMH("A"),AMH("D"),AMH("M"),AMH("COUNT"),AMH("ERROR COUNT"))=0
 W:'$D(ZTQUEUED) !,"Generating transactions.  Counting visits.  (1)" S AMHCNTR=0
 S AMHR=0 F  S AMHR=$O(^AMHXLOG(AMH("RUN LOG"),21,AMHR)) Q:AMHR'=+AMHR  D PROCESS2 Q:AMH("QFLG")
 Q
PROCESS2 ;
 K AMHE,AMHV,AMHTX
 X AMHCNT
 S ^XTMP("AMHREDO","MAIN TX",AMHR)="",AMHV("TX GENERATED")=0
 Q:'$D(^AMHREC(AMHR))
 S AMHREC=^AMHREC(AMHR,0)
 S AMHV("V DATE")=+AMHREC\1
 D KILL^AUPNPAT D RECORD^AMHEXD2
CNTBUILD ;count and build tx
 I AMHE]"" S AMH("ERROR COUNT")=AMH("ERROR COUNT")+1 D ^AMHEXERR Q
 S AMH("COUNT")=AMH("COUNT")+1
 S AMHV("TX GENERATED")=1,^XTMP("AMH"_$S(AMHO("RUN")="NEW":"DR",AMHO("RUN")="REDO":"REDO",1:"DR"),"MAIN TX",AMHR)=AMH("MAIN TX DATE")
 S AMH($E(AMHTX))=AMH($E(AMHTX))+1
 S ^AMHSDATA(AMH("COUNT"))="MH^"_AMHTX
SETUTIL S ^XTMP("AMHREDO",AMHR)=AMHR_U_AMHV("TX GENERATED")_U_$E(AMHTX)
 Q
 ;
TAPE ; COPY TRANSACTIONS TO TAPE
 ;S AMH("DEF DEVICE")=$P(^AMHSITE(DUZ(2),0),U,2)
 ;I AMH("DEF DEVICE")="" W:'$D(ZTQUEUED) !,"No Default Device in SITE File",!," NOTIFY YOUR SUPERVISOR, I cannot continue until there is a default device ",!," in the Site File",$C(7),$C(7) S AMH("QFLG")=4 Q
 D EN^AMHEXTAP I $D(ZTQUEUED),AMH("QFLG") D ABORT
 ;Q:AMH("QFLG")
 ;Q:$D(ZTQUEUED)
 ;Q:$P(^AMHSITE(DUZ(2),0),U,11)="Y"
 ;Q:$D(ZTQUEUED)
 ;S DIR(0)="Y",DIR("A")="Do you want to write the MHSS transactions to an output device",DIR("B")="N" K DA D ^DIR K DIR
 ;Q:$D(DIRUT)
 ;Q:'Y
 ;I Y=1 S AMH("AMHTAPE")="" D EN^AMHEXTAP
 ;I AMH("QFLG")=99 S AMH("QFLG")=0
 Q
 ;
 ;
CHKLOG ; CHECK LOG FILE
 S AMH("X")=0 F AMH("I")=AMH("RUN LOG"):-1:1 Q:'$D(^AMHXLOG(AMH("I")))  I $O(^AMHXLOG(AMH("I"),21,0)) S AMH("X")=AMH("X")+1
 I AMH("X")>3 W !!,"-->There are more than three generations of RECORDs stored in the LOG file.",!,"-->Time to do a purge."
 Q
 ;
RESETV ; RESET RECORD DATA IN LOG
 W:'$D(ZTQUEUED) !,"Resetting RECORD specific data in Log file.  (1)" S AMHCNTR=0
 S AMH("X")="" F  S AMH("X")=$O(^XTMP("AMHREDO",AMH("X"))) Q:AMH("X")'=+AMH("X")  S AMH("Y")=^(AMH("X")),^AMHXLOG(AMH("RUN LOG"),21,AMH("X"),0)=AMH("Y") X AMHCNT ;FORGIVE ME LORD
 W:'$D(ZTQUEUED) !,"Resetting RECORD TX Flags. (1)" S AMHCNTR=0
 S AMH("X")="" F  S AMH("X")=$O(^XTMP("AMHREDO","MAIN TX",AMH("X"))) Q:AMH("X")'=+AMH("X")  D
 .S DIE="^AMHREC(",DA=AMH("X"),DR=".24///"_$S(^XTMP("AMHREDO","MAIN TX",AMH("X"))]"":^XTMP("AMHREDO","MAIN TX",AMH("X")),1:"@") D CALLDIE^AMHLEIN K DA,DR X AMHCNT
 .Q
 K ^XTMP("AMHREDO")
 Q
 ;
INIT ;
 D INIT^AMHEXRE1
 Q
ABORT ; ABNORMAL TERMINATION
 I $D(AMH("RUN LOG")) S AMH("QFLG1")=$O(^AMHERRC("B",AMH("QFLG"),"")),DA=AMH("RUN LOG"),DIE="^AMHXLOG(",DR=".15///F;.16////"_AMH("QFLG1")
 I $D(ZTQUEUED) D ERRBULL^AMHEXDI3,ABORT,EOJ Q
 W !!,"Abnormal termination!!  QFLG=",AMH("QFLG")
 S DIR(0)="EO",DIR("A")="Press enter to continue" K DA D ^DIR K DIR
 Q
 ;
EOJ ;
 D ^AMHEXEOJ
 Q
