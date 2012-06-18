VENPCCG1 ; IHS/OIT/GIS - GET ICD PREFERENCES: SORTER ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ;
ST ;   EP -  CALLED FROM VENPCCG AND VENPCC1
 I '$G(QUIET) D ^XBCLS
 ;
MSG ;
 I '$G(NEWDXP) U 0 W !!,"Building Temp file. Please hold......"
 E  I '$G(QUIET) W !!,"Searching database for preferences..."
 ;
 S ED=ED_".9999"
 S VD=BD-1
 F  S VD=$O(^AUPNVSIT("B",VD)) Q:VD=""  D
 . S VDFN=0 F  S VDFN=$O(^AUPNVSIT("B",VD,VDFN)) Q:VDFN=""  D
 ..I $G(VENDEPT) S %=$P($G(^AUPNVSIT(VDFN,0)),U,8) I VENDEPT'=% Q
 ..I TYPE'="A" D SCREEN I FL="N" Q
 ..D PAT Q:DOB=""  Q:PAT=""
 .. S Z=0 F  S Z=$O(^AUPNVPOV("AD",VDFN,Z)) Q:'Z  D
 ... S REC=^AUPNVPOV(Z,0)
 ... S ICD=$P(REC,"^",1)
 ... S PNP=$P(REC,"^",4)     ;dmh added 8/31/2000  to get prov. narr.
 ...I AGE<18 S AGEGRP=1
 ...E  S AGEGRP=2
 ...D AGEGRPS
 ...;S @TMP@("VPOV",AGEGRP,SEX,CLIN,ICD)=$G(@TMP@("VPOV",AGEGRP,SEX,CLIN,ICD))+1
 ... S @TMP@("VPOV",ICD,"B",AGEGRP)=$G(@TMP@("VPOV",ICD,"B",AGEGRP))+1  ;8/11
 ... S @TMP@("VPOV",ICD)=$G(@TMP@("VPOV",ICD))+1  ;8/11
 ... S @TMP@("VPOV",ICD,AP)=$G(@TMP@("VPOV",ICD,AP))+1  ;8/11
 ...  ;the AP IS age group piece
 ...;
 ...;
 ...I PNP'="" S @TMP@("VPOV","PN",ICD,PNP)=$G(@TMP@("VPOV","PN",ICD,PNP))+1  ;8/31  ;not splitting out by age-sex grouping... just lumping all together
 ...;
 ...;
 G EXIT
 Q
EXIT ;CLEANUP
 ;D NEXT
 I '$G(NEWDXP) D ^%ZISC
 K X,Y,Z,REC,CPT,VREC,CL,CT,CODE,CLIN,VEN,DPT0,DOS,VENPRV,VENGBL
 Q
PAT ;
 S VIS=^AUPNVSIT(VDFN,0)
 S PAT=$P(VIS,"^",5)
 Q:PAT=""
 S CLIN=$P(VIS,"^",8)
 I CLIN="" S CLIN="OTHER"
 E  D
 .S CC=$P($G(^DIC(40.7,CLIN,0)),"^",2)
 .I (CC=30)!(CC=80) S CLIN="ER"
 .E  S CLIN="OTHER"
 S DOS=$P(VIS,"^",1),DOS=$P(DOS,".",1)
 S DPT0=$G(^DPT(PAT,0))
 S DOB=$P(DPT0,"^",3) Q:DOB=""
 S SEX=$P(DPT0,"^",2)
 I SEX="" S SEX="U"
 S X1=DOS,X2=DOB D ^%DTC S AGE=X\365.25
 Q
SCREEN ;
 S FL="N"
 S VEN=0
 S %=$C(68)_"IC(6,",VENGBL=$S($G(^DD(9000010.06,.01,0))[%:(U_%_"VENPRV,0)"),1:"^VA(200,VENPRV,""PS"")")
 F  S VEN=$O(^AUPNVPRV("AD",VDFN,VEN)) Q:VEN=""  D  Q:FL="Y"
 .I TYPE="P" D
 .. S VENPRV=$P($G(^AUPNVPRV(VEN,0)),"^",1)
 ..I VENPRV'="" I $D(VEN("PRV",VENPRV)) S FL="Y" Q
 ..;I $P($G(^AUPNVPRV(VEN,0)),"^",1)=VEN("PRV") S FL="Y"
 ..Q
 .I TYPE="C" D
 .. S VENPRV=$P($G(^AUPNVPRV(VEN,0)),"^",1)
 .. S VENPTY=$S(VENGBL[200:$P($G(@VENGBL),U,5),1:$P($G(@VENGBL),U,4))
 ..I VENPTY'="",$D(VEN("PC",VENPTY)) S FL="Y"
 ..Q
 Q
AGEGRPS ;
 ;  AP will be the age group node that will be used in extraction
 I (AGE<3) S AP=1 Q
 I (AGE>2),(AGE<13) S AP=2 Q
 I (AGE>12),(AGE<18),(SEX="M") S AP=3 Q
 I (AGE>12),(AGE<18),(SEX="F") S AP=4 Q
 I (AGE>17),(AGE<65),(SEX="M") S AP=5 Q
 I (AGE>17),(AGE<65),(SEX="F") S AP=6 Q
 I (AGE>64),(SEX="M") S AP=7 Q
 I (AGE>64),(SEX="F") S AP=8 Q
 Q
