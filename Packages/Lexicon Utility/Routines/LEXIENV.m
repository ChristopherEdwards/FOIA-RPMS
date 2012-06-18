LEXIENV ; ISL Environment Check                    ; 09-23-96
 ;;2.0;LEXICON UTILITY;;Sep 23, 1996
 ;
EN N Y
 I +($G(XPDENV))=0 D
 . W !,"Update",?15,"Clinical Lexicon Utility v 1.0       Problem List v 2.0"
 . W !,"To",?15,"Lexicon Utility v 2.0                Problem List v 2.0*7",!
 I $S($D(DUZ)[0:1,$D(DUZ(0))[0:1,'DUZ:1,1:0) W !!,$C(7),">> DUZ and DUZ(0) must be defined as an active user to initialize." S XPDQUIT=2
 I '$D(^LEX) W !!,$C(7),">> Cannot find Lexicon global, ^LEX must be loaded into or ",!,"   translated to this account" G ABRT
 ;
 ;IHS/ITSC/LJF 03/28/2003 added check for ACPT patch #2; must have Effective Date multiple in ^ICPT
 I '$D(^DD(81,60,0)) W !!,"***** You must have ACPT patch #2 installed! ******" G ABRT
 ;
 I +($G(XPDENV))>0 G END
 W !
END ;
 Q
RTN(X) ; is Routine X in this UCI
 S X=$G(X) Q:'$L(X) 0 X ^%ZOSF("TEST") Q $T
ABRT ; Abort
 W ! S XPDQUIT=1 Q
