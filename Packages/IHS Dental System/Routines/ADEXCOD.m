ADEXCOD ; IHS/HQT/MJL  - UPDATE ADA CODE FILE ;08:42 PM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;------->INIT
 S U="^"
 I $D(^ADEXCOD)<10 D  K DIFQ G END1
 . W !!,*7,"The ADEXCOD global must be restored before installing the IHS DENTAL package.",!,"Please review the installation instructions."
 I $P(^ADEXCOD(0),U)'["9-1-94" D  K DIFQ G END1
 . W !!,*7,"The CURRENT VERSION of the ADEXCOD global must be restored",!,"before installing the IHS DENTAL package.  Please review the installation",!,"instructions."
 ;
CONF S %=0
 W !,"Did you back up the ^AUTTADA global before beginning this installation"
 D YN^DICN
 I %=0 W !?5,"Answer NO if you did not save a backup of the ^AUTTADA global before",!,"beginning this installation.",! G CONF
 I %'=1 W !!,"Back up ^AUTTADA before installing the IHS DENTAL package.",!,"Keep the backup on file." K DIFQ G END1
 W !!,"CHECKING FOR DUPLICATE CODES AND REINDEXING"
 D ^ADEXCOD2
 W !!,"UPDATING ADA CODE FILE NOW."
 ;W !,"TEST--SKIPPING UPDATE" G END ;***COMMENT AND KEEP
 ;Set Input Transforms
 S ADEY=0
 F ADEX=.01:.01:.09,8801 S ADEY=ADEY+1,ADEXFRM(ADEY)=$P(^DD(9999999.31,ADEX,0),U,5,99)
 S ADECOD=0,ADEXFRM(8)=""
CTRL ;------->$O THRU TEMPFILE ^ADEXCOD AND GET CODE
 S ADECOD=$O(^ADEXCOD("B",ADECOD)) G:ADECOD="" END
 S ADEZDFN=0 W "." S ADEZDFN=$O(^ADEXCOD("B",ADECOD,ADEZDFN))
 ;------->IF CODE IN ^AUTTADA, UPDATE
 I $D(^AUTTADA("B",ADECOD)) D UPDATE G CTRL
 ;------->OTHERWISE ADD IT
 D ADD G CTRL
END W !,"ADA CODE File update done!"
END1 K ADERROR,ADEODFN,ADEZDFN,ADECOD,ADEOMN,ADEX,ADEY,ADEXFRM,ADENOD
 ;
RESTYP ;Re-index DENTAL RESOURCE TYPE file
 Q:'$D(^ADERSCT)
 W !!,"Re-indexing the DENTAL RESOURCE TYPE file - please wait.",!
 K ^ADERSCT("B") ;Kill "b" x-ref prior to re-index
 S DIK="^ADERSCT("
 D IXALL^DIK
 Q
 ;
UPDATE S ADEODFN=0
 ;
U1 S ADEODFN=$O(^AUTTADA("B",ADECOD,ADEODFN))
 G:$O(^AUTTADA("B",ADECOD,ADEODFN))]"" U1
 ;KILL OLD "C" AND "D" XREFS
 I $P(^AUTTADA(ADEODFN,0),U,2)]"" K ^AUTTADA("C",$E($P(^AUTTADA(ADEODFN,0),U,2),1,30),ADEODFN)
 I $P(^AUTTADA(ADEODFN,0),U,6)]"" K ^AUTTADA("D",$E($P(^AUTTADA(ADEODFN,0),U,6),1,30),ADEODFN)
 ;S ^AUTTADA(ADEODFN,0)=^ADEXCOD(ADEZDFN,0)
 S ADENOD=^ADEXCOD(ADEZDFN,0)
 F ADEX=1:1:9 D
 . S X=$P(ADENOD,U,ADEX)
 . Q:X=""
 . D  Q:'$D(X)  ;Apply input transform
 . . X ADEXFRM(ADEX)
 . S $P(^AUTTADA(ADEODFN,0),U,ADEX)=X
 D XREF
 K ^AUTTADA(ADEODFN,11) S:$D(^ADEXCOD(ADEZDFN,11,0)) ^AUTTADA(ADEODFN,11,0)=^ADEXCOD(ADEZDFN,11,0)
 I $D(^ADEXCOD(ADEZDFN,11,0)) D TEXT
 I $D(^AUTTADA(ADEODFN,88)),^(88)]"" S ADEOMN=^AUTTADA(ADEODFN,88) K ^AUTTADA("B",ADEOMN),^AUTTADA(ADEODFN,88)
 I $D(^ADEXCOD(ADEZDFN,88)),^(88)]"" D
 . S X=^ADEXCOD(ADEZDFN,88)
 . X ADEXFRM(10) ;Apply input transform
 . Q:'$D(X)
 . S ^AUTTADA(ADEODFN,88)=X,^AUTTADA("B",$E(X,1,30),ADEODFN)=1
 Q
ADD S ADEODFN=$P(^AUTTADA(0),U,3)+1
A1 I $D(^AUTTADA(ADEODFN)) S ADEODFN=ADEODFN+1 G A1
 ;S ^AUTTADA(ADEODFN,0)=^ADEXCOD(ADEZDFN,0) D XREF
 S ADENOD=^ADEXCOD(ADEZDFN,0)
 S ADEXFRM(8)=""
 F ADEX=1:1:9 D
 . S X=$P(ADENOD,U,ADEX)
 . Q:X=""
 . D  Q:'$D(X)  ;Apply input transform
 . . X ADEXFRM(ADEX)
 . S $P(^AUTTADA(ADEODFN,0),U,ADEX)=X
 D XREF
 S ^AUTTADA("B",$E(ADECOD,1,30),ADEODFN)=""
 I $D(^ADEXCOD(ADEZDFN,11,0)) D
 . S ^AUTTADA(ADEODFN,11,0)=^ADEXCOD(ADEZDFN,11,0)
 . D TEXT
 I $D(^ADEXCOD(ADEZDFN,88)),^(88)]"" D
 . S X=^ADEXCOD(ADEZDFN,88)
 . X ADEXFRM(10) ;Apply input transform
 . Q:'$D(X)
 . S ^AUTTADA(ADEODFN,88)=X,^AUTTADA("B",$E(X,1,30),ADEODFN)=1
 S $P(^AUTTADA(0),U,3)=ADEODFN,$P(^(0),U,4)=$P(^(0),U,4)+1
 Q
TEXT S ADETXT=0
 ;NOTE:  There is NO input transform for the field set in next line
 ;because it is a Fileman word-processing field and Fileman doesn't
 ;put input-transforms on wp fields.
 F  S ADETXT=$O(^ADEXCOD(ADEZDFN,11,ADETXT)) Q:'+ADETXT  S:$D(^ADEXCOD(ADEZDFN,11,ADETXT,0)) ^AUTTADA(ADEODFN,11,ADETXT,0)=^ADEXCOD(ADEZDFN,11,ADETXT,0)
 Q
XREF S:$P(^AUTTADA(ADEODFN,0),U,2)]"" ^AUTTADA("C",$E($P(^AUTTADA(ADEODFN,0),U,2),1,30),ADEODFN)=""
 S:$P(^AUTTADA(ADEODFN,0),U,6)]"" ^AUTTADA("D",$E($P(^AUTTADA(ADEODFN,0),U,6),1,30),ADEODFN)=""
 S ^AUTTADA("BA",ADECOD_" ",ADEODFN)=""
 Q
