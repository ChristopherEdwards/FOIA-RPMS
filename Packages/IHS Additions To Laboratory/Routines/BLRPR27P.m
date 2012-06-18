BLRPR27P ;IHS/OIT/MKK - IHS Lab PATCH 1027 Post Install Routine ;JUL 06, 2010 3:14 PM
 ;;5.2;IHS LABORATORY;**1027**;NOV 01, 1997
 ;
 Q
 ;
EP ; EP
 D EEP^BLRGMENU
 Q
 ;
ADDEAGDC ; EP -- Add Estimated Average Glucose (EAG) to Delta Check dictionary
 NEW DESC,DESC1STR,DESC2STR,NAME,OVER1,OVER1STR,XCODE,XCODESTR
 NEW A1CIEN,A1CDESC,MESSAGE,TARGET
 ;
 ;
 D MKDELTA("HEMOGLOBIN A1C","ESTIMATED AVERAGE GLUCOSE","Created by IHS Lab Patch 1027")
 Q
 ;
MKDELTA(F60TEST1,F60TEST2,FRMWHERE) ; EP
 NEW EAGDNAME
 S XCODESTR="S %X="""" X:$D(LRDEL(1)) LRDEL(1) W:$G(%X)'="""" ""  ESTIMATED AVERAGE GLUCOSE:"",$P(%X,""^"") S:LRVRM>0 LRSB($$GETDNAM^BLREXECU("""_F60TEST2_"""))=%X K %,%X,%Y,%Z,%ZZ"
 S OVER1STR="S %ZZ=$$GETDNAM^BLREXECU("""_F60TEST1_""") X:LRVRM>0 ""F %=%ZZ S %X(%)=$S(%=LRSB:X,$D(LRSB(%)):+LRSB(%),1:0)"" X:LRVRM>0 ""F %=%ZZ S %X(%)=$S($D(LRSB(%)):LRSB(%),1:0)"" S %X=$FN((((X)*28.7)-46.7),"""",0)"
 S OVER1STR=OVER1STR_"_""^^!!!!!!^^!!!!!!mg/dl!!^^^^""_$G(DUZ(2))"
 ;
 S NAME="EAG"
 S EAGDNAME=$$GETDNAM^BLREXECU(F60TEST2)
 S EAGDNAME=$P($G(^DD(63.04,EAGDNAME,0)),"^")
 S XCODE=XCODESTR
 S OVER1=OVER1STR
 S DESC(1)="This delta check, when added to the A1C test, will calculate an Estimated"
 S DESC(2)="Average Glucose (EAG) using the equation: EAG=((A1C)*28.7)-46.7.  It will"
 S DESC(3)="stuff the result into the "_EAGDNAME_" Location (Data Name)."
 D DLTADICA(NAME,XCODE,OVER1,.DESC,FRMWHERE)
 ;
 Q
 ;
DLTADICA(NAME,XCODE,OVER1,DESC,FRMWHERE) ; EP
 NEW DICT0,DICT1,FDA,ERRS,PTR
 NEW HEREYAGO
 ;
 D BMES^XPDUTL("Adding "_NAME_" to Delta Check Dictionary")
 ;
 D ^XBFMK
 K ERRS,FDA,IENS,DIE
 ; 
 S DICT1="62.1"
 S FDA(DICT1,"?+1,",.01)=NAME   ; Find the Name node, or create it.
 S FDA(DICT1,"?+1,",10)=XCODE   ; Execute Code
 S FDA(DICT1,"?+1,",20)=OVER1   ; Overflow 1
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . D SORRY^BLRPRE27("Error in adding "_NAME_" to the Delta Check Dictionary.","NONFATAL")
 ;
 D OKAY^BLRKIDSU(NAME_" Delta Check added to Delta Check Dictionary.",5)
 ;
 ; Now, add the Description
 K ERRS
 D FIND^DIC(62.1,"","","",NAME,"","","","","HEREYAGO") ; Get Pointer
 S PTR=$G(HEREYAGO("DILIST",2,1))
 M WPARRAY("WP")=DESC
 D WP^DIE(62.1,PTR_",",30,"K","WPARRAY(""WP"")","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . D SORRY^BLRPRE27("Error in adding DESCRIPTION to "_NAME_" Delta Check in the Delta Check Dictionary.","NONFATAL")
 ;
 D OKAY^BLRKIDSU(NAME_" Delta Check DESCRIPTION added to Delta Check Dictionary.",5)
 ;
 ; Now, add the SITE NOTES DATE
 K ERRS,FDA
 S FDA(62.131,"?+1,"_PTR_",",.01)=$P($$NOW^XLFDT,".",1)
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . D SORRY^BLRPRE27("Error in adding SITES NOTES DATE to "_NAME_" Delta Check in the Delta Check Dictionary.","NONFATAL")
 ;
 ; Now, add the TEXT
 K ERRS,WPARRAY
 S WPARRAY("WP",1)=FRMWHERE
 D WP^DIE(62.131,"1,"_PTR_",",1,"K","WPARRAY(""WP"")","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . D SORRY^BLRPRE27("Error in adding TEXT to "_NAME_" Delta Check in the Delta Check Dictionary.","NONFATAL")
 ;
 D OKAY^BLRKIDSU(NAME_" Delta Check TEXT added to Delta Check Dictionary.",5)
 D BMES^XPDUTL(NAME_" Successfully Added to Delta Check Dictionary")
 Q
 ;
TESTEAG(A1C) ; EP -- Interactive EAG Results
 NEW EAG
 I $G(A1C)="" D  Q
 . W !,"Null A1C.  Routine Ends.",!
 ;
 S EAG=((A1C)*28.7)-46.7
 W !,?4,"A1C = ",A1C,?19,"EAG = ",$FN(EAG,"",0),?34,"EAG with decimals=",EAG,!
 Q
 ;
UCHOOSE ; EP - Allows User to select tests to use for EAG Delta Check
 NEW DESC,DESC1STR,DESC2STR,NAME,OVER1,OVER1STR,XCODE,XCODESTR
 NEW A1CIEN,A1CDESC,MESSAGE,TARGET
 NEW A1CTEST,CUREAG,EAGTEST,HEADER,LINE,OUT,QFLAG
 ;
 S HEADER(1)="Estimated Average Glucose Delta Check Setup"
 D HEADERDT^BLRGMENU
 ;
 ; Write Warning
 S PKG="DLTAWARN"
 F I=3:1 S X=$T(@PKG+I) Q:X["$$END"  D
 . W $P(X,";",3),!
 ;
 D ^XBFMK
 S DIR("A")="Continue (Y/N)"
 S DIR(0)="Y"
 D ^DIR
 I +$G(Y)<1 D  Q
 . W !,"YES not selected.  Routine ends.",!
 . D PRESSKEY^BLRGMENU(10)
 ;
 K HEADER
 S HEADER(1)="Estimated Average Glucose Delta Check"
 S HEADER(2)="Re-Initialization"
 S QFLAG=0
 ;
 ; Make sure user either ends the session or answers both test questions
 F  Q:QFLAG!((+$G(A1CTEST)>0)&(+$G(EAGTEST)>0))  D
 . D HEADERDT^BLRGMENU
 . Q:$$GETF60("Enter HEMOGLOBIN A1C Test Name",.A1CTEST,.QFLAG)="Q"
 . Q:$$GETF60("Enter Estimated Average Glucose Test Name",.EAGTEST,.QFLAG)="Q"
 ;
 Q:QFLAG
 ;
 K HEADER(2)
 S HEADER(2)="Delete Current Estimated Average Glucose Delta Check"
 D HEADERDT^BLRGMENU
 W !,"The Current EAG will now be deleted.",!!
 W ?5,"YES will delete the current EAG Delta Check.",!!
 W ?5,"NO will stop the process.",!!
 D ^XBFMK
 S DIR("A")="Delete current EAG"
 S DIR(0)="Y"
 D ^DIR
 I +$G(Y)<1 D
 . W !!,"Current EAG Delta Check will *NOT* be deleted.  Routine ends.",!
 . D PRESSKEY^BLRGMENU(10)
 . S QFLAG=1
 ;
 Q:QFLAG
 ;
 ; Get IEN of current EAG Delta Check
 D ^XBFMK
 D FIND^DIC(62.1,,,,"EAG",,,,,"OUT")
 S CUREAG=+$G(OUT("DILIST",2,1))
 I CUREAG<1 D  Q
 . W !!,"Could not find Current EAG Delta Check.  Routine ends.",!
 . D PRESSKEY^BLRGMENU(10)
 . S QFLAG=1
 ;
 Q:QFLAG
 ;
 ; Delete current EAG
 D ^XBFMK
 S DIK="^LAB(62.1,"
 S DA=CUREAG
 D ^DIK
 ;
 W !!,"Current EAG Deleted",!
 D PRESSKEY^BLRGMENU(10)
 ;
 ; Create NEW EAG
 K HEADER(2)
 S HEADER(2)="Creating new EAG (Estimated Average Glucose) Delta Check"
 D HEADERDT^BLRGMENU
 W !
 D MKDELTA($P(A1CTEST,"^",3),$P(EAGTEST,"^",3),"Interactively Created.")
 ;
 D PRESSKEY^BLRGMENU(10)
 Q
 ;
GETF60(MSG,F60TEST,QFLAG) ; EP
 NEW DATANAME,TESTDESC,TESTIEN
 ;
 S DATANAME=0
 F  Q:DATANAME>1!(QFLAG)  D
 . D HEADERDT^BLRGMENU
 . D ^XBFMK
 . S DIR(0)="P^60"
 . S DIR("A")=MSG
 . D ^DIR
 . I +$G(DIRUT)>0!(+$G(Y)<1) D  Q
 .. S QFLAG=1
 .. W !,?5,"Exit Selected.  Routine ends.",!
 .. D PRESSKEY^BLRGMENU(10)
 . ;
 . S TESTIEN=+$P($G(Y),"^")
 . S TESTDESC=$P($G(Y),"^",2)
 . S DATANAME=+$G(^LAB(60,+$G(Y),.2))
 . I DATANAME<1 D
 .. W !,?5,"Test ",TESTDESC," does NOT have a LOCATION (DATA NAME).",!!
 .. D ^XBFMK
 .. S DIR(0)="Y"
 .. S DIR("A")="Try Again."
 .. D ^DIR
 .. I +$G(Y)<1 D
 ... S QFLAG=1
 ;
 Q:QFLAG "Q"
 ;
 S F60TEST=$G(Y)_"^"_$P($G(^DD(63.04,DATANAME,0)),"^")
 I 'QFLAG D
 . S WOTNAME=$$TRIM^XLFSTR($P($P(MSG,"Enter",2),"Name"))
 . W !!,?5,TESTDESC," (",TESTIEN,") selected as ",WOTNAME,".",!!
 . D PRESSKEY^BLRGMENU(10)
 ;
 Q $S(QFLAG:"Q",1:"OK")
 ;
DLTAWARN ; EP -- Warning verbiage
 ;;1234567890123456789012345678901234567890123456789012345678901234567890
 ;;
 ;;          This routine will allow a user to specify two tests from
 ;;     the Laboratory Test File (# 60) that will be used to create a
 ;;     new  Estimated Average Glucose (EAG) Delta Check in the Delta
 ;;     Check File (# 62.1).
 ;;     
 ;;          Please note that this will  **DELETE**  the original EAG
 ;;     Delta check that was created during the post-install phase of
 ;;     IHS Lab Patch 1027.
 ;;     
 ;;$$END
