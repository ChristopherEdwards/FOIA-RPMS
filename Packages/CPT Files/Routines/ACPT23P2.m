ACPT23P2 ; CPT V2.03 patch 2 - 7/7/2003 2:05:48 PM [ 09/09/2003  10:03 AM ]
 ;;2.03;CPT FILES;**2**;DEC 19, 2002
 ;
 ; New routine - adds/edits/deletes to CPT file
 ; for 7/1/2003 released changes from AMA
 ;
START ; - EP
 D ADD
 D EDIT
 D DELETE
 D LINEUP
 Q
 ;
 ;;code^description
ADD ;add
 K DIC
 W !,"ADDING CODES"
 S DIC="^ICPT("
 S DIC(0)="LXO"
 S DLAYGO=81
 S X=99601
 W !,X
 D ^DIC  ;adds code
 ;
 I +Y>0 D
 .S DIE=DIC
 .S DA=99601
 .S DR="50///Home infusion/specialty drug administration, per visit (up to 2 hours)"
 .S DR=$G(DR)_";7///7/1/2003"
 .D ^DIE
 .;;
 .K DIC
 .S DIC="^ICPT(99601,60,"
 .S DA(1)=99601
 .S DIC(0)="L"
 .S DIC("P")=$P(^DD(81,60,0),"^",2)
 .S (DA,X)=3030701
 .S DIC("DR")=".02////1"
 .D ^DIC
 ;
 ;
 K DIC,X,DLAYGO,Y
 S DIC="^ICPT("
 S DIC(0)="LXO"
 S DLAYGO=81
 S X=99602
 W !,X
 D ^DIC
 ;
 I +Y>0 D
 .S DIE=DIC
 .S DA=99602
 .S DR="50///Each additional hour (List separately in addition to primary procedure)"
 .S DR=$G(DR)_";7///7/1/2003"
 .D ^DIE
 .K DIC
 .S DIC="^ICPT(99602,60,"
 .S DA(1)=99602
 .S DIC(0)="L"
 .S DIC("P")=$P(^DD(81,60,0),"^",2)
 .S (DA,X)=3030701
 .S DIC("DR")=".02////1"
 .D ^DIC
 Q
 ;
EDIT ;edit
 W !,"EDITING CODES"
 S DA(1)=$O(^ICPT("B",99050,""))
 S DIE="^ICPT("_DA(1)_",""D"","
 S DA=1
 S DR=".01///Services requested after posted office hours in addition to basic service"
 W !,DA(1)
 D ^DIE
 Q
 ;
DELETE ;delete
 W !,"DELETING CODES"
 S DIE="^ICPT("
 F ACPTCD=99551,99552,99553,99554,99555,99556,99557,99558,99559,99560,99561,99562,99563,99564,99565,99566,99567,99568,99569 D
 . S ACPTCDE=$O(^ICPT("B",ACPTCD,""))
 . S DA=ACPTCDE
 . W !,DA
 . S DR="8///7/1/2003;5////1"  ;Date deleted/inactive flag
 . D ^DIE
 . ;
 . S DA(1)=DA
 . S DIC="^ICPT("_DA(1)_",60,"
 . S DIC(0)="L"
 . S DIC("P")=$P(^DD(81,60,0),"^",2)
 . S (DA,X)=3030701
 . S DIC("DR")=".02///0"
 . D ^DIC
 Q
LINEUP ;  Make sure effective date multiple and active/inactive stuff are the same
 S ACPTDA=0
 F  S ACPTDA=$O(^ICPT(ACPTDA)) Q:ACPTDA=""  D
 . Q:$L(ACPTDA)'=$L(+ACPTDA)  ;only do "good" codes
 . K ACPTINA,ACPTDDEL,ACPTEDT,ACPTDA2,DIC,DIE,DA
 . S ACPTINA=$P($G(^ICPT(ACPTDA,0)),"^",4)  ;inactive flag
 . S ACPTDDEL=$P($G(^ICPT(ACPTDA,0)),"^",7)  ;date deleted
 . S ACPTEDT=$O(^ICPT(ACPTDA,60,"B",9999999),-1)  ;most current effective date
 . S:ACPTEDT'="" ACPTDA2=$O(^ICPT(ACPTDA,60,"B",ACPTEDT,0))
 . S:$G(ACPTDA2)'="" ACPTSTAT=$P($G(^ICPT(ACPTDA,60,ACPTDA2,0)),"^",2),ACPTEDT=$P($G(^ICPT(ACPTDA,60,ACPTDA2,0)),"^")  ;status
 . I $G(ACPTDDEL)="",$G(ACPTINA)="",$G(ACPTSTAT)=1 D LINEUP2 Q  ;no delete date, no inactive flag and status is active
 . I ACPTDDEL'="",($E(ACPTDDEL,1,3))'=($E(ACPTEDT,1,3)) D
 .. I ACPTDDEL>ACPTEDT D
 ... S DA(1)=ACPTDA
 ... S DIC="^ICPT("_DA(1)_",60,"
 ... S DIC(0)="LIX"
 ... S DLAYGO=81.02
 ... S X=ACPTDDEL
 ... S DIC("DR")=".02///0"
 ... S DIC("P")=$P(^DD(81,60,0),"^",2)
 ... D ^DIC
 .. I ACPTEDT>ACPTDDEL D
 ... S DIE="^ICPT("
 ... S DA=ACPTDA
 ... S DR="8////"_ACPTEDT
 ... I ACPTSTAT=0 S DR=DR_";5///1"  ;inactive
 ... I ACPTSTAT=1 S DR=DR_";5///@"  ;active
 ... D ^DIE
 .D LINEUP2
 Q
 ; lineup Date Added
LINEUP2 S ACPTADT=$P($G(^ICPT(ACPTDA,0)),"^",6)
 Q:ACPTADT'=""  ;there's a date, don't do anything
 I ACPTADT="" D
 . S ACPTEDA=0,ACPTSTAT=""
 . F  S ACPTEDA=$O(^ICPT(ACPTDA,60,"B",ACPTEDA)) Q:+ACPTEDA=0  D  Q:$G(ACCPTEDT)'=""  ;most current effective date
 .. S ACPTEDA2=$O(^ICPT(ACPTDA,60,"B",ACPTEDA,0))
 .. S ACPTSTAT=$P($G(^ICPT(ACPTDA,60,ACPTEDA2,0)),"^",2)
 .. I $G(ACPTSTAT)=1 S ACPTEDT=$P($G(^ICPT(ACPTDA,60,ACPTEDA2,0)),"^")
 . I $G(ACPTEDT)'="" D
 .. S DIE="^ICPT("
 .. S DA=ACPTDA
 .. S DR="7////"_ACPTEDT
 .. D ^DIE
 Q
