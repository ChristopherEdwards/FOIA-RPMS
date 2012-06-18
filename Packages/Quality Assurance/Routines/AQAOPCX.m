AQAOPCX ; IHS/ORDC/LJF - EXTRA SCREENS ON REPORTS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This is an extrinsic function called by trending reports to screen
 ;occurrences by the extra sorts that can be added to the reports.
 ;Called by ^AQAOPC11,^AQAOPC21,^AQAOPC41.
 ;Call based on existence of variable AQAOXS.
 ;
CHK(AQAOL)  ;ENTRY POINT EXTR FUNCTION to screen occ by user selected items
 ;variable AQAOL=ifn in QI SORT file
 ;
 N AQAOFLG,X,Y,Z,AQAONOD,I,AQAOX,AQAOY,AQAOICD0
 S AQAOFLG=0 K AQAOARS
 D MAINCHK ;check entries against screen
 I $D(AQAOARS) S AQAOFLG=1
 Q AQAOFLG ;1=keep occ, 0=bypass occ
 ;
 ;
MAINCHK ; >> SUBRTN to screen by items selected by user
 ; find data within occurrence for sort requested
 S X=$G(^AQAO1(9,AQAOL,"IFN")) Q:X=""  X X Q:AQAONOD=""  ;sets AQAONOD
 S AQAOX=0 F  S AQAOX=$O(@AQAONOD) Q:AQAOX=""  D
 .S (AQAOFL,DIC)=$P(^AQAO1(9,AQAOL,0),U,6),(AQAOFD,DR)=$P(^(0),U,7)
 .S DA=AQAOX,DIQ(0)="IE" K ^UTILITY("DIQ1",$J) D EN^DIQ1
 .S AQAOY=^UTILITY("DIQ1",$J,AQAOFL,AQAOX,AQAOFD,"I") Q:AQAOY=""
 .S AQAOY1=^UTILITY("DIQ1",$J,AQAOFL,AQAOX,AQAOFD,"E")
 .;
 .; first check: all values selected OR matches one user selected
 .I $D(AQAOXS(0))!($D(AQAOXS(1,+AQAOY))) S AQAOFLG=1 D XTRACHK
 .;
 .I AQAOFLG=1 D  ;if passed both checks, set printable value
 ..I '$D(AQAOXS(0)),'$D(AQAOXS(1,+AQAOY)) Q
 ..I AQAOXSM="PROV"  S AQAOARS($$CLASS_$$TYPE_+AQAOY)="" Q
 ..S AQAOARS(AQAOY1)=""
 K ^UTILITY("DIQ1",$J) Q
 ;
 ;
XTRACHK ; >> SUBRTN to check xtra screen requested by user
 S I=1
 F  S I=$O(AQAOXS(I)) Q:I=""  Q:AQAOFLG=0  D
 .S Y=$G(^AQAO1(9,AQAOL,"SCREEN")) X Y
 .I Z="" S AQAOFLG=0 Q
 .I Z'[AQAOXS(I) S AQAOFLG=0
 Q
 ;
CLASS() ; -- EXTRN VAR to return provider class if any
 I AQAOY'["VA(200" Q ""
 S X=$$VAL^XBDIQ1(200,+AQAOY,53.5)
 Q $S(X="":"",1:X_": ")
 ;
TYPE() ; -- EXTRN VAR to return provider, person, or vendor
 Q $S(AQAOY["AUTTVNDR":"VENDOR",$$CLASS="":"PERSON",1:"PROVIDER")_" #"
