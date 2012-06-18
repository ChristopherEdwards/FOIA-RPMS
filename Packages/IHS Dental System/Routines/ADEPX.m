ADEPX ;IHS/HQW/MJL - DENTAL REPORT EXPORTS  [ 03/24/1999   8:35 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
 ;CREATE REPORTS FOR EXPORT TO HFS
 ;
 S U="^"
 ;SET UP FILE NAME
 S ADEFN=$$FILE("ade1")
 ;GET HFS DEVICE LIST
 S ADEHFS=$$HFS()
 ;PROCESS
 S ADEU=$$ADEU^ADEPSUB()
 D CALIF^ADEPX01
 ;
 ;CALL %ZIS
 D ZIS
 ;OUTPUT REPORT
 U IO
 D OUT
 D ^%ZISC
 ;
END ;K ^TMP("ADEP",ADEU)
 L -^TMP("ADEP",ADEU)
 ;
 Q
 ;
OUT ;W !
 S ADEX=0
 F  S ADEX=$O(^TMP("ADEP",ADEU,ADEX)) Q:'+ADEX  D
 . S ADEDAT=^TMP("ADEP",ADEU,ADEX)
 . F ADEJ=1:1:$L(ADEDAT,U) D
 . . W $P(ADEDAT,U,ADEJ)
 . . W:ADEJ'=$L(ADEDAT,U) $C(9)
 . W !
 Q
 ;
ZIS N ADECNT
 S ADECNT=1
Z1 S IOP=$P(ADEHFS,U,ADECNT)
 S %ZIS("IOPAR")="("_$C(34)_ADEFN_$C(34)_":"_$C(34)_"W"_$C(34)_")"
 D ^%ZIS
 Q:'POP
 S ADECNT=ADECNT+1
 I ADECNT<$L(ADEHFS,U) G Z1
 Q
 ;
FILE(ADEFN) ;
 ;Returns path concatenated with filename
 ;
 ;If unix then path="/usr/spool/uucppublic"
 ;if dos then path=$P(^AUTTSITE(1,1),U,2)
 ;OS data found in $P(^AUTTSITE(1,0),U,21) where 1=unix and 2=dos
 ;
 ;EXPORT FILE NAME STRUCTURE:
 ; ade # ar su . fa month
 ; where # is a report identifier from 0 to z
 ; and month is month number from 1 to c
 ;
 N ADEOS,ADEPATH
 S ADEFN=ADEFN_"3031.01" ;Concatenate with ASUFAC
 S ADEFN=ADEFN_"A" ;Concatenate with Month
 ;
 ;PATH
 S ADEOS=$P(^AUTTSITE(1,0),U,21) ;Get OS
 I ADEOS=1 S ADEPATH="/usr/spool/uucppublic"
 I ADEOS=2 S ADEPATH=$P(^AUTTSITE(1,1),U,2)
 I 1 S ADEPATH="/usr/ihs/hwhitt"
 S ADEFN=ADEPATH_$S(ADEOS=1:"/",1:"\")_ADEFN
 ;
 Q ADEFN
 ;
HFS() ;RETURNS U-DELIMITED LIST OF HFS DEVICES
 ;$O THRU %ZIS(1 LOOKING FOR %ZIS(1,D0,"TYPE")="HFS"
 ;
 N ADEX,ADECNT,ADEHFS,ADEIO
 S ADEX=0,ADECNT=1,ADEHFS=""
 F  S ADEX=$O(^%ZIS(1,ADEX)) Q:'+ADEX  D
 . Q:'$D(^%ZIS(1,ADEX,"TYPE"))
 . I $P(^%ZIS(1,ADEX,"TYPE"),U)="HFS" D
 . . S ADEIO=$P(^%ZIS(1,ADEX,0),U,2)
 . . S:ADEHFS'[ADEIO $P(ADEHFS,U,ADECNT)=ADEIO,ADECNT=ADECNT+1
 Q ADEHFS
