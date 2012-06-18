APCLOCCK ; IHS/CMI/LAB - Extrinsic Functions to check visit location ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;----->  The user is given a chance to select locations.  If they
 ;        select one of the three methods to select a location, but
 ;        fail in their attempt, they are returned to the MAIN prompt
 ;        based on the APCLFLAG variable, and given a second chance.
 ;
 ;----->  Only failure to respond to the MAIN prompt will result in 
 ;        a returned value of -1.
 ;
GETLOC(APCLOCCK) ;EP - Entry point of extrinsic function
 ;
 ;----->  Return a -1 if the user does not select a facility
 ;----->  Return a 0 if the user wants all facilities
 ;----->  Return a string if the user selects one or more facilities
 ;
 ;        LocationIEN1_U_LocationIEN2_U_LocationIEN3 etc.
 ;
MAIN ;
 S APCLOCCK=""
 W !!,"You may include visits from all facilities, from one of more facilities"
 W !,"selected individually, from all facilities within a Service Unit, or from"
 W !,"a pre-defined Taxonomy (Search Template) of facilities"
 K DIR
 S DIR(0)="SM^1:All;2:Individually;3:For a Service Unit;4:From a Taxonomy"
 S DIR("A")="Do you want to select"
 S DIR("?")="If you select from a taxonomy, you must have already created one.  If you select individually, you will be prompted for one or more entries."
 D ^DIR
 I $D(DIRUT) S APCLOCCK=-1 G EXIT
 S APCLFLAG=0
 I Y=1 D ALL
 I Y=2 D INDIV
 I Y=3 D SERVUNIT
 I Y=4 D TAXONOMY
 I APCLFLAG=0 G MAIN
 ;
EXIT ;
 K DIC,DIR,DIE,DR
 K APCLFLAG
 Q APCLOCCK
 ;
ALL ;----->  Get all facilities
 S APCLFLAG=1
 S APCLLOC=""
 Q
 ;
INDIV ;----->  Get one of more facilities individually
 S APCLOCCK=""
 W !
 K DIC,DIE,DR
 S DIC="^AUTTLOC(",DIC(0)="AEQMZ"
 F  D  Q:X=""  Q:X["^"
 .D ^DIC
 .I X="" Q
 .I X["^" Q
 .I Y'>0 Q
 .W !
 .S:APCLOCCK]"" APCLOCCK=APCLOCCK_U
 .S APCLOCCK=APCLOCCK_+Y
 .;I $L(APCLOCCK)>230 W !,"Maximum entries reached" S X="" Q
 .S APCLFLAG=2
 K DIC,DIE,DR
 Q
 ;
SERVUNIT ;----->  Get all facilities within a service unit
 S APCLOCCK=""
 W !
 K DIC,DIE,DR
 S DIC="^AUTTSU(",DIC(0)="AEQMZ"
 D ^DIC
 K DIC,DIE,DR
 I Y'>0 Q
 ;
 S X=$P(^AUTTSU(+Y,0),U,4)  ;ASU Index
 S N=X_"00"  ;Set beginning of ASUFAC Index range
 S X=X_"99"  ;Set end of ASUFAC Index range
 F  S N=$O(^AUTTLOC("C",N)) Q:N>X  Q:N=""  D  Q:X=""
 .S:APCLOCCK]"" APCLOCCK=APCLOCCK_U
 .S APCLOCCK=APCLOCCK_$O(^AUTTLOC("C",N,0))
 .;I $L(APCLOCCK)>230 W !,"Maximum entries reached" S N="" Q
 .S APCLFLAG=3
 Q
 ;
TAXONOMY ;----->  Get all facilties within a taxonomy
 S APCLOCCK=""
 W !
 K DR,DIC,DIE
 S DIC("S")="I $P(^(0),U,15)=9999999.06"
 S DIC="^ATXAX(",DIC(0)="AEQMZ"
 S DIC("A")="Which Taxonomy do you want? "
 D ^DIC
 K DIC,DIE,DR
 I Y'>0 Q
 ;
 ;----->  Loop through entries in the taxonomy to populate APCLOCCK
 S N=0
 F  S N=$O(^ATXAX(+Y,21,N)) Q:'N  D
 .;I $L(APCLOCCK)>230 W !,"Maximum entries reached" S N=999999 Q
 .S Z=$P(^ATXAX(+Y,21,N,0),U)
 .I APCLOCCK]"" S APCLOCCK=APCLOCCK_U
 .S APCLOCCK=APCLOCCK_Z
 W !!,"Taxonomy Entries added!",!
 S APCLFLAG=4
 Q
 ;----->  Check if template is from Location or Institution file
 I $P(^DIBT(+Y,0),U,4)?.A1"4" S APCLFLAG=4
 I $P(^DIBT(+Y,0),U,4)?.A1"9999999.06" S APCLFLAG=4
 ;
 ;----->  If template does not point to correct file, check to see
 ;----->  if the .01 field from the file associated with that template
 ;----->  points to the correct file.
 I APCLFLAG=0 D
 .W !!,"The template you selected was not created from the Location file!!"
 .W !!,"I am now checking to see if the file associated with this template"
 .W !,"points to the Location file."
 .S X=$P(^DIBT(+Y,0),U,4)
 .I '+X F  S X=$E(X,2,99) Q:+X  Q:X=""
 .I X="" Q
 .S X=$P(^DD(+X,.01,0),U,2)
 .I '+X F  S X=$E(X,2,99) Q:X=""  Q:+X
 .I +X?1"9999999.06" W "  YES IT DOES!" S APCLFLAG=4
 .I +X?1"4" W "  YES IT DOES!" S APCLFLAG=4
 ;
 ;----->  Taxonomy doesn't point to the Location or Institution file
 I APCLFLAG=0 D  Q
 .W "   NOPE!"
 .W !!,"SORRY!  I'm not smart enough to do anything with THIS template!!"
 ;
 Q
 ;
 ;
CHKLOC(APCLOCCK,APCLDUZ2)   ;EP ----->  Entry point for extrinsic function
 ;
 ;----->  Return a 1 if the facility is in the list
 ;----->  Return a 0 if the facility is not in the list
 ;----->  Return a 1 if the list equals 0 (all facilities)
 ;
 I $G(APCLOCCK)="" Q 1
 I $G(APCLDUZ2)="" Q 0
 I APCLOCCK=0 Q 1
 S APCLOCCK=U_APCLOCCK_U
 S APCLDUZ2=U_APCLDUZ2_U
 I APCLOCCK[APCLDUZ2 Q 1
 Q 0
