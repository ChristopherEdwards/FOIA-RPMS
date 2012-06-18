AUM111PX ;IHS/VEN/RNB - AUM v12.0 pre-init ;
 ;;12.0;TABLE MAINTENANCE;;SEP 27,2011
 ;
 ; From orignal AUMPREX routine
 ; This is the pre-init for AUM 9.1. It strips all control chars
 ; out of the ^ICD9 global prior to the install of the patch.
 ;
 ; 2008 04 18-20 Rick Marshall created this routine from scratch to
 ; clear out control characters found in the ^AUM globals in both
 ; values and subscripts.
 ;
 ; 09/09/2010 RNB - add additional control checking to remove characters
 ; that are out side the character ASCII of 32 and 126
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at CLEANALL by KIDS as the pre-init
 ; for AUM 9.1.
 ;
CHECK ; troubleshooting entry point
 ;
 N AUMNAME S AUMNAME="^ICD9" ; the name value of each node of ^ICD9
 N AUMCNTC S AUMCNTC=0 ; how many nodes had control characters
 N AUMCNTN S AUMCNTN=0 ; how many node names had control characters
 ;
 N AUMCNT ; count nodes
 F AUMCNT=1:1 D  S AUMNAME=$Q(@AUMNAME) Q:AUMNAME=""  ; walk ^ICD9
 . ;
 . I '(AUMCNT#1000) W "." ; indicate progress
 . ;
 . I AUMNAME?.E1C.E D  ; if the node name contains a control char
 . . S AUMCNTC=AUMCNTC+1,AUMCNTN=AUMCNTN+1 ; add to both counts
 . . W "@",AUMCNT,"@",$C(7) ; note presence of control characters
 . . W !,AUMNAME ; write node name
 . ;
 . N AUMVALU S AUMVALU=$G(@AUMNAME) ; fetch value of node
 . ;
 . I AUMVALU?.E1C.E D  ; if the node value contains a control char
 . . S AUMCNTC=AUMCNTC+1 ; add to our count of instances
 . . W "=",AUMCNT,"=",$C(7) ; note presence of control characters
 . . W !,AUMVALU ; write node name
 ;
 W !!,"Number of nodes in global: ",AUMCNT
 W !!,"Number of nodes with control characters: ",AUMCNTC
 W !!,"Number of node names with control characters: ",AUMCNTN
 QUIT  ; end of CHECK
 ;
 ;
CLEANALL ; AUM*8.0*3 PRE-INIT: Remove Control Characters from ^ICD9
 ;
 D BMES^XPDUTL($$T("MSG+9")) ; AUM*8.0*3 PRE-INIT
 D MES^XPDUTL($$T("MSG+8")) ; Removing control character from your ...
 ;
 K ^TMP("AUM",$J) ; clear scratch space
 ;
 N AUMNAME S AUMNAME="^ICD9" ; the name value of each node of ^ICD9
 N AUMCNTC S AUMCNTC=0 ; how many nodes had control characters
 N AUMCNTN S AUMCNTN=0 ; how many node names had control characters
 ;
 N AUMCNT ; count nodes, walk ^ICD9
 F AUMCNT=1:1 D  S AUMNAME=$Q(@AUMNAME) Q:AUMNAME=""
 . ;
 . I '(AUMCNT#1000) W "." ; indicate progress
 . ;
 . N AUMVALU S AUMVALU=$G(@AUMNAME) ; fetch value of node
 . N AUMBADN S AUMBADN=AUMNAME?.E1C.E ; is it a bad name
 . N AUMBADV S AUMBADV=AUMVALU?.E1C.E ; is it a bad value
 . ;[RNB] Add next 2 lines
 . K AUMX F AUMX=1:1:$L(AUMNAME) S AUMY=$E(AUMNAME,AUMX) I ($A(AUMY)<32)!($A(AUMY)>126) S AUMBADN=1 Q
 . K AUMX F AUMX=1:1:$L(AUMVALU) S AUMY=$E(AUMVALU,AUMX) I ($A(AUMY)<32)!($A(AUMY)>126) S AUMBADV=1 Q
 . Q:'AUMBADN&'AUMBADV  ; skip good nodes
 . ;
 . ; for output, show where control characters were
 . N AUMMAPN S AUMMAPN=AUMNAME
 . N AUMMAPV S AUMMAPV=AUMVALU
 . ;
 . N AUMCLN S AUMCLN=AUMNAME ; save cleaned up name in AUMCLN
 . I AUMBADN D  ; if the node name contains a control character
 . . S AUMCNTC=AUMCNTC+1,AUMCNTN=AUMCNTN+1 ; add to both counts
 . . ;[RNB]W AUMCNT,$C(7),": bad name" ; note presence of control chars
 . . W !,AUMCNT,$C(7),": bad name" ; note presence of control chars
 . . D CLEAN(.AUMCLN,.AUMMAPN,1) ; strip out the control characters
 . ;
 . I AUMBADV D  ; if the node value contains a control character
 . . S AUMCNTC=AUMCNTC+1 ; add to our count of instances
 . . ;[RNB]W AUMCNT,$C(7),": bad value" ; note presence of control chars
 . . W !,AUMCNT,$C(7),": bad value" ; note presence of control chars
 . . D CLEAN(.AUMVALU,.AUMMAPV,0) ; strip out the control characters
 . ;
 . D MES^XPDUTL(AUMMAPN_"="_AUMMAPV_"...") ; show the problem (safely)
 . ;
 . I AUMBADV,'AUMBADN S @AUMNAME=AUMVALU Q  ; good name but bad value
 . ;
 . ; what we wish we could do here is just kill the node and replace it
 . ; but we would need the Millennium standard's KVALUE, which can kill
 . ; just a node. We are stuck with KILL, which kills the entire tree
 . ; and so would interfere with nodes we have not yet scanned and saved
 . ; off. So, we have to separate the killing from the scanning & saving.
 . ; For now we copy our cleaned up names and values out to ^TMP.
 . N AUMEMP S AUMEMP=AUMCLN ; change name from ^ICD9(*)
 . ;S $E(AUMEMP,1,9)="^TMP(""AUM"","_$J_"," ; to ^TMP("AUM",$J,*)
 . S $E(AUMEMP,1,6)="^TMP(""AUM"","_$J_"," ; to ^TMP("AUM",$J,*)
 . ;IHS/OIT/CLS 09/17/2008 change to equal length of global root ^ICD9(
 . ;
 . ; W AUMCLN,"  ==>  ",AUMEMP ; debugging code
 . S @AUMEMP=AUMVALU ; save off the cleaned up node to ^TMP
 . S @AUMEMP@(U)=AUMNAME ; save off bad name with ctl chars
 ;
 I AUMCNTN D BMES^XPDUTL($$T("MSG+7")) ; Replacing the bad node ...
 ;
 S AUMNAME=$NA(^TMP("AUM",$J)) ; now we will traverse our saved nodes
 N AUMLENG S AUMLENG=$L(AUMNAME) ; get the length of the prefix
 N AUMPRE S AUMPRE=$E(AUMNAME,1,AUMLENG-1) ; & grab that prefix
 ; walk ^TMP("AUM",$J), exit when name no longer starts with prefix
 F  S AUMNAME=$Q(@AUMNAME) Q:$P(AUMNAME,AUMPRE)'=""!(AUMNAME="")  D
 . N ICD9 S ICD9=AUMNAME,$E(ICD9,1,AUMLENG)="^ICD9(" ; change back
 . K @(@AUMNAME@(U)) ; delete node in ^ICD9 whose bad name we saved off
 . N AUMVALU S AUMVALU=@AUMNAME ; get the saved, clean value
 . S @ICD9=AUMVALU ; copy cleaned up node back into ^ICD9
 . N AUMSUB S AUMSUB=$QS(AUMNAME,3) ; get the main subscript
 . K @AUMNAME@(U) ; delete the saved node name to avoid it
 . D MES^XPDUTL(ICD9_"="_AUMVALU) ; report nodes as we copy them back
 K ^TMP("AUM",$J) ; clean up rest of temp space
 ;
 D BMES^XPDUTL(AUMCNT-1_$$T("MSG+1")) ; # nodes in ^ICD9 were scanned.
 D MES^XPDUTL(AUMCNTC_$$T("MSG+2")) ; # instances of control charact...
 ; # of them from node names, # from values.
 D MES^XPDUTL(AUMCNTN_$$T("MSG+3")_(AUMCNTC-AUMCNTN)_$$T("MSG+4"))
 ; Your ^ICD9 global is [now] free of control characters.
 D BMES^XPDUTL($$T("MSG+5")_$S(AUMCNTC:"now ",1:"")_$$T("MSG+6"))
 ;
 QUIT  ; end of CLEANALL
 ;
 ;
T(TAG) QUIT $P($T(@TAG),";;",2)
 ;
 ;
MSG ; messages to display
 ;; nodes in ^ICD9 were scanned.
 ;; instances of control characters were found and removed,
 ;; of them from node names, 
 ;; from values.
 ;;Your ^ICD9 global is 
 ;;free of control characters.
 ;;Replacing the bad node names found in ^ICD9
 ;;Removing control characters from your ^ICD9 global...
 ;;AUM*8.0*3 PRE-INIT
 ;
 ;
CLEAN(AUMSTR,AUMMAP,AUMNAME) ; private, strip ctl chars out of a string
 ;
 ; .AUMSTR = input & output: string to clear of control characters
 ; .AUMMAP = output: display version of AUMSTR
 ; AUMNAME = 1 if this is a name, else 0, affects quotation marks
 ;
 ; code useful another time, but not here
 ; N AUMCHAR
 ; S AUMCHAR=$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21)
 ; S AUMCHAR=AUMCHAR_$C(22,23,24,25,26,27,28,29,30,31,127)
 ; S AUMSTR=$TR(AUMSTR,AUMCHAR) ; strip out standard ASCII ctl chars
 ;
 ; traverse loop backward so our insertions do not throw off our position
 ; within AUMMAP. Replacing one control character with _$C(#)_ expands
 ; the value of AUMMAP, shifting all the character positions & throwing
 ; off its positional mapping to AUMSTR; we work from the end of the
 ; string forward so that the loss of correspondence happens in the part
 ; of AUMMAP we have already looked at.
 ;
 S AUMNAME=+$G(AUMNAME) ; default to not a name
 S AUMMAP=AUMSTR ; create copy to highlight the control characters
 N AUMPOS ; each position
 ;[RNB]F AUMPOS=$L(AUMSTR):-1:1 D:$E(AUMSTR,AUMPOS)?1C  ; for each ctl char
 F AUMPOS=$L(AUMSTR):-1:1 D:($A($E(AUMSTR,AUMPOS))<32)!($A($E(AUMSTR,AUMPOS))>126)  ; per control chara
 . N AUMCHAR S AUMCHAR=$E(AUMSTR,AUMPOS) ; copy it
 . N AUMASCI S AUMASCI=$A(AUMCHAR) ; get its ASCII code
 . ; replace control chars that have standard ASCII equivalents
 . N AUMREPL
 . S AUMREPL=$TR(AUMCHAR,$C(28,145,146,147,148,150,151),"C''""""--")
 . I AUMNAME,AUMASCI=147!(AUMASCI=148) S AUMREPL="""""" ; dbl for nm
 . ; I AUMASCI=153 S AUMREPL="(TM)" ; cutting legal text
 . ;[RNB] I AUMREPL?1C S AUMREPL="" ; if no replacement, delete it
 .I ($A($E(AUMSTR,AUMPOS))<32)!($A($E(AUMSTR,AUMPOS))>126) S ACPTREPL=""
 . S $E(AUMSTR,AUMPOS)=AUMREPL ; replace the ctl char
 . S $E(AUMMAP,AUMPOS)="_$C("_AUMASCI_")_" ; highlight it in AUMMAP
 ;
 QUIT  ; end of CLEAN
 ;
 ;
 ; end of routine AUM28P1
