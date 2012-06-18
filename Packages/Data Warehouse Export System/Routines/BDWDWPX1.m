BDWDWPX1 ; IHS/CMI/LAB - RPMS report for DW export-3/12/2004 12:46:58 PM ;
 ;;1.0;IHS DATA WAREHOUSE;;JAN 23, 2006
 ;
WRITE() ;EP use XBGSAVE to save the temp global (BDWDWPX) to a delimited
 ; file that is exported to the DW system at 127.0.0.1
 ;
 N XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN
 N AGASU,AGJUL,DT,X2,X1,X
 S ^BDWDWPX($J,99999999999)="T0^"_$P($$DATE^INHUT($$NOW^XLFDT,1),"-")
 S XBGL="BDWDWPX",XBMED="F",XBQ="N",XBFLT=1,XBE=$J,XBF=$J
 S XBNAR="DW Pat Reg Audit"
 I '$D(DT) D DT^DICRW     ;get julian date for file name
 S X2=$E(DT,1,3)_"0101",X1=DT
 D ^%DTC
 S AGJUL=X+1
 S AGASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S XBFN="BDWDWPX"_AGASU_"."_AGJUL
 ;S XBQTO="-l dwtest:regpcc 127.0.0.1"
 S XBS1="DATA WAREHOUSE SEND"
 ;
 D ^XBGSAVE
 ;
 I XBFLG=0 D
 . W !,"Patient Reg audit file successfully created and transferred.",!!
 . K ^BDWDWPX($J)
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" W:'$D(ZTQUEUED) !!,"Patient Reg audit file successfully created",!! K ^BDWDATA
 . I XBFLG(1)]"" W:'$D(ZTQUEUED) !!,"Patient Reg audit file NOT successfully created",!!
 . W:'$D(ZTQUEUED) !,"File was NOT successfully transferred to the data warehouse",!,"you will need to manually ftp it.",!
 . W:'$D(ZTQUEUED) !,XBFLG(1),!!
 ;
 ;
 Q XBFLG
 ;
