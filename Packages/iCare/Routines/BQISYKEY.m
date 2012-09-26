BQISYKEY ;VNGT/HS/ALA - Manage iCare Keys ; 12 Jun 2008  10:44 AM
 ;;2.3;ICARE MANAGEMENT SYSTEM;;Apr 18, 2012;Build 59
 ;
 ;
UPD(DATA,USER,RLIST) ; EP - BQI UPDATE USER ROLES
 NEW UID,II,ROLE,RIEN,BKEY,BKIEN,OKEY,FLAG,BN,BQ,DINUM,PDATA,VALUE,X
 NEW FINAL,FKY,MSG,RESULT
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQISYKEY",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQISYKEY D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S @DATA@(II)="I00010RESULT^T01024MSG"_$C(30)
 S RLIST=$G(RLIST,"")
 I RLIST="" D
 . S LIST="",BN=""
 . F  S BN=$O(RLIST(BN)) Q:BN=""  S LIST=LIST_RLIST(BN)
 . K RLIST
 . S RLIST=LIST
 . K LIST
 ;
 F BQ=1:1:$L(RLIST,$C(28)) D
 . S PDATA=$P(RLIST,$C(28),BQ)
 . S BKEY=$P(PDATA,"=",1),VALUE=$P(PDATA,"=",2,99)
 . I VALUE="Y" D ADD Q
 . I VALUE="N" D REM
 . Q
 ;
 S FINAL=1,FKY="",MSG=""
 F  S FKY=$O(RESULT(FKY)) Q:FKY=""  I $P(RESULT(FKY),U,1)=-1 S FINAL=-1,MSG=MSG_$P(RESULT(FKY),U,2)_"; "
 I $G(MSG)'="" S MSG=$$TKO^BQIUL1(MSG,"; ")
 S II=II+1,@DATA@(II)=FINAL_U_$G(MSG)_$C(30)
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ADD ;EP - Add ROLE to user
 NEW RIEN,ROLE,BKIEN,Y
 S RIEN=$O(^BQI(90505.2,"C",BKEY,"")) I RIEN="" Q
 S ROLE=$P(^BQI(90505.2,RIEN,0),U,1)
 S BKIEN=$O(^DIC(19.1,"B",BKEY,""))
 I $D(^XUSEC(BKEY,USER)) Q
 I BKIEN="" Q
 NEW DIC
 S DIC(0)="NMQ",DIC("P")="200.051PA"
 S DIC="^VA(200,"_USER_",51,",DA(1)=USER,X=BKIEN,DINUM=X
 K DO,DD D FILE^DICN
 I Y<0 S RESULT(BKEY)="-1^Unable to add role "_ROLE Q
 S RESULT(BKEY)=1
 Q
 ;
REM ;EP - Remove ROLE from user
 NEW RIEN
 S RIEN=$O(^BQI(90505.2,"C",BKEY,"")) I RIEN="" Q
 S ROLE=$P(^BQI(90505.2,RIEN,0),U,1)
 S BKIEN=$O(^DIC(19.1,"B",BKEY,""))
 I '$D(^XUSEC(BKEY,USER)) Q
 NEW DIK,DA
 S DIK="^VA(200,"_USER_",51,",DA(1)=USER,DA=BKIEN
 D ^DIK
 S RESULT(BKEY)=1
 Q
 ;
RET(DATA,USER,ROLE) ; EP - BQI GET USER ROLES
 ;
 ;Parameters:
 ;USER (optional) = DUZ of specific user to report on
 ;ROLE (optional) = Specific role that user(s) must have to return information
 ;
 NEW UID,II,BKEY,BKIEN,OKEY,HDR,RIEN,BQROLE,NPOS
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQISYKG",UID))
 K @DATA
 S ROLE=$G(ROLE,""),USER=$G(USER,"")
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQISYKEY D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 S HDR="T00050BQIUSER^T00001EDIT_CANDIDATE^T00001TAX_CANDIDATE^T00001BQIZCUSR^T00001BQIRPC^"
 S HDR=HDR_"T00001BQIZCMED^T00001BQIZTXED^T00001BQIZMGR^T00001BTPWZCMGR^T00001BQIZBHUSR^"
 S HDR=HDR_"T00001BQIZMUMGR^T00001BQIZEMPHLTH^T00001BQIZIPCMGR"
 S @DATA@(II)=HDR_$C(30)
 ;
 K BQROLE
 ;
 ;Define all roles, put a 1 for any to look for
 S RIEN=0
 F  S RIEN=$O(^BQI(90505.2,RIEN)) Q:'RIEN  D
 . S BKEY=$P(^BQI(90505.2,RIEN,0),U,2)
 . S BQROLE(BKEY)=$P(^BQI(90505.2,RIEN,0),U,3)_U_RIEN_U_$S(ROLE="":1,1:"")
 ;
 ;If a role was passed in, set it up with a 1
 I ROLE'="" D
 . S RIEN=$O(^BQI(90505.2,"B",ROLE,"")) Q:RIEN=""
 . S BKEY=$P(^BQI(90505.2,RIEN,0),U,2) Q:BKEY=""
 . S BQROLE(BKEY)=$P(^BQI(90505.2,RIEN,0),U,3)_U_RIEN_U_"1"
 ;
 D ROL(USER,.BQROLE)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 I $D(II),$D(DATA) S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ROL(BUSER,BQROLE) ;EP - Assemble User Information Based on input User/Role
 ;
 NEW BQUSER,BUSR,POS
 ;
 ;Handle single user request
 I BUSER'="" D  Q:'$D(BQUSER(BUSER))
 . N ASKY,BKEY,POS,RLIEN,RLCK,RLCNT,ROL,VAL
 . ;
 . ;Reset role flag and count
 . S ROL="",RLCNT=0
 . ;
 . ;Skip corrupted entries
 . I $G(^VA(200,BUSER,0))="" Q
 . ;
 . ;Set initial entry
 . S BQUSER(BUSER)=""
 . ;
 . ;Loop through keys for user
 . S BKEY="" F  S BKEY=$O(BQROLE(BKEY)) Q:BKEY=""  D
 .. S VAL=$G(BQROLE(BKEY))
 .. S POS=$P(VAL,U),RLIEN=$P(VAL,U,2),RLCK=$P(VAL,U,3)
 .. I RLCK=1 S RLCNT=RLCNT+1        ;Keep track of # of roles to check
 .. ;
 .. I $D(^XUSEC(BKEY,BUSER)) D
 ... S $P(BQUSER(BUSER),U,POS)="Y"  ;User has key
 ... S:RLCK=1 ROL=1                 ;Set flag if role to check
 .. ;
 .. ;Check whether a candidate
 .. S ASKY="" F  S ASKY=$O(^BQI(90505.2,RLIEN,10,"B",ASKY)) Q:ASKY=""  D
 ... Q:'$D(^XUSEC(ASKY,BUSER))
 ... I BKEY="BQIZCMED" S $P(BQUSER(BUSER),U,2)="Y"
 ... I BKEY="BQIZTXED" S $P(BQUSER(BUSER),U,3)="Y"
 ... I BKEY="BQIZBHUSR" S $P(BQUSER(BUSER),U,POS)="Y"
 . ;
 . ;If checking for a specific role and not found clear out entry
 . ;(Role count for specific role check will be 1, otherwise >1)
 . I ROL="",RLCNT=1 K BQUSER(BUSER) Q
 . ;
 . ;Check if iCare User
 . S:$G(^BQICARE(BUSER,0))'="" $P(BQUSER(BUSER),U,4)="Y"
 . ;
 . ;Check for BQIRPC Secondary Menu
 . D BQIRPC(BUSER,.BQROLE,.BQUSER)
 ;
 ;Handle blank (multiple) user request
 I BUSER="" D  Q:'$D(BQUSER)
 . N ASKY,BKEY,BUSR,POS,RLCK,RLCNT,RLIEN,ROL,VAL
 . ;
 . ;Reset role count
 . S RLCNT=0
 . ;
 . ;Loop through keys
 . S BKEY="" F  S BKEY=$O(BQROLE(BKEY)) Q:BKEY=""  D
 .. S VAL=$G(BQROLE(BKEY))
 .. S POS=$P(VAL,U),RLIEN=$P(VAL,U,2),RLCK=$P(VAL,U,3)
 .. I RLCK=1 S RLCNT=RLCNT+1        ;Keep track of # of roles to check
 .. ;
 .. ;Loop through users holding that key
 .. S BUSR="" F  S BUSR=$O(^XUSEC(BKEY,BUSR)) Q:BUSR=""  D
 ... I $G(^VA(200,BUSR,0))="" Q
 ... S $P(BQUSER(BUSR),U,POS)="Y"
 ... I RLCK=1 S ROL(BUSR)="" ;Set flag if looking for this role
 .. ;
 .. ;Check whether candidate
 .. S ASKY="" F  S ASKY=$O(^BQI(90505.2,RLIEN,10,"B",ASKY)) Q:ASKY=""  D
 ... S BUSR="" F  S BUSR=$O(^XUSEC(ASKY,BUSR)) Q:BUSR=""  D
 .... I $G(^VA(200,BUSR,0))="" Q
 .... I $P($G(^VA(200,BUSR,0)),U,11)'="" Q
 .... I BKEY="BQIZCMED" S $P(BQUSER(BUSR),U,2)="Y"
 .... I BKEY="BQIZTXED" S $P(BQUSER(BUSR),U,3)="Y"
 .... I BKEY="BQIZBHUSR" S $P(BQUSER(BUSR),U,POS)="Y"
 . ;
 . ;Check if iCare User
 . S BUSR=0 F  S BUSR=$O(^BQICARE(BUSR)) Q:'BUSR  D
 .. I $G(^VA(200,BUSR,0))="" Q
 .. S $P(BQUSER(BUSR),U,4)="Y"
 . ;
 . ;Check for BQIRPC Secondary Menu
 . D BQIRPC(BUSER,.BQROLE,.BQUSER)
 . ;
 . ;If checking for a specific role and not found clear out entries
 . ;Role count for specific role check will be 1, otherwise >1
 . I RLCNT=1 D
 .. S BUSR="" F  S BUSR=$O(BQUSER(BUSR)) Q:BUSR=""  D
 ... I '$D(ROL(BUSR)) K BQUSER(BUSR)
 ;
 ;Assemble records
 S NPOS=$O(^BQI(90505.2,"AC",""),-1)
 S BUSR="" F  S BUSR=$O(BQUSER(BUSR)) Q:BUSR=""  D
 . S $P(BQUSER(BUSR),U,1)=BUSR_$C(28)_$P(^VA(200,BUSR,0),U,1)
 . F POS=2:1:NPOS I $P(BQUSER(BUSR),U,POS)="" S $P(BQUSER(BUSR),U,POS)="N"
 . S POS=6 I $P(BQUSER(BUSR),U,POS)="Y" S $P(BQUSER(BUSR),U,2)="Y"  ; taxonomy edit candidate
 . S POS=7 I $P(BQUSER(BUSR),U,POS)="Y" S $P(BQUSER(BUSR),U,3)="Y"  ; edit candidate
 . I $P(BQUSER(BUSR),U,5)'="Y" K BQUSER(BUSR) Q
 . S II=II+1,@DATA@(II)=BQUSER(BUSR)_$C(30)
 Q
 ;
BQIRPC(BUSER,BQROLE,BQUSER) ;EP - Locate users with BQIRPC Sec. Menu Assigned
 ;
 ;Parameters:
 ;  BUSER = DUZ of passed in user or Null
 ; BQROLE = ROLE Array - if only one entry it was passed in by RPC
 ; BQUSER = Array which gets updated (and possibly added to)
 ;
 NEW BQIEN,DIC,RL,RLCNT,X,Y
 ;
 ;Get BQIRPC secondary menu IEN
 S DIC=19,DIC(0)="X",X="BQIRPC" D ^DIC Q:Y<0
 S BQIEN=+Y
 ;
 ;No user or role was passed, new entries are allowed
 S RL="",RLCNT=0 F  S RL=$O(BQROLE(RL)) Q:RL=""  I $P(BQROLE(RL),U,3)=1 S RLCNT=RLCNT+1
 I $G(BUSER)="",$G(RLCNT)>1 D  Q  ;If a role was passed, there would only be 1
 . ;
 . ;Find all users with "BQIRPC" as a secondary menu
 . S BUSER="" F  S BUSER=$O(^VA(200,"AD",BQIEN,BUSER)) Q:'BUSER  D
 .. I $G(^VA(200,BUSER,0))=""!'$$ACTIVE^XUSER(BUSER) Q
 .. S $P(BQUSER(BUSER),U,5)="Y"
 . Q
 ;
 ;If either a user or role passed in, just update users already found
 S BUSER="" F  S BUSER=$O(BQUSER(BUSER)) Q:BUSER=""  D
 .I $O(^VA(200,BUSER,203,"B",BQIEN,""))]"" S $P(BQUSER(BUSER),U,5)="Y"
 ;
 Q
