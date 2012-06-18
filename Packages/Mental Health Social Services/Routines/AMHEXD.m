AMHEXD ; IHS/CMI/LAB - MAIN DRIVER FOR PCC EXPORT TX GEN AUGUST 14, 1992 ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
START ;
 Q
 I $D(ZTQUEUED) S AMHO("SCHEDULED")=""
 S AMHO("RUN")="NEW" ;      Let AMHEXDI know this is a new run.
 D ^AMHEXDI ;           Do initialization
 I $D(AMHO("QUEUE")) D EOJ W !!,"Okay, your request is queued!  Bye",! Q
 I AMH("QFLG")=99 D EOJ W !!,"Bye",!! Q
 I AMH("QFLG") D ABORT Q
DRIVER ;called from TSKMN+2
 S AMH("BT")=$H
 D NOW^%DTC S AMH("RUN START")=%,AMH("MAIN TX DATE")=$P(%,".") K %,%H,%I
 S DIE="^AMHXLOG(",DA=AMH("RUN LOG"),DR=".15///R"_";.03////"_AMH("RUN START") D CALLDIE^AMHLEIN
 I $D(Y) D ABORT Q
 S AMHCNT=$S('$D(ZTQUEUED):"X AMHCNT1  X AMHCNT2",1:"S AMHCNTR=AMHCNTR+1"),AMHCNT1="F AMHCNTL=1:1:$L(AMHCNTR)+1 W @AMHBS",AMHCNT2="S AMHCNTR=AMHCNTR+1 W AMHCNTR,"")"""
 D PROCESS ;            Generate trasactions
 I AMH("QFLG") D ABORT Q
 D ^AMHEXLOG ;                Update Log
 I AMH("QFLG") D ABORT Q
 D PURGE ;              Purge AEX xref entries
 D RUNTIME^AMHEXEOJ ;            Show run time
 L
 D TAPE ; Write transactions to tape
 I AMH("QFLG") D ABORT Q
 ;D:'$D(ZTQUEUED) CHKLOG ;             See if Log needs cleaning
 I '$D(ZTQUEUED) W !! S DIR(0)="E",DIR("A")="DONE  --  Press ENTER to Continue" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 D EOJ
 Q
 ;
PROCESS ;
 W:'$D(ZTQUEUED) !,"Generating transactions.  Counting records.  (1)"
 S AMHCNTR=0,AMH("CONTROL DATE")=AMH("RUN BEGIN")-1,AMH("T-INIT")="  ",AMH("POSTING DATE")="      "
 F  S AMH("CONTROL DATE")=$O(^AMHREC("AEX",AMH("CONTROL DATE"))) Q:AMH("CONTROL DATE")=""!(AMH("CONTROL DATE")>AMH("RUN END"))  D PROCESS2 Q:AMH("QFLG")
 Q
PROCESS2 ;
 S AMHR="" F  S AMHR=$O(^AMHREC("AEX",AMH("CONTROL DATE"),AMHR)) Q:AMHR=""  D PROCESS3 Q:AMH("QFLG")
 Q
PROCESS3 ;
 K AMHT,AMHV,AMHE
 D KILL^AUPNPAT
 Q:$D(^AMHXLOG(AMH("RUN LOG"),21,AMHR))
 S AMHV("TX GENERATED")=0,^XTMP("AMHDR",AMH("CONTROL DATE"),AMHR)="",^XTMP("AMHDR","MAIN TX",AMHR)=""
 X AMHCNT
 S AMHREC=^AMHREC(AMHR,0)
 S AMHV("R DATE")=+AMHREC\1
 K AMHE,AMHTX D RECORD^AMHEXD2
 D CNTBUILD
 D ^XBFMK
 S DA=AMH("RUN LOG"),DR="2101///""`"_AMHR_"""",DIE="^AMHXLOG("
 S DR(2,9002014.2101)=".02////"_AMHV("TX GENERATED")_";.03///"_$E(AMHTX)
 D CALLDIE^AMHLEIN
 Q
 ;
PURGE ; PURGE 'AEX' XREF FOR MHSS RECORDS JUST DONE
 W:'$D(ZTQUEUED) !,"Deleting cross-reference entries. (1)"
 S AMHCNTR=0,AMHV("R DATE")=""
 F  S AMHV("R DATE")=$O(^XTMP("AMHDR",AMHV("R DATE"))) Q:AMHV("R DATE")'=+AMHV("R DATE")  D PURGE2
 K ^XTMP("AMHDR"),^XTMP("AMHDR")
 Q
PURGE2 ;
 S AMHR="" F  S AMHR=$O(^XTMP("AMHDR",AMHV("R DATE"),AMHR)) Q:AMHR=""  D RESET
 Q
 ;
RESET ; kill MHSS xref and set flag if tx 23 or 24 generated
 K ^AMHREC("AEX",AMHV("R DATE"),AMHR)
 I ^XTMP("AMHDR","MAIN TX",AMHR)]"" S DIE="^AMHREC(",DA=AMHR,DR=".24///"_^XTMP("AMHDR","MAIN TX",AMHR)_";.22///@" D CALLDIE^AMHLEIN
 X AMHCNT
 Q
 ;
 ;
CNTBUILD ;count and build tx
 I AMHE]"" S AMH("ERROR COUNT")=AMH("ERROR COUNT")+1 D ^AMHEXERR Q
 S AMH("COUNT")=AMH("COUNT")+1
 S AMHV("TX GENERATED")=1,^XTMP("AMH"_$S(AMHO("RUN")="NEW":"DR",AMHO("RUN")="REDO":"REDO",1:"DR"),"MAIN TX",AMHR)=AMH("MAIN TX DATE")
 S AMH($E(AMHTX))=AMH($E(AMHTX))+1
 S ^AMHSDATA(AMH("COUNT"))="MH^"_AMHTX
 Q
TAPE ; COPY TRANSACTIONS TO TAPE
 ;S AMH("DEF DEVICE")=$P(^AMHSITE(DUZ(2),0),U,7)
 ;I AMH("DEF DEVICE")="" W:'$D(ZTQUEUED) !,"No Default Device in SITE File",!," NOTIFY YOUR SUPERVISOR, I cannot continue until there is a default device ",!," in the Site File",$C(7),$C(7) S AMH("QFLG")=4 Q
 D EN^AMHEXTAP I $D(ZTQUEUED),AMH("QFLG") D ERRBULL^AMHEXDI3
 ;Q:AMH("DEF DEVICE")="F"
 ;Q:AMH("QFLG")
 ;Q:$D(ZTQUEUED)
 ;S DIR(0)="Y",DIR("A")="Do you want to write the MHSS transactions to an output device",DIR("B")="N" K DA D ^DIR K DIR
 ;Q:$D(DIRUT)
 ;Q:'Y
 ;I Y=1 S AMH("AMHTAPE")="" D EN^AMHEXTAP
 ;I AMH("QFLG")=99 S AMH("QFLG")=0
 Q
 ;
CHKLOG ; CHECK LOG FILE
 Q
 S AMH("X")=0 F AMH("I")=AMH("RUN LOG"):-1:1 Q:'$D(^AMHXLOG(AMH("I")))  I $O(^AMHXLOG(AMH("I"),21,0)) S AMH("X")=AMH("X")+1
 I AMH("X")>12 W !,"-->There are more than twelve generations of MHSS RECORDs stored in the LOG file.",!,"-->Time to do a purge."
 Q
 ;
ABORT ; ABNORMAL TERMINATION
 I $D(AMH("RUN LOG")) S AMH("QFLG1")=$O(^AMHDTER("B",AMH("QFLG"),"")),DA=AMH("RUN LOG"),DIE="^AMHXLOG(",DR=".15///F;.16////"_AMH("QFLG1")
 I $D(ZTQUEUED) D ERRBULL^AMHEXDI3,EOJ Q
 W !!,"Abnormal termination!!  QFLG=",AMH("QFLG")
 S DIR(0)="E",DIR("A")="DONE  --  Press ENTER to Continue" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 D EOJ
 Q
 ;
EOJ ; EOJ
 D ^AMHEXEOJ
 Q
