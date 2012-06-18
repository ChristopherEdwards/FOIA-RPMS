ACHSBUG3 ; IHS/ITSC/PMF - EDIT MISSING AUTHORIZATION DATES ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; - Check for missing 3-nodes and allow user to edit info.
 ;
 ; - A recurring bug deletes the 3-nodes, where the Beginning and
 ;   Ending Authorization dates are kept.  Current and previous
 ;   developers have attempted to squash the bug, with no success.
 ;
 N ACHSDUZ2,ACHSERR,ACHSFLAG,ACHSMIS3,ACHSVIEW,D,L
 ;
 S ACHSVIEW=1,ACHSDUZ2=DUZ(2),(ACHSMIS3,L)=0
 D HELP("HELPC3")
 ;
LOOP ;
 S ACHSFLAG=$$DIR^XBDIR("SO^S:Search;D:Select an Individual Document","","","","^D HELP^ACHSBUG3(""HELPC3"")",2)
 I ACHSFLAG="D" D SEL G LOOP
 I ACHSFLAG="S" D SEARCH G LOOP
 D EOJ
 Q
 ;
SEARCH ;
 F  S L=$O(^ACHSF("B",L)) Q:'L!$D(DUOUT)!$D(DTOUT)  S D=0 F  S D=$O(^ACHSF(L,"D",D)) Q:'D!$D(DUOUT)!$D(DTOUT)  W "." I '$D(^(D,3)) S ACHSMIS3=ACHSMIS3+1 D
 . I '$$SETENVRN(L) D DISPLAY(L,D),EDIT(L,D)
 ;
 Q
 ;
EOJ ;
 W !,ACHSMIS3," documents processed."
 N ACHSDOIT
 S ACHSDOIT="S"_" DU"_"Z(2)="_ACHSDUZ2
 X ACHSDOIT
 D ^ACHSUF
 I $$DIR^XBDIR("E","Press RETURN...")
 Q
 ;
SETENVRN(L) ;
 N ACHSDOIT
 S ACHSDOIT="S"_" DU"_"Z(2)="_L
 X ACHSDOIT
 K L
 N D
 D ^ACHSUF
 Q $G(ACHSERR)
 ;
DISPLAY(L,D) ;
 N ACHSDOIT
 S ACHSDOIT="S"_" DU"_"Z(2)="_L
 X ACHSDOIT
 ;
 S ACHSDIEN=D,ACHSTIEN=1
 K ACHSSIG,D,L
 D INIT^ACHSRP2,^ACHSAV
 S ACHSADJ=""
 D A0A^ACHSUSC
 K ACHSADJ
 Q
 ;
EDIT(L,D) ;
 N DA,DIE,DR
 S DIE="^ACHSF("_L_",""D"",",DA=D,DR="75;76"
 K D,L
 F  D ^DIE Q:'$$DIR^XBDIR("Y","Edit again","N","","If you missed something, do you want to edit again (Y/N)","",1)  D DISPLAY(+$P($P(DIE,"(",2),","),DA)
 Q
 ;
SEL ;
 D ^ACHSUD
 Q:'$D(ACHSDIEN)
 D DISPLAY(DUZ(2),ACHSDIEN)
 I $P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,3)),U,1) W !,*7,"AUTH BEGINNING DATE exists for this document." S X=$$DIR^XBDIR("E") Q:$D(DIRUT)  G SEL
 D EDIT(DUZ(2),ACHSDIEN)
 Q
 ;
HELPC3 ;EP
 ;;You have the option of [S]earching for PDO's with missing beginning
 ;;authorization dates, or selecting a particular [D]ocument.  In either
 ;;case, the document will be displayed, and you will be given the
 ;;opportunity to edit both the AUTH BEGINNING DATE and the AUTH ENDING
 ;;DATE.  The AUTH BEGINNING DATE field is required.  You can skip the
 ;;document by hatting out ("^").  You will be given the opportunity
 ;;of editing the dates, again, before proceeding to the next document.
 ;;###
 ;
HELP(L) ;EP - Display text at label L.  Probably called from DIR.
 W !
 F %=1:1 W !?4,$P($T(@L+%),";",3) Q:$P($T(@L+%+1),";",3)="###"
 Q
 ;
