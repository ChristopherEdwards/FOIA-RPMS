AUMAUTUP ;IHS/OIT/ABK - AUM 10 patch 2 AD-HOC LOAD [ 10/11/2010  9:19 AM ]
 ;;11.0;TABLE MAINTENANCE;**5**;Oct 15,2010
 ;
QUIT ; This routine should not be called at the top.  
 ;
PARTIAL ;This tag sets a variable to prevent the deactivation of all
 ; existing topics like we do when we do a full update.  This is in
 ; affect a partial update.
 S APART=1
 ;
START ; 
 ; First check to ensure AUMPCLN exists
 N TOTCNT,AUMERR,TOTNEW,TOTUPD,TOTINACT,TMNMISS,AUMSKIP
 S (TOTCNT,AUMERR,TOTNEW,TOTUPD,TOTINACT,TMNMISS,AUMSKIP)=0
 I $D(^AUMPCLN)=0 D
 .D BMES^XPDUTL("Source Global ^AUMPCLN does not exist, quitting.") ; Quit if no AUMPCLN
 .Q
 E  D
 .D UPD
 .Q
 Q
UPD ;
 S AUMERR=0
 D KILL^AUMUP102,POST^AUMUP102
 ; Copy the target global AUTTEDT to a save global AUTTEDTSAV
 D GCPY("AUTTEDT","AUTTEDTSAV")
 ;
 ; Inactivate all existing topics in AUTTEDT
 I $G(APART)'=1 D
 .W !,"Deactivating Topics",!
 .D START^AUMP1012
 .Q
 ;
 ; Clean target global from all control characters
 W !,"Cleaning Target Global",!
 D CLEAN("AUTTEDT","")
 ;
 W !,"Running Update",!
 D START^AUMUP102
 Q
 ;
T(TAG) QUIT $P($T(@TAG),";;",2)
 ;
MSG ; messages to display
 ;; nodes in 
 ;; were scanned. 
 ;; instances of control characters were found and removed, 
 ;; of them from node names, 
 ;; from values. 
 ;; Copying global 
 ;; to  
 ;; Removing control characters from 
 ;; nodes were copied 
 ;; from 
 ;
CLEAN(SRC,TAR) ; private, strip ctl chars out of a GLOBAL
 ;
 ; .SRC = input GLOBAL
 ; .TAR = output GLOBAL; IF Null, replace data into same global
 ;
 ; traverse loop backward so our insertions do not throw off our position
 ; within AUMMAP. Replacing one control character with _$C(#)_ expands
 ; the value of AUMMAP, shifting all the character positions & throwing
 ; off its positional mapping to AUMSTR; we work from the end of the
 ; string forward so that the loss of correspondence happens in the part
 ; of AUMMAP we have already looked at.
 ;
 S GLB="^"_SRC,INPLACE=0
 D BMES^XPDUTL($$T("MSG+8")_GLB) ; removing control characters from ...
 I (TAR="") S TAR=SRC,INPLACE=1
 S TGLB="^"_TAR
 S CNTC=0 ; how many nodes had control characters
 S CNTN=0 ; how many node names had control characters
 ;
 F CNT=1:1 D  S GLB=$Q(@GLB) Q:GLB=""
 .S VALU=$G(@GLB) ; fetch value of node
 .S BADN=0 ; is it a bad name
 .S BADV=0 ; is it a bad value
 .S CLN=GLB ; save cleaned up name in CLN
 .K X F X=1:1:$L(VALU) S Y=$E(VALU,X) I ($A(Y)<32)!($A(Y)>126) S BADV=1 Q
 .K X F X=1:1:$L(GLB) S Y=$E(GLB,X) I ($A(Y)<32)!($A(Y)>126) S BADN=1 Q
 .Q:('BADN&'BADV)&(INPLACE=1)  ; skip good nodes
 .S MAPN=GLB
 .S MAPV=VALU
 .I BADN D  ; if the node name contains a control character
 ..S CNTC=CNTC+1,CNTN=CNTN+1 ; add to both counts
 ..D CLNSTR(.CLN) ; strip out the control characters
 .;
 .I BADV D  ; if the node value contains a control character
 ..S CNTC=CNTC+1 ; add to our count of instances
 ..D CLNSTR(.VALU) ; strip out the control characters
 .I CNT>1 S TNODE=TGLB_"("_$P($P(CLN,"(",2,99),")",1,99)
 .I CNT=1 S TNODE=TGLB
 .S @TNODE=VALU
 .Q
 D BMES^XPDUTL(CNT-1_$$T("MSG+1")_SRC_$$T("MSG+2")) ; # nodes in ^SRC were scanned.
 D MES^XPDUTL(CNTC_$$T("MSG+3")) ; # instances of control charact...
 ; # of them from node names, # from values.
 D MES^XPDUTL(CNTN_$$T("MSG+4")_(CNTC-CNTN)_$$T("MSG+5"))
 Q
 ;
CLNSTR(AUMSTR) ; private, strip ctl chars out of a string
 ;
 ; .AUMSTR = input & output: string to clear of control characters
 ;
 N AUMPOS ; each position
 F AUMPOS=$L(AUMSTR):-1:1 D:($A($E(AUMSTR,AUMPOS))<32)!($A($E(AUMSTR,AUMPOS))>126)
 .N AUMCHAR S AUMCHAR=$E(AUMSTR,AUMPOS) ; cpy it
 .N AUMASCI S AUMASCI=$A(AUMCHAR) ; get its ASCII code
 .; replace control chars that have standard ASCII equivalents
 .N AUMREPL
 .S AUMREPL=$TR(AUMCHAR,$C(28,145,146,147,148,150,151),"C''""""--")
 .; if no replacement, delete it
 .I ($A($E(AUMSTR,AUMPOS))<32)!($A($E(AUMSTR,AUMPOS))>126) S AUMREPL=""
 .S $E(AUMSTR,AUMPOS)=AUMREPL ; replace the ctl char
 Q
GCPY(SRC,TARG) ; global copy to save target before we modify it
 ;
 ; .SRC  = input  GLOBAL
 ; .TARG = output GLOBAL
 ;
 S GLB="^"_SRC,TGLB="^"_TARG
 D BMES^XPDUTL($$T("MSG+6")_GLB_$$T("MSG+7")_TGLB) ; copying global from to
 F CNT=1:1 D  S GLB=$Q(@GLB) Q:GLB=""
 .S VALU=$G(@GLB) ; fetch value of node
 .S CLN=GLB ; save cleaned up name in CLN
 .I CNT>1 S TNODE=TGLB_"("_$P($P(CLN,"(",2,99),")",1,99)
 .I CNT=1 S TNODE=TGLB
 .S @TNODE=VALU
 .Q
 D MES^XPDUTL(CNT_$$T("MSG+9")_$$T("MSG+10")_SRC_$$T("MSG+7")_TARG) ; nodes were copied from to
 Q
