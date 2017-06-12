BQIRMCHK ;GDIT/HCSD/ALA-Check duplicate reminders ; 22 Sep 2015  6:41 AM
 ;;2.5;ICARE MANAGEMENT SYSTEM;**1**;May 24, 2016;Build 17
 ;
 ;
EN ; EP
 I $G(TJOB)'="Weekly" Q
 NEW IEN,NAME,CODE,ARRAY,CT
 S IEN=""
 F  S IEN=$O(^BQI(90506.1,"AC","R",IEN)) Q:IEN=""  D
 . I $P(^BQI(90506.1,IEN,0),"^",10)=1 Q
 . S NAME=$P(^BQI(90506.1,IEN,0),"^",3),CODE=$P(^(0),"^",1)
 . I $P(CODE,"_",1)'="EHR" Q
 . S ARRAY(NAME,IEN)=CODE
 ;
 S NAME=""
 F  S NAME=$O(ARRAY(NAME)) Q:NAME=""  D
 . S CT=0,IEN=""
 . F  S IEN=$O(ARRAY(NAME,IEN)) Q:IEN=""  S CT=CT+1
 . I CT<2 K ARRAY(NAME)
 ;
 I '$D(ARRAY) Q
 ;
 ; Send notification message
 NEW OWNR,PLIEN,SUBJECT,BODY,RIEN
 S OWNR=0
 F  S OWNR=$O(^BQICARE(OWNR)) Q:'OWNR  D
 . I '$$KEYCHK^BQIULSC("BQIZMGR",OWNR) Q
 . S SUBJECT="Duplicate EHR reminders found"
 . S BODY(1)="The following duplicate EHR reminders are active.  Please contact the EHR"_$C(10)_$C(13)
 . S BODY(2)="Reminder CAC to go to the Reminder Definition Management menu and inactivate"_$C(10)_$C(13)
 . S BODY(3)="the incorrect duplicate reminders."_$C(10)_$C(13)
 . S BODY(4)=" ",CT=4
 . S NAME=""
 . F  S NAME=$O(ARRAY(NAME)) Q:NAME=""  D
 .. S IEN=""
 .. F  S IEN=$O(ARRAY(NAME,IEN)) Q:IEN=""  D
 ... S CODE=ARRAY(NAME,IEN),RIEN=$P(CODE,"_",2)
 ... S CT=CT+1,BODY(CT)="    "_NAME_" ["_$P(^PXD(811.9,RIEN,0),"^",1)_"]"_$C(10)_$C(13)
 . D ADD^BQINOTF("",OWNR,SUBJECT,.BODY,1)
 ;
 Q
