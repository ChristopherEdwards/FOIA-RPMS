ACDPXMD ;IHS/ADC/EDE/KML - MAIL NOTICE FOR INCOMING DATA;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;****************************************************
 ;//^ACDPIMP
 ;//^ACDPSRV1
 ;***************************************************
EN(ACDPARM1,ACDPARM2) ;EP
 ;ACDPARM1 = unix file or mail server message #
 ;ACDPARM2 = header values
 ;
 S Y=$P(ACDPARM2(4),U) S ACDRNG=$$DD^ACDFUNC(Y),Y=$P(ACDPARM2(4),U,2) S ACDRNG="DATA RANGE : "_ACDRNG_" 'through' "_$$DD^ACDFUNC(Y)_"."
 S XMDUZ="CDMIS V4.0 PACKAGE"
 ;
 ;Set the actual message text
 ;ACDOWN exists if a facility tries to import its own extract (areas)
 ;or the incoming data is a suspected duplicate.
 ;
 S ACDMSG(1,0)="CDMIS FILE : "_ACDPARM1_$S($D(ACDOWN):" has been STOPPED",1:"")
 ;
 ;^ACDP1TMP will exists if I detect that the destination machine
 ;receiving imports has a location file corruption."
 I $D(^ACDP1TMP) S ACDMSG(1,0)="CDMIS FILE: "_ACDPARM1_" has been STOPPED"
 ;
 S ACDMSG(2,0)="DATA ORIGIN:"_ACDPARM2(2)
 S ACDMSG(3,0)=ACDRNG
 S ACDMSG(4,0)=" "
 S ACDMSG(5,0)="This message is a AUDIT TRAIL. Do *NOT* DELETE this message."
 S ACDMSG(6,0)="Save this message to a basket other than 'IN' for long term storage."
 S XMTEXT="ACDMSG("
 ;
 ;
 S XMSUB="DATA TRANSFER COMPLETE"
 I $D(ACDOWN) S XMSUB="AREAS OWN DATA/OR DUPE DATA (IMPORT FAILED)"
 I $D(^ACDP1TMP) S XMSUB="LOCATION FILE CORRUPTION (IMPORT FAILED)"
 ;
 ;User has bumped the server with a goose message. (lets get the user)
 I $D(ACDGOOSE) S ACDMSG(7,0)="",ACDMSG(8,0)="WARNING...SERVER INTRUSION. * CONTACT SITE MANAGER IMMEDIATLY."
 ;
 ;Send audit message to holder of a key (postmaster by default)
 K XMY S XMY(.5)="" I $D(^XUSEC("ACDZ SUPER8")) F ACDDUZ=0:0 S ACDDUZ=$O(^XUSEC("ACDZ SUPER8",ACDDUZ)) Q:'ACDDUZ  S XMY(ACDDUZ)=""
 ;
 D ^XMD
 W !,"Mail message audit created.....",*7,!!
 Q
K ;
