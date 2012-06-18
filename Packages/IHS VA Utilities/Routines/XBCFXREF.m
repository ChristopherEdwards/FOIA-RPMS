XBCFXREF ; IHS/ADC/GTH - CHECK/FIX XREFS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine checks all REGULAR xrefs at the file level
 ; for selected files to insure all pointed to entries exist.
 ;
START ;
 D INIT
 I XBCFXREF("QFLG") D EOJ Q
 D FILES
 D EOJ
 Q
 ;
INIT ;
 S XBCFXREF("QFLG")=0
 D ^XBKVAR
 W !,"This routine will check the xrefs for the files you select and display",!,"  all errors found.  You may also delete the bad xrefs."
 W !!,"You should probably capture the output to an aux printer."
 S XBCFXREF("DF")=$$DIR^XBDIR("S^1:DISPLAY ONLY;2:DISPLAY & FIX","","1")
 I $D(DIRUT) S XBCFXREF("QFLG")=1 Q
 D ^XBDSET
 I '$D(^UTILITY("XBDSET")) S XBCFXREF("QFLG")=1 Q
 Q
 ;
FILES ; CHECK FILES
 S XBCFXREF("C")=0
 F XBCFXREF("FILE")=0:0 S XBCFXREF("FILE")=$O(^UTILITY("XBDSET",$J,XBCFXREF("FILE"))) Q:XBCFXREF("FILE")=""  D FILE
 Q
 ;
 ;---------------------------------------------------------------------
 ; Gather up xrefs to check
 ;
FILE ; CHECK ONE FILE
 W !!,"Checking the ",$P(^DIC(XBCFXREF("FILE"),0),U,1)," (",XBCFXREF("FILE"),") file"
 KILL XBCFXREF("TBL")
 S XBCFXREF("XREF")=""
 F  S XBCFXREF("XREF")=$O(^DD(XBCFXREF("FILE"),0,"IX",XBCFXREF("XREF"))) Q:XBCFXREF("XREF")=""  S XBCFXREF("XREF FILE")=$O(^(XBCFXREF("XREF"),0)),XBCFXREF("XREF FIELD")=$O(^(XBCFXREF("XREF FILE"),0)) D
 . S XBCFXREF("TBL",XBCFXREF("XREF FILE"),XBCFXREF("XREF FIELD"),XBCFXREF("XREF"))=""
 .Q
 I $D(XBCFXREF("TBL")) D XREFILE KILL XBCFXREF("TBL")
 I $D(XBCFXREF("TBL2")) D CHECK KILL XBCFXREF("TBL2")
 Q
 ;
XREFILE ; CHECK EACH FILE/FIELD CREATING XREFS
 F XBCFXREF("XREF FILE")=0:0 S XBCFXREF("XREF FILE")=$O(XBCFXREF("TBL",XBCFXREF("XREF FILE"))) Q:XBCFXREF("XREF FILE")=""  D  D XREFIELD
 . S XBCFXREF("TOP DA")=0,XBCFXREF("PARENT")=""
 . Q:'$D(^DD(XBCFXREF("XREF FILE"),0,"UP"))  ; quit if not subfile
 . NEW SUBFILE,PARENT,FIELD,LVL
 . S SUBFILE=XBCFXREF("XREF FILE"),PARENT="",LVL=1
 . D BACKUP
 . S XBCFXREF("TOP DA")=LVL,XBCFXREF("PARENT")=PARENT
 . Q
 Q
 ;
BACKUP ; BACKUP TREE (CALLED RECURSIVELY)
 S PARENT=^DD(SUBFILE,0,"UP")
 S FIELD=$O(^DD(PARENT,"SB",SUBFILE,""))
 I $D(^DD(PARENT,0,"UP")) S SUBFILE=PARENT,LVL=LVL+1 D BACKUP ; Recurse
 Q
 ;
XREFIELD ; CHECK EACH FIELD CREATING XREFS
 F XBCFXREF("XREF FIELD")=0:0 S XBCFXREF("XREF FIELD")=$O(XBCFXREF("TBL",XBCFXREF("XREF FILE"),XBCFXREF("XREF FIELD"))) Q:XBCFXREF("XREF FIELD")=""  D XREF
 Q
 ;
XREF ; CHECK XREFS ON FIELD
 NEW G,L,S,X,Y
 KILL XBCFXRT,XBCFXREF("XREFS")
 D ^XBGXREFS(XBCFXREF("XREF FILE"),XBCFXREF("XREF FIELD"),.XBCFXRT)
 F XBCFXREF("XN")=0:0 S XBCFXREF("XN")=$O(XBCFXRT(XBCFXREF("XREF FIELD"),XBCFXREF("XN"))) Q:XBCFXREF("XN")=""  S X=XBCFXRT(XBCFXREF("XREF FIELD"),XBCFXREF("XN")) D
 . Q:$P(X,U,2)=""  ; must be trigger
 . Q:$P(X,U,3)]""  ; not REGULAR xref
 . Q:'$D(XBCFXREF("TBL",XBCFXREF("XREF FILE"),XBCFXREF("XREF FIELD"),$P(X,U,2)))  ; not of interest
 . Q:'$D(XBCFXRT(XBCFXREF("XREF FIELD"),XBCFXREF("XN"),"S"))  ; no set
 . S Y=XBCFXRT(XBCFXREF("XREF FIELD"),XBCFXREF("XN"),"S")
 . I '$F(Y,",DA"),'$F(Y,",D0") D  Q
 .. W !?2,$P(X,U,2)," doesn't use DA or D0.  Skipping."
 .. Q
 . I $F(Y,",D0)=") D SAVE Q
 . I XBCFXREF("PARENT")="",$F(Y,",DA)=") D SAVE Q
 . I XBCFXREF("PARENT")]"" S S=",DA("_XBCFXREF("TOP DA")_"))=" I $F(Y,S) D SAVE Q
 . Q
 KILL XBCFXRT
 Q
 ;
SAVE ; SAVE XREF TO CHECK
 S XBCFXREF("C")=XBCFXREF("C")+1
 S XBCFXREF("TBL2",XBCFXREF("C"))=$P(X,U,2) ; save it
 Q
 ;
 ;---------------------------------------------------------------------
 ; Check data global for xrefs previously gathered
 ;
CHECK ; CHECK DATA GLOBAL FOR XREFS
 W !!,"  Checking the following xrefs:"
 NEW I
 F I=0:0 S I=$O(XBCFXREF("TBL2",I)) Q:I=""  W:$X>73 ! W "  ",XBCFXREF("TBL2",I)
 F XBCFXREF("C")=0:0 S XBCFXREF("C")=$O(XBCFXREF("TBL2",XBCFXREF("C"))) Q:XBCFXREF("C")=""  S XBCFXREF("XREF")=XBCFXREF("TBL2",XBCFXREF("C")) D CHKXREF
 Q
 ;
CHKXREF ; CHECK ONE XREF
 W !!,"  Checking the """,XBCFXREF("XREF"),""" xref."
 NEW G,L,R,V,X,Y
 S X=XBCFXREF("XREF")
 S G=^DIC(XBCFXREF("FILE"),0,"GL"),R=G_""""_X_""",",X=$E(R,1,$L(R)-1)_")",L=$L(R)
 F  S X=$Q(@X) Q:$E(X,1,L)'=R  D
 . Q:@X  ; quit if mnemonic xref
 . S Y=+$P(X,",",$L(X,","))
 . Q:$D(@(G_Y_",0)"))
 . W !?4,$$MSMZR^ZIBNSSV," does not exist.",!?6,"XREF node=",X
 . I XBCFXREF("DF")=2 KILL @X W " deleted."
 .Q
 Q
 ;
 ;---------------------------------------------------------------------
EOJ ;
 KILL ^UTILITY("XBDSET",$J)
 KILL XBCFXREF,XBCFXRT
 KILL DIRUT,DUOUT,DTOUT
 W !!,"All done",!
 Q
 ;
