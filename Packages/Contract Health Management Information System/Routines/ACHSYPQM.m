ACHSYPQM ; IHS/ITSC/PMF - MOVE OLD PRINT QUEUE ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; In version of CHS prior to 1.6, the document print queue was kept
 ; in the ^%ZTSK global.  This utility move the queue from the ^%ZTSK
 ; global to the new location at ^ACHSF("PQ".
 ;
 ; This was part of the post-init for version 1.6 and 2.0.
 ;
 ; You probably don't need to run this, but it can't hurt.
 ;
 W !,$$C^XBFUNC("Checking old document print q.")
 X ^%ZOSF("UCI")
 I '$D(^%ZTSK(Y,"ACHQ")) W !,$$C^XBFUNC("Nothing there.  Previously converted.") G END2
 W !,$$C^XBFUNC("Transferring Document print Q from %ZTSK to ACHSF('PQ')")
 ;
 ;  L=Location, S=TypeOfSvc, D=DocIEN, T=TransIEN
 ;
 S L=""
L1 ;
 S L=$O(^%ZTSK(Y,"ACHQ",L))
 G END1:L=""
 S S=""
L2 ;
 S S=$O(^%ZTSK(Y,"ACHQ",L,S))
 G L1:S=""
 S %=""
L3 ;
 S %=$O(^%ZTSK(Y,"ACHQ",L,S,%))
 G L2:%=""
 S D=$P(^%ZTSK(Y,"ACHQ",L,S,%),U),T=$P(^(%),U,2),^ACHSF("PQ",L,S,D,T)=""
 W "."
 G L3
END1 ;
 W !,$$C^XBFUNC("Print Q Transferred.")
 K ^%ZTSK(Y) ; Old global node
END2 ;
 K L,D,T,S,Y
 K ^TMP("ACHSYPQM",$J)
 Q
 ;
