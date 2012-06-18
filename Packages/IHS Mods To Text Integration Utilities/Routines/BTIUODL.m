BTIUODL ; IHS/ITSC/LJF - LIST OBJECT DESCRIPTIONS ;02-Nov-2005 13:58;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1002,1003**;NOV 04, 2004
 ;IHS/ITSC/LJF 3/24/2005 PATCH 1002 - code was using incorrect IEN
 ;IHS/CIA/MGH - Modified to use the new field for description in the
 ;TIU DOCUMENT DEFINITION file
EN ; -- main entry point for BTIU LIST OBJECT DESC
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BTIU LIST OBJECT DESC")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 NEW OBJ,NAME,LINE,COUNT,IEN
 S (COUNT,VALMCNT)=0
 K ^TMP("BTIUODL",$J),^TMP("BTIUODL1",$J)
 ;
 ; first put objects into alpha order
 S OBJ=0 F  S OBJ=$O(^TIU(8925.1,"AT","O",OBJ)) Q:'OBJ  D
 . S NAME=$$GET1^DIQ(8925.1,OBJ,.01)
 . S ^TMP("BTIUODL1",$J,NAME,OBJ)=""
 ;
 ; pull from alpha list and build display line
 S NAME=0 F  S NAME=$O(^TMP("BTIUODL1",$J,NAME)) Q:NAME=""  D
 . S OBJ=0 F  S OBJ=$O(^TMP("BTIUODL1",$J,NAME,OBJ)) Q:'OBJ  D
 . . I $D(^TIU(8925.1,OBJ,9003130.1,0))>0 D
 . . .S COUNT=COUNT+1
 . . .S LINE=$J(COUNT,3)_$$SP(2)_$E(NAME,1,30)
 . . .;
 . . .S LINE=$$PAD(LINE,38)_$$GET1^DIQ(8925.1,OBJ,.07)   ;name & status
 . . .S LINE=$$PAD(LINE,49)_$E($$OWNER(OBJ),1,20)        ;object owner
 . . .;
 . . .D SET(LINE,OBJ,COUNT,.VALMCNT)
 . . .;
 . . .D SET($$SP(5)_"Method:  "_$$GET1^DIQ(8925.1,OBJ,9),OBJ,COUNT,.VALMCNT)  ;object method
 . . .;
 . . .; now loop thru description & place in array
 . . .D SET("",OBJ,COUNT,.VALMCNT)
 . . .S IEN=0 F  S IEN=$O(^TIU(8925.1,OBJ,9003130.1,IEN)) Q:'IEN  D
 . . . . D SET($$SP(5)_^TIU(8925.1,OBJ,9003130.1,IEN,0),OBJ,COUNT,.VALMCNT)
 . . .D SET("",OBJ,COUNT,.VALMCNT)
 ;
 I '$D(^TMP("BTIUODL",$J)) D SET("NO OBJECTS FOUND",0,1,1)
 Q
 ;
OWNER(IEN) ; return class or personal owner of object
 NEW X
 S X=$$GET1^DIQ(8925.1,IEN,.06) I X]"" Q X  ;class
 Q $$GET1^DIQ(8925.1,IEN,.05)               ;personal
 ;
SET(DATA,IEN,CNT,LINENUM) ; place display data into array
 S LINENUM=LINENUM+1
 S ^TMP("BTIUODL",$J,LINENUM,0)=DATA
 S ^TMP("BTIUODL",$J,"IDX",LINENUM,CNT)=IEN
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BTIUODL",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAD(DATA,LENGTH) ; pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; pad spaces
 Q $$PAD(" ",NUM)
