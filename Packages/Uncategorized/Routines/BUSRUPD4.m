BUSRUPD4 ;IHS/MSC/MGH - Authorization/Subscription Service ;11-Sep-2012 12:49;DU
 ;;1.0;AUTHORIZATION/SUBSCRIPTION;**1004**;APR 24, 1997;Build 15
 ;=================================================================
 ;
 ;
ENV ;Environment checker for USR updates
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="USR*1.0*1003"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numbers
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
POST ; Create new Business Rules
 ; Create rules for ONE User Class & ONE DDEF
 ; -- Set data for rules:
 ;If rules already exist, quit
 N CLASS,ACTION,DOC,STATUS,RULENUM
 S RULENUM=0
 S DOC="PATIENT RECORD FLAG CAT I",STATUS="UNSIGNED",CLASS="PROVIDER",ACTION="LINK TO FLAG"
 D DO(DOC,STATUS,CLASS,ACTION)
 S DOC="PATIENT RECORD FLAG CAT II",STATUS="UNSIGNED",CLASS="PROVIDER",ACTION="LINK TO FLAG"
 D DO(DOC,STATUS,CLASS,ACTION)
 S DOC="PATIENT RECORD FLAG CAT I",STATUS="COMPLETED",CLASS="CHIEF, MIS",ACTION="LINK TO FLAG"
 D DO(DOC,STATUS,CLASS,ACTION)
 S DOC="PATIENT RECORD FLAG CAT II",STATUS="COMPLETED",CLASS="CHIEF, MIS",ACTION="LINK TO FLAG"
 D DO(DOC,STATUS,CLASS,ACTION)
 D PROCESS
 D ROLE
 Q
DO(DOC,STATUS,CLASS,ACTION) ;DO THE ACTION,STATUS,DOC
 N CL,ST,MSG,VIEW,PRINT,IEN,USR
 S CL=$$FIND1^DIC(8925.1,,"BO",DOC,,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the document class "_DOC_" Rules cannot be added."
 S ST=$$FIND1^DIC(8930.6,,,STATUS,,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the status "_STATUS_" Rules cannot be added"
 S USR=$$FIND1^DIC(8930,,,CLASS,,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the user class "_USR_" Rules cannot be added."
 S VIEW=$$FIND1^DIC(8930.8,,,ACTION,,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the action "_VIEW_" Rules cannot be added."
 S IEN="" S IEN=$O(^USR(8930.1,"AC",CL,ST,VIEW,USR,IEN))
 ;Only add if this rule does not exist
 I IEN="" D
 . S RULENUM=RULENUM+1
 . D SETDATA(RULENUM,VIEW)
 Q
PROCESS ; -- Loop through numbered list of rules:
 N NUM,SUCCESS
 S SUCCESS=1,NUM=0
 I '$O(^TMP("USR1004",$J,"RULES",0)) S SUCCESS=0 W "Business rules already exist" Q
 F  S NUM=$O(^TMP("USR1004",$J,"RULES",NUM)) Q:'NUM  D
 .N USRERR,FDA,DESC
 .M FDA(8930.1,"+1,")=^TMP("USR1004",$J,"RULES",NUM)
 .M DESC=^TMP("USR1004",$J,"RULESDESC")
 .S FDA(8930.1,"+1,",1)="DESC"
 .D UPDATE^DIE("","FDA","","USRERR")
 .I $D(USRERR) S SUCCESS=0 Q
 .K ^TMP("USR1004",$J,"RULES",NUM)
 K ^TMP("USR1004",$J,"RULESDESC")
 I '$G(SUCCESS) D  Q
 . W "Problem creating Business Rules. Please contact National VistA Support."
 W !,"Business Rules created successfully."
 Q
 ;
SETDATA(RULENUM,ACTION) ; Set data for rules
 ; -- Set data for exported Rules into Rule nodes of ^TMP.
 ;    Use interior data since there may be dup DDEF names.
 ;    Must set AFTER User Class is created:
 N DDEFIEN,USRCLASS,EXACTION
 S ^TMP("USR1004",$J,"RULES",RULENUM,.01)=CL
 S ^TMP("USR1004",$J,"RULES",RULENUM,.04)=USR
 S ^TMP("USR1004",$J,"RULES",RULENUM,.02)=ST
 S ^TMP("USR1004",$J,"RULES",RULENUM,.03)=VIEW
 S ^TMP("USR1004",$J,"RULESDESC",1)="Rule created by patch USR*1*1004."
 S ^TMP("USR1004",$J,"RULESDESC",2)="Rules allowing PRF documents to be linked."
 Q
ROLE ;Set business rules
 N CL,ST,ACTION,MSG,RULENUM,VIEW,PRINT,IEN,USR,DOC,STATUS,ACTION,ROLE
 S DOC="CLINICAL DOCUMENTS",STATUS="UNSIGNED",ACTION="SIGNATURE",ROLE="SURROGATE"
 S RULENUM=0
 S CL=$$FIND1^DIC(8925.1,,,DOC,,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the document class "_DOC_" Rules cannot be added."
 S ST=$$FIND1^DIC(8930.6,,,STATUS,,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the status "_STATUS_" Rules cannot be added"
 S USR=$$FIND1^DIC(8930.2,,,ROLE,,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the user class "_USR_" Rules cannot be added."
 S VIEW=$$FIND1^DIC(8930.8,,,ACTION,,,"MSG")
 I $D(MSG) D  Q
 .W !!,"Unable to find the action "_VIEW_" Rules cannot be added."
 S IEN="" S IEN=$O(^USR(8930.1,"AR",CL,ST,VIEW,USR,IEN))
 ;Only add if this rule does not exist
 I IEN="" D
 . S RULENUM=RULENUM+1
 . S ^TMP("USR1004",$J,"RULES",RULENUM,.01)=CL
 . S ^TMP("USR1004",$J,"RULES",RULENUM,.06)=USR
 . S ^TMP("USR1004",$J,"RULES",RULENUM,.02)=ST
 . S ^TMP("USR1004",$J,"RULES",RULENUM,.03)=VIEW
 . S ^TMP("USR1004",$J,"RULESDESC",1)="Rule created by patch USR*1*1004."
 . S ^TMP("USR1004",$J,"RULESDESC",2)="Rules allowing SURROGATES TO SIGN documents."
 . N NUM,SUCCESS
 . S SUCCESS=1,NUM=0
 . ; -- Loop through numbered list of rules:
 . I '$O(^TMP("USR1004",$J,"RULES",0)) S SUCCESS=0 W "Business rules already exist" Q
 . S NUM=$O(^TMP("USR1004",$J,"RULES",NUM)) Q:'NUM  D
 ..N USRERR,FDA,DESC
 ..M FDA(8930.1,"+1,")=^TMP("USR1004",$J,"RULES",NUM)
 ..M DESC=^TMP("USR1004",$J,"RULESDESC")
 ..S FDA(8930.1,"+1,",1)="DESC"
 ..D UPDATE^DIE("","FDA","","USRERR")
 ..I $D(USRERR) S SUCCESS=0 Q
 ..K ^TMP("USR1004",$J,"RULES",NUM)
 ..K ^TMP("USR1004",$J,"RULESDESC")
 .I '$G(SUCCESS) D  Q
 ..W "Problem creating Business Rules. Please contact National VistA Support."
 .W !,"Business Rules created successfully."
SETX ;
 Q
