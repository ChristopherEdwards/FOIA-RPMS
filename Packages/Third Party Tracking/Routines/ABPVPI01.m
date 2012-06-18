ABPVPI01 ;POST INITIALIZATION TASKS; [ 06/06/91  6:47 AM ]
 ;;2.0;FACILITY PVT-INS TRACKING;*0*;IHS-OKC/KJR;AUGUST 7, 1991
 G MAIN
 ;---------------------------------------------------------------------
LOCKS ;PROCEDURE TO CHECK VALIDITY OF THE OPTION/LOCK RELATIONSHIPS
 W !!,"   Inspecting your option/lock relationships..."
 K MSG S MSG="everything looks O.K.!"
 S ABPVR="ABPV" F I=0:0 D  Q:$E(ABPVR,1,4)'="ABPV"
 .S ABPVR=$O(^DIC(19,"B",ABPVR)) Q:$E(ABPVR,1,4)'="ABPV"
 .S ABPVRR=0 F J=0:0 D  Q:+ABPVRR=0
 ..S ABPVRR=$O(^DIC(19,"B",ABPVR,ABPVRR)) Q:+ABPVRR=0
 ..Q:$D(^DIC(19,ABPVRR,0))'=1
 ..S ABPVLOCK="ABPVZ"_$E(ABPVR,5,99)
 ..I $P(^DIC(19,ABPVRR,0),"^",6)]"" D
 ...I $P(^DIC(19,ABPVRR,0),"^",6)'=ABPVLOCK D
 ....W !,"      '",ABPVR,"' has the wrong lock..." K MSG
 ....K DIE,DA,DR S DIE="^DIC(19,",DR="3///@",DA=ABPVRR D ^DIE
 ....W "fixed!"
 I $D(MSG)=1 W MSG
 Q
 ;---------------------------------------------------------------------
UPDATE ;PROCEDURE TO UPDATE VERSION 1.X FILE ENTRIES TO 2.0 FORMAT
 Q:+$P(^ABPVFAC(0),"^",4)'>0
 W !!,"   ...Updating your file entries to the Version 2.0 format..."
 S ABPVR=0 F ABPVI=0:0 D  Q:+ABPVR=0
 .S ABPVR=$O(^ABPVFAC(ABPVR)) Q:+ABPVR=0
 .Q:$D(^ABPVFAC(ABPVR,0))'=1  S X=$P(^(0),"^") Q:X'?1N.N
 .K ^ABPVFAC("B",X,ABPVR) S X=X_"A",$P(^ABPVFAC(ABPVR,0),"^")=X
 Q
 ;---------------------------------------------------------------------
XREF ;PROCEDURE TO VALIDATE CROSS REFERENCES
 Q:+$P(^ABPVFAC(0),"^",4)'>0
 W !!,"   ...Excuse me, I insist upon checking your file indexes..."
 W !,"      This may take awhile.  Please be patient.  "
 K DIK,DA S DIK="^ABPVFAC(" D IXALL^DIK W "all done!"
 Q
 ;---------------------------------------------------------------------
MAIN ;ENTRY POINT - THE PRIMARY ROUTINE DRIVER
 W *7,!!,"I HAVE TO RUN A POST-INITIALIZATION ROUTINE."
 D OPTS^ABPVPI02,LOCKS,UPDATE,XREF
 W !!,"POST INITIALIZATION COMPLETE!"
 Q
