AMQQRMAN ; IHS/CMI/THL - R-MAN SPECIAL REPORTS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
MAIL ; ENTRY POINT FROM AMQQOPT
 I AMQQCCLS'="P" W !!,"The subject of your search must be 'PATIENT(S)'.  Request denied...",*7,!! H 3 S AMQQRERF="" Q
 D ^AMQQRML
 Q
 ;
AGE ; ENTRY POINT
 I AMQQCCLS'="P" W !!,"The subject of your search must be 'PATIENT(S)'.  Request denied...",*7,!! H 3 S AMQQRERF="" Q
 D ^AMQQRMA
 Q
 ;
WORK ; ENTRY POINT
MONTH ; ENTRY POINT
TIME ; ENTRY POINT
 I AMQQCCLS'="V",'$D(AMQQMULX) W !!,"This search does not find individual visits for analysis.  Request denied...",*7,!! H 3 S AMQQRERF="" Q
 Q
 ;
HSUM ; ENTRY POINT
 I AMQQCCLS'="P" W !!,"The subject of your search must be 'PATIENT(S)'.  Request denied...",*7,!! H 3 S AMQQRERF="" Q
 Q
 ;
FF ; ENTRY POINT
 S AMQV("OPTION")="PRINT"
EMAN S X="AMQQEMAN"
 X ^%ZOSF("TEST")
 I  S AMQV("OPTION")="EMAN"
 Q
 ;
