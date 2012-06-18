BLRPR30P ;IHS/OIT/MKK - IHS Lab PATCH 1030 Post Install Routine ;FEB 09, 2011 6:45 AM
 ;;5.2;IHS LABORATORY;**1030**;NOV 01, 1997
 ;
 ; Cloned from BLRPR27P
 ; 
 Q
 ;
EP ; EP
 D EEP^BLRGMENU
 Q
 ;
 ; Modify the Estimated Average Glucose (EAG) Delta Check so that only a
 ; NUMERIC A1C result will store data. If the A1C result is not numeric,
 ; DO NOT store anything.
MODEAGDC ; EP
 NEW DESC,DESC1STR,DESC2STR,NAME,OVER1,OVER1STR,XCODE,XCODESTR
 NEW A1CIEN,A1CDESC,CP,MESSAGE,TARGET
 ;
 S CP=$P($T(+2),"*",3)  ; Current Patch
 ;
 D MKDELTA("HEMOGLOBIN A1C","ESTIMATED AVERAGE GLUCOSE","Modified by IHS Lab Patch "_CP)
 Q
 ;
MKDELTA(F60TEST1,F60TEST2,FRMWHERE) ; EP
 NEW EAGDNAME
 ;
 S XCODESTR="S %X="""" X:$D(LRDEL(1)) LRDEL(1) W:+$G(%X)>0 ""  ESTIMATED AVERAGE GLUCOSE:"",$P(%X,""^"") S:+$G(%X)>0 LRSB($$GETDNAM^BLREXECU("""_F60TEST2_"""))=%X K %,%X,%Y,%Z,%ZZ"
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
 S DESC(3)="stuff the result into the "_EAGDNAME_" Location (Data Name).  NOTE: if "
 S DESC(4)="the result of the A1C test is not numeric, or if the EAG evaluates to a"
 S DESC(5)="number < 1, no value will be inserted into the Estimated Average Glucose"
 S DESC(6)="test."
 D DLTADICA(NAME,XCODE,OVER1,.DESC,FRMWHERE)
 ;
 Q
 ;
DLTADICA(NAME,XCODE,OVER1,DESC,FRMWHERE) ; EP
 NEW DICT0,DICT1,FDA,ERRS,PTR
 NEW HEREYAGO
 ;
 D BMES^XPDUTL("Modifying "_NAME_" Delta Check")
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
 . D SORRY^BLRPRE27("Error in modifying "_NAME_" Delta Check XECUTABLE CODE field.","NONFATAL")
 ;
 D OKAY^BLRKIDSU(NAME_" Delta Check XECUTABLE CODE field modified.",5)
 ;
 ; Modify the Description
 K ERRS
 D FIND^DIC(62.1,"","","",NAME,"","","","","HEREYAGO") ; Get Pointer
 S PTR=$G(HEREYAGO("DILIST",2,1))
 M WPARRAY("WP")=DESC
 D WP^DIE(62.1,PTR_",",30,"K","WPARRAY(""WP"")","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . D SORRY^BLRPRE27("Error in modifying DESCRIPTION of "_NAME_" Delta Check.","NONFATAL")
 ;
 D OKAY^BLRKIDSU(NAME_" Delta Check DESCRIPTION modified.",5)
 ;
 ; Modify the SITE NOTES DATE
 K ERRS,FDA
 S FDA(62.131,"?+1,"_PTR_",",.01)=$P($$NOW^XLFDT,".",1)
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . D SORRY^BLRPRE27("Error in modifying SITES NOTES DATE of "_NAME_" Delta Check.","NONFATAL")
 ;
 D OKAY^BLRKIDSU(NAME_" Delta Check SITES NOTES DATE modified.",5)
 ;
 ; Modify the TEXT
 K ERRS,WPARRAY
 S WPARRAY("WP",1)=FRMWHERE
 D WP^DIE(62.131,"1,"_PTR_",",1,"K","WPARRAY(""WP"")","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . D SORRY^BLRPRE27("Error in modifying TEXT of "_NAME_" Delta Check.","NONFATAL")
 ;
 D OKAY^BLRKIDSU(NAME_" Delta Check TEXT modified.",5)
 D MES^XPDUTL(NAME_" Delta Check Successfully Modified.")
 D MES^XPDUTL("")
 Q
 ;
 ; Create new Estimated Average Glucose that will use GETREFR^BLRLINKU call to get
 ; Reference Ranges & Units to stuff into File 63
NEWEAG ; EP
 NEW DESC,DESC1STR,DESC2STR,NAME,OVER1,OVER1STR,XCODE,XCODESTR
 NEW A1CIEN,A1CDESC,CP,MESSAGE,TARGET
 ;
 S CP=$P($T(+2),"*",3)  ; Current Patch
 ;
 D MKNDELTA("ESTIMATED AVERAGE GLUCOSE","Created by IHS Lab Patch "_CP,"MEAG")
 Q
 ;
MKNDELTA(F60TEST2,FRMWHERE,EAGDNAME) ; EP
 S XCODESTR="S %X="""" X:$D(LRDEL(1)) LRDEL(1) W:+$G(%X)>0 ""  ESTIMATED AVERAGE GLUCOSE:"",$P(%X,""^"") S:+$G(%X)>0 LRSB($$GETDNAM^BLREXECU("""_F60TEST2_"""))=%X K %,%X,%Y,%Z,%ZZ"
 S OVER1STR="S %ZZ=$$GETREFR^BLRUTIL3(""ESTIMATED AVERAGE GLUCOSE"")  S %XX=$FN((((X)*28.7)-46.7),"""",0)  S %YY=$S(%XX'>$P(%ZZ,""!"",2):""L"",%XX'<$P(%ZZ,""!"",3):""H"",1:"""")  S %X=%XX_""^""_%YY_""^!!!!!!^^""_%ZZ_""^^^^""_$G(DUZ(2))"
 ;
 S XCODE=XCODESTR
 S OVER1=OVER1STR
 S DESC(1)="This delta check, when added to the A1C test, will calculate an Estimated"
 S DESC(2)="Average Glucose (EAG) using the equation:"
 S DESC(3)="          EAG=((A1C)*28.7)-46.7."
 S DESC(4)=" "
 S DESC(5)="It will store the calculated result in the LAB DATA (# 63) File."
 S DESC(6)="It will also store the UNITS, REFERENCE LOW, and REFERENCE HIGH values for"
 S DESC(7)="the ESTIMATED AVERAGE GLUCOSE test in the LAB DATA (#63) file, if those"
 S DESC(8)="entries exist."
 S DESC(9)=" "
 S DESC(10)="NOTE: if the result of the A1C test is not numeric, OR if the EAG"
 S DESC(11)="      calculation < 1, then data will NOT be stored into the"
 S DESC(12)="      Estimated Average Glucose test."
 S DESC(13)=" "
 ;
 D NDLTADIC(EAGDNAME,XCODE,OVER1,.DESC,FRMWHERE)
 ;
 Q
 ;
 ; Adding NEW delta check
NDLTADIC(NAME,XCODE,OVER1,DESC,FRMWHERE) ; EP
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
