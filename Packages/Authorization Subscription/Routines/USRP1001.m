USRP1001 ; SLC/MAM -  After installing TIU*1.0*137;28-Feb-2006 16:13;MGH
 ;;1.0;AUTHORIZATION/SUBSCRIPTION;**1001**;Jun 20, 1997
 ; Run this after installing patch 137.
 ;Use option: TIU137 DDEFS Rules, Anat Path
 ;
ENV N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="USR*1.0*23"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numb
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
POST ; Create new Business Rules
 ; Create rules for ONE User Class & ONE DDEF
 ; -- Set data for rules:
 ;If rules already exist, quit
 N CL,ST,ACTION,MSG,RULENUM,VIEW,PRINT,IEN,USR
 S RULENUM=0
 S CL=$$FIND1^DIC(8925.1,,,"CLINICAL DOCUMENTS",,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the class clinical documents.  Rules cannot be added"
 S ST=$$FIND1^DIC(8930.6,,,"RETRACTED",,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the status RETRACTED.  Rules cannot be added"
 S USR=$$FIND1^DIC(8930,,,"CHIEF, MIS",,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the user class CHIEF, MIS.  Rules cannot be added."
 S VIEW=$$FIND1^DIC(8930.8,,,"VIEW",,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the action, VIEW.  Rules cannot be added."
 S PRINT=$$FIND1^DIC(8930.8,,,"PRINT RECORD",,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the action PRINT RECORD.  Rules cannot be added."
 S IEN="" S IEN=$O(^USR(8930.1,"AC",CL,ST,VIEW,USR,IEN))
 ;Only add if this rule does not exist
 I IEN="" D
 . S RULENUM=RULENUM+1
 . D SETDATA(RULENUM,VIEW)
 ;Only add the print rule if its not there
 S IEN="" S IEN=$O(^USR(8930.1,"AC",CL,ST,PRINT,USR,IEN))
 I IEN="" D
 . S RULENUM=RULENUM+1
 . D SETDATA(RULENUM,PRINT)
 N NUM,SUCCESS
 S SUCCESS=1,NUM=0
 ; -- Loop through numbered list of rules:
 I '$O(^TMP("USR1001",$J,"RULES",0)) S SUCCESS=0 W "Business rules already exist" Q
 F  S NUM=$O(^TMP("USR1001",$J,"RULES",NUM)) Q:'NUM  D
 .N USRERR,FDA,DESC
 .M FDA(8930.1,"+1,")=^TMP("USR1001",$J,"RULES",NUM)
 .M DESC=^TMP("USR1001",$J,"RULESDESC")
 .S FDA(8930.1,"+1,",1)="DESC"
 .D UPDATE^DIE("","FDA","","USRERR")
 .I $D(USRERR) S SUCCESS=0 Q
 .K ^TMP("USR1001",$J,"RULES",NUM)
 K ^TMP("USR1001",$J,"RULESDESC")
 I '$G(SUCCESS) D  Q
 . W "Problem creating Business Rules. Please contact National VistA Support."
 W "Business Rules created successfully."
 Q
 ;
SETDATA(RULENUM,ACTION) ; Set data for rules
 ; -- Set data for exported Rules into Rule nodes of ^TMP.
 ;    Use interior data since there may be dup DDEF names.
 ;    Must set AFTER User Class is created:
 N DDEFIEN,USRCLASS,EXACTION
 S ^TMP("USR1001",$J,"RULES",RULENUM,.01)=CL
 S ^TMP("USR1001",$J,"RULES",RULENUM,.04)=USR
 S ^TMP("USR1001",$J,"RULES",RULENUM,.02)=ST
 S ^TMP("USR1001",$J,"RULES",RULENUM,.03)=ACTION
 S ^TMP("USR1001",$J,"RULESDESC",1)="Rule created by patch USR*1*1001."
 S ^TMP("USR1001",$J,"RULESDESC",2)="Rules allowing retracted documents to be used by only medical records."
 Q
SETX ;
 Q
