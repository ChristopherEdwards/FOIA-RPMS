ACHSACO ; IHS/ITSC/PMF - AREA CONSOLIDATION (1/3) ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**5,11,13,18,19**;JUN 11,2001
 ;IHS/SET/GTH ACHS*3.1*5 12/06/2002 - Clarified error message.
 ;IHS/SET/JVK ACHS*3.1*11 Add check for area to test ACHS version
 ; added a call to %ZISC in tag S15 - 10/5/00 - pmf
 ;ACHS*3.1*13 6.11.07 IHS/OIT/FCJ Added ufms work global
 ;ACHS*3.1*18 4.20.2010 IHS.OIT.FCJ Added ACHSPTH Var to replace calls to IM^ACHS and EX^ACHS-Tribal sites process data fr the export path
 ;
 ;CHECK TO SEE IF ACHS IS SET UP IN BULLETIN FILE
 S X=$O(^XMB(3.6,"B","ACHS AREA BALANCES",0))
 I 'X D  D XIT^ACHSACOA Q
 . W *7,!,"Mail Bulletin 'ACHS AREA BALANCES' does not exist."
 . S X=$$DIR^XBDIR("E","Press RETURN...")
 ;
 I '$O(^XMB(3.6,X,2,0)) D  D XIT^ACHSACOA Q
 . W *7,!,"Mail Bulletin 'ACHS AREA BALANCES' does not have a MAIL GROUP."
 . S X=$$DIR^XBDIR("E","Press RETURN...")
 ;
 ;SHOW AREA OFFICE PARAMETERS SETTINGS
 W !!,"         PROCESS FI DATA parameter = '",$$AOP^ACHS(2,3),"'"
 W !,"PROCESS AREA OFFICE DATA parameter = '",$$AOP^ACHS(2,4),"'"
 W !,"        HAS/CORE CONTROL parameter = '",$$AOP^ACHS(2,2),"'",!!
 ;
 ;ACHS*3.1*13 IHS/OIT/FCJ Added ufms workglobal to nxt line
 F ACHS="^ACHSPCC","^ACHSBCBS","^ACHSAOPD","^ACHSAOVU","^ACHSZOCT","^ACHSPIG","^ACHSSVR","^ACHSCORE","^ACHSUFMS" D
 . W !,"KILL'ing work global ",ACHS
 . I $$KILLOK^ZIBGCHAR($P(ACHS,U,2)) W !,$$ERR^ZIBGCHAR($$KILLOK^ZIBGCHAR($P(ACHS,U,2)))
 . K @ACHS ; Kill unsubscripted work globals.
 . S @(ACHS_"(0)")=""
 ;
 ;
 W !?10,"Previously Consolidated CHS Facility Data has been Deleted",!
 ;
 K ^TMP("ACHSACO",$J)
 ;
 D RSLT(">>>  PLEASE ENSURE THE AREA CHS OFFICER RECEIVES THIS MESSAGE  <<<")
 D RSLT("ASUFAC"_$J("Export Date",15)_$J("Adv of Allowance",18)_$J("Obligated YTD",18)_$J("Balance",18))
 D RSLT("------"_$J("-------------",15)_$J("----------------",18)_$J("---------------",18)_$J("---------------",18))
 ;
 S ACHSFN=""      ;ACHS*3.1*19
 S ^ACHSPCC("COUNT")=0,ACHSOK=0
 S ^ACHSUFMS("COUNT")=0,^ACHSUFMS(0)=0
 K ACHSZFAC
 S ACHSDTJL=$E(DT,2,3)_$$JDT^ACHS(DT,1)
S1 ;
 S %ZIS("A")="Enter Printer Device for Consolidation Report: ",%ZIS="P"
 D ^%ZIS
 I POP U IO(0) W !,"Printer Not Available - JOB CANCELLED",! D XIT^ACHSACOA Q
 S ACHSPTR=IO
 I $D(IO("S")) D SLV^ACHSFU,^%ZISC   ;IF SLAVE CHOSEN DO SLAVE SETUP
 ;                                    THEN CLOSE EVERYTHING?????
 ;
FSEL ;
 ;RETURN A LIST OF FILES TO CONSOLIDATE E.G. ACHS202100.221
 K ACHSLIST
 ;
 ;                   IMPORT PATH=$P(^AUTTSITE(1,1),U)
 ;GET ALL FILES STARTING WITH ACHS AND PUT IN ARRAY ACHSLIST
 ;THE FORMAT FOR ACHSLIST IS:
 ;          P^1=FILENAME
 ;          P^2=FACILITY NAME
 ;          P^3=VENDOR NUMBER????
 ;          P^4=DATE OF GLOBAL SAVE
 ;          P^5=Y IF CHOSEN?????
 ;ACHS*3.1*18 IHS.OIT.FCJ ADDED LINE AND MODIFIED NXT LINE
 S X=$$ASF^ACHS(DUZ(2)) S ACHSPTH=$S((X=808301)!(X=252611):$$EX^ACHS,1:$$IM^ACHS)
 I $$LIST^%ZISH(ACHSPTH,"ACHS*",.ACHSLIST) D ERROR^ACHSTCK1 D XIT^ACHSACOA Q   ;ACHS*3.1*18
 ;I $$LIST^%ZISH($$IM^ACHS,"ACHS*",.ACHSLIST) D ERROR^ACHSTCK1 D XIT^ACHSACOA Q   ;ACHS*3.1*18
 ;
 ;
 ;GO THRU LIST OF FILES TO CONSOLIDATE
 S ACHSCNT=0,ACHSNCNT=0
 F  S ACHSCNT=$O(ACHSLIST(ACHSCNT)) Q:'ACHSCNT  D  Q:$G(ACHSJFLG)
 .;
 .;ELIMINATE IF NOT AN ACCEPTED FILE NAME FORMAT ; ACHS*3.1*19 ADDED NEW FORMAT FOR PATCH 19
 . ;I (ACHSLIST(ACHSCNT)'?1"ACHS"4.6N1"."1.3N) K ACHSLIST(ACHSCNT) Q
 . I (ACHSLIST(ACHSCNT)'?1"ACHS"4.6N1"."1.8N.1"_".6N) K ACHSLIST(ACHSCNT) Q
 .;TRY TO OPEN THE FILE
 .;ACHS*3.1*18 IHS.OIT.FCJ changed $$IM^ACHS TO ACHSPTH IN NXT LINE
 . I $$OPEN^%ZISH(ACHSPTH,ACHSLIST(ACHSCNT),"R") D ERROR^ACHSTCK1 Q   ;ACHS*3.1*18
 . S ACHSNCNT=ACHSNCNT+1
 .;
 .;
 .;THE FORMAT IS THE SAVE OF GLOBAL ^ACHSDATA(
 . U IO
 . R X:DTIME
 . S $P(ACHSLIST(ACHSCNT),U,4)=X   ;READ DATE/TIME STAMP
 .                                 ;THIS IS THE DATE WHEN SAVED NOT SENT
 .;
 .;
 .R X:DTIME      ;READ AREA
 .R X:DTIME      ;READ GLOBAL NODE
 .R X:DTIME      ;READ FIRST GLOBAL RECORD
 .;
 .S $P(ACHSLIST(ACHSCNT),U,2)=$P(X,U,2)   ;FACILITY NAME
 .S $P(ACHSLIST(ACHSCNT),U,3)=$P(X,U,7)   ;TOTAL ALL RECORD TYPES
 .;ITSC/SET/JVK-ACHS*3.1*11 CHECK THE FILE VERSION NO.
 .S $P(ACHSLIST(ACHSCNT),U,6)=$P(X,U,12)      ;VERSION OF ACHS
 .D ^%ZISC    ;CLOSE ALL DEVICES
 ;
 I $G(ACHSJFLG) D XIT^ACHSACOA Q
 ;
 ;
 S ACHSCNT=ACHSNCNT
 K ACHSNCNT
 ;ACHS*3.1*18 IHS.OIT.FCJ changed $$IM^ACHS TO ACHSPTH IN NXT LINE
 ;I ACHSCNT<1 U IO(0) W *7,!!?5,"No Facility Files Available for Processing",!! D XIT^ACHSACOA Q;IHS/SET/GTH ACHS*3.1*5 12/06/2002
 I ACHSCNT<1 U IO(0) W *7,!!?5,"No Facility Files (ACHS*) Available for Processing in the ",ACHSPTH," directory.",!! D XIT^ACHSACOA Q  ;ACHS*3.1*5 ACHS*3.1*18
 ; Reorder list if some files weren't Facility files.
 ;
 ;
 S (X,Y)=0
 F  S X=$O(ACHSLIST(X)),Y=Y+1 Q:'X  S Z=ACHSLIST(X) K ACHSLIST(X) S ACHSLIST(Y)=Z
 ;
S2 ;
 F %=1:1 Q:'$D(ACHSLIST(%))  S:$P(ACHSLIST(%),U,5)="Y" $P(ACHSLIST(%),U,5)=""
S2A ;
 ;
 K ACHSPLST
 S ACHSZ=0
 F  S ACHSZ=$O(ACHSLIST(ACHSZ)) Q:'ACHSZ  S $P(ACHSLIST(ACHSZ),U,5)=""
 ;
 ;
 D FDISP             ;FILE LIST DISPLAY
 ;
 ;LETS CHOOSE FILE TO PROCESS
SEL ;
 S Y=$$DIR^XBDIR("L^1:"_ACHSCNT,"Enter Seq # of File to Process  (1-"_ACHSCNT_" for All)","","","","",1)
 ;
 I $D(DUOUT)!($D(DTOUT)) U IO(0) W !!,"No Files Selected for Consolidation - Job Terminated",! D XIT^ACHSACOA Q
 ;
 ;
 F ACHSZ=1:1:ACHSCNT Q:$P(Y,",",ACHSZ)=""  S Z=$P(Y,",",ACHSZ) S:+$P(ACHSLIST(Z),U,3)>0 $P(ACHSLIST(Z),U,5)="Y"
 ;ITSC/SET/JVK ACHS*3.1*11
 I $P(ACHSLIST(Z),U,6)="" U IO(0) W !!,"File(s) with a version of unknown are not compatiable with current CHS version",!,?35,"Job Terminiated",! D XIT^ACHSACOA Q
 ;
 ;
 K ACHSPLST
 S ACHSJ=0
 F ACHSI=1:1:ACHSCNT I $P(ACHSLIST(ACHSI),U,5)="Y" S ACHSJ=ACHSJ+1,ACHSPLST(ACHSJ)=$P(ACHSLIST(ACHSI),U)
 ;
 D FDISP                ;FILE LIST DISPLAY
 ;
 U IO(0)
 S Y=$$DIR^XBDIR("Y","Files Selected Above will Now be Processed - Is This Correct? (Y/N)","N","","","",1)
 I Y=0 G S2A
 I $D(DTOUT)!($D(DUOUT)) U IO(0) W !,"Job Cancelled",! D XIT^ACHSACOA Q
 ;
 ;
FIL1 ;
 S ACHSZ=""
FIL2 ;
 F  S ACHSZ=$O(ACHSPLST(ACHSZ)) Q:ACHSZ=""  D
 .;
 .;I ACHSZ="" D REPORT^ACHSACOA Q      ;PRINT REPORTS
 .;
 .;TRY AND OPEN THE FILE
 .;ACHS*3.1*18 IHS.OIT.FCJ changed $$IM^ACHS TO ACHSPTH IN NXT LINE
 .I $$OPEN^%ZISH(ACHSPTH,$P(ACHSPLST(ACHSZ),U,1),"R") D ERROR^ACHSTCK1 D XIT^ACHSACOA  ;ACHS*3.1*18
RDHDR .; Read the header of the file being processed.
 .U IO
 .R X:DTIME          ;READ BLANK LINE
 .R X:DTIME          ;READ BLANK LINE
 .R ACHSXD1:DTIME    ;READ GLOBAL NODE
 .R ACHSXD2:DTIME    ;READ RECORD
 .;
 .U IO(0)
 .;
 .S ACHSFN=$P(ACHSPLST(ACHSZ),U)     ;ACHS*3.1*19
 .S ACHSFACD=$P(ACHSXD2,U)           ;'ASUFAC'
 .S ACHSGBL=$P($P(ACHSXD1,"("),U,2)  ;GLOBAL NAME
 .;
 .;EXPECTING GLOBAL SAVES OF THESE TWO GLOBALS SEE "EXPORT GLOBALS" DOCS
 .I ACHSGBL'="ACHSDATA",(ACHSGBL'="ACHSTXDT") D  Q
 ..W !,"CONTAINS UNRECOGNIZED DATA"
 ..W !,"FACILITY CODE : '",$G(ACHSFACD,"UNDEFINED"),"'"
 ..W !,"GLOBAL NAME : '",$G(ACHSGBL,"UNDEFINED"),"'",!
 ..D ABEND^ACHSACOA
 .;
 .W !?20,U,ACHSGBL,"( Data  -- As Listed Below",!
 .S X=$P(ACHSXD2,U)     ;USE FACILITY ID READ IN FILE
 .S DIC="^AUTTLOC("     ;LOOK AT AREA LOCATION FILE
 .S DIC(0)=""           ;
 .S D="C"               ;USE THE ASUFAC X-REF
 .D IX^DIC
 .K DIC,D
 .;
 .I +Y<0 U IO(0) D  Q
 ..W *7,!,"FACILITY LOOK-UP ERROR ON FACILITY '",$P(ACHSXD2,U,2)
 ..W "', ASUFAC INDEX = '",X,"' WAS NOT FOUND IN THE 'ASUFAC' CROSS"
 ..W "REFERENCE IN '^AUTTLOC LOCATION FILE'"
 ..S IONOFF="" D ^%ZISC D ABEND^ACHSACOA
 .;
 .S:+Y>0 ACHSFCPT=+Y
 .S ACHSDRUN=$P(ACHSXD2,U,3)      ;DATE RUN
 .S ACHSFREC=$P(ACHSXD2,U,4)      ;DATE OF FIRST RECORD
 .S ACHSLREC=$P(ACHSXD2,U,5)      ;DATE OF LAST RECORD
 .S ACHSNRCD=$P(ACHSXD2,U,7)      ;NUMBER OF RECORDS
 .;
 .W !,"FACILITY NAME",?20,":",?25,$P(ACHSXD2,U,2)
 .W !,"DATE EXPORT RUN",?20,":",?25,$$FMTE^XLFDT(ACHSDRUN)
 .W !,"DATE OF FIRST RECORD",?20,":",?25,$$FMTE^XLFDT(ACHSFREC)
 .W !,"DATE OF LAST RECORD",?20,":",?25,$$FMTE^XLFDT(ACHSLREC)
 .W !,"NUMBER OF RECORDS",?20,":",?25,ACHSNRCD,!
 .K ACHSZFIF
S15F .;
 .;IF NO ENTRY IN THE LOG FILE CONTINUE PROCESS
 .;USE FACILITY PTR FROM ^AUTTLOC AND LOOK AT LOG FILE
 .I '$D(^ACHSAOLG(ACHSFCPT,1,ACHSDRUN)) D S15X Q
 .U IO(0)
 .;                                        INSTITUTION NAME
 .W !!,*7,"DATA ALREADY PROCESSED FOR: ",$E($P($G(^DIC(4,ACHSFCPT,0)),U),1,20),"  EXPORT DATE OF: ",$$FMTE^XLFDT(ACHSDRUN),!!
 .I $$DIR^XBDIR("E","Enter <RETURN> to Continue Processing")
 .;
 .;added next line - 10/5/00 - pmf
 .;now CLOSE the file, since we are not going to process it.
 .D ^%ZISC
 .;
 D REPORT^ACHSACOA            ;DO CONSOLIDATION REPORTS
 Q
 ;
 ;
S15X ;
 D RSLT(ACHSFACD_$J($$FMTE^XLFDT(ACHSDRUN),15)_$J("$"_$FN($P(ACHSXD2,U,10),",",2),18)_$J("$"_$FN($P(ACHSXD2,U,11),",",2),18)_$J("$"_$FN($P(ACHSXD2,U,10)-$P(ACHSXD2,U,11),",",2),18))
 ;
 ;
 D ^ACHSACO1     ;AREA CONSOLIDATION (2/3)  INITIALIZE COUNTERS
                 ;MAIN PROCESSING LOOP
 ;
 ;
 I $D(ACHSOK) I 'ACHSOK D ABEND^ACHSACOA Q
 ;
 ;
 S $P(ACHSZFAC(ACHSFCPT,ACHSDRUN,0),U,2)=ACHSDRUN
 S $P(ACHSZFAC(ACHSFCPT,ACHSDRUN,0),U,3)=ACHSFREC
 S $P(ACHSZFAC(ACHSFCPT,ACHSDRUN,0),U,4)=ACHSLREC
 S $P(ACHSZFAC(ACHSFCPT,ACHSDRUN,0),U,5)=ACHSNRCD
 ;
 U IO(0)
 I $$DIR^XBDIR("E","         Press RETURN to Process NEXT FILE")
 Q
 ;
FDISP ;
 U IO(0)
 W @IOF,"Files available for CHS Consolidation are listed Below:"
 W !,"Seq",?7,"File Name",?32,"Facility Name",?53,"# Rcds",?61,"Export Date Process",!   ;ACHS*3.1*19
 S ACHSI=""
 F  S ACHSI=$O(ACHSLIST(ACHSI)) Q:+ACHSI=0  D
 .S X=ACHSLIST(ACHSI)
 .U IO(0)
 .W !,$J(ACHSI,3),?5,$E($P(X,U,1),1,30),?32,$E($P(X,U,2),1,20),?53,$J($P(X,U,3),6),?61,$P($P(X,U,4),"@")  ;ACHS*3.1*19
 .S ACHSKJRY=X,ACHSKJRX=$P($P(X,U,1),".",2),ACHSKJRX=$$JTF^ACHS(ACHSKJRX)
 .; Do a FM Lookup based on the ASUFAC for the file being processed
 .S ACHSX=ACHSKJRY
 .D FACLKUP
 .I +Y<0 U IO(0) W *7,!,"==>FACILITY CODE LOOK-UP ERROR ON CODE '",X,"'" Q
 .S X=ACHSKJRX
 .K ACHSKJRX
 .I '$D(^ACHSAOLG(+Y,1,X,0)) D FD2 Q
 .S Z=$P($G(^ACHSAOLG(+Y,1,X,0)),U,5)
 .I Z="" S Z=9999999
 .S $P(ACHSLIST(ACHSI),U,5)=Z
 .W ?70,$E(Z,4,5),"/",$E(Z,6,7),"/",$E(Z,2,3)
 Q
 ;
FD2 ;
 W ?75,$P(ACHSLIST(ACHSI),U,5)   ;ACHS*3.1*19
 Q
 ;
 ;
FACLKUP ;
 S X=$E($P(ACHSX,".",1),5,10)
 S DIC(0)="ZM"                 ;
 S DIC="^AUTTLOC("             ;AREA LOCATION FILE
 S D="C"                       ;USE ASUFAC  X-REF  
 D ^DIC
 I Y<1 K D S X=$P(ACHSLIST(ACHSI),U,2) D ^DIC
 Q
 ;
RSLT(X) ;
 S ^(0)=$G(^TMP("ACHSACO",$J,0))+1,^(^(0))=X
 Q
 ;