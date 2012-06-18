GMRCYP26 ;SLC/JFR - Pre and post-install GMRC*3*26 ;6/06/02@09:21
 ;;3.0;CONSULT/REQUEST TRACKING;**26**;DEC 27, 1997
 Q
PRE ; Pre-install entry point
 ;
 ; delete existing "AC" x-refs on file 123.5, subflds 123.33 and 123.34
 N GMRCFL
 F GMRCFL=123.555,123.58 D
 . D DELIX^DDMOD(GMRCFL,.02,1) ;deletes x-ref from ^DD
 Q
POST ; post-install entry point
 ; loop entries in file and delete existing data x-refs
 N GMRCSRV
 S GMRCSRV=0
 F  S GMRCSRV=$O(^GMR(123.5,GMRCSRV)) Q:'GMRCSRV  D
 . K ^GMR(123.5,GMRCSRV,123.33,"AC")
 . K ^GMR(123.5,GMRCSRV,123.34,"AC")
 ;
 ; trigger new "AC" index on file 123.5, subflds 123.33 and 123.34
 N GMRCREC,DIK,DA,GMRCFLD
 S GMRCREC=0
 F  S GMRCREC=$O(^GMR(123.5,GMRCREC)) Q:'GMRCREC  D
 . S DA(1)=GMRCREC
 . F GMRCFLD=123.33,123.34 D
 .. S DIK="^GMR(123.5,"_DA(1)_","_GMRCFLD_","
 .. S DIK(1)=".02^AC"
 .. D ENALL^DIK
 .. Q
 . Q
 Q
