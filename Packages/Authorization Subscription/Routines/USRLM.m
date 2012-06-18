USRLM ; SLC/JER - User Class Membership functions and proc's ; Jan 1, 2004
 ;;1.0;AUTHORIZATION/SUBSCRIPTION;**2,3,6,7,8,13,16,25**;Jun 20, 1997
 ; 15 Dec 99 MA - Modified entry point TERM
 ; 14 Feb 00 MA - Add check to verify that x-ref AUC has valid 0 node.
 ; 27 Jun 00 MA - Changed WHOIS to build array in alphabetical order
 ;                by subscriber name.
ISA(USER,CLASS,ERR,USRDT) ; Boolean - Is USER a Member of CLASS?
 N USRY,USRI
 I $S(CLASS="USER":1,CLASS=+$O(^USR(8930,"B","USER",0)):1,1:0) S USRY=1 G ISAX
 I '+USER S USER=+$O(^VA(200,"B",USER,0))
 I +USER'>0 S ERR="INVALID USER" Q 0
 I '+CLASS S CLASS=+$O(^USR(8930,"B",CLASS,0))
 I +CLASS'>0 S ERR="INVALID USER CLASS" Q 0
 ; If USER is a member of CLASS return true
 S USRY=0
 I +$D(^USR(8930.3,"AUC",USER,CLASS)) D
 . N USRMDA
 . S USRMDA=0
 . F  S USRMDA=+$O(^USR(8930.3,"AUC",USER,CLASS,USRMDA)) Q:((+USRMDA'>0)!(USRY))  D
 .. S USRY=+$$CURRENT(USRMDA,$G(USRDT))
 I USRY Q USRY
 ; Otherwise, check to see if user is a member of any subclass of CLASS
 S USRI=0
 F  S USRI=$O(^USR(8930,+CLASS,1,USRI)) Q:+USRI'>0!+$G(USRY)  D
 . N USRSUB S USRSUB=+$G(^USR(8930,+CLASS,1,USRI,0)) Q:+USRSUB'>0
 . S USRY=$$ISA(USER,USRSUB,,+$G(USRDT)) ; Recurs to find members of subclass
ISAX Q +$G(USRY)
 ;======================================================================
ISAWM(USER,CLASS) ; Boolean - Is USER a Member of CLASS, with message.
 I $$ISA(USER,CLASS) D  Q 1
 . W !,"Already a member of this class"
 . H 2
 E  Q 0
 ;
 ;======================================================================
CURRENT(MEMBER,USRDT) ; Boolean - Is Membership current?
 N USRIN,USROUT,USRY
 I +$G(USRDT)'>0 S USRDT=DT
 S USRIN=+$P($G(^USR(8930.3,+MEMBER,0)),U,3)
 S USROUT=+$P($G(^USR(8930.3,+MEMBER,0)),U,4)
 I USRIN'>USRDT,$S(USROUT>0&(USROUT'<USRDT):1,USROUT=0:1,1:0) S USRY=1
 E  S USRY=0
 Q USRY
 ;
 ;======================================================================
ISTERM(USER) ;Return true if USER has a termination date and that date
 ;is less than the current date and time. The read is covered by
 ;DBIA 10060
 N TERM,TERMDATE
 S TERM=0
 I '$D(^VA(200,+USER,0)) D
 . S TERMDATE=0
 . W !,"Warning bad data DUZ=",+USER," found in file 8930.3 but does not exist in file 200!"
 . H 3
 E  S TERMDATE=+$P(^VA(200,+USER,0),U,11)
 I (TERMDATE>0) D
 . I TERMDATE<$$NOW^XLFDT S TERM=1
 Q TERM
 ;
 ;======================================================================
RESIZE(LONG,SHORT,SHRINK) ; Resizes list area
 N USRBM S USRBM=$S(VALMMENU:SHORT,+$G(SHRINK):SHORT,1:LONG)
 I VALM("BM")'=USRBM S VALMBCK="R" D
 . S VALM("BM")=USRBM,VALM("LINES")=(USRBM-VALM("TM"))+1
 . I +$G(VALMCC) D RESET^VALM4
 Q
 ;======================================================================
TERM ;Actions to be taken when a user is terminated. Invoked by
 ;XU USER TERMINATE. XUIFN is the user being terminated.
 ;15 DEC 99 MA - Replaced $$NOW^XLFDT with DT.  Piece 4 does
 ;not need the time.  Piece 4 is date only.
 N IND,OLDTERM,NOW
 S NOW=DT
 S IND=""
 F  S IND=$O(^USR(8930.3,"B",XUIFN,IND)) Q:IND=""  D
 . S OLDTERM=+$P($G(^USR(8930.3,IND,0)),U,4)
 . I (OLDTERM>0)&(OLDTERM<NOW) Q
 . S $P(^USR(8930.3,IND,0),U,4)=NOW
 Q
 ;
 ;======================================================================
WHOIS(MEMBER,CLASS) ; Given a Class, return list of CURRENT members
 ; CLASS is pointer to file 8930
 ; MEMBER is name of array (local or global) in which members are
 ;        returned in alphabetical order by name
 N USER,USRCLNM,USRCNT,USRDA,EFFCTV,EXPIRES,USRI,USRNAME
 S USER=0,USRCNT=+$P($G(@MEMBER@(0)),U,3)
 F  S USER=$O(^USR(8930.3,"ACU",CLASS,USER)) Q:+USER'>0  D
 . S USRDA=$O(^USR(8930.3,"ACU",CLASS,USER,0)) Q:+USRDA'>0
 . S EFFCTV=$P($G(^USR(8930.3,+USRDA,0)),U,3)
 . S EXPIRES=$P($G(^USR(8930.3,+USRDA,0)),U,4)
 . S USRCLNM=$$CLNAME(+CLASS)
 . S USRNAME=$$GET1^DIQ(200,USER,.01)
 . S @MEMBER@(USRNAME)=USER_U_USRDA_U_USRCLNM_U_EFFCTV_U_EXPIRES
 . S USRCNT=+$G(USRCNT)+1
 I '$D(@MEMBER@(0)) S @MEMBER@(0)=CLASS_U_$P($G(^USR(8930,+CLASS,0)),U)_U
 S $P(@MEMBER@(0),U,3)=USRCNT
 S USRI=0 F  S USRI=$O(^USR(8930,+CLASS,1,USRI)) Q:+USRI'>0  D
 . N USRSUB S USRSUB=+$G(^USR(8930,+CLASS,1,USRI,0)) Q:+USRSUB'>0
 . D WHOIS(MEMBER,USRSUB) ; Recurs to find members of subclass
 Q
WHOIS2(MEMBER,CLASS) ; Given a Class, return list of CURRENT members
 ; CLASS is pointer to file 8930
 ; MEMBER is name of array (local or global) in which members are
 ;        returned in alphabetical order by name - indexed by number
 ;       i.e. @MEMBER@(1 ...n)
 ;  @member@(0) = ien of8930^usr class name^count of members
 ;  @member@(1..n)=
 ;    1    2        3          4         5        6       7      8
 ;  p200^p8930.3^classname^effectdate^inactdate^username^title^mailcode
 ;  Note: For pieces 2,4 & 5 - Only one of potentially many is returned
 ;
 N USER,USRNM,USRCLNM,USRCNT,USRDA,USRNDX,EFFCTV,EXPIRES,USRI
 D WHOISTMP(.CLASS)
 S USRNM="",USRNDX=0
 F  S USRNM=$O(^TMP($J,"USRWHO2","B",USRNM)) Q:USRNM']""  D
 . S USER=0 F  S USER=$O(^TMP($J,"USRWHO2","B",USRNM,USER)) Q:'USER  D
 . . S USRNDX=USRNDX+1
 . . S @MEMBER@(USRNDX)=^TMP($J,"USRWHO2",USER)
 S @MEMBER@(0)=^TMP($J,"USRWHO2",0)
 S $P(@MEMBER@(0),U,3)=USRNDX
 K ^TMP($J,"USRWHO2")
 Q
WHOISTMP(CLASS) ; Given a Class, return list of CURRENT members into ^TMP
 ; CLASS is pointer to file 8930
 ; MEMBER is name of array (local or global) in which members are
 ;        returned in order by user/x-ref by name
 ;        main = ^tmp($j,"USRWHO2",user)
 ;        x-ref= ^tmp($j,"USRWHO2","b",usrnm,user)
 ;  -- used by whois2 call
 N USER,USRNM,USRCLNM,USRCNT,USRDA,EFFCTV,EXPIRES,USRI,USRMC,USRTIT,USRX
 S USER=0,USRCNT=+$P($G(@MEMBER@(0)),U,3)
 F  S USER=$O(^USR(8930.3,"ACU",CLASS,USER)) Q:+USER'>0  D
 . S USRDA=$O(^USR(8930.3,"ACU",CLASS,USER,0)) Q:+USRDA'>0
 . S EFFCTV=$P($G(^USR(8930.3,+USRDA,0)),U,3)
 . S EXPIRES=$P($G(^USR(8930.3,+USRDA,0)),U,4)
 . S USRNM=$P($G(^VA(200,+USER,0)),U)
 . S USRX=$P($G(^VA(200,+USER,0)),U,9)
 . S USRTIT=$$EXTERNAL^DILFD(200,8,"",USRX)
 . S USRMC=$P($G(^VA(200,+USER,5)),U,2)
 . S USRCLNM=$$CLNAME(+CLASS)
 . S ^TMP($J,"USRWHO2",USER)=USER_U_USRDA_U_USRCLNM_U_EFFCTV_U_EXPIRES_U_USRNM_U_USRTIT_U_USRMC
 . S ^TMP($J,"USRWHO2","B",USRNM,USER)=""
 . S USRCNT=+$G(USRCNT)+1
 I '$D(^TMP($J,"USRWHO2",0))#2 S ^TMP($J,"USRWHO2",0)=CLASS_U_$P($G(^USR(8930,+CLASS,0)),U)_U
 S $P(^TMP($J,"USRWHO2",0),U,3)=USRCNT
 S USRI=0 F  S USRI=$O(^USR(8930,+CLASS,1,USRI)) Q:+USRI'>0  D
 . N USRSUB S USRSUB=+$G(^USR(8930,+CLASS,1,USRI,0)) Q:+USRSUB'>0
 . D WHOISTMP(USRSUB) ; Recurs to find members of subclass
 Q
WHATIS(USER,CLASS) ; Given a User, return list of class memberships
 ; USER is pointer to file 200
 ; CLASS is name of array (local or global) in which the list of
 ;       classes to which the USER belongs will be returned in
 ;       alphabetic order by class name
 N IND,GROUP,CLASSNM,CLASSCNT,USRDA,EFFCTV,EXPIRES
 S (CLASSCNT,IND,GROUP)=0
 F  S GROUP=$O(^USR(8930.3,"AUC",USER,GROUP)) Q:+GROUP'>0  D
 . S USRDA=0
 . F  S USRDA=$O(^USR(8930.3,"AUC",USER,GROUP,USRDA)) Q:+USRDA'>0  D
 .. S EFFCTV=$P($G(^USR(8930.3,+USRDA,0)),U,3)
 .. S EXPIRES=$P($G(^USR(8930.3,+USRDA,0)),U,4)
 .. S CLASSNM=$$CLNAME(+GROUP)
 .. S IND=IND+1
 .. S @CLASS@(CLASSNM_IND)=GROUP_U_USRDA_U_CLASSNM_U_EFFCTV_U_EXPIRES
 .. S CLASSCNT=+$G(CLASSCNT)+1
 S @CLASS@(0)=USER_U_$$SIGNAME^USRLS(+USER)_U_CLASSCNT
 Q
CLNAME(CLASS) ; Given a class, return the Display Name
 N USRREC,USRY
 S USRREC=$G(^USR(8930,+CLASS,0))
 Q $S($P(USRREC,U,4)]"":$P(USRREC,U,4),1:$$MIXED^USRLS($P(USRREC,U)))
PUT(USER,CLASS) ; Make user a member of a given class
 N DIC,DLAYGO,DA,DR,DIE,X,Y
 S (DIC,DLAYGO)=8930.3,DIC(0)="LXF",X=""""_"`"_USER_"""" D ^DIC Q:+Y'>0
 S DIE=DIC,DA=+Y,DR=".02///"_CLASS_";.03///"_DT
 D ^DIE
 Q
SUBCLASS(DA,CLASS) ; Evaluate whether a given USER CLASS is a DESCENDENT
 ;                 of another class
 ; Receives DA = record # of possible subclass in 8930, and
 ;       CLASS = record # of possible descendent class in 8930
 N USRI,USRY S (USRI,USRY)=0
 I +$G(DA)'>0 S DA=+$O(^USR(8930,"B",DA,0))
 I +$G(CLASS)'>0 S CLASS=+$O(^USR(8930,"B",CLASS,0))
 F  S USRI=$O(^USR(8930,"AD",DA,USRI)) Q:+USRI'>0!(USRY=1)  D
 . I USRI=CLASS S USRY=1 Q
 . S USRY=$$SUBCLASS(USRI,CLASS)
 Q USRY
CANDEL(USRCLDA) ; Evaluate whether user can delete a class
 N USRMLST,USRY S USRY=0
 D WHOIS("USRMLST",USRCLDA)
 I +$P(USRMLST(0),U,3)>0 S USRY=1 W "  There are members of the class ",$$CLNAME(USRCLDA)
 Q USRY
