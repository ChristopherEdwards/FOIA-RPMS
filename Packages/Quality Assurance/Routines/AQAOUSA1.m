AQAOUSA1 ; IHS/ORDC/LJF - PRINT ACCESS BY OCCURRENCE ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn print the listing of users with access to a particular
 ;occurrence.  It is called by ^AQAOUSA.
 ;
 D INIT^AQAOUTIL S AQAOTY="USERS WITH ACCESS TO AN OCCURRENCE"
 D HEADING^AQAOUTIL,HDG1
 ;
FIND ; >> find sorted user list
 I '$D(^TMP("AQAOUSA",$J)) W !!,"NO DATA FOUND",! Q
 S AQAOCAT=0
 F  S AQAOCAT=$O(^TMP("AQAOUSA",$J,AQAOCAT)) Q:AQAOCAT=""  Q:AQAOSTOP=U  D
 .S X=$S(AQAOCAT="A":"QI STAFF",AQAOCAT="M":"QI TEAM MEMBERS",AQAOCAT="R":"PERSONAL REFERRALS",1:"TEAM REFERRALS")
 .S X="*** "_X_" ***" W !!?AQAOIOMX-$L(X)/2,X,!! ;category title
 .S AQAOUSN=0
 .F  S AQAOUSN=$O(^TMP("AQAOUSA",$J,AQAOCAT,AQAOUSN)) Q:AQAOUSN=""  Q:AQAOSTOP=U  D
 ..S AQAOUSR=0
 ..F  S AQAOUSR=$O(^TMP("AQAOUSA",$J,AQAOCAT,AQAOUSN,AQAOUSR)) Q:AQAOUSR=""  Q:AQAOSTOP=U  D
 ...S AQAOS=^TMP("AQAOUSA",$J,AQAOCAT,AQAOUSN,AQAOUSR)
 ...I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1
 ...W AQAOUSN
 ...I AQAOCAT="A" W ?40,AQAOS,! Q  ;qi staff level
 ...I AQAOCAT="M" D  Q
 ....F I=1:2 Q:$P(AQAOS,U,I)=""  W ?40,"TEAM: ",$P(AQAOS,U,I),?60,$P(AQAOS,U,I+1),! I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1 ;teams & access
 ...;
 ...;PATCH 4 BEGIN
 ...I AQAOCAT="R" D  Q  ;referred by name
 ....F I=1:1 Q:$P(AQAOS,U,I)=""  Q:AQAOSTOP=U  D
 .....W ?40,"Referred By: ",$E($P(AQAOS,U,I),1,15),!
 .....I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1
 ...;
 ...F I=1:3 Q:$P(AQAOS,U,I)=""  Q:AQAOSTOP=U  D  ;referred by team
 ....W ?40,"Referred By: ",$E($P(AQAOS,U,I),1,15),!
 ....W ?40,"Referred To: ",$E($P(AQAOS,U,I+1),1,15)
 ....W ?60," - ",$P(AQAOS,U,I+2),!!
 ....I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1
 ...;PATCH 4 END
 ;
 Q  ;return to ^AQAOUSA
 ;
 ;
HDG1 ; >> SUBRTN to print 2nd half of heading
 S X=$P(^AQAOC(AQAOIFN,0),U),X="Occurrence #"_X
 W ?AQAOIOMX-$L(X)/2,X,!,AQAOLINE,!
 Q
