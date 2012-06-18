ORWDAL32 ; SLC/REV - Allergy calls to support windows ;17-Aug-2011 12:47;DU
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,85,109,190,1007,1008**;Dec 17, 1997
 ;
DEF(LST) ; Get dialog data for allergies
 N ILST,I,X S ILST=0
 S LST($$NXT)="~Reactions" D REACTTYP
 S LST($$NXT)="~Top Ten" D TOPTEN
 S LST($$NXT)="~Observ/Hist" D OBSHIST
 S LST($$NXT)="~Severity" D SEVERITY
 Q
TOPTEN ;  Get top ten symptoms from Allergy Site Parameters file
 N X0,I,CNT S I=0,X0="",CNT=0
 F  S I=$O(^GMRD(120.84,1,1,I)),CNT=CNT+1 Q:+I=0!(CNT>10)  D
 . S X0=^GMRD(120.84,1,1,I,0) Q:'$D(^GMRD(120.83,X0))  Q:$P(^GMRD(120.83,X0,0),"^")="OTHER REACTION" ;IHS/MSC/MGH 1008
 . I $L($T(SCREEN^XTID)) Q:$$SCREEN^XTID(120.83,.01,X0_",")  ;IHS/MSC/MGH 1008
 . S LST($$NXT)="i"_X0_U_$P($G(^GMRD(120.83,X0,0)),U,1)
 Q
ALLSRCH(Y,X) ; Return list of partial matches  ; CHANGED TO PRODUCE TREEVIEW IN GUI
 N ORX,ROOT,XP,CNT,ORFILE,ORSRC,INAC,ORIEN,ORREAX S ORIEN=0,CNT=0,ORSRC=0,ORFILE="",ORREAX=""
 S ORX=X,X=$$UP^XLFSTR(X)
 F ROOT="^GMRD(120.82,""B"")","^GMRD(120.82,""D"")",$$B^PSNAPIS,$$T^PSNAPIS,"^PSDRUG(""B"")","^PSDRUG(""C"")","^PS(50.416,""P"")","^PS(50.605,""C"")" D
 . S INACT=0,ORSRC=ORSRC+1,ORFILE=$P(ROOT,",",1)_")",ORSRC(ORSRC)=$P($T(FILENAME+ORSRC),";;",2)
 . I (ORSRC'=2),(ORSRC'=6) S CNT=CNT+1,Y(CNT)=ORSRC_U_ORSRC(ORSRC)_U_U_U_"TOP"_U_"+"
 . I $D(@ROOT@(X)) D
 . . I ORSRC=1,X="OTHER ALLERGY/ADVERSE REACTION" Q  ;IHS/MSC/MGH 1008
 . . I ORSRC=5!(ORSRC=6) Q  ;Patch 8 don't send file 50 entries
 . . ;IHS/MSC/MGH Screen out inactive allergies
 . . S ORIEN=$O(@ROOT@(X,0))
 . . I ORSRC=1!(ORSRC=2) S INAC=$$CHECK(ORIEN) Q:+INAC
 . . ;end of mods
 . . I ORSRC=2 S CNT=CNT+1,Y(CNT)=ORIEN_U_$P($G(^GMRD(120.82,+ORIEN,0)),U,1)_" <"_X_">"_ROOT
 . . E  I ORSRC=6 S CNT=CNT+1,Y(CNT)=ORIEN_U_$P($G(^PSDRUG(+ORIEN,0)),U,1)_" <"_X_">"_ROOT
 . . E  S CNT=CNT+1,Y(CNT)=ORIEN_U_X_ROOT
 . . S ORREAX=$S($P(Y(CNT),U,3)?1"GMR".E:$P($G(^GMRD(120.82,+Y(CNT),0)),U,2),1:"D")
 . . S Y(CNT)=Y(CNT)_U_ORREAX_U_$S(ORSRC=2:1,ORSRC=6:5,1:ORSRC)
 . S XP=X F  S XP=$O(@ROOT@(XP)) Q:XP=""  Q:$E(XP,1,$L(X))'=X  D
 . . S ORIEN=$O(@ROOT@(XP,0))
 . . I ORSRC=1,XP="OTHER ALLERGY/ADVERSE REACTION" Q  ;IHS/MSC/MGH 1008
 . . ;IHS/MSC/MGH Changes made to screen out inactive allergies
 . . I ORSRC=5!(ORSRC=6) Q
 . . I ORSRC=1!(ORSRC=2) S INAC=$$CHECK(ORIEN) Q:+INAC
 . . ;End of mods
 . . I ORSRC=2 S CNT=CNT+1,Y(CNT)=ORIEN_U_$P($G(^GMRD(120.82,+ORIEN,0)),U,1)_" <"_XP_">"_ROOT ; partial matches
 . . E  I ORSRC=6 S CNT=CNT+1,Y(CNT)=ORIEN_U_$P($G(^PSDRUG(+ORIEN,0)),U,1)_" <"_XP_">"_ROOT ; partial matches
 . . E  S CNT=CNT+1,Y(CNT)=ORIEN_U_XP_ROOT
 . . S ORREAX=$S($P(Y(CNT),U,3)?1"GMR".E:$P($G(^GMRD(120.82,+Y(CNT),0)),U,2),1:"D")
 . . S Y(CNT)=Y(CNT)_U_ORREAX_U_$S(ORSRC=2:1,ORSRC=6:5,1:ORSRC)
 Q
FILENAME ; Display text of filenames for search treeview
 ;;VA Allergies File
 ;;VA Allergies File (Synonyms)  SPACER ONLY - NOT DISPLAYED
 ;;National Drug File - Generic Drug Name
 ;;National Drug file - Trade Name
 ;;Local Drug File
 ;;Local Drug File (Synonyms)  SPACER ONLY - NOT DISPLAYED
 ;;Drug Ingredients File
 ;;VA Drug Class File
 ;;
REACTTYP ; Get the reaction types
 ;F X="A^Allergy","R^Adverse Reaction" D  ; NEED ART CHANGES FIRST!!
 F X="D^Drug","F^Food","O^Other","DF^Drug,Food","DO^Drug,Other","FO^Food,Other" D
 . S LST($$NXT)="i"_X
 Q
OBSHIST ; Observed or historical
 F X="o^Observed","h^Historical" D
 . S LST($$NXT)="i"_X
 Q
SEVERITY ; Severity
 F X="1^Severe","2^Moderate","3^Mild" D
 . S LST($$NXT)="i"_X
 Q
SYMPTOMS(Y,FROM,DIR) ; Return a subset of symptoms
 ; .Return Array, Starting Text, Direction
 N I,IEN,CNT,X S I=0,CNT=44
 F  Q:I'<CNT  S FROM=$O(^GMRD(120.83,"B",FROM),DIR) Q:FROM=""  D
 . I FROM="OTHER REACTION" Q  ;Don't send this entry IHS/MSC/MGH 1008
 . S IEN=0 F  S IEN=$O(^GMRD(120.83,"B",FROM,IEN)) Q:'IEN  D
 . . S I=I+1
 . . S Y(I)=IEN_U_FROM
 Q
NXT() ; Increment index of LST
 S ILST=ILST+1
 Q ILST
 ;=====================================================
 ;  NEXT THREE CALLS NEED ART CHANGES BEFORE IMPLEMENTING
 ;=====================================================
EDITLOAD(Y,ORALIEN) ; Load an allergy/adverse reaction for editing
 Q:+$G(ORALIEN)=0
 N ORNODE,I
 S ORNODE=$NAME(^TMP("GMRA",$J)),I=0
 ;D GETREC^GMRAGUI(ORALIEN,ORNODE)
 S Y=ORNODE
 Q
EDITSAVE(Y,ORALIEN,ORDFN,OREDITED) ; Save Edit/Add of an allergy/adverse reaction
 N ORNODE
 S ORNODE=$NAME(^TMP("GMRA",$J))
 M @ORNODE=OREDITED
 ;D FILE^GMRAEDIT(ORALIEN,ORDFN,ORNODE)
 S Y="-1^Save not yet implemented."
 Q
SENDBULL(Y,ORDUZ,ORDFN,ORTEXT,ORCMTS) ; Send bulletin if user attempts free-text entry
 I '$$PATCH^XPDUTL("GMRA*4.0*17") S Y="-1^Unable to send bulletin." Q
 I '$D(ORCMTS) D
 . S Y=$$SENDREQ^GMRAPES0(ORDUZ,ORDFN,ORTEXT)
 E  D
 . S Y=$$SENDREQ^GMRAPES0(ORDUZ,ORDFN,ORTEXT,.ORCMTS)
 Q
CHECK(ORIEN) ;Check to see if allergy is active)
 N VALUE,STAT,STATUS
 S VALUE=0
 S STAT=$O(^GMRD(120.82,ORIEN,"TERMSTATUS",$C(0)),-1) I STAT'=""  D
 .S STATUS=$P($G(^GMRD(120.82,ORIEN,"TERMSTATUS",STAT,0)),U,2)
 .I STATUS=0 S VALUE=1
 Q VALUE
