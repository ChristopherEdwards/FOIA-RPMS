BGOVPOV1 ; MSC/IND/DKM - Fix VPOV sequencing (primary first) ;20-Mar-2007 13:52;DKM
 ;;1.1;BGO COMPONENTS;**3**;Mar 20, 2007
 ; Display routine help
HELP ;EP
 N LP,X
 F LP=0:1 S X=$P($T(HELPDATA+LP),";;",2,99)  Q:X="<END>"  W X,!
 Q
 ; Finds all visits with improperly sequenced VPOVs
 ; If FIX is true, the VPOVs will be resequenced
FINDALL(FIX) ;EP
 N VIEN,FND,FIXED,LP
 K ^XTMP("BGOVPOV1")
 S ^XTMP("BGOVPOV1",0)=DT_U_DT
 S (FND,FIXED,VIEN)=0,FIX=+$G(FIX)
 F LP=0:1  S VIEN=$O(^AUPNVPOV("AD",VIEN)) Q:'VIEN  D
 .W:'(LP#1000) "."
 .Q:$$GETVPOVS(VIEN)
 .S FND=FND+1
 .I FIX,$$FIXVPOVS(VIEN)=1 S FIXED=FIXED+1,^XTMP("BGOVPOV1","FIXED",VIEN)=""
 .E  S ^XTMP("BGOVPOV1","NOT FIXED",VIEN)=""
 S ^XTMP("BGOVPOV1","FIXED")=FIXED,^("NOT FIXED")=FND-FIXED
 W !,"Visits with improperly sequenced VPOVs: ",FND,!
 W !,"Visits with successfully resequenced VPOVs: ",FIXED,!
 Q
 ; Called from BGOVPOV to insure that the primary is the first entry.
 ;  VIEN = IEN of visit to inspect
 ; .VPOV = IEN of entry to track (optional - returned as new IEN if changed)
 ;  Returns: 0 = VPOV entries require no resequencing
 ;           1 = VPOV entries were successfully resequenced
 ;           2 = VPOV entries were not successfully resequenced
FIXVPOVS(VIEN,VPOV) ;EP
 N VPOV1,VPOV2,RET
 Q:$$GETVPOVS(VIEN,.VPOV1,.VPOV2) 0
 S RET=$$SWAP(VPOV1,VPOV2)
 Q:'RET 2
 S VPOV=$G(VPOV)
 S VPOV=$S(VPOV=VPOV1:VPOV2,VPOV=VPOV2:VPOV1,1:VPOV)
 Q 1
 ; Returns two VPOVs to be swapped.
 ;  VIEN = IEN of visit to inspect
 ;  VPOV1, VPOV2 = VPOV's to be swapped
 ;  Return value is 1 if VPOVs are in correct order
GETVPOVS(VIEN,VPOV1,VPOV2) ;EP
 S VPOV1=$$FNDPRI(VIEN)
 Q:'VPOV1 1
 S VPOV2=$O(^AUPNVPOV("AD",VIEN,0))
 Q:'VPOV2!(VPOV2=VPOV1) 1
 Q 0
 ; Swap VPOVs
 ; Returns true if successful
SWAP(VPOV1,VPOV2) ;
 N FDA,RET
 Q:'$$BLDFDA(VPOV1,VPOV2,.FDA) 0
 S RET=$$UPDATE^BGOUTL(.FDA,"@")
 Q $S(RET<0:0,1:1)
 ; Build FDA array for swap
 ; Returns true if successful
BLDFDA(VPOV1,VPOV2,FDA,FLG) ;
 N REC,ERR,FLD,FNUM,IENS1,IENS2
 S IENS1=VPOV1_",",IENS2=VPOV2_",",FNUM=9000010.07
 D GETS^DIQ(FNUM,IENS1,"**","I","REC","ERR")
 Q:$$REFERR 0
 S FLD=""
 F  S FLD=$O(REC(FNUM,IENS1,FLD)) Q:'$L(FLD)  D
 .Q:$$GET1^DID(FNUM,FLD,,"TYPE")="COMPUTED"
 .S FDA(FNUM,IENS2,FLD)=REC(FNUM,IENS1,FLD,"I")
 Q:'$G(FLG) $$BLDFDA(VPOV2,VPOV1,.FDA,1)
 S FLD=""
 F  S FLD=$O(FDA(FNUM,IENS1,FLD)) Q:'$L(FLD)  D
 .I FDA(FNUM,IENS1,FLD)=FDA(FNUM,IENS2,FLD) D
 ..K FDA(FNUM,IENS1,FLD),FDA(FNUM,IENS2,FLD)
 Q:$D(FDA(FNUM,IENS1,.03)) 0
 Q:$D(FDA(FNUM,IENS1,.02)) 0
 Q 1
REFERR() I $D(ERR("DIERR",1,"TEXT",1)) D  Q 1
 .S ^XTMP("BGOVPOV1","ERROR",VPOV1)=ERR("DIERR",1,"TEXT",1)
 Q 0
 ; Display POVs associated with a visit
DISPPOVS(VIEN) ;
 N VPOV,X
 S VPOV=0
 F  S VPOV=$O(^AUPNVPOV("AD",VIEN,VPOV)) Q:'VPOV  D
 .S X=$G(^AUPNVPOV(VPOV,0)),Y=$G(^(12))
 .W !,VIEN,": ",VPOV,!?5,"0: ",X,!?4,"12: ",Y,!!
 Q
 ; Return IEN of primary POV for a visit
FNDPRI(VIEN) ;EP
 N VPOV,RET,X
 S VPOV=0
 F  S VPOV=$O(^AUPNVPOV("AD",VIEN,VPOV)) Q:'VPOV  D  Q:$D(RET)
 .S X=$G(^AUPNVPOV(VPOV,0))
 .I $P(X,U,3)=VIEN,$P(X,U,12)="P" S RET=VPOV
 Q $G(RET)
HELPDATA ;;
 ;;
 ;;When BGOVPOV files VPOV entries, it does not place the primary POV
 ;;first.  PCC expects the primary POV to always have the lowest IEN
 ;;of POV's associated with a visit.  This utility aids in identifying
 ;;and fixing VPOV entries that are improperly sequenced.  The following
 ;;entry points are available:
 ;;
 ;;FIXVPOVS: This entry point accepts a visit IEN as its parameter.
 ;;When invoked, it will examine the specified visit and resequence
 ;;the associated POV entries if necessary.  It will return one of
 ;;the following values:
 ;;
 ;;     0 = No resequencing required
 ;;     1 = Resequencing succeeded
 ;;     2 = Resequencing failed
 ;;
 ;;FINDALL: This entry point will search all visits with associated
 ;;POV entries and report any with improperly sequenced entries.
 ;;It accepts an optional parameter.  If this parameter is passed
 ;;and has a nonzero value, improperly sequenced entries will be
 ;;repaired automatically.
 ;;
 ;;This entry point stores the results of the search in the
 ;;^XTMP("BGOVPOV1") global.  This global may be examined to
 ;;determine which visits were successfully resequenced
 ;;(listed under ^XTMP("BGOVPOV1","FIXED")) and which were not
 ;;(listed under ^XTMP("BGOVPOV1","NOT FIXED")).
 ;;
 ;;
 ;;<END>
