APCDSKL ; IHS/CMI/LAB - DISPLAY SKIN TESTS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ; MODIFIED FOR RPMS PCC DATA ENTRY 4-23-87/EDE
 ;
 D HEAD,HP,HD K APCDSKA D ^APCDSKL1
END K APCDSKLC,APCDSKLJ,APCDSKLL,APCDSKLS,APCDSKLV,APCDSKLY Q
HEAD W !?31,"Skin Test Record",!!
 Q
HP I $D(APCDPAT),$D(^DPT(APCDPAT,0)) S APCDSKLX=^(0),APCDSKLN=$P(APCDSKLX,"^"),APCDSKLS=$P(APCDSKLX,"^",2) W !,$P(APCDSKLN,","),", ",$P(APCDSKLN,",",2,99)
 S APCDSKLN=$P(APCDSKLX,"^",3) G H2:'APCDSKLN W ?24,"   ",$P("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"," ",$E(APCDSKLN,4,5))," " W:$E(APCDSKLN,6,7) +$E(APCDSKLN,6,7)," " W $E(APCDSKLN,1,3)+1700
 ;S X1=DT,X2=APCDSKLN D ^%DTC S APCDSKLN=$S(X<60:X_" Days",X<913:$J(X/30.44,0,0)_" Months",1:$J(X/365.25,0,0)_" Years") W " (",APCDSKLN,")"
H2 W:APCDSKLS]"" ?55,"  ",$S(APCDSKLS="F":"FE",1:""),"MALE"
 Q
HD W !!?7,"Date",?18,"Skin Test",?35,"Reading",?50,"Result",?61,"Date Read"
 W !?3,"------------",?18,"------------",?34,"------------",?49,"-----------",?61,"--------"
 Q
