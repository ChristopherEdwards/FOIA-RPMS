INHP ; FRW,JSH,BAR ; 4 Mar 98 14:57; Interface - Transaction/Error Purge
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
TPURGE ;Purge transactions from UIF
 ;Transactions with type: COMPLETE, ERROR, or NEGATIVE ACKNOWLEDGED can be purged
 N TYPE,DAY,T,I,J,X,Y,%,INMAX,ZTSK,ZTDESC,ZTDTH,ZTRTN,ZTSAVE
 I '$D(IOF) S (%ZIS,IOP)="" D ^%ZIS
 W @IOF,?27,"*** Transaction Purge ***",!!
 W "This option will create a background job which will purge transactions of the",!,"type indicated.",!!
 S TYPE="",I=1 F  W ! S X=$$SOC^UTIL("Select status of transactions to purge: ","","COMPLETE^ERROR^NEGATIVE ACKNOWLEDGED",0) Q:X=""!($E(X)="^")  S X=$E(X) S:X="N" X="K" S:TYPE'[X I=I+1,$P(TYPE,U,I)=X
 Q:$E(X)="^"!$G(DTOUT)
 S TYPE=TYPE_U,DAY=$P($G(^INRHSITE(1,0)),U,11) S:'DAY DAY=14
 W !! D ^UTSRD("Number of days to keep transactions: ;;;;"_DAY_";2,60","^D DHLP^INHP")
 Q:X=""!($E(X)="^")  S DAY=+X
 ; recap what they selected
 W !!,"  All interface transactions before "_$$CDATASC^%ZTFDT($H-DAY,1)_" with the status of",!
 S Y=$L(TYPE,U)-1 W "  " F I=2:1:Y D
 . S X=$P(TYPE,"^",I),X=$S(X="C":"COMPLETE",X="E":"ERROR",X="K":"NEGATIVE ACKNOWLEDGE",1:"")
 . W $S(I=Y&(Y>2):" or ",1:"")_X_$S(I=Y!(Y<4):"",1:", ")
 W " will be purged."
 ; note user with other purge info before they say OK
 S INMAX=$P($G(^INRHSITE(1,0)),U,18)
 I '$L(INMAX) W !!,"  Maximum days to keep any interface transaction is",!,"  not set and no additional purging will be done.",!
 E  W !!,"  All interface transactions older than "_$$CDATASC^%ZTFDT($H-INMAX,1)_" will be purged.",!
 S X=$$YN^UTSRD("OK to proceed? ;1","") Q:'X
 S ZTIO="",ZTRTN="ZTSK^INHP" F I="DAY","TYPE" S ZTSAVE(I)=""
 S ZTDESC="Purge GIS Messages" D ^%ZTLOAD W !,"Request",$S($G(ZTSK):" ",1:" NOT "),"QUEUED!" K ZTSK
 Q
 ;
ZTSK ;Taskman entry point
 ;DAY = number of days to keep transactions
 ;TYPE = status(es) of message to purge
 ;   C = complete, E = error, K = Negative Acknowledge
 ; TYPE can contain more than one of these letters separated by ^
 ;   for example, to purge types E and C set TYPE="E^C"
 ;
 ;Do misc cleanup
 D MISC
 ;
 N INTYPE,INDAY,INCOUNT,INMAX,INDT,DIK
 S INTYPE=TYPE,INDAY=DAY,INCOUNT=0
 D SETDT^UTDT S X1=DT,X2=-DAY D C^%DTC S INDAY=X
 ; get max days for transactions, calc date if filled in
 S INMAX=$P($G(^INRHSITE(1,0)),U,18)
 I $L(INMAX) S X1=DT,X2=-INMAX D C^%DTC S INMAX=X
 ;Loop through file
 S INX=0 F  S INX=$O(^INTHU(INX)) Q:'INX  D
 . I '$L($G(^INTHU(INX,0))) K ^INTHU(INX) Q  ;SHOULD ALSO LOG ERROR
 . S INDT=$P(^INTHU(INX,0),U,14)
 . ; purge all transactions after certain date
 . I (+^INTHU(INX,0))<INMAX S DA=INX,DIK="^INTHU(" D ^DIK,HANG Q
 . I INDT<INDAY,INTYPE[(U_$P(^INTHU(INX,0),U,3)_U) S DA=INX,DIK="^INTHU(" D ^DIK,HANG
 Q
 ;
HANG ;Limit entries deleted to 21000/hour
 S INCOUNT=INCOUNT+1 Q:INCOUNT<6
 S INCOUNT=0 H 1
 Q
 ;
MISC ;Misc cleanup
 ;Purge save global for postmaster
 K ^DIJUSV(.5)
 ;Purge message search file
 S %=$$CPURG()
 ;
 ;CLEAN UP ANY OLD (10 days?) ^UTILITY GLOBAL SUBSCRIPTS FOR THE GIS
 ;  -   ^UTILITY("INSAVE" , description , $H )
 ;  -  TRANSACTION TYPE MOVER
 ;  -  TEST DRIVER (^UTILITY("INTHU")) - maybe not
 ;
 Q
 ;
DHLP ;Help for # of days question
 W !,"This is the number of days that must have passed since the last activity",!,"on a transaction has occurred.  For example, entering a value of 3 here will"
 W !,"cause any transactions whose last activity was 4 or more days ago to be purged.",!!,"You may enter a number from 2 to 60."
 W ! Q
 ;
DEHLP ;Help for days to keep errors question
 W !,"This is the number of days that must have passed since the error was logged",!,"in order for it to be purged.  For example, entering a value of 3 here will"
 W !,"cause any errors that were created more than 4 days ago to be deleted.",!!,"You may enter a number from 2 to 60.",! Q
 ;
EPURGE ;Purge Interface Errors
 N TYPE,DAY,T,I,J,X,%,ZTSK
 I '$D(IOF) S (%ZIS,IOP)="" D ^%ZIS
 W @IOF,?30,"*** Error Purge ***",!!
 W "This option will create a background job which will purge Interface Errors",!,"older than the number of days specified."
 W !! D ^UTSRD("Number of days to keep errors: ;;;;14;2,60","^D DEHLP^INHP")
 Q:X=""!($E(X)="^")
 S DAY=+X,X=$$YN^UTSRD("OK to proceed? ;1","") Q:'X
 S ZTIO="",ZTRTN="EZTSK^INHP",ZTDESC="Purge GIS Errors",ZTSAVE("DAY")="" D ^%ZTLOAD W !,"Request QUEUED!" K ZTSK Q
 ;
EZTSK ;Taskman can enter here with DAY=# of days to keep errors
 D SETDT^UTDT S X1=DT,X2=-DAY D C^%DTC S DAY=X
 S DIK="^INTHER(",INX="",INCOUNT=0
 F  S INX=$O(^INTHER("B",INX)) Q:'INX!(INX'<DAY)  S DA=0 F  S DA=$O(^INTHER("B",INX,DA)) Q:'DA  D ^DIK,HANG
 Q
 ;
CPURG() ;Purge aged entries from Interface Criteria File, #4001.1
 ; returns:   1 - Purge completed
 N INDA,INGL,INPDT,INX
 S INGL="^DIZ(4001.1)"
 ; get date to purge to. TODAY - CRITERIA RETENSION DAYS
 S INPDT=$P($G(^INRHSITE(1,0)),U,17),INPDT=$$RELDT^INHUTC2("T-"_$S('$L(INPDT):180,1:INPDT))
 S INDA=0 F  S INDA=$O(@INGL@(INDA)) Q:'INDA  D
 . ; get zero node data
 . S INX=$G(@INGL@(INDA,0))
 . ; bkgrd entry, do not remove if task exists, set dete to 0 to purge
 . I $P(INX,U,3)="B" Q:$D(^%ZTSK(+$P(INX,U,7),0))  S $P(INX,U,9)=0
 . ;check for standard entry or date of last access GT purge date
 . Q:$P(INX,U,3)="S"!($P(INX,U,9)'<INPDT)
 . ;kill entry
 . S %=$$DELCRIT^INHUTC(INDA)
 Q 1
 ;
AUTO ;Autopurge of transactions and errors
 N DAY,TYPE
 S TYPE="^C^E^K^",DAY=$P(^INRHSITE(1,0),U,11) Q:'DAY
 D ZTSK
 S DAY=$P(^INRHSITE(1,0),U,11) Q:'DAY
 D EZTSK
 Q
