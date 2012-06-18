TIUFLF7 ; SLC/MAM - Library; File 8925.1: POSSTYPE(PFILEDA),TYPELIST(NAME,FILEDA,PFILEDA,TYPEMSG,TYPELIST),EDTYPE(FILEDA,NODE0,PFILEDA,XFLG,USED),DUPNAME(NAME,FILEDA),DUPITEM(NAME,PFILEDA,FILEDA) ;15-NOV-1999 10:31:38
 ;;1.0;TEXT INTEGRATION UTILITIES;**2,17,90**;Jun 20, 1997
 ;
POSSTYPE(PFILEDA) ; Function returns possible Types an Entry may have to
 ;be consistent with its parent, e.g. ^CL^DC^
 ; If parent has bad type or no type, Returns POSSTYPE="".
 ; If PFILEDA = 0, Returns all Types including Object.
 ; Requires PFILEDA = 8925.1 IFN of parent of Entry;
 ;                  = 0 if Entry has no parent, actual or prospective.
 ; Shared CO can have more than 1 parent.  But any parent will determine the type of the Child to be a CO, so OK to check only 1 parent.
 N PNODE0,POSSTYPE,PTYPE
 S POSSTYPE=""
 I 'PFILEDA S POSSTYPE="^CL^DC^DOC^CO^O^" G POSTX
 S PNODE0=$G(^TIU(8925.1,PFILEDA,0)) I '$D(PNODE0) W !!," File entry "_PFILEDA_" does not exist in File; See IRM",! D PAUSE^TIUFXHLX G POSTX
 S PTYPE=$P(PNODE0,U,4)
 S POSSTYPE=$S(PTYPE="CL":"^CL^DC^",PTYPE="DC":"^DOC^",PTYPE="CO"!(PTYPE="DOC"):"^CO^",1:"")
POSTX Q POSSTYPE
 ;
TYPELIST(NAME,FILEDA,PFILEDA,TYPEMSG,TYPELIST) ; Module sets list of possible types, sets msg array TYPEMSG explaining nonparent limits on type.
 ; Requires NAME of entry being checked
 ; Requires PFILEDA=IFN of parent if entry has actual or prospective parent (as in Create, Add Items)
 ; Requires FILEDA if entry already exists in the file
 ; Optional TYPEMSG
 ; Optional TYPELIST: Returns TYPELIST = subset of CL,DC,DOC,CO,O
 ;representing permitted Types. Example: ^CL^DOC^
 ;If has parent, parent already has item w same name, then TYPELIST=""
 N DUPNAME,POSSTYPE,TYPE,REST,FDATYPE
 S FILEDA=+$G(FILEDA),PFILEDA=+$G(PFILEDA),TYPELIST=""
 S FDATYPE=$S(FILEDA:$P(^TIU(8925.1,FILEDA,0),U,4),1:"")
 I (FDATYPE'="CL")&(FDATYPE'="DC")&(FDATYPE'="DOC")&(FDATYPE'="CO")&(FDATYPE'="O") S FDATYPE=""
 S DUPNAME=$$DUPNAME(NAME,FILEDA)
 S POSSTYPE=$$POSSTYPE(PFILEDA) G:$D(DTOUT) TYPEX
 I POSSTYPE="" S TYPEMSG("T")="Parent has No Type/Wrong Type" G TYPEX
 I FDATYPE="O"!(TIUFTMPL="J") S TYPELIST="^O^" G TYPEX
 S REST="" F TYPE="CL","DC","DOC","CO","O" I POSSTYPE[(U_TYPE_U) D
 . I DUPNAME[(U_TYPE_U) S:TYPE'="DOC" REST=$S(REST'="":REST_" or "_TYPE,1:TYPE) S:TYPE="DOC" REST=$S(REST'="":REST_" or TL",1:"TL") Q
 . I TYPE="O" D  Q
 . . I FDATYPE'="" Q
 . . I '$$BADNAP^TIUFLF1(NAME,FILEDA,1) S TYPELIST=TYPELIST_U_TYPE Q
 . . S TYPEMSG("O")=" Type cannot be Object; Object would be ambiguous"
 . S TYPELIST=TYPELIST_U_TYPE
 I TYPELIST'="" S TYPELIST=TYPELIST_U
 I REST'="" S TYPEMSG("R")=" Type cannot be "_REST_"; File already has",TYPEMSG("R1")="an entry of that Type with the same Name" Q
TYPEX Q
 ;
DUPNAME(NAME,FILEDA) ; Function returns 1 if NAME already
 ;exists in file for entry OTHER THAN FILEDA, else 0.  If 1, returns
 ;1^Type^Type^ etc., for example, 1^DOC^CO^ means: file has a duplicate
 ;name of Type DOC other than FILEDA and a duplicate name of Type CO
 ;other than FILEDA.
 N XDUPANS,XDUPDA,TYPE
 S FILEDA=+$G(FILEDA)
 S (XDUPDA,XDUPANS)=0
 F  S XDUPDA=$O(^TIU(8925.1,"B",$E(NAME,1,60),XDUPDA)) Q:'XDUPDA  D  ;TIU*1*90 change to 60 chars
 . I NAME=$P(^TIU(8925.1,XDUPDA,0),U),XDUPDA'=FILEDA S:'XDUPANS XDUPANS="1^" S TYPE=$P(^TIU(8925.1,XDUPDA,0),U,4) I TYPE'="" S:XDUPANS'[(U_TYPE_U) XDUPANS=XDUPANS_TYPE_U
 Q XDUPANS
 ;
DUPITEM(NAME,PFILEDA,FILEDA) ; Function returns 1 if PFILEDA already has item
 ;(other than FILEDA) named NAME.
 ; Requires NAME, PFILEDA
 ; Requires FILEDA if FILEDA should be excluded from items checked for
 ;duplicate names
 N ITEMANS,XDUPDA
 S (XDUPDA,ITEMANS)=0,FILEDA=+$G(FILEDA)
 F  S XDUPDA=$O(^TIU(8925.1,"B",$E(NAME,1,60),XDUPDA)) Q:'XDUPDA  D  Q:ITEMANS  ; TIU*1*90 change to 60 chars
 . I NAME=$P(^TIU(8925.1,XDUPDA,0),U),$D(^TIU(8925.1,"AD",XDUPDA,PFILEDA)),XDUPDA'=FILEDA S ITEMANS=1
 I ITEMANS S TIUFIMSG=" Please enter a different Name; Parent already has Item with that Name"
DUPIX Q ITEMANS
 ;
DUP(NAME,PFILEDA,FILEDA) ; Function returns 1 if PFILEDA already has item
 ;(possibly FILEDA itself if FILEDA is Shared) named NAME.
 ; Requires NAME, PFILEDA, FILEDA; Used in NAMSCRN^TIUFLF2
 ; FILEDA is potential, not actual item of PFILEDA.
 N DUPANS S DUPANS=0
 ;Patch 13: Set TIUFIMSG here so NAMSCRN (which calls DUP) always sets
 ;it:
 I $D(^TIU(8925.1,PFILEDA,10,"B",FILEDA)) S DUPANS=1,TIUFIMSG=" Please enter a different Name; Parent already has Item with that Name" G DUPX
 S DUPANS=$$DUPITEM(NAME,PFILEDA,FILEDA)
DUPX Q DUPANS
 ;
EDTYPE(FILEDA,NODE0,PFILEDA,XFLG,USED) ; User edit FILEDA Type.
 ; Requires FILEDA, NODE0.
 ; Requires PFILEDA if DA has an actual/prospective parent. Need PFILEDA
 ;for add items/Create DDEF - they're not in AD xref because not items
 ;yet.
 ; Updates NODE0 (not the array, just the node).
 ; Returns XFLG=1 if user ^exited or timed out, else as received.
 ; Requires USED =1 for object or $$DDEFUSED^TIUFLF
 N TYPE,X,Y,NAME,TIUFTMSG,TIUFTLST,DEFLT,DIE,DR
 K DIRUT,DUOUT,DIROUT
 I $P(NODE0,U,4)="O" W !!,"TYPE: Object. Can't edit Type",! G EDTYX
 I USED="YES"!(USED="ERROR") W !!,"TYPE: Entry In Use by Documents; Can't edit Type",! G EDTYX
 S PFILEDA=+$G(PFILEDA),NAME=$P(NODE0,U)
 D TYPELIST(NAME,FILEDA,PFILEDA,.TIUFTMSG,.TIUFTLST) G:$D(DTOUT) EDTYX
 I $D(TIUFTMSG("T")) W !!,TIUFTMSG("T"),!,"Can't edit Type" S XFLG=1 D PAUSE^TIUFXHLX G EDTYX
 I $D(TIUFTMSG("R")),$D(TIUFTMSG("R1")) W !!,TIUFTMSG("R"),!,TIUFTMSG("R1"),!
 I $D(TIUFTMSG("O")) W:'$D(TIUFTMSG("R")) ! W TIUFTMSG("O"),!
 I TIUFTLST="" W !!,"TYPE: ",$S($D(TIUFTMSG):TIUFTMSG(1),1:" Faulty entry; File has entries of every permitted Type with the same Name"),! D PAUSE^TIUFXHLX S XFLG=1 G EDTYX
 S DEFLT=$P(NODE0,U,4) S:$L(TIUFTLST,U)=3 DEFLT=$P(TIUFTLST,U,2) S:DEFLT="DOC" DEFLT="TL"
READTYP K DUOUT S TYPE=$S(DEFLT'="":$$SELTYPE^TIUFLF8(FILEDA,DEFLT),1:$$SELTYPE^TIUFLF8(FILEDA))
 I $D(DUOUT)!$D(DTOUT) G EDTYX
 I TYPE="" W "  ?? Enter appropriate Type or '^' to exit",! H 2 G READTYP
 S:TYPE="TL" TYPE="DOC" S DIE=8925.1,DR=".04////"_TYPE D ^DIE
 S NODE0=^TIU(8925.1,FILEDA,0)
EDTYX S:$D(DUOUT)!$D(DTOUT) XFLG=1
 Q
 ;
