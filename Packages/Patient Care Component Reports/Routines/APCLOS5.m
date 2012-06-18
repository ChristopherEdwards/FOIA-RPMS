APCLOS5 ; IHS/CMI/LAB - RX ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;This Routine works with the Division of the Pharmacy
 ;Site and Prescription File.  The Related Institution
 ;field of the Pharmacy Site file contains the Facility
 ;Location IEN for each .01 Free Text Division Entries
 ;This routine checks hits against the location if the
 ;User has requested individual facility summaries.
 ;The Related Institution Field must be the Division
 ;itself, not the Primary Service Unit Facility.
 ;
RX ;
 S X1=APCLFYB,X2=-1 D C^%DTC S APCLSD=X_".9999",APCLED=APCLFYE,APCLOS="APCLOS" D PROC
 S X1=APCLPYB,X2=-1 D C^%DTC S APCLSD=X_".9999",APCLED=APCLPYE,APCLOS="APCLOSP" D PROC
 K APCLRX,APCLODAT,APCLSD,APCLED,APCLOS,APCLRX1,APCLPS,APCLDIV
 Q
 ;
PROC ;
 S APCLODAT=$O(^PSRX("AD",APCLSD)) Q:APCLODAT=""
 S APCLODAT=APCLSD F  S APCLODAT=$O(^PSRX("AD",APCLODAT)) Q:APCLODAT=""!((APCLODAT\1)>APCLED)  D PROC1
 Q
PROC1 ;
 S APCLRX="" F  S APCLRX=$O(^PSRX("AD",APCLODAT,APCLRX)) Q:APCLRX'=+APCLRX  D PROC2
 Q
PROC2 ;
 Q:$$DEMO^APCLUTL($P(^PSRX(APCLRX,0),U,2),$G(APCLDEMO))
 S APCLPS=$$VALI^XBDIQ1(52,APCLRX,20)
 Q:APCLPS=""
 S APCLDIV=$$VALI^XBDIQ1(59,APCLPS,100)
 Q:'$D(^XTMP("APCLSU",APCLJOB,APCLBTH,APCLDIV))
 S APCLRX1="" F  S APCLRX1=$O(^PSRX("AD",APCLODAT,APCLRX,APCLRX1)) Q:APCLRX1=""  D PROC3
 Q
PROC3 ;
 G:APCLRX1>0 REFILL
 S ^("RXNEW")=$S($D(^XTMP(APCLOS,APCLJOB,APCLBTH,"RXNEW")):(+^("RXNEW")+1),1:1)
 ;
 Q
REFILL ;
 S ^("RXREFILLS")=$S($D(^XTMP(APCLOS,APCLJOB,APCLBTH,"RXREFILLS")):(+^("RXREFILLS")+1),1:1)
 Q
