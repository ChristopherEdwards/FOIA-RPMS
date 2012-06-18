ACD4P1P ;IHS/ADC/EDE/KML - POST-INIT CONVERSIONS FOR V4.1; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
START ;
 W !!,"Beginning the post-init routine ",$T(+0)
 W !!,"Installing Protocols..." D ^ACDONIT
 W !!,"Installing List templates..." D ^ACDL
 I $D(^TMP("ACD",$J,"VIRGIN INSTALL")) W !!,"Virgin install so post-init not necessary.",! K ^TMP("ACD",$J) Q
 I '$G(DUZ)!($G(DUZ(0))'["@") W !!,"Either DUZ is not set or you do not have programmer access.  I don't",!,"know how you got here but I cannot run this post-int routine.",!! Q
 D PGMFIX ;                      kill most program data
 D VXREFS ;                      kill CDMIS VISIT xrefs
 D SERVICE ;                     convert CDMIS SERVICE file
 D LOCATION ;                    convert CDMIS LOCATION file
 D COMPONEN ;                    convert CDMIS COMPONENT file
 D REPOINT ;                     repoint data files
 D TOBACCO ;                     fix tobacco debacle
 D PROBS ;                       delete problems
 D FILE200 ;                     convert file 6 ptrs to file 200 ptrs
 D GBLKILL ;                     kill file gbls to be restored
 D EOJ
 Q
 ;
PGMFIX ; DELETE PROGRAM DATA
 S ACDPGM=0
 F  S ACDPGM=$O(^ACDF5PI(ACDPGM)) Q:'ACDPGM  D
 .  S ACDN11=$G(^ACDF5PI(ACDPGM,11))
 .  S DIK="^ACDF5PI(",DA=ACDPGM
 .  D DIK^ACDFMC
 .  S DIC="^ACDF5PI(",X="`"_ACDPGM,DIC(0)="LQ",DLAYGO=9002173
 .  D DIC^ACDFMC
 .  Q:ACDN11=""
 .  S ^ACDF5PI(ACDPGM,11)=ACDN11
 .  Q
 Q
 ;
VXREFS ; KILL CDMIS VISIT XREFS
 K ^ACDVIS("E")
 K ^ACDVIS("F")
 K ^ACDVIS("G")
 K ^ACDVIS("H")
 Q
 ;
SERVICE ; DELETE CDMIS SERVICE TP AND TPR
 W !!,"Now converting your CDMIS SERVICE file."
 S ACDSIEN("TP")=$O(^ACDSERV("C","TP",0))
 I ACDSIEN("TP") S DIK="^ACDSERV(",DA=ACDSIEN("TP") D DIK^ACDFMC W "."
 S ACDSIEN("TPR")=$O(^ACDSERV("C","TPR",0))
 I ACDSIEN("TPR") S DIK="^ACDSERV(",DA=ACDSIEN("TPR") D DIK^ACDFMC W "."
 S ACDSIEN("OTH")=$O(^ACDSERV("C","OTH",0))
 Q
 ;
LOCATION ; DELETE CDMIS LOCATION SCHOOL-*
 W !!,"Now converting your CDMIS LOCATION file."
 ; school-pre-headstart
 S ACDLIEN("11")=$O(^ACDLOT("C","11",0))
 I ACDLIEN("11") S DIK="^ACDLOT(",DA=ACDLIEN("11") D DIK^ACDFMC W "."
 ; school-primary
 S ACDLIEN("12")=$O(^ACDLOT("C","12",0))
 I ACDLIEN("12") S DIK="^ACDLOT(",DA=ACDLIEN("12") D DIK^ACDFMC W "."
 ; school-secondary
 S ACDLIEN("13")=$O(^ACDLOT("C","13",0))
 I ACDLIEN("13") S DIK="^ACDLOT(",DA=ACDLIEN("13") D DIK^ACDFMC W "."
 ; school-post secondary
 S ACDLIEN("14")=$O(^ACDLOT("C","14",0))
 I ACDLIEN("14") S DIK="^ACDLOT(",DA=ACDLIEN("14") D DIK^ACDFMC W "."
 ; school
 S ACDLIEN("1")=$O(^ACDLOT("C","1",0))
 Q
 ;
COMPONEN ; DELETE CDMIS COMPONENETS LARGE, SMALL, & SPECL DROP IN
 W !!,"Now converting your CDMIS COMPONENT file."
 S ACDCIEN("LARGE DROP IN")=$O(^ACDCOMP("B","LARGE DROP IN",0))
 I ACDCIEN("LARGE DROP IN") S DIK="^ACDCOMP(",DA=ACDCIEN("LARGE DROP IN") D DIK^ACDFMC W "."
 S ACDCIEN("SMALL DROP IN")=$O(^ACDCOMP("B","SMALL DROP IN",0))
 I ACDCIEN("SMALL DROP IN") S DIK="^ACDCOMP(",DA=ACDCIEN("SMALL DROP IN") D DIK^ACDFMC W "."
 S ACDCIEN("SPECL DROP IN")=$O(^ACDCOMP("B","SPECL DROP IN",0))
 I ACDCIEN("SPECL DROP IN") S DIK="^ACDCOMP(",DA=ACDCIEN("SPECL DROP IN") D DIK^ACDFMC W "."
 S ACDCIEN("DROP IN CENTER")=$O(^ACDCOMP("B","DROP IN CENTER",0))
 Q
 ;
REPOINT ; REPOINT DATA FILES
 W !!,"Now repointing files that point to the CDMIS COMPONENT file."
 S ACDGBL="^ACDIIF(",ACDFP="15;16,17;18,101;21"
 D REPOINT2 ;                   repoint init/info/fu
 S ACDGBL="^ACDPD(",ACDFP="1;2"
 D REPOINT2 ;                   repoint prevention
 S ACDGBL="^ACDTDC(",ACDFP="12;13,14;15"
 D REPOINT2 ;                   repoint trans/disc/close
 S ACDGBL="^ACDVIS(",ACDFP="1;2"
 D REPOINT2 ;                   repoint visit
 S ACDGBL="^ACDPAT(",ACDFP=".03;3"
 D REPOINT2 ;                   repoint client category
 S ACDGBL="^ACDINTV(",ACDFP="10;10,11;11"
 D REPOINT2 ;                   repoint interventions
 W !!,"Now repointing files that point to the CDMIS SERVICE file."
 S ACDRIEN=0
 F  S ACDRIEN=$O(^ACDCS(ACDRIEN)) Q:ACDRIEN'=+ACDRIEN  S X=$G(^ACDCS(ACDRIEN,0)),X=$P(X,U,3) D  D:ACDHIT REPCS
 . S ACDHIT=0
 . I X=ACDLIEN("11") S ACDHIT=1 Q
 . I X=ACDLIEN("12") S ACDHIT=1 Q
 . I X=ACDLIEN("13") S ACDHIT=1 Q
 . I X=ACDLIEN("14") S ACDHIT=1 Q
 . Q
 Q
 ;
REPOINT2 ; REPOINT SPECIFIC FILE
 S ACDRIEN=0
 F  S ACDRIEN=$O(@(ACDGBL_ACDRIEN_")")) Q:ACDRIEN'=+ACDRIEN  S ACDNODE0=$G(^(ACDRIEN,0)) D
 .  Q:ACDNODE0=""
 .  F ACDY=1:1 S X=$P(ACDFP,",",ACDY) Q:X=""  D
 ..  S F=$P(X,";"),P=$P(X,";",2)
 ..  S X=$P(ACDNODE0,U,P) D  D:ACDHIT REPF
 ...  S ACDHIT=0
 ...  I X=ACDCIEN("LARGE DROP IN") S ACDHIT=1 Q
 ...  I X=ACDCIEN("SMALL DROP IN") S ACDHIT=1 Q
 ...  I X=ACDCIEN("SPECL DROP IN") S ACDHIT=1 Q
 ...  Q
 ..  Q
 .  Q
 K F,P
 Q
 ;
REPF ; REPOINT FIELD
 S DIE=ACDGBL,DA=ACDRIEN,DR=F_"////"_ACDCIEN("DROP IN CENTER")
 D DIE^ACDFMC
 W "."
 Q
 ;
REPCS ; REPOINT CDMIS CLIENT SVCS
 S DIE="^ACDCS(",DA=ACDRIEN,DR="2////"_ACDLIEN("1")
 D DIE^ACDFMC
 W "."
 Q
 ;
TOBACCO ; DELETE TOBACCO FROM DRUGS USED AND SET NEW FIELD
 W !!,"Now converting tobacco use to new field."
 S ACDTOB1=$O(^ACDDRUG("B","TOBACCO (SMOKING)",0))
 S ACDTOB2=$O(^ACDDRUG("B","TOBACCO (SMOKELESS)",0))
 I 'ACDTOB1!('ACDTOB2) W !!,"Cannot locate TOBACCO entries in CDMIS DRUG file.  No conversion necessary.",! Q
 S ACDGBL="^ACDIIF("
 D TOBACCO2 ;                       fix init/info/fu
 S ACDGBL="^ACDTDC("
 D TOBACCO2 ;                       fix trans/disc/close
 F Y=ACDTOB1,ACDTOB2 S DIK="^ACDDRUG(",DA=Y D ^DIK
 Q
 ;
TOBACCO2 ; FIX ONE FILE
 S ACDRIEN=0
 F  S ACDRIEN=$O(@(ACDGBL_ACDRIEN_")")) Q:ACDRIEN'=+ACDRIEN  S ACDNODE0=$G(^(ACDRIEN,0)) D
 .  Q:ACDNODE0=""
 .  K ACDTOB
 .  S ACDMIEN=0
 .  ; drug multiple
 .  F  S ACDMIEN=$O(@(ACDGBL_ACDRIEN_",2,"_ACDMIEN_")")) Q:ACDMIEN'=+ACDMIEN  S X=+^(ACDMIEN,0)  D
 ..  I X'=ACDTOB1,X'=ACDTOB2 Q  ;     quit if not tobacco
 ..  S ACDTOB(X)=""  ;                save type of tobacco
 ..  S DIK=ACDGBL_ACDRIEN_",2,",DA(1)=ACDRIEN,DA=ACDMIEN D ^DIK
 ..  Q
 .  Q:'$D(ACDTOB)  ;                  no tobacco use for entry
 .  S Y=$O(ACDTOB(0)) ;               get type used
 .  S ACDTOB=$S(Y=ACDTOB1:1,1:2)
 .  S X=0
 .  F Y=ACDTOB1,ACDTOB2 S X=X+$D(ACDTOB(Y))
 .  S:X>1 ACDTOB=3 ;                  uses both kinds
 .  S DIE=ACDGBL,DA=ACDRIEN,DR="30////"_ACDTOB
 .  D DIE^ACDFMC
 .  W "."
 .  Q
 Q
 ;
PROBS ; DELETE SELECTED PROBLEMS FROM APPROPRIATE FILES
 W !!,"Now converting CDMIS PROBLEM file."
 S ACDPIEN=$O(^ACDPROB("C",51,0))
 I 'ACDPIEN W !!,"Cannot find PREVIOUS TREATMENT in CDMIS PROBLEM file.  No conversion necessary.",! Q
 S ACDGBL="^ACDIIF(",ACDNODE=3
 D PROBSDEL ;                       fix init/info/fu
 S ACDGBL="^ACDTDC(",ACDNODE=3
 D PROBSDEL ;                       fix trans/disc/close
 S ACDGBL="^ACDINTV(",ACDNODE=1
 D PROBSDEL ;                       fix interventions
 S DIK="^ACDPROB(",DA=ACDPIEN D ^DIK
 Q
 ;
PROBSDEL ; DELETE ENTRIES FROM FILE
 S ACDRIEN=0
 F  S ACDRIEN=$O(@(ACDGBL_ACDRIEN_")")) Q:ACDRIEN'=+ACDRIEN  D
 .  S ACDMIEN=0
 .  F  S ACDMIEN=$O(@(ACDGBL_ACDRIEN_","_ACDNODE_","_ACDMIEN_")")) Q:ACDMIEN'=+ACDMIEN  S Y=+^(ACDMIEN,0) D
 ..  Q:Y'=ACDPIEN  ;                   not previous treatment
 ..  S DIK=ACDGBL_ACDRIEN_","_ACDNODE_",",DA(1)=ACDRIEN,DA=ACDMIEN D ^DIK
 ..  Q
 .  Q
 Q
 ;
GBLKILL ; KILL GBLS TO BE RESTORED, INFORM OPERATOR
 W !!,"Selected file globals will now be killed.  You must now",!
 W "restore the globals from acd_0410.g",!!
 K ^ACDDRUG,^ACDLOT,^ACDSERV,^ACDPROB ; SAC EXEMPTION (2.3.2.3 Killing of unsubscripted globals is prohibited)
 Q
 ;
EOJ ;
 K ACDCIEN,ACDLIEN,ACDSIEN,ACDNODE,ACDPIEN,ACDRIEN,ACDY
 K ACDFP,ACDGBL,ACDHIT,ACDMIEN,ACDN11,ACDNODE0,ACDPGM,ACDTOB1,ACDTOB2
 Q
 ;
 ;
FILE200 ; CONVERT FILE 6 POINTERS TO FILE 200 POINTERS
 D ^ACD4P1PB
 Q
