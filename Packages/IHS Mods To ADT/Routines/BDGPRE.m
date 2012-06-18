BDGPRE ; IHS/ANMC/LJF - PIMS PREINIT ;  [ 12/02/2002  4:25 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ; Changes that must be made BEFORE running install
 ;11/6/2002 WAR - added a call to ^BDGPRE1
 ;D DPTDEL,BULLD,BULLC Q
 D ^BDGPRE1,DPTDEL,BULLD,BULLC Q
 ;
DPTDEL ; -- delete old dd for files 2,40.8, 42, 43, 44, 405
 ; -- VA removed lots of fields
 S ADIFROM("IHS")=""     ;so user won't be asked continue question
 K ^UTILITY("XBDSET",$J)
 S ^UTILITY("XBDSET",$J,2)="S^S"
 S ^UTILITY("XBDSET",$J,40.8)="S^S"
 S ^UTILITY("XBDSET",$J,42)="S^S"
 S ^UTILITY("XBDSET",$J,43)="S^S"
 S ^UTILITY("XBDSET",$J,44)="S^S"
 S ^UTILITY("XBDSET",$J,405)="S^S"
 D EN2^XBKD
 K ADIFROM("IHS")
 Q
 ;
BULLD ; delete obsolete bulletins
 NEW BDGI,DIK,DA,NAME
 S DIK="^XMB(3.6,"
 F BDGI=1:1:3 S NAME=$P($T(OLDBUL+BDGI),";;",2) D
 . Q:'$D(^XMB(3.6,"B",NAME))    ;does not have old bulletins
 . S DA=$O(^XMB(3.6,"B",NAME,0)) I DA D ^DIK
 Q
 ;
BULLC ; change names of ADT bulletins if already on system
 ; and delete message text to start fresh
 NEW DIE,DA,DR,OLD,IEN,X,BDGI
 F BDGI=1:1:9 S OLD=$P($T(BULLNM+BDGI),";;",2) D
 . Q:'$D(^XMB(3.6,"B",OLD))    ;does not have old bulletin
 . S IEN=$O(^XMB(3.6,"B",OLD,0)) Q:'IEN   ;bad xref
 . ;
 . ; change name
 . S DIE=3.6,DA=IEN,DR=".01///"_$P($T(BULLNM+BDGI),";;",3) D ^DIE
 . ;
 . ; now remove message text
 . S X=0 F  S X=$O(^XMB(3.6,IEN,1,X)) Q:'X  D
 .. K ^XMB(3.6,IEN,1,X,0)
 Q
 ;
 ;
OLDBUL ;; obsolete bulletins
 ;;DG IHS INCOMPLETE MOVEMENT;;
 ;;DG IHS ADCORR;;
 ;;DG IHS VHOSP;;
 ;
 ;
BULLNM ;; bulletin names (old;;new)
 ;;DG IHS A&D;;BDG A&D READY;;
 ;;DG IHS B ADMIT AFTER DAY SURG;;BDG ADMIT AFTER DAY SURG;;
 ;;DG IHS B AMA DISCHARGE;;BDG AMA DISCHARGE;;
 ;;DG IHS B DEATH;;BDG DEATH;;
 ;;DG IHS B ICU TRANSFER;;BDG ICU TRANSFER;;
 ;;DG IHS B READMISSION;;BDG READMISSION;;
 ;;DG IHS B TRANSFER IN ADMIT;;BDG TRANSFER IN ADMIT;;
 ;;DG IHS B TRANSFER OUT DISCH;;BDG TRANSFER OUT DISCH;;
 ;;DG IHS DELETED ADMITS;;BDG DELETED ADMITS;;
