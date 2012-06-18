LR210 ;DALISC/FHS - LR*5.2*210 PATCH ENVIRONMENT CHECK ROUTINE
 ;;5.2T8;LR;**1018**;Oct 27, 2004
 ;;5.2;LAB SERVICE;**210**;Sep 27, 1994
EN ;
 Q:'$G(XPDENV)
 L +^LAM:15 I '$T D BMES^XPDUTL($$CJ^XLFSTR(" Unable to successfully lock the ^LAM global. ",80)) S XPDQUIT=2
 L +^LRO(69,"AA"):15 I '$T D BMES^XPDUTL($$CJ^XLFSTR(" Unable to successfully lock the ^LRO(69,AA) global. ",80)) S XPDQUIT=2
 I '$D(^LAM(0))#2 D BMES^XPDUTL($$CJ^XLFSTR("There is no WKLD CODE file.",80)) S XPDQUIT=2
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1018 ALPHA ONLY??
 ;I $$VERSION^XPDUTL("ICPT")'="6.0" D BMES^XPDUTL($$CJ^XLFSTR("You must install ICPT V6.0 Package first.",80)) S XPDQUIT=2
 ;----- END IHS MODIFICATIONS
 I '$O(^LAM(0)) D BMES^XPDUTL($$CJ^XLFSTR("There is no data in your WKLD CODE file.",80)) S XPDQUIT=2
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D BMES^XPDUTL($$CJ^XLFSTR("Terminal Device in not defined.",80)) S XPDQUIT=2
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D BMES^XPDUTL($$CJ^XLFSTR("Please Log in to set local DUZ... variables.",80)) S XPDQUIT=2
 I '$D(^VA(200,$G(DUZ),0))#2 D BMES^XPDUTL($$CJ^XLFSTR("You are not a valid user on this system.",80)) S XPDQUIT=2
 I +$G(^LAM("VR"))'>5.1 D BMES^XPDUTL($$CJ^XLFSTR("You must have LAB V5.2 or greater Installed.",80)) S XPDQUIT=2
 I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("Install environment check FAILED.",80)) L -^LRO(69,"AA"),-^LAM
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("Environment Check is Ok ---",80))
 Q
PRE ;AFTER USER COMMITS ROUTINE KIDS INSTALL"
 Q:'$D(XPDNM)
 S:$D(^LAM(0))#2 $P(^LAM(0),U,3)=2225
 I $D(^LAB(64.81,0))#2 S X=$P(^(0),U,1,2) K ^LAB(64.81) S ^LAB(64.81,0)=X
 S X="TRAP^LR210",@^%ZOSF("TRAP")
 D BMES^XPDUTL($$CJ^XLFSTR("** Pre Install Step Complete **",80))
 Q
POST ;Post cleanup
 N $ESTACK,$ETRAP
 S $ETRAP="D ERROR^LR210"
 K ^XTMP("LR","NLT")
 S ^XTMP("LR","NLT")="LR*5.2*210 Spelling errors"
 S ^XTMP("LR","NLT",0)=$$FMADD^XLFDT(DT,7)_U_$$NOW^XLFDT_U_DUZ
 D BMES^XPDUTL($$CJ^XLFSTR("Correcting Duplicates or Spelling Errors",80))
 D BMES^XPDUTL($$CJ^XLFSTR("Names that begin with 'X*' have codes that are incorrect.",80))
 ;
 N DIC,DA
 S LR81=0,LRFILE=64,LRERFILE="^XTMP(""LR"",""NLT"")"
 F  S LR81=$O(^LAB(64.81,LR81)) Q:LR81<1  D
 . S LRNODE=$G(^LAB(64.81,LR81,0)) Q:LRNODE=""
 . S LRLKNM=$P(LRNODE,U),LRNAME=$S($L($P(LRNODE,U,8)):$P(LRNODE,U,8),1:LRLKNM)
 . S LRLKCODE=$P(LRNODE,U,2),LRCODE=$P(LRNODE,U,3)
 . S LRCK=$S(LRLKCODE:1,LRCODE:1,$L(LRLKNM):1,1:0) Q:'LRCK
 . W:$G(LRDBUG) !,LRLKNM,?30,LRNAME,!,LRLKCODE,?30,LRCODE
 . K DIC,DA S DIC="^LAM(",DIC(0)="ZOXMN"
 . S LRCK=0,X=LRLKCODE,DIC("S")="I $P(^(0),U)="""_LRLKNM_"""" D ^DIC
 . I Y<1 D PURG Q
 . I Y>0 S LRDA=+Y W ! D
 . . I LRLKNM'=LRNAME D
 . . . D BMES^XPDUTL($$CJ^XLFSTR("Correcting Spelling of entry ^(LAM,"_LRDA_") from ",80))
 . . . D BMES^XPDUTL($$CJ^XLFSTR(LRLKNM_" to "_LRNAME,80))
 . . . S LRFD=.01,LRDATA=$E(LRNAME,1,60),DA=LRDA
 . . . S LRCK=$$FILE(LRDA,LRFILE,LRFD,LRDATA,LRERFILE)
 . . . I LRCK D BMES^XPDUTL($$CJ^XLFSTR("*** An "_$P(LRCK,U,2)_" error has occured ***",80)) D  Q
 . . . . S $P(^LAB(64.81,LR81,0),U,9)=$E(LRCK,1,19)
 . . . D BMES^XPDUTL($$CJ^XLFSTR("Name change successful",80))
 . . I LRLKCODE'=LRCODE D
 . . . D BMES^XPDUTL($$CJ^XLFSTR("Correcting NLT Code of entry ^LAM("_LRDA_") from ",80))
 . . . D BMES^XPDUTL($$CJ^XLFSTR(LRLKCODE_" to "_LRCODE,80))
 . . . S LRFD=1,LRDATA=LRCODE,DA=LRDA
 . . . S LRCK=$$FILE(LRDA,LRFILE,LRFD,LRDATA,LRERFILE)
 . . . I LRCK D BMES^XPDUTL($$CJ^XLFSTR("*** An "_$P(LRCK,U,2)_" error has occured ***",80)) D  Q
 . . . . S $P(^LAB(64.81,LR81,0),U,9)=$E(LRCK,1,19)
 . . . D BMES^XPDUTL($$CJ^XLFSTR("NLT Code change successful",80))
 . . I '$G(LRCK),$G(LR81) D PURG
 D BMES^XPDUTL($$CJ^XLFSTR("Spelling/Code Numbers update is complete.",80))
ENPOS ;NLT CODE UPGRADE POST INSTALL ROUTINE KIDS INSTALL"
 ;
 I '$O(^LAB(64.81,0)) D BMES^XPDUTL($$CJ^XLFSTR("Database Upgrade Completed Successfully",80)) K ^XTMP("LR","NLT") G MSG
 W ! D BMES^XPDUTL($$CJ^XLFSTR(" ****************************** ",80))
 D BMES^XPDUTL($$CJ^XLFSTR(" Database Upgrade is Incomplete - Use FM to print upgrade errors",80))
 D BMES^XPDUTL($$CJ^XLFSTR("stored in the LAB NLT/CPT CODES (#64.81) file.",80))
 D BMES^XPDUTL($$CJ^XLFSTR(" ****************************** ",80)) W !
MSG D BMES^XPDUTL($$CJ^XLFSTR("Use 'Workload code list option [LRCAPD] for a full listing of",80))
 D BMES^XPDUTL($$CJ^XLFSTR("ALL NLT Codes used in Laboratory Test File (#60).",80))
 D BMES^XPDUTL($$CJ^XLFSTR("You can also use the [Edit or Print WKLD CODES] option for a listing",80))
 D BMES^XPDUTL($$CJ^XLFSTR("of linked CPT linked NLT codes.",80))
 S I=0 F  S I=$O(^LAM(I)) Q:I<1  I $O(^LAM(I,4,0)) D
 . S II=0 F  S II=$O(^LAM(I,4,II)) Q:II<1  D
 . . I $P($G(^LAM(I,4,II,0)),U,2)="CPT",'$P(^(0),U,3) S $P(^(0),U,3)=2980301
 D BMES^XPDUTL($$CJ^XLFSTR("** Post install completed **",80))
END S:$D(^LAM(0))#2 $P(^(0),U,3)=99999 S $P(^LAB(69.9,1,"VSIT"),U)=1
 L -^LAB(69,"AA"),-^LAM Q
ERROR D END,UNWIND^%ZTER
 Q
PURG ;
 N DIK,DA
 S DIK="^LAB(64.81,",DA=LR81 D ^DIK K DIK
 Q
FILE(DA,FILE,FIELD,DATA,ERR) ;
 ; Utility call to FILE^DIE database call. Can be used to update uneditable fields.
 ;DA= to the IEN of the node to update
 ;FILE = The file number containing the DA
 ;FIELD = Set to the field number of the file
 ;DATA = Is equal to the new value of the FIELD
 ;ERR (Optional) = The global to store any errors from the FILE^DIE
 ;ERROR is returned - I successful = 0 Failure = 1~_error text
 ;   there maybe more that one error but only the first is reported
 N LRROOT
 I '+DA!('$L(FILE))!('FIELD)!(DATA="") Q "1~Calling error"
 S LRROOT(FILE,+DA_",",FIELD)=DATA
 D FILE^DIE("","LRROOT",ERR)
 S ERROR=0 I $D(DIERR),ERR]"" S ERROR="1~"_$TR(@ERR@("DIERR",1,"TEXT",1),"^","~")
 Q ERROR
