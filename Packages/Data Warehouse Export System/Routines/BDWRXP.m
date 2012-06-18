BDWRXP ;cmi/anch/maw - BDW Mark Visit for Export that didn't export already 8/8/2007 10:14:44 AM
 ;;1.0;IHS DATA WAREHOUSE;**1,2**;JAN 23, 2006
 ;
 ;
 ;
 ;this routine will go back to the beginning of the fiscal year and mark
 ;visits for export that did not export already
 ;
 ;
MAIN ;-- this is the main routine driver
 S BDWFY=$$FY(DT)
 D LOOK(BDWFY_"0930.9999",(DT-.0001))
 D EOJ
 Q
 ;
FY(BDWDT) ;-- lets find out the fiscal year based on DT passed in
 N BDWYR,BDWMO,BDWFY
 S BDWYR=$E(BDWDT,1,3)
 S BDWMO=$E(BDWDT,4,5)
 S BDWFY=BDWYR
 I BDWMO="01" S BDWFY=BDWYR-1
 I BDWMO="02" S BDWFY=BDWYR-1
 I BDWMO="03" S BDWFY=BDWYR-1
 I BDWMO="04" S BDWFY=BDWYR-1
 I BDWMO="05" S BDWFY=BDWYR-1
 I BDWMO="06" S BDWFY=BDWYR-1
 I BDWMO="07" S BDWFY=BDWYR-1
 I BDWMO="08" S BDWFY=BDWYR-1
 I BDWMO="09" S BDWFY=BDWYR-1
 Q BDWFY
 ;
LOOK(BDWBEG,BDWEND) ;-- look through all visits for the fiscal year until today and mark for export
 N BDWDA,BDWCNT
 S BDWCNT=0
 I $G(BDWINT) W !,"Searching"
 S BDWDA=BDWBEG F  S BDWDA=$O(^AUPNVSIT("B",BDWDA)) Q:'BDWDA!(BDWDA>BDWEND)  D
 . S BDWIEN=0 F  S BDWIEN=$O(^AUPNVSIT("B",BDWDA,BDWIEN)) Q:'BDWIEN  D
 .. S BDWCNT=BDWCNT+1
 .. I $G(BDWINT),BDWCNT=50 D
 ... W "."
 ... S BDWCNT=0
 .. N BDWREC,BDWREC1,BDWVCDT,BDWUSER,BDWVEDT
 .. S BDWREC=$G(^AUPNVSIT(BDWIEN,0))
 .. S BDWUSER=$P(BDWREC,U,23)  ;created by user
 .. I BDWUSER Q:BDWUSER=.5  ;screen out postmaster for MFI sites  
 .. S BDWREC1=$G(^AUPNVSIT(BDWIEN,11))
 .. S BDWVCDT=$P(BDWREC,U,2)  ;visit creation date
 .. S BDWVEDT=$P(BDWREC,U,13)  ;visit last update
 .. Q:'BDWVCDT
 .. Q:'BDWVEDT
 .. Q:$P(BDWREC,U,11)  ;visit deleted
 .. Q:$P(BDWREC1,U,6)  ;already exported
 .. Q:$D(^AUPNVSIT("ADWO",BDWVCDT,BDWIEN))  ;xref already set
 .. Q:$D(^AUPNVSIT("ADWO",BDWVEDT,BDWIEN))  ;xref already set
 .. ;N BDWFDA,BDWIENS,BDWERR
 .. ;S BDWIENS=BDWIEN_","
 .. ;S BDWFDA(9000010,BDWIENS,.13)=DT
 .. S BDWRXP=1  ;flag to tell trigger not to fire
 .. ;D FILE^DIE("K","BDWFDA","BDWERR(1)")
 .. D ^XBFMK S DIE="^AUPNVSIT(",DA=BDWIEN,DR=".13////"_DT D ^DIE K DIE,DA,DR
 .. K BDWRXP
 Q
 ;
EOJ ;-- end of job
 D EN^XBVK("BDW")
 K DIR
 D ^XBFMK
 Q
 ;
ASK ;-- ask the dates for the run
 N BDWFY,BDW3FY
 S BDWFY=$$FY(DT)  ;get fiscal year
 S BDW3FY=($E(BDWFY,1,3)-3)_"0930.9999"  ; get begin date for last 3 full fys per dr. stan griffith
 S BDWFD=$$FMADD^XLFDT($P(BDW3FY,"."),1)  ;earliest date for reader call
 W !!,"This option can be used to flag visits for export "
 W !,"that have not previously been exported to the National Data Warehouse.",!
 W !,"You will be asked to enter a beginning and ending date.  The system will"
 W !,"review all visits in that date range and if the visit has never been"
 W !,"exported to the NDW it will flag it for export on the next export."
 W !!,"The earliest date you can enter for this option is ",$$FMTE^XLFDT(BDWFD),".",!!
 ;S %DT="AEP",%DT(0)=BDW3FY,%DT("A")="Enter Begin Date: "
 ;D ^%DT
 ;I Y<0 K BDWBG,%DT
 ;S BDWBG=+Y_.9999
 ;S %DT="AE",%DT(0)="-NOW",%DT("A")="Enter End Date: "
 ;D ^%DT
 ;I Y<0 K BDWBG,%DT
 ;S BDWED=+Y_.9999
 ;K %DT
BD ;get beginning date
 S (BDWBG,BDWED)=""
 S DIR(0)="D^"_BDWFD_":"_DT_":EP",DIR("A")="Enter Beginning Date",DIR("?")="Enter the beginning visit date.  It must be after "_$$FMTE^XLFDT(BDWFD)
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 S BDWBG=Y
ED ;
 S DIR(0)="DA^"_BDWBG_":"_DT_":EP",DIR("A")="Enter Ending Date:  " D ^DIR K DIR,DA S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 I Y<BDWBG W !,"Ending date must be greater than or equal to beginning date!" G ED
 S BDWED=Y
 Q
 ;
INTER ;-- interactive run
 S BDWINT=1
 D ASK
 I '$G(BDWBG)!('$G(BDWED)) W !!,"Beginning and ending dates not selected.",! D PAUSE,EOJ Q
 D LOOK(BDWBG,BDWED)
 D EOJ
 Q
 ;
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="Press enter:  " D ^DIR K DIR
 Q
