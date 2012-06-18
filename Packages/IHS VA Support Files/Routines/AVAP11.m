AVAP11 ;IHS/ASDST/GTH - DISABLE AD XREF ON FILE 4 ; [ 05/08/1999  9:20 AM ]
 ;;93.2;VA SUPPORT FILES;**11**;JUL 01, 1993
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY Q
 ;
 D HOME^%ZIS,DT^DICRW
 ;
 S X=$T(+2)
 W !,$$C^XBFUNC("--  "_$P(X,";",4)_" v "_$P(X,";",3)_" Patch "_$P(X,"*",3)_"  --")
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$C^XBFUNC("Hello, "_$P(X,",",2)_" "_$P(X,",")),!!,$$C^XBFUNC("Checking Environment for Version "_$P($T(+2),";",3)_" of "_$P($T(+2),";",4)_".")
 ;
 S X="AVA",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0 D  Q
 . W !!,$$C^XBFUNC("You Have More Than One Entry In The")
 . W !,$$C^XBFUNC("PACKAGE File with an ""AVA"" prefix.")
 . W !,$$C^XBFUNC("One entry needs to be deleted.")
 . W !,$$C^XBFUNC("Please FIX IT! Before Proceeding."),!
 . D SORRY
 .Q
 ;
 S DA=+Y
 W !!,$$C^XBFUNC("AVA version '"_$G(^DIC(9.4,DA,"VERSION"))_"' currently installed")
 ;
 S X=$G(^DD("VERSION"))
 W !!,$$C^XBFUNC("Need at least FileMan 21.....FileMan "_X_" Present")
 I X<21 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 W !!,$$C^XBFUNC("Need at least Kernel 8.....Kernel "_X_" Present")
 I X<8 D SORRY Q
 ;
 W !!,$$C^XBFUNC("ENVIRONMENT OK.")
 ;
 I '$$DIR^XBDIR("E","","","","","",1) Q
 ;
 D HELP("INTRO")
 ;
 G EOJ:'$$DIR^XBDIR("YO","Run patch 11","N")
 ;
 D WAIT^DICD
 W !,"Disabling dd..."
 ;
UPDATEDD ;EP - From A9AVA11, for RPI, non-interactive update.
 NEW AVAWRITE,DA
 S AVAWRITE='$D(ZTQUEUED)
 F %=1:1 Q:'$D(^DD(4,.01,1,%))  I $P(^(%,0),"^",2)="AD" S DA=% Q
 I '$D(DA) W:AVAWRITE !,"X-REF 'AD' not found in File 4, Field .01.",!,"That's OK!!" G EOJ
 ;
 W:AVAWRITE !,"Disabling SET of x-ref 'AD'..."
 I $E(^DD(4,.01,1,DA,1),1,4)'="Q  ;" S ^(1)="Q  ;"_^(1)
 W:AVAWRITE "Done disabling SET."
 ;
 W:AVAWRITE !,"Disabling KILL of x-ref 'AD'..."
 I $E(^DD(4,.01,1,DA,2),1,4)'="Q  ;" S ^(2)="Q  ;"_^(2)
 W:AVAWRITE "Done disabling KILL."
 ;
 S ^DD(4,.01,"DT")=$$DT^XLFDT
 KILL DA ;
 W:AVAWRITE !,"dd update complete."
 W:AVAWRITE !!,"Patch 11 to AVA 93.2 is complete.",!
 ;
 D MAIL^XBMAIL("XUMGR-XUPROGMODE","INTRO^AVAP11")
 ;
EOJ ;     
 KILL DIC,DIR,DIE,DA,DR,X,Y
 Q
 ;
INTRO ;
 ;;This is Patch 11 to AVA 93.2.
 ;;  
 ;;The 'AD' x-ref on file 4, field .01, will be disabled.  The 'AD'
 ;;x-ref was added by the VA to keep the LOCATION file in sync with
 ;;file 4 (INSTITUTION) when additions were made to file 4 by the VA's
 ;;PCE software.  This is unneeded by IHS since all additions of
 ;;locations are made into the LOCATION file, which is DINUM'd to
 ;;file 4.  Unfortunately, the 'AD' x-ref on file 4 causes an
 ;;<UNDEF> to occur when IHS attempts to add locations into the
 ;;LOCATION file.
 ;; 
 ;;This patch disables the 'AD' x-ref on file 4, field .01.
 ;;  
 ;;###
 ;
HELP(L) ;EP - Display text at label L.
 W !
 F %=1:1 W !?4,$P($T(@L+%),";",3) Q:$P($T(@L+%+1),";",3)="###"
 Q
 ;
SORRY ;
 W *7,!,$$C^XBFUNC("Sorry....")
 D EOJ
 Q
 ;
