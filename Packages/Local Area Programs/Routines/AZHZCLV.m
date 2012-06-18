AZHZCLV ;DSD/PDW - Clean VA patient file ; AUGUST 14, 1992
 ;;1.0;AZHZ;;AUG 14, 1992
 ;;
S ;
VAPAT ;start edits for fields in VA patient file
 ;perform top level edits
 S AZHZGL="^DPT("
 F AZHZFLD=1,9,111,112,113,114,211,2401,2402,2403,331 D @AZHZFLD,TX1X2
 ; perform checks on 'Other Name' multiple
 S IEN=0 F  S IEN=$O(^DPT(DFN,.01,IEN)) Q:(DFOUT!DUOUT)  Q:'IEN  S (AZHZX1,AZHZX2)=$P(^(IEN,0),U) D BLNK,NAME I AZHZX1'=AZHZX2 S ^AZHZTEMP(DFN,"OTHER",IEN,.01,"O")=AZHZX1,^("N")=AZHZX2
 Q
 ;---------------------------------------------------------------------
VA ; edits for VA patient file
1 S AZHZN=0,AZHZP=1,AZHZFLDN=.01 D PULL D NAME Q  ; edit name field
9 S AZHZN=0,AZHZP=9,AZHZFLDN=.09 D PULL S AZHZX2=$TR(AZHZX2,"-") Q  ;edit SSN (-)
111 S AZHZN=.11,AZHZP=1,AZHZFLDN=.111 D PULL Q  ; edit for address l1
112 S AZHZN=.11,AZHZP=2,AZHZFLDN=.112 D PULL Q  ; edit for address l2
113 S AZHZN=.11,AZHZP=3,AZHZFLDN=.113 D PULL Q  ; edit for address l3
114 S AZHZN=.11,AZHZP=4,AZHZFLDN=.114 D PULL Q  ; edit for address L4
211 S AZHZN=.21,AZHZP=1,AZHZFLDN=.211 D PULL D NAME Q  ;edit for  next of kin
2401 S AZHZN=.24,AZHZP=1,AZHZFLDN=.2401 D PULL D NAME Q  ;edit for father name
2402 S AZHZN=.24,AZHZP=2,AZHZFLDN=.2402 D PULL D NAME Q  ;edit for mother name 
2403 S AZHZN=.24,AZHZP=3,AZHZFLDN=.2403 D PULL D NAME Q  ;edit for mother maiden name 
331 S AZHZN=.33,AZHZP=1,AZHZFLDN=.331 D PULL D NAME Q  ;edit for emergency contact
 ;---------------------------------------------------------------------
PULL ; pull data item and remove beginning blanks
 S AZHZNODE=AZHZGL_DFN_","_AZHZN_")",(AZHZX1,AZHZX2)="" I $D(@AZHZNODE) S AZHZX1=$P(@(AZHZNODE),U,AZHZP),AZHZX2=AZHZX1 D BLNK
 Q
 ;---------------------------------------------------------------------
BLNK ; REMOVE BEGINNING BLANKS
 F  Q:'($E(AZHZX2)=" ")  S AZHZX2=$E(AZHZX2,2,999)
 Q
 ;---------------------------------------------------------------------
TX1X2 ; test x1 - x2 set
 ;I AZHZX1'=AZHZX2 W !,DFN,?15,AZHZX1,!,?15,AZHZX2
 I AZHZX1'=AZHZX2 S ^AZHZTEMP(DFN,"V",AZHZFLDN,"O")=AZHZX1,^("N")=AZHZX2
 Q  ;-----
 ;---------------------------------------------------------------------
NAME ; edit name: uppercase:  change  () to - : remove punctuation
 Q:'$L(AZHZX2)
 S AZHZX3=$TR(AZHZX2,")(&/","----") S:AZHZX3'=AZHZX2 ^AZHZTEMP("P",DFN)=""
 S AZHZX2=AZHZX3,AZHZX2=$TR(AZHZX2,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ"),AZHZX2=$TR(AZHZX2,"/:;`*()_+=*&%$#@!") S:AZHZX2[", " AZHZX2=$P(AZHZX2,", ")_","_$P(AZHZX2,", ",2)
 F I=1:1:3 S AZHZNAM(I)=$P(AZHZX2,",",I)
 S AZHZLN=AZHZNAM(1),AZHZFN=AZHZNAM(2)
 F  Q:AZHZLN'?1P.E  S AZHZLN=$E(AZHZLN,2,99)
 F  Q:AZHZFN'?1P.E  S AZHZFN=$E(AZHZFN,2,99)
 S AZHZX2=AZHZLN_","_AZHZFN S:$L(AZHZNAM(3)) AZHZX2=AZHZX2_","_AZHZNAM(3)
 Q  ;-----
EVAPAT ;
TNAM ;R !,"NAME : ",X Q:X=""  S AZHZX2=X D NAME W !,">",AZHZX2,"<" G TNAM
