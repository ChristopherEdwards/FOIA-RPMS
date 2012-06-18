INHPCO2 ; JKB ; 29 Oct 97 08:58 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;;
 ;
 ;
CONTROLS ; re-index GIS control files
 N INFILE
 W:$G(INVERBOS) !!,"Re-indexing GIS control files:"
 F INFILE="^INRHD(","^INRHNS(","^INRHR(","^INRHS(","^INRHT(","^INTHERL(","^INTHL7F(","^INTHL7FT(","^INTHL7M(","^INTHL7S(","^INTHPC(","^INVD(4090.2," D:$G(INVERBOS)  D REINDEX(INFILE)
 .N X S X=@(INFILE_"0)")
 .W !,$P(X,U)_" (#"_+$P(X,U,2)_")  "_$P(X,U,4)_" entries started at "_$P($$CDATASC^%ZTFDT($H,2,3)," ",2)
 Q
 ;
REINDEX(DIU,INDD) ; kill & re-index all xrefs for a file
 ; Input : DIU  (req) = file global root in DIC format
 ;         INDD (opt) = re-index the DD also (boolean)
 ; Output: void
 ; Note  : derived from ^DIU1
 N DA,DCNT,DH,DI,DIC,DIK,DV,DW,X,Y
 K ^UTILITY("DIK",$J)
 S DI=+$P(@(DIU_"0)"),U,2)
 ; get xref data and put in ^UTILITY
 S X=0,DIK=DIU D DD^DIK
 ; loop thru xref data (DW=file#, DV=field#, DH=xref#)
 S (X,DW)=0
 F  S DW=$O(^UTILITY("DIK",$J,DW)) Q:'DW  S DV=0 D
 .F  S DV=$O(^UTILITY("DIK",$J,DW,DV)),DH=0 Q:'DV  S DH=0 D
 ..F  S DH=$O(^UTILITY("DIK",$J,DW,DV,DH)) Q:'DH  D
 ...; the 6 node designates a non-'re-runnable' xref
 ...I $G(^DD(DW,DV,1,DH,6)) Q
 ...; move xref data into local X array, incrementing counter
 ...S Y=^UTILITY("DIK",$J,DW,DV,DH),X=X+1,X(X)=Y,X(X,0)=DW_U_DV
 ...; pick up triggers (they're stored differently by DD^DIK)
 ...I $P(Y,U,3)="",'Y,$D(^UTILITY("DIK",$J,DW,DV,DH,0)) S X(X)=^(0)
 K ^UTILITY("DIK",$J)
 ; if no xrefs, just re-index the DD and quit
 I 'X D:$G(INDD) DD(DI) Q
 ; loop thru xref info and kill 'regular' xrefs
 F X=X:-1:1 S Y=$P(X(X),U,2,9) I Y]"",Y'[U,+X(X)=DI K @(DIK_"Y)"),X(X)
 ; set flag to not fire bulletins
 S DIK(0)="B"
 ; execute delete logic for 'special' xrefs (or all xrefs?)
 I $O(X(0)) S X=2,(DA,DCNT)=0 D DIXALL^DIK,CNT^DIK1
 ; re-index the file's DD and its data
 K X D:$G(INDD) DD(DI) S DIK=DIU D IXALL^DIK
 Q
DD(DI) ; clean re-index of the DD
 ; Input:  DI = file number (do not pass by ref - it is modified)
 N DDD S DDD=$O(^DIC(DI))
 F  D  S DI=$O(^DD(DI)) I 'DI!(DI=DDD) Q
 .S DIK="^DD(DI,",DA(1)=DI
 .; kill the DD xrefs
 .K ^DD(DI,"B"),^("GL"),^("IX"),^("RQ"),^("GR"),^("SB")
 .; re-index the field definitions
 .I $D(^DD(DI,0))#2 D IXALL^DIK
