BSDSCDUP ;ihs/cmi/maw - BSD Find Duplicate Appointment entries caused by auto rebook and clean them up
 ;;5.3;Scheduling;**1016**;Nov 07,2012;Build 20
 ;
 ;
MAIN ;EP -- main routine entry point
 D END
 D LOOP
 D CLEAN
 D SCUP
 D END
 Q
 ;
LOOP ;-- loop through the hospital location file and find duplicates
 N BDA,BIEN,BOEN,PAT
 S CNT=0
 S BDA=0 F  S BDA=$O(^SC(BDA)) Q:'BDA  D
 . S BIEN=3120901 F  S BIEN=$O(^SC(BDA,"S",BIEN)) Q:'BIEN  D
 .. S BOEN=0 F  S BOEN=$O(^SC(BDA,"S",BIEN,1,BOEN)) Q:'BOEN  D
 ... S PAT=+$P($G(^SC(BDA,"S",BIEN,1,BOEN,0)),U)
 ... Q:'PAT
 ... S:'$D(^MAW($J,BDA,BIEN,PAT)) ^MAW($J,BDA,BIEN,PAT)=0
 ... S ^MAW($J,BDA,BIEN,PAT)=^MAW($J,BDA,BIEN,PAT)+1
 Q
 ;
CLEAN ;-- clean up entries that have only one
 N TDA,TIEN,TPAT
 S TDA=0 F  S TDA=$O(^MAW($J,TDA)) Q:'TDA  D
 . S TIEN=0 F  S TIEN=$O(^MAW($J,TDA,TIEN)) Q:'TIEN  D
 .. S TPAT=0 F  S TPAT=$O(^MAW($J,TDA,TIEN,TPAT)) Q:'TPAT  D
 ... I $G(^MAW($J,TDA,TIEN,TPAT))<2 K ^MAW($J,TDA,TIEN,TPAT)
 Q
 ;
SCUP ;-- now go back through the hospital location file and cleanup duplicate entries
 W !,"Cleaning up duplicate entries caused by auto rebook"
 N SDA,SIEN,SPAT,SOEN
 S SDA=0 F  S SDA=$O(^MAW($J,SDA)) Q:'SDA  D
 . S SIEN=0 F  S SIEN=$O(^MAW($J,SDA,SIEN)) Q:'SIEN  D
 .. S SPAT=0 F  S SPAT=$O(^MAW($J,SDA,SIEN,SPAT)) Q:'SPAT  D
 ... S SOEN=0 F  S SOEN=$O(^SC(SDA,"S",SIEN,1,SOEN)) Q:'SOEN  D
 .... I $P($G(^SC(SDA,"S",SIEN,1,SOEN,0)),U)=SPAT D
 ..... I $L($P($G(^SC(SDA,"S",SIEN,1,SOEN,0)),U,7))=7 W "." K ^SC(SDA,"S",SIEN,1,SOEN,0)
 Q
 ;
END ;-- cleanup variables and quit
 K ^MAW($J)
 Q
 ;
