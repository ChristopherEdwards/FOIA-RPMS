AUMPRE32 ;IHS/VEN/TOAD - AUM 9.1 patch 3 pre-init ;
 ;;9.1;AUM SCB UPDATE;**3**;NOV 11, 2008
 ;
 ; This is the pre-init for AUM*9.1*3. It strips all control chars
 ; out of the ^AUTTEDT global prior to the install of the patch.
 ;
 ; 2008 04 18-20 Rick Marshall created this routine from scratch to
 ; clear out control characters found in the ^AUTTEDT global in both
 ; values and subscripts.
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at CLEANALL by AUMPRE21 as the
 ; pre-init for AUM*9.1*3.
 ;
CHECK ; troubleshooting entry point
 ;
 N AUMNAME S AUMNAME="^AUTTEDT" ; the name value of each node of ^AUTTEDT
 N AUMCNTC S AUMCNTC=0 ; how many nodes had control characters
 N AUMCNTN S AUMCNTN=0 ; how many node names had control characters
 ;
 N AUMCNT ; count nodes
 F AUMCNT=1:1 D  S AUMNAME=$Q(@AUMNAME) Q:AUMNAME=""  ; walk ^AUTTEDT
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
CLEANALL ; AUM*9.1*3 PRE-INIT: Remove Control Characters from ^AUTTEDT
 ;
 D BMES^XPDUTL($$T("MSG+9")) ; AUM*8.0*3 PRE-INIT
 D MES^XPDUTL($$T("MSG+8")) ; Removing control character from your ...
 ;
 K ^TMP("AUM",$J) ; clear scratch space
 ;
 N AUMNAME S AUMNAME="^AUTTEDT" ; the name value of each node of ^AUTTEDT
 N AUMCNTC S AUMCNTC=0 ; how many nodes had control characters
 N AUMCNTN S AUMCNTN=0 ; how many node names had control characters
 ;
 N AUMCNT ; count nodes, walk ^AUTTEDT
 F AUMCNT=1:1 D  S AUMNAME=$Q(@AUMNAME) Q:AUMNAME=""
 . ;
 . I '(AUMCNT#1000) W "." ; indicate progress
 . ;
 . N AUMVALU S AUMVALU=$G(@AUMNAME) ; fetch value of node
 . N AUMBADN S AUMBADN=AUMNAME?.E1C.E ; is it a bad name
 . N AUMBADV S AUMBADV=AUMVALU?.E1C.E ; is it a bad value
 . Q:'AUMBADN&'AUMBADV  ; skip good nodes
 . ;
 . ; for output, show where control characters were
 . N AUMMAPN S AUMMAPN=AUMNAME
 . N AUMMAPV S AUMMAPV=AUMVALU
 . ;
 . N AUMCLN S AUMCLN=AUMNAME ; save cleaned up name in AUMCLN
 . I AUMBADN D  ; if the node name contains a control character
 . . S AUMCNTC=AUMCNTC+1,AUMCNTN=AUMCNTN+1 ; add to both counts
 . . W AUMCNT,$C(7),": bad name" ; note presence of control chars
 . . D CLEAN(.AUMCLN,.AUMMAPN,1) ; strip out the control characters
 . ;
 . I AUMBADV D  ; if the node value contains a control character
 . . S AUMCNTC=AUMCNTC+1 ; add to our count of instances
 . . W AUMCNT,$C(7),": bad value" ; note presence of control chars
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
 . N AUMEMP S AUMEMP=AUMCLN ; change name from ^AUTTEDT(*)
 . S $E(AUMEMP,1,9)="^TMP(""AUM"","_$J_"," ; to ^TMP("AUM",$J,*)
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
 . N AUTTEDT S AUTTEDT=AUMNAME,$E(AUTTEDT,1,AUMLENG)="^AUTTEDT(" ; change back
 . K @(@AUMNAME@(U)) ; delete node in ^AUTTEDT whose bad name we saved off
 . N AUMVALU S AUMVALU=@AUMNAME ; get the saved, clean value
 . S @AUTTEDT=AUMVALU ; copy cleaned up node back into ^AUTTEDT
 . N AUMSUB S AUMSUB=$QS(AUMNAME,3) ; get the main subscript
 . K @AUMNAME@(U) ; delete the saved node name to avoid it
 . D MES^XPDUTL(AUTTEDT_"="_AUMVALU) ; report nodes as we copy them back
 K ^TMP("AUM",$J) ; clean up rest of temp space
 ;
 D BMES^XPDUTL(AUMCNT-1_$$T("MSG+1")) ; # nodes in ^AUTTEDT were scanned.
 D MES^XPDUTL(AUMCNTC_$$T("MSG+2")) ; # instances of control charact...
 ; # of them from node names, # from values.
 D MES^XPDUTL(AUMCNTN_$$T("MSG+3")_(AUMCNTC-AUMCNTN)_$$T("MSG+4"))
 ; Your ^AUTTEDT global is [now] free of control characters.
 D BMES^XPDUTL($$T("MSG+5")_$S(AUMCNTC:"now ",1:"")_$$T("MSG+6"))
 ;
 QUIT  ; end of CLEANALL
 ;
 ;
T(TAG) QUIT $P($T(@TAG),";;",2)
 ;
 ;
MSG ; messages to display
 ;; nodes in ^AUTTEDT were scanned.
 ;; instances of control characters were found and removed,
 ;; of them from node names, 
 ;; from values.
 ;;Your ^AUTTEDT global is 
 ;;free of control characters.
 ;;Replacing the bad node names found in ^AUTTEDT
 ;;Removing control characters from your ^AUTTEDT global...
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
 F AUMPOS=$L(AUMSTR):-1:1 D:$E(AUMSTR,AUMPOS)?1C  ; for each ctl char
 . N AUMCHAR S AUMCHAR=$E(AUMSTR,AUMPOS) ; copy it
 . N AUMASCI S AUMASCI=$A(AUMCHAR) ; get its ASCII code
 . ; replace control chars that have standard ASCII equivalents
 . N AUMREPL
 . S AUMREPL=$TR(AUMCHAR,$C(28,145,146,147,148,150,151),"C''""""--")
 . I AUMNAME,AUMASCI=147!(AUMASCI=148) S AUMREPL="""""" ; dbl for nm
 . ; I AUMASCI=153 S AUMREPL="(TM)" ; cutting legal text
 . I AUMREPL?1C S AUMREPL="" ; if no replacement, delete it
 . S $E(AUMSTR,AUMPOS)=AUMREPL ; replace the ctl char
 . S $E(AUMMAP,AUMPOS)="_$C("_AUMASCI_")_" ; highlight it in AUMMAP
 ;
 QUIT  ; end of CLEAN
 ;
 ;
 ; end of routine AUMPRE32
