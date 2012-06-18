BQIRGTH1 ;APTIV/HC/ALA-Trigger RPCs for HMS data fields ; 16 Apr 2008  1:14 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
EN(DATA,DCAT,ETIO,RSTAT,NOTIF,STHREP,STHACS,STAREP,STAACS) ; EP -- BQI REGISTER HMS TRIGGERS
 ; These are small individual value triggers
 ; Input
 ;   DCAT  - Diagnosis Category (BKMDCAT)
 ;   ETIO  - Etiology (BKMETIO)
 ;   RSTAT - Register Status (BKMSTAT)
 ;   NOTIF - Partner Notification Status (BKMPTSTA)
 ;   STHREP - State HIV Report Status (BKMSHRST)
 ;   STHACS - State HIV Acknowledgement Status (BKMSHAST)
 ;   STAREP - State AIDS Report Status (BKMSARST)
 ;   STAACS - State AIDS Acknowledgement Status (BKMSAAST)
 ;
 NEW UID,II,BI,LM,TEXT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIRGTH1",UID))
 K @DATA
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQIRGTH1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="T00008SOURCE^T00001ABLE_FLAG^T01024CLEAR_FIELDS"_$C(30)
 ;
 ;Diagnosis Category
 S DCAT=$G(DCAT,"")
 I DCAT'="" D
 . ; If category is At Risk
 . I DCAT'="A"&(DCAT'="H") D
 .. F BI=1:1 S LM=$T(DCATR+BI) Q:LM=" Q"  D
 ... S TEXT=$P(LM,";;",2)
 ... S II=II+1,@DATA@(II)=TEXT_$C(30)
 . ; If category is HIV
 . I DCAT="H" D
 .. F BI=1:1 S LM=$T(DCATH+BI) Q:LM=" Q"  D
 ... S TEXT=$P(LM,";;",2)
 ... S II=II+1,@DATA@(II)=TEXT_$C(30)
 . ; If category is AIDS
 . I DCAT="A" D
 .. F BI=1:1 S LM=$T(DCATA+BI) Q:LM=" Q"  D
 ... S TEXT=$P(LM,";;",2)
 ... S II=II+1,@DATA@(II)=TEXT_$C(30)
 ;
 ;Etiology
 S ETIO=$G(ETIO,"")
 I ETIO'="",ETIO'="@" S II=II+1,@DATA@(II)="BKMETIOC^Y^"_$C(30)
 I ETIO="@" S II=II+1,@DATA@(II)="BKMETIOC^N^"_$C(30)
 ;
 ;Register Status
 S RSTAT=$G(RSTAT,"")
 I RSTAT'="" S II=II+1,@DATA@(II)="BKMRCOM^Y^"_$C(30)
 ;
 ;Partner Notification Status
 S NOTIF=$G(NOTIF,"")
 I NOTIF'="" D
 . I NOTIF="Y" S II=II+1,@DATA@(II)="BKMPTDT^Y^"_$C(30) Q
 . S II=II+1,@DATA@(II)="BKMPTDT^N^BKMPTDT"_$C(30)
 ;
 ;State HIV Report Status
 S STHREP=$G(STHREP,"")
 I STHREP'="" D
 . I STHREP="Y" D  Q
 .. S II=II+1,@DATA@(II)="BKMSHRDT^Y^"_$C(30)
 .. S II=II+1,@DATA@(II)="BKMSHAST^Y^"_$C(30)
 .. ;S II=II+1,@DATA@(II)="BKMSHADT^Y^"_$C(30)
 . S II=II+1,@DATA@(II)="BKMSHRDT^N^BKMSHRDT"_$C(30)
 . S II=II+1,@DATA@(II)="BKMSHADT^N^"_$C(30)
 . S II=II+1,@DATA@(II)="BKMSHAST^N^BKMSHAST;BKMSHADT"_$C(30)
 ;
 ;State HIV Acknowledgement Status
 S STHACS=$G(STHACS,"")
 I STHACS'="" D
 . I STHACS="Y" S II=II+1,@DATA@(II)="BKMSHADT^Y^"_$C(30) Q
 . S II=II+1,@DATA@(II)="BKMSHADT^N^BKMSHADT"_$C(30)
 ;
 ;State AIDS Report Status
 S STAREP=$G(STAREP,"")
 I STAREP'="" D
 . I STAREP="Y" D  Q
 .. S II=II+1,@DATA@(II)="BKMSARDT^Y^"_$C(30)
 .. S II=II+1,@DATA@(II)="BKMSAAST^Y^"_$C(30)
 .. ;S II=II+1,@DATA@(II)="BKMSAADT^Y^"_$C(30)
 . S II=II+1,@DATA@(II)="BKMSARDT^N^BKMSARDT"_$C(30)
 . S II=II+1,@DATA@(II)="BKMSAADT^N^"_$C(30)
 . S II=II+1,@DATA@(II)="BKMSAAST^N^BKMSAAST;BKMSAADT"_$C(30)
 ;
 ;State AIDS Acknowledgement Status
 S STAACS=$G(STAACS,"")
 I STAACS'="" D
 . I STAACS="Y" S II=II+1,@DATA@(II)="BKMSAADT^Y^"_$C(30) Q
 . S II=II+1,@DATA@(II)="BKMSAADT^N^BKMSAADT"_$C(30)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
DCATH ;HIV Diagnosis Category
 ;;BKMDCOM^Y^
 ;;BKMDXDT^Y^
 ;;BKMAIDT^N^BKMAIDT
 ;;BKMCLCLS^Y^
 ;;BKMSHRST^Y
 ;;BKMSARST^N
 Q
 ;
DCATR ;At Risk Category
 ;;BKMDCOM^Y^
 ;;BKMDXDT^N^
 ;;BKMAIDT^N^
 ;;BKMCLCLS^N^BKMCLCLS
 Q
 ;
DCATA ;AIDS Category
 ;;BKMDCOM^Y^
 ;;BKMDXDT^Y^
 ;;BKMAIDT^Y^
 ;;BKMCLCLS^Y^
 ;;BKMSARST^Y
 Q
 ;
STAT ; Status trigger
 ;;BKMDCAT^N^
 ;;BKMDCOM^N^
 ;;BKMDXDT^N^
 ;;BKMAIDT^N^
 ;;BKMETIO^N^
 ;;BKMCLCLS^N^
 ;;BKMPTSTA^N^
 ;;BKMHPROV^N^
 ;;BKMHCSMR^N^
 ;;BKMLOC^N^
 ;;BKMSHRST^N^
 ;;BKMSHAST^N^
 ;;BKMSHADT^N^
 ;;BKMSARST^N^
 ;;BKMSAAST^N^
 Q
