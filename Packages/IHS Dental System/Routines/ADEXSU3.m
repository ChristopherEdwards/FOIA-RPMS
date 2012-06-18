ADEXSU3 ; IHS/HQT/MJL  - DENTAL EXTRACT PART 5 ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
FIN ;EP
 W !,?15,"RECORDS PROCESSED: ",ADERC,!
 I $D(ADEERR) W !,"THE ABOVE ERRORS SHOULD BE CORRECTED BEFORE THE NEXT DENTAL DATA EXTRACTION.",! K ADEERR
 W !,?15,"P R O C E S S I N G   C O M P L E T E D",!!
 D ^%ZISC
 I $D(ZTQUEUED),$D(ZTSK) D KILL^%ZTLOAD
 ;
EXIT ;
 K ADEA,ADEADACP,ADEADAF,ADEADAQ,ADEASF,ADEASITE,ADEB,ADEBDT,ADEBS6,ADEC,ADED,ADEDF,ADEDFN,ADEDMFLG,ADEDOB,ADEEDT,ADEERR,ADEFN,ADEFNO,ADEHRN,ADEIDX,ADENAT,ADENODE,ADERC,ADERDV,ADEREPD,ADESERV,ADESEX,ADESITE,ADESUFAC,ADESVCS,ADETCOST
 K ADETYPE,ADEVDTE,ADEVDTP,ADEVISDT,ADEVNODE,ADEZIP,ADEZTSK,ADELAST,ADELDAY,ADEXDT,ADEDT,ADESTAT,ADEDA,ADEREX,ADECOD,ADEND,ADERR12,ADERR13,ADEXDA,ADEXNOD,ADERERUN,ADERROR
 K ADECHS Q
 ;
ERR ;;Called to trap unexpected errors and resume procesing
 W !,"An unexpected error occurred while processing",!,"entry number ",ADEA," in the DENTAL PROCEDURE file."
 I $D(^%ZOSF("ERRTN")) D
 . W !,"Local variables at the time of the error will be saved in the error trap.",!,"Processing will RESUME after logging the error",!
 . I '$D(ZTQUEUED) W "and displaying an error message"
 . W "."
 . D @^%ZOSF("ERRTN")
 . W !!,"Now resuming dental data extraction process."
 S X="ERR^ADEXSU3",@^%ZOSF("TRAP")
 G RESTART^ADEXSU1
 ;
TASK ;EP
 ;Entry point to queue for tasked monthly processing
 ;Check Extraction Log
 Q:'$D(IO)
 I $D(DUZ)[0 G TEND
 D ^XBKVAR,DT^DICRW
 ;Must have "@" or "[" in DUZ(0), otw quit
 I DUZ(0)'["@",DUZ(0)'["[" G TEND
 I '$D(^ADELOG("LAST","D")) G TASK1
 ;If last extraction abended, send notificaton bulletin and quit
 I $P(^ADELOG("LAST","D"),"^",2)["AB" D  G TEND
 . S XMB="ADEX-ABEND",XMDUZ="DENTAL PACKAGE" D ^XMB
 ;If last extraction was today, just quit.
 I $P(^ADELOG("LAST","D"),U)=DT G TEND
TASK1 ;Send bulletin that extraction started on device #
 S XMB="ADEX-START",XMB(1)=IO,XMDUZ="DENTAL PACKAGE" D ^XMB
 ;Set ADEBDT=First day of fiscal Year
 S ADEBDT=$$FY(DT)
 S ADEND=DT
 S ADEXDT=DT
 S ADECHS=0 S:$P(^ADEPARAM(+^AUTTSITE(1,0),0),U,6)="y" ADECHS=1
 ;Do Extraction (ADEXSU1)
 D ^ADEXSU1
 S ADERC=$S($D(^ADENDATA(0))=1:$P(^ADENDATA(0),U,7),1:0)
 ;Save file to unix host
 I ADERC S XBIO=51,XBMED="F",XBGL="ADENDATA" D ^XBGSAVE
 ;(NOTE:  Change AUGSAVE to XBSAVE whenever that gets written)
 ;Send bulletin that extraction complete and data saved to FILE
 S XMB="ADEX-COMPLETE",XMDUZ="DENTAL PACKAGE"
 I 'ADERC S XMB(1)=0,XMB(2)="",XMB(3)="" D ^XMB G TEND
 ;If AUFLG=-1 Set bulletin variable to augsave error message
 ;contained in AUGFLG(1)
 S XMB(1)=ADERC
 I $D(AUFLG),AUFLG=-1 D  D ^XMB G TEND
 . S XMB(2)="But the AUGSAVE routine was not able to save the extracted data to a unix file."
 . I $D(AUFLG(1)),AUFLG(1)]"" S XMB(2)=XMB(2)_" The error message returned from AUGSAVE was: "_AUFLG(1)
 . S XMB(3)="The dental data cannot be forwarded to the Area until it can be saved to a unix file.  Please contact your Area Information System Coordinator or IHS Dental Headquarters (505) 262 6319."
 ;
 D  D ^XMB G TEND
 . S XMB(2)="Data saved to unix file."
 . S XMB(3)="Retain a copy of the data extraction printout for your records.  Coordinate with Area Headquarters to ensure that the data file is forwarded and received."
TEND K AUFLG,ADEBDT,ADEND,ADEXDT,ADERC
 Q
 ;
FY(ADEDT) ;;Returns beginning of ADEADEDT's fiscal year in FM form
 N ADEFY
 ;beginning Y2K fix
 ;S ADEFY=1001 
 ;S ADEFY="2"_$S($E(ADEDT,4,5)<10:$E(ADEDT,2,3)-1,1:$E(ADEDT,2,3))_ADEFY
 S ADEFY=$P($$FISCAL^XBDT(ADEDT),U,2)  ;Y2000
 ;end Y2K fix block
 Q ADEFY
 K ADEFY ;*NE
