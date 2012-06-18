ABMDREL0 ; IHS/ASDST/DMJ - PRINTING UTILITIES ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
CALC ;
 I Y=0!(X=0) S Z="**" G COMMA
 S Z=(((X/Y)-1)*100),Z=$FN(Z,"+,",1)
COMMA ;
 S X=$FN(X,",")
 Q
DONE ;EP to print run summary
 Q:$D(ABMD("Q"))
 I $D(ABMD("ET")) S ABMD("TS")=(86400*($P(ABMD("ET"),",",1)-$P(ABMD("BT"),",",1)))+($P(ABMD("ET"),",",2)-$P(ABMD("BT"),",",2)),ABMD("H")=$P(ABMD("TS")/3600,".",1) S:ABMD("H")="" ABMD("H")=0
 S ABMD("TS")=ABMD("TS")-(ABMD("H")*3600),ABMD("M")=$P(ABMD("TS")/60,".",1) S:ABMD("M")="" ABMD("M")=0 S ABMD("TS")=ABMD("TS")-(ABMD("M")*60),ABMD("S")=ABMD("TS") W !!,"RUN TIME (H.M.S): ",ABMD("H"),".",ABMD("M"),".",ABMD("S")
 Q
EOJ ;
 K %DT,Y,X,ZTSK,ZTQUEUED,POP,ZTIO,DIRUT,DIR
 K Z,^TMP("ABMDBRH",ABMD("$J")),ABMD
 Q
