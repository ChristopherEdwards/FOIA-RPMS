ACPT28P1 ;IHS/VEN/TOAD - ACPT*2.08*1 pre-init ; 04/21/2008 00:29
 ;;2.09;CPT FILES;;JAN 2, 2009
 ;
 ; This is the pre-init for ACPT*2.08*1. It strips all control chars
 ; out of the ^ICPT global prior to the install of the patch.
 ;
 ; 2008 04 18-20 Rick Marshall created this routine from scratch to
 ; clear out control characters found in the ^ICPT global in both
 ; values and subscripts.
 ;
 QUIT  ; This routine should not be called at the top or anywhere
 ; else. It is only to be called at CLEANALL by KIDS as the pre-init
 ; for ACPT*2.08*1.
 ;
CHECK ; troubleshooting entry point
 ;
 N ACPTNAME S ACPTNAME="^ICPT" ; the name value of each node of ^ICPT
 N ACPTCNTC S ACPTCNTC=0 ; how many nodes had control characters
 N ACPTCNTN S ACPTCNTN=0 ; how many node names had control characters
 ;
 N ACPTCNT ; count nodes
 F ACPTCNT=1:1 D  S ACPTNAME=$Q(@ACPTNAME) Q:ACPTNAME=""  ; walk ^ICPT
 . ;
 . I '(ACPTCNT#1000) W "." ; indicate progress
 . ;
 . I ACPTNAME?.E1C.E D  ; if the node name contains a control char
 . . S ACPTCNTC=ACPTCNTC+1,ACPTCNTN=ACPTCNTN+1 ; add to both counts
 . . W "@",ACPTCNT,"@",$C(7) ; note presence of control characters
 . . W !,ACPTNAME ; write node name
 . ;
 . N ACPTVALU S ACPTVALU=$G(@ACPTNAME) ; fetch value of node
 . ;
 . I ACPTVALU?.E1C.E D  ; if the node value contains a control char
 . . S ACPTCNTC=ACPTCNTC+1 ; add to our count of instances
 . . W "=",ACPTCNT,"=",$C(7) ; note presence of control characters
 . . W !,ACPTVALU ; write node name
 ;
 QUIT  ; end of CHECK
 ;
 ;
CLEANALL ; ACPT*2.08*1 PRE-INIT: Remove Control Characters from ^ICPT
 ;
 D BMES^XPDUTL($$T("MSG+9")) ; ACPT*2.08*1 PRE-INIT
 D MES^XPDUTL($$T("MSG+8")) ; Removing control character from your ...
 ;
 K ^TMP("ACPT",$J) ; clear scratch space
 ;
 N ACPTNAME S ACPTNAME="^ICPT" ; the name value of each node of ^ICPT
 N ACPTCNTC S ACPTCNTC=0 ; how many nodes had control characters
 N ACPTCNTN S ACPTCNTN=0 ; how many node names had control characters
 ;
 N ACPTCNT ; count nodes, walk ^ICPT
 F ACPTCNT=1:1 D  S ACPTNAME=$Q(@ACPTNAME) Q:ACPTNAME=""
 . ;
 . I '(ACPTCNT#1000) W "." ; indicate progress
 . ;
 . N ACPTVALU S ACPTVALU=$G(@ACPTNAME) ; fetch value of node
 . N ACPTBADN S ACPTBADN=ACPTNAME?.E1C.E ; is it a bad name
 . N ACPTBADV S ACPTBADV=ACPTVALU?.E1C.E ; is it a bad value
 . Q:'ACPTBADN&'ACPTBADV  ; skip good nodes
 . ;
 . ; for output, show where control characters were
 . N ACPTMAPN S ACPTMAPN=ACPTNAME
 . N ACPTMAPV S ACPTMAPV=ACPTVALU
 . ;
 . N ACPTCLN S ACPTCLN=ACPTNAME ; save cleaned up name in ACPTCLN
 . I ACPTBADN D  ; if the node name contains a control character
 . . S ACPTCNTC=ACPTCNTC+1,ACPTCNTN=ACPTCNTN+1 ; add to both counts
 . . W ACPTCNT,$C(7),": bad name" ; note presence of control chars
 . . D CLEAN(.ACPTCLN,.ACPTMAPN,1) ; strip out the control characters
 . ;
 . I ACPTBADV D  ; if the node value contains a control character
 . . S ACPTCNTC=ACPTCNTC+1 ; add to our count of instances
 . . W ACPTCNT,$C(7),": bad value" ; note presence of control chars
 . . D CLEAN(.ACPTVALU,.ACPTMAPV,0) ; strip out the control characters
 . ;
 . D MES^XPDUTL(ACPTMAPN_"="_ACPTMAPV_"...") ; show the problem (safely)
 . ;
 . I ACPTBADV,'ACPTBADN S @ACPTNAME=ACPTVALU Q  ; good name but bad value
 . ;
 . ; what we wish we could do here is just kill the node and replace it
 . ; but we would need the Millennium standard's KVALUE, which can kill
 . ; just a node. We are stuck with KILL, which kills the entire tree
 . ; and so would interfere with nodes we have not yet scanned and saved
 . ; off. So, we have to separate the killing from the scanning & saving.
 . ; For now we copy our cleaned up names and values out to ^TMP.
 . N ACPTEMP S ACPTEMP=ACPTCLN ; change name from ^ICPT(*)
 . S $E(ACPTEMP,1,6)="^TMP(""ACPT"","_$J_"," ; to ^TMP("ACPT",$J,*)
 . ; W ACPTCLN,"  ==>  ",ACPTEMP ; debugging code
 . S @ACPTEMP=ACPTVALU ; save off the cleaned up node to ^TMP
 . S @ACPTEMP@(U)=ACPTNAME ; save off bad name with ctl chars
 ;
 I ACPTCNTN D BMES^XPDUTL($$T("MSG+7")) ; Replacing the bad node ...
 ;
 S ACPTNAME=$NA(^TMP("ACPT",$J)) ; now we will traverse our saved nodes
 N ACPTLENG S ACPTLENG=$L(ACPTNAME) ; get the length of the prefix
 N ACPTPRE S ACPTPRE=$E(ACPTNAME,1,ACPTLENG-1) ; & grab that prefix
 ; walk ^TMP("ACPT",$J), exit when name no longer starts with prefix
 F  S ACPTNAME=$Q(@ACPTNAME) Q:$P(ACPTNAME,ACPTPRE)'=""  D
 . N ICPT S ICPT=ACPTNAME,$E(ICPT,1,ACPTLENG)="^ICPT(" ; change back
 . K @(@ACPTNAME@(U)) ; delete node in ^ICPT whose bad name we saved off
 . N ACPTVALU S ACPTVALU=@ACPTNAME ; get the saved, clean value
 . S @ICPT=ACPTVALU ; copy cleaned up node back into ^ICPT
 . N ACPTSUB S ACPTSUB=$QS(ACPTNAME,3) ; get the main subscript
 . K @ACPTNAME@(U) ; delete the saved node name to avoid it
 . D MES^XPDUTL(ICPT_"="_ACPTVALU) ; report nodes as we copy them back
 K ^TMP("ACPT",$J) ; clean up rest of temp space
 ;
 D BMES^XPDUTL(ACPTCNT-1_$$T("MSG+1")) ; # nodes in ^ICPT were scanned.
 D MES^XPDUTL(ACPTCNTC_$$T("MSG+2")) ; # instances of control charact...
 ; # of them from node names, # from values.
 D MES^XPDUTL(ACPTCNTN_$$T("MSG+3")_(ACPTCNTC-ACPTCNTN)_$$T("MSG+4"))
 ; Your ^ICPT global is [now] free of control characters.
 D BMES^XPDUTL($$T("MSG+5")_$S(ACPTCNTC:"now ",1:"")_$$T("MSG+6"))
 ;
 QUIT  ; end of CLEANALL
 ;
 ;
T(TAG) QUIT $P($T(@TAG),";;",2)
 ;
 ;
MSG ; messages to display
 ;; nodes in ^ICPT were scanned.
 ;; instances of control characters were found and removed,
 ;; of them from node names, 
 ;; from values.
 ;;Your ^ICPT global is 
 ;;free of control characters.
 ;;Replacing the bad node names found in ^ICPT
 ;;Removing control characters from your ^ICPT global...
 ;;ACPT*2.08*1 PRE-INIT
 ;
 ;
CLEAN(ACPTSTR,ACPTMAP,ACPTNAME) ; private, strip ctl chars out of a string
 ;
 ; .ACPTSTR = input & output: string to clear of control characters
 ; .ACPTMAP = output: display version of ACPTSTR
 ; ACPTNAME = 1 if this is a name, else 0, affects quotation marks
 ;
 ; code useful another time, but not here
 ; N ACPTCHAR
 ; S ACPTCHAR=$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21)
 ; S ACPTCHAR=ACPTCHAR_$C(22,23,24,25,26,27,28,29,30,31,127)
 ; S ACPTSTR=$TR(ACPTSTR,ACPTCHAR) ; strip out standard ASCII ctl chars
 ;
 ; traverse loop backward so our insertions do not throw off our position
 ; within ACPTMAP. Replacing one control character with _$C(#)_ expands
 ; the value of ACPTMAP, shifting all the character positions & throwing
 ; off its positional mapping to ACPTSTR; we work from the end of the
 ; string forward so that the loss of correspondence happens in the part
 ; of ACPTMAP we have already looked at.
 ;
 S ACPTNAME=+$G(ACPTNAME) ; default to not a name
 S ACPTMAP=ACPTSTR ; create copy to highlight the control characters
 N ACPTPOS ; each position
 F ACPTPOS=$L(ACPTSTR):-1:1 D:$E(ACPTSTR,ACPTPOS)?1C  ; for each ctl char
 . N ACPTCHAR S ACPTCHAR=$E(ACPTSTR,ACPTPOS) ; copy it
 . N ACPTASCI S ACPTASCI=$A(ACPTCHAR) ; get its ASCII code
 . ; replace control chars that have standard ASCII equivalents
 . N ACPTREPL
 . S ACPTREPL=$TR(ACPTCHAR,$C(28,145,146,147,148,150,151),"C''""""--")
 . I ACPTNAME,ACPTASCI=147!(ACPTASCI=148) S ACPTREPL="""""" ; dbl for nm
 . ; I ACPTASCI=153 S ACPTREPL="(TM)" ; cutting legal text
 . I ACPTREPL?1C S ACPTREPL="" ; if no replacement, delete it
 . S $E(ACPTSTR,ACPTPOS)=ACPTREPL ; replace the ctl char
 . S $E(ACPTMAP,ACPTPOS)="_$C("_ACPTASCI_")_" ; highlight it in ACPTMAP
 ;
 QUIT  ; end of CLEAN
 ;
 ;
 ; end of routine ACPT28P1
