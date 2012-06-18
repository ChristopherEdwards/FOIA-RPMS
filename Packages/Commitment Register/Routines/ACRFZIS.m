ACRFZIS ;IHS/OIRM/DSD/THL,AEF - DEVICE CALLS AND QUEUING; [ 04/27/2007   4:18 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**13,21,22**;NOV 05, 2001
 ;;ROUTINE USED AS CENTRAL POINT FOR ALL DEVICE HANDLING
 ;;AND QUEUING FROM THE PRINT OPTION
 ;;SEE QUE^ACRFUTL FOR QUEUING FROM WITHIN ROUTINES
ZIS ;EP;TO CALL DEVICE
 I '$D(ACRORIGF),$P(^ACRSYS(1,"DT"),U,29) D  Q
 .S DIR(0)="SO^P:PRINT Output;B:BROWSE Output on Screen"
 .I $D(ACR("HFS")) S DIR(0)=DIR(0)_";H:HFS Output to file"  ;ACR*2.1*21.04 IM22466
 .S DIR("A")="Do you want to "
 .S DIR("B")="PRINT"
 .W !
 .D DIR^ACRFDIC
 .Q:$D(ACRQUIT)!$D(ACROUT)
 .I $E($G(X))="P" D ZIS1 Q
 .I $E($G(Y))="B" D BROWSE Q
 .I $E($G(Y))="H" D PROCHFS Q          ;ACR*2.1*21.04 IM22466
ZIS1 ;EP;
 K DN
 I $D(ACRORIGF) D P2
 Q:$D(ACRQUIT)
 I $D(ACRORIGF) D PRE Q:$D(ACROUT)
 D FS
 I $D(ACRCOND) D CONDENSE
 S %ZIS=$S('$D(ACRORIGF):"NPQ",1:"NP")
 S ZIBH=$TR($H,",","")_$R(1000)
 W !
 S:$D(ACRREV) IOP="HOME"
 D ^%ZIS
 I POP>0 D CLOSE Q
 I $D(ACRORIGF),$D(IO("Q")) D  K ACRQUIT G ZIS
 .W !!,"You cannot QUEUE a request to print on a pre-printed form"
 .D PAUSE^ACRFWARN
 S:$G(IOPAR)]"" %ZIS("IOPAR")=IOPAR
 S ZTSAVE("%ZIS*")=""
 S ZTSAVE("ZIBH")=""
 S ZTRTN="OPEN^ACRFZIS"
 I $D(IO("Q")),IO=IO(0)!$D(IO("S")) D  G ZIS
 .W *7,*7
 .W !!,"CANNOT QUEUE TO HOME OR SLAVE DEVICE."
 I '$D(ACRORIGF),$E(IOST,1,2)="P-",'$D(ACRREV) D  I $D(ACRQUIT)!$D(ACROUT) D CLOSE Q
 .S DIR(0)="NO^1:99"
 .S DIR("A")="Number of Copies"
 .S DIR("B")=1
 .D DIR^ACRFDIC
 .I $D(ACRQUIT)!$D(ACROUT)!'+Y S ACRQUIT="" Q
 .S ACRCOPY=+Y
 I '$D(IO("Q")) D  D CLOSE Q
 .I $E(IOST,1,2)="P-" D
 ..W !!,"...One moment please, while I complete your print request..."
 ..W !
 .D:$D(ACRRTN) @ZTRTN
 E  D ZTLOAD
 Q
CLOSE ;EP;TO CLOSE DEVICE
 D ^%ZISC
 K IOP,IOPAR,%ZIS,ZTSK,ZTQUEUED,ZTREQ
 Q
ZTLOAD ;EP;TO CALL %ZTLOAD
 K ACRDR
 S ZTIO=ION
 S ZTSAVE("ACR*")=""
 D ^%ZTLOAD
 W !!,$S($G(ZTSK)]"":"Request queued!",1:"Request cancelled.")
 D CLOSE
 H 2
 Q
OPEN ;EP;TO OPEN DEVICE AND PRINT SELECTED REPORT
 I '$D(ZTQUEUED)!(ION["HOST") S IOP=ION D ^%ZIS I POP S ACRQUIT="" Q
 U IO
 D @ACRRTN
 S:$D(ZTQUEUED) ZTREQ="@"
 D:'$D(ZTQUEUED) CLOSE
 Q
HOST ;EP;TO OPEN HOST FILE
 ;%FN - FILE NAME REQUIRED
 ;ACROP - 'R' FOR READ, 'W' FOR WRITE REQUIRED, 'M' FOR READ/WRITE ;ACR*2.1*13.01 IM13574
 ;ACROP - 'R' FOR READ, 'W' FOR WRITE REQUIRED ;ACR*2.1*13.01 IM13574
 Q:'$D(%FN)!'$D(ACROP)
 S POP=1
 F ACRI=1:1:4 Q:'POP  D
 .S (IOP,ION)="HOST FILE SERVER #"_ACRI
 .S %ZIS("IOPAR")="("""_%FN_""":"""_ACROP_""")"
 .D ^%ZIS
 I POP D  G HOST:$G(ACRX)<2 S ACRQUIT="" Q
 .W !!,"Waiting for HOST FILE SERVER."
 .S ACRX=$G(ACRX)+1
 K IOP,POP
 Q
FS ;EP;TO CHECK IF WIDE CARRIAGE/CONDENSED PRINTER NEEDED
 I $G(ACRDOCDA),$D(^ACRDOC(ACRDOCDA,3)) N X S X=^(3) D
 .I $P(X,U,13),'$P(X,U,17) D
 ..I $P($G(^ACRPO(+$P($G(^ACRDOC(ACRDOCDA,0)),U,8),"DT")),U,10) D  I 1
 ...S X=$P(^ACRPO(+$P($G(^ACRDOC(ACRDOCDA,0)),U,8),"DT"),U,10)
 ...S (ION,%ZIS("B"))=$P(^%ZIS(1,X,0),U)
 ..E  S ACRCOND=""
 .S:$P(X,U,17)=1 ACR3542=""
 Q
CONDENSE ;CONDENSE PRINTER REQUIRED
 I $G(ACRPODA),$P($G(^ACRPO(ACRPODA,"DT")),U,10) D
 .S X=$P(^ACRPO(ACRPODA,"DT"),U,10)
 .I X,$D(^%ZIS(1,X,0)) S (ION,%ZIS("B"))=$P(^%ZIS(1,X,0),U) Q
 W *7,*7
 W !!,"The report you are about to print requires either a wide carriage printer or"
 W !,"a printer set for condensed mode with a width of 132 characters."
 W !,"Check with your system manager if you are uncertain which device to select."
 K ACRCOND
 Q
PRE ;PRE-PRINTED FORM REQUIRED
 W !!,"Please insert Standard Form ",@ACRON,+$G(ACRPSC),@ACROF
 I $D(ACRZIS(2))#2 W !,"and applicable CONTINUATION SHEETS"
 W "into the printer now."
 Q
P2 ;EP;TO SELECT SECOND PRINTER FOR SINGLE PRINT JOB
 K ACRZIS
 W !!,"NOTE: You may select a printer to use for any CONTINUATION SHEETS"
 W !,"required to print this order.",!
 N IO,IOP,IOST,IOP,ION
 S %ZIS="NP"
 S %ZIS("A")="Printer for CONTINUATION SHEETS: "
 S %ZIS("B")=""
 D ^%ZIS
 I POP>0 D CLOSE S ACRQUIT="" Q
 S:$E($G(IOST),1,2)="P-" ACRZIS(2)=ION
 W !,"Now select the main printer to print the FIRST PAGE of this form."
 Q
BROWSE ;EP;TO BROWSE
 Q:$G(ACRRTN)=""
 S ACRFLD("BROWSE")=1
 D VIEWR^ACRFLM(ACRRTN)
 I $D(ACRQUIT) D  Q
 .K ACRQUIT
 .W !!,"BROWSE function temporarily unavailable."
 .D ZIS1
 D CLEAR^VALM1
 KILL XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF,VALMCON,VALMDN,VALMEVL,VALMIOXY,VALMKEY,VALMLFT,VALMLST,VALMMENU,VALMSGR,VALMUP,VALMWD,VALMY,XQORS,XQORSPEW,VALMCOFF,ACRFLD,VALMHDR
 Q
PROCHFS ;EP - PROCESS HFS FILE REQUEST
 ;ACR*2.1*21.04 IM22466
 W !!,"This option will allow you to create a file in your home directory."
 N OUT,X,Y
 S OUT=0
 D ^XBKVAR
 D ASKDIR
 Q:OUT
 D FILE
 Q:OUT
 S:ZISH2'["." ZISH2=ZISH2_".csv"          ;ACR*2.1*22.11d UFMS
 S ZISH3="W"
 D HFS^ACRFZISH(ZISH1,ZISH2,ZISH3,.%FILE)
 Q:POP
 S ACRHFS=""
 Q
ASKDIR ;EP ASK FOR PATH
 ;ACR*2.1*21.04 IM22466
 ;S ZISH1=$$PWD^ACRFZISH("")                ;ACR*2.1*22.11d UFMS
 S ZISH1=$$ARMSDIR^ACRFSYS(1)                ;ACR*2.1*22.11d UFMS
 ;W !!,"The file will go into your home directory"_"  "_ZISH1 ;ACR*2.1*22.11d UFMS
 W !!,"The file will go into the ARMS home directory"_"  "_ZISH1  ;ACR*2.1*22.11d UFMS
 W !,"If you need to send the file to a different directory,"
 W !,"replace the default with the full path at the ""Replace"" prompt.",!
 D SELDIR^ACRFZISH(.ZISH1,.OUT)
 Q
FILE ;EP - SELECT FILENAME FOR UNIX FILE
 ;ACR*2.1*21.04 IM22466
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 S DIR(0)="FA"
 S DIR("A")="Select UNIX file name: "
 D ^DIR
 I $D(DIRUT)!($D(DTOUT))!($D(DUOUT)) S OUT=1
 I Y']"" S OUT=1
 S ZISH2=Y
 Q
