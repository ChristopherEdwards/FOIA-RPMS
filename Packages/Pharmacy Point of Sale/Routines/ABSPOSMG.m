ABSPOSMG ; IHS/SD/RLT - INSURER BILLING STATUS ;     [ 06/13/06  11:20 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**17**;JUN 7, 2006
 ;
 ;Reports Insurers in file #9999999.18 that have RX
 ;BILLING STATUS set to P - BILLED POINT OF SALE or
 ;to U - UNBILLABLE depending on the report selected.
 ;The BILLED POINT OF SALE report also shows whether
 ;the insurer is tied to a POS format.
 ;----------------------------------------------------------
 ;----------------------------------------------------------
 ;
EN ;EP
 N RESP
 S RESP=$$GETRESP
 Q:RESP=""
 D DISDATA
 Q
GETRESP() ;Prompt for report type
 W @IOF
 W "Choose from:"
 W !,"P BILLED POINT OF SALE - insurers set-up to bill RX's through POS"
 W !,"U UNBILLABLE - insurers set to NOT bill RX's"
 D ^XBFMK                  ;kill Fileman variables
 S DIR(0)="SO^P:BILLED POINT OF SALE;U:UNBILLABLE"
 D ^DIR
 Q $TR(X,"pu","PU")
DISDATA ;Display Data
 N PGCNT
 S PGCNT=0
 D RPTHDR
 N INSIEN,BILLSTAT,INSNAME,STATDIS,POSLINK
 S:RESP="P" STATDIS="BILLED POINT OF SALE"
 S:RESP="U" STATDIS="UNBILLABLE"
 S INSNAME=""
 F  S INSNAME=$O(^AUTNINS("B",INSNAME)) Q:INSNAME=""  D
 . S INSIEN=0
 . F  S INSIEN=$O(^AUTNINS("B",INSNAME,INSIEN)) Q:'INSIEN  D
 .. S BILLSTAT=$P($G(^AUTNINS(INSIEN,2)),U,3)
 .. Q:BILLSTAT'=RESP
 .. S POSLINK="N"
 .. S:$P($G(^ABSPEI(INSIEN,100)),U)'="" POSLINK="Y"
 .. W !,INSNAME,?35,STATDIS
 .. W:RESP="P" ?68,POSLINK
 .. I $$EOPQ^ABSPOSU8(2,,"D RPTHDR^"_$T(+0)) S INSIEN="A",INSNAME="ZZZZZ"
 D ENDRPT^ABSPOSU5()
 Q
RPTHDR ;Report Header
 N DASHES,X,RPTDATE,Y,BLANK20,ABSPSITE
 S ABSPSITE=$P($G(^DIC(4,DUZ(2),0)),"^")
 S PGCNT=PGCNT+1
 S $P(DASHES,"-",80)=""
 S X="RX BILLING STATUS - "
 S:RESP="P" X=X_"BILLED POINT OF SALE"
 S:RESP="U" X=X_"UNBILLABLE"
 S RPTDATE=$P($$NOWEXT^ABSPOSU1,"@")
 S $P(BLANK24," ",24)=""
 S $P(BLANK17," ",17)=""
 S Y="INSURER NAME"_BLANK24_"RX BILLING STATUS"
 S:RESP="P" Y=Y_BLANK17_"LINK TO POS"
 W @IOF
 W X,?52,RPTDATE,?68,$$RJBF^ABSPOSU9("PAGE "_PGCNT,11)
 W !,ABSPSITE
 W !!,Y
 W !,DASHES
 Q
