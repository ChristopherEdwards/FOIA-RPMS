APCL1H1 ; IHS/CMI/LAB - Inpatient 2A report process ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 S APCLBT=$H,APCLJOB=$J
 K ^XTMP("APCL1H",APCLJOB,APCLBT)
 D XTMP^APCLOSUT("APCL1H","PCC HOSPITALIZATION COUNT RPT APCL1H")
 S APCLSD=APCLFY-.0001 S X1=APCLFY,X2=365 D C^%DTC S APCLFYE=$E(X,1,3)_"0930"
LOC S APCLJ=0 F  S APCLJ=$O(^AUTTLOC(APCLJ)) Q:APCLJ'=+APCLJ  S:$P(^AUTTLOC(APCLJ,0),U,4)=APCLAREA ^XTMP("APCL1H",APCLJOB,APCLBT,"LOCATIONS",APCLJ)=""
V ; Run by visit date
 S APCLGRAN=0
 S APCLODAT=APCLSD F  S APCLODAT=$O(^AUPNVINP("B",APCLODAT)) Q:APCLODAT=""!((APCLODAT\1)>APCLFYE)  D V1
 S APCLET=$H
 Q
V1 ;
 S APCLVINP="" F  S APCLVINP=$O(^AUPNVINP("B",APCLODAT,APCLVINP)) Q:APCLVINP'=+APCLVINP  I $D(^AUPNVINP(APCLVINP,0)) S APCLHREC=^(0) D PROC,EOJ
 Q
PROC ;
 Q:$$DEMO^APCLUTL($P(APCLHREC,U,2),$G(APCLDEMO))
 S APCLVDFN=$P(APCLHREC,U,3)
 S APCLVREC=^AUPNVSIT(APCLVDFN,0)
 Q:$D(^APCLCNTL(4,11,"B",$P(APCLVREC,U,3)))  ;LAB/TUCSON CHANGED FOR VA
 S APCLVLOC=$P(APCLVREC,U,6)
 Q:'$D(^XTMP("APCL1H",APCLJOB,APCLBT,"LOCATIONS",APCLVLOC))
 Q:'$D(^AUPNVPOV("AD",APCLVDFN))
 Q:'$D(^AUPNVPRV("AD",APCLVDFN))
PROC1 S (APCL1,APCL2)=0 F  S APCL2=$O(^AUPNVPRV("AD",APCLVDFN,APCL2)) Q:APCL2=""  I $P(^AUPNVPRV(APCL2,0),U,4)="P" S APCL1=APCL1+1
 Q:APCL1=0
 Q:APCL1>1
 S APCLMOS=+$E(APCLODAT,4,5)
 S ^(APCLMOS)=$S($D(^XTMP("APCL1H",APCLJOB,APCLBT,"MONLOCTOT",APCLVLOC,APCLMOS)):^(APCLMOS)+1,1:1)
 S ^(APCLVLOC)=$S($D(^XTMP("APCL1H",APCLJOB,APCLBT,"LOCTOT",APCLVLOC)):^(APCLVLOC)+1,1:1)
 S APCLGRAN=APCLGRAN+1
 Q
EOJ K APCLVLOC,APCLHREC,APCL1,APCL2,APCLVREC,APCLVDFN
 Q
 ;