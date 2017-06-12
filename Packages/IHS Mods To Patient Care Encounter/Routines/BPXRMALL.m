BPXRMALL ;IHS/CIA/MGH - Handle Allergy findings. ;18-Apr-2014 15:23;DU
 ;;2.0;CLINICAL REMINDERS;**1001,1002**;Feb 04, 2005;Build 15
 ;=======================================================================
ALLERGY ;******************************ALLERGIES*******************************
 ;
ALL1(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding to return a 1 if Adverse Reaction entry is not found.
 S DATE=DT
 S TEST=1
 I $D(^GMR(120.86,"B",DFN)) S TEST=0
 Q
 ;
ALLEGG(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding to return a 1 if EGG allergy is found.
 N AA,TESTI,X,Y,INAC
 S (AA,TEST)=0,TEXT="Not Found"
 I '$D(^GMR(120.8,"B",DFN)) Q
 F  S AA=$O(^GMR(120.8,"B",DFN,AA)) Q:AA'>0  D
 . ;I $P(^GMR(120.8,AA,0),"^",16)'=1 Q    ;Quit if not verified
 . I $D(^GMR(120.8,AA,"ER")),$P(^GMR(120.8,AA,"ER"),"^",1)=1 Q
 .;Quit if entered in error
 . S X=$P(^GMR(120.8,AA,0),"^",2) X ^%ZOSF("UPPERCASE")
 . S INAC=$$INACTIVE^GMRADSP6(AA)
 . Q:+INAC    ;Quit if inactive
 . I Y["EGG" S TEST=1,DATE=DT,TEXT="Egg allergy found"
 K AA,TESTI,X,Y
 Q
 ;
ALLTHRM(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding to return a 1 if Thimerosal allergy is found.
 N AA,TESTI,X,Y,INAC
 S (AA,TEST)=0,TEXT="Not Found"
 I '$D(^GMR(120.8,"B",DFN)) Q
 F  S AA=$O(^GMR(120.8,"B",DFN,AA)) Q:AA'>0  D
 . ;I $P(^GMR(120.8,AA,0),"^",16)'=1 Q    ;Quit if not verified
 . I $D(^GMR(120.8,AA,"ER")),$P(^GMR(120.8,AA,"ER"),"^",1)=1 Q         ;Quit if entered in error
 . S INAC=$$INACTIVE^GMRADSP6(AA)
 . Q:+INAC    ;Quit if inactive
 . S X=$P(^GMR(120.8,AA,0),"^",2) X ^%ZOSF("UPPERCASE")
 . I Y["THIMEROSAL" S TEST=1,DATE=DT,TEXT="Thimerosal allergy found"
 K AA,TESTI,X,Y
 Q
 ;
ALLINFL(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding to return a 1 if Influenza vaccine allergy is found.
 N AA,TESTI,X,Y,INAC
 S (AA,TEST)=0,TEXT="Not Found"
 I '$D(^GMR(120.8,"B",DFN)) Q
 F  S AA=$O(^GMR(120.8,"B",DFN,AA)) Q:AA'>0  D
 . ;I $P(^GMR(120.8,AA,0),"^",16)'=1 Q    ;Quit if not verified
 . I $D(^GMR(120.8,AA,"ER")),$P(^GMR(120.8,AA,"ER"),"^",1)=1 Q         ;Quit if entered in error
 . S INAC=$$INACTIVE^GMRADSP6(AA)
 . Q:+INAC    ;Quit if inactive
 . S X=$P(^GMR(120.8,AA,0),"^",2) X ^%ZOSF("UPPERCASE")
 . I Y["FLU" S TEST=1,DATE=DT,TEXT="Influenza vaccine allergy found"
 K AA,TESTI,X,Y
 Q
 ;
ALLPNEU(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding to return a 1 if Pneumonia vaccine allergy is found.
 N AA,TESTI,X,Y,INAC
 S (AA,TEST)=0,TEXT="Not Found"
 I '$D(^GMR(120.8,"B",DFN)) Q
 F  S AA=$O(^GMR(120.8,"B",DFN,AA)) Q:AA'>0  D
 . ;I $P(^GMR(120.8,AA,0),"^",16)'=1 Q    ;Quit if not verified
 . I $D(^GMR(120.8,AA,"ER")),$P(^GMR(120.8,AA,"ER"),"^",1)=1 Q         ;Quit if entered in error
 . S INAC=$$INACTIVE^GMRADSP6(AA)
 . Q:+INAC    ;Quit if inactive
 . S X=$P(^GMR(120.8,AA,0),"^",2) X ^%ZOSF("UPPERCASE")
 . I Y["PNEUMO" S TEST=1,DATE=DT,TEXT="Pneumonia vaccine allergy found"
 K AA,TESTI,X,Y
 Q
 ;
ALLTETA(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding to return a 1 if Tetanus vaccine allergy is found.
 N AA,TESTI,X,Y,INAC
 S (AA,TEST)=0,TEXT="Not Found"
 I '$D(^GMR(120.8,"B",DFN)) Q
 F  S AA=$O(^GMR(120.8,"B",DFN,AA)) Q:AA'>0  D
 . ;I $P(^GMR(120.8,AA,0),"^",16)'=1 Q    ;Quit if not verified
 . I $D(^GMR(120.8,AA,"ER")),$P(^GMR(120.8,AA,"ER"),"^",1)=1 Q         ;Quit if entered in error
 . S INAC=$$INACTIVE^GMRADSP6(AA)
 . Q:+INAC    ;Quit if inactive
 . S X=$P(^GMR(120.8,AA,0),"^",2) X ^%ZOSF("UPPERCASE")
 . I Y["TETANUS" S TEST=1,DATE=DT,TEXT="Tetanus vaccine allergy found"
 K AA,TESTI,X,Y
 Q
 ;
ALLCLOP(DFN,TEST,DATE,VALUE,TEXT) ;Computed finding to return a 1 if plavix allergy is found.
 N AA,TESTI,X,Y,INAC
 S (AA,TEST)=0,TEXT="Not Found"
 I '$D(^GMR(120.8,"B",DFN)) Q
 F  S AA=$O(^GMR(120.8,"B",DFN,AA)) Q:AA'>0  D
 . ;I $P(^GMR(120.8,AA,0),"^",16)'=1 Q    ;Quit if not verified
 . I $D(^GMR(120.8,AA,"ER")),$P(^GMR(120.8,AA,"ER"),"^",1)=1 Q         ;Quit if entered in error
 . S INAC=$$INACTIVE^GMRADSP6(AA)
 . Q:+INAC    ;Quit if inactive
 . S X=$P(^GMR(120.8,AA,0),"^",2) X ^%ZOSF("UPPERCASE")
 . I Y["CLOPIDOGREL" S TEST=1,DATE=DT,TEXT="Clopidogrel allergy found"
 K AA,TESTI,X,Y
 Q
ALLWARF(DFN,TEST,DATE,VALUE,TEXT) ;Return TEST=1 if allergy to ANTICOAGULANTS found
 N AA,BB,TESTI,X,Y,INAC
 S (AA,TEST)=0,TEXT="Not Found"
 I '$D(^GMR(120.8,"B",DFN)) Q
 F  S AA=$O(^GMR(120.8,"B",DFN,AA)) Q:AA'>0  D
 . ;I $P(^GMR(120.8,AA,0),"^",16)'=1 Q    ;Quit if not verified
 . I $D(^GMR(120.8,AA,"ER")),$P(^GMR(120.8,AA,"ER"),"^",1)=1 Q  ;Quit if entered in error
 . S INAC=$$INACTIVE^GMRADSP6(AA)
 . Q:+INAC    ;Quit if inactive
 . S X=$P(^GMR(120.8,AA,0),"^",2) X ^%ZOSF("UPPERCASE")
 . I (Y["COUMADIN")!(Y["WARFARIN") S TEST=1,DATE=DT,TEXT="Warfarin Allergy found" Q
 . S BB=0
 . F  S BB=$O(^GMR(120.8,AA,3,"B",BB)) Q:BB'>0  D
 . . I $P(^PS(50.605,BB,0),"^",1)="BL100" S TEST=1,TEXT="Warfarin allergy found" Q
 K AA,BB,TESTI,X,Y
 Q
 ;
ALLASP(DFN,TEST,DATE,VALUE,TEXT) ;Return TEST=1 if allergy to ASPIRIN found
 N AA,BB,TESTI,X,Y,INAC
 S (AA,TEST)=0,TEXT="Aspirin not found, didn't evaluate for NSAIDS"
 I '$D(^GMR(120.8,"B",DFN)) Q
 F  S AA=$O(^GMR(120.8,"B",DFN,AA)) Q:AA'>0  D
 . ;I $P(^GMR(120.8,AA,0),"^",16)'=1 Q    ;Quit if not verified
 . I $D(^GMR(120.8,AA,"ER")),$P(^GMR(120.8,AA,"ER"),"^",1)=1 Q         ;Quit if entered in error
 . S INAC=$$INACTIVE^GMRADSP6(AA)
 .Q:+INAC    ;Quit if inactive
 . S X=$P(^GMR(120.8,AA,0),"^",2) X ^%ZOSF("UPPERCASE")
 . I (Y["ASPIRIN")!(Y["SALSA")!(Y["SALICY") S TEST=1,DATE=DT,TEXT="Aspirin allergy found" Q
 . ; Can't check for drug class, too many non-aspirin drugs in class
 . ; Check in drug ingredient field however
 . S BB=0
 . F  S BB=$O(^GMR(120.8,AA,2,"B",BB)) Q:BB'>0  D
 . . I '$D(^PS(50.416,BB,0)) Q
 . . S X=$P(^PS(50.416,BB,0),"^",1) X ^%ZOSF("UPPERCASE")
 . . I (Y["ASPIRIN")!(Y["SALSA")!(Y["SALICY") S TEST=1,DATE=DT,TEXT="Aspirin allergy found" Q
 K AA,BB,TESTI,X,Y
 Q
 ;
ALLBETA(PSODFN,TEST,DATE,VALUE,TEXT) ;Return TEST=1 if allergy to  BETA BLOCKERS/RELATED found
 S VALUE="",DATE=DT
 N CHECK,I S CHECK=""
 S I="CV100" S CHECK=CHECK_"^"_$$FIND1^DIC(50.605,"","MX",I)_"C"
 S CHECK=$E(CHECK,2,$L(CHECK))  ;GET RID OF FIRST '^'
 I $L(CHECK,"^")'=1 S TEST=0,TEXT="VA DRUG CLASS FOR 'CV100' NOT DEFINED!!" Q
 D ALLER^BPXRMAL1(PSODFN,CHECK,.TEST,.TEXT)
 Q
 ;
ALLACE(PSODFN,TEST,DATE,VALUE,TEXT) ;Return TEST=1 if allergy to  ACE INHIBITORS found
 S VALUE="",DATE=DT
 N CHECK,I S CHECK=""
 S I="CV800" S CHECK=CHECK_"^"_$$FIND1^DIC(50.605,"","MX",I)_"C"
 S CHECK=$E(CHECK,2,$L(CHECK))  ;GET RID OF FIRST '^'
 I $L(CHECK,"^")'=1 S TEST=0,TEXT="VA DRUG CLASS FOR 'CV100' NOT DEFINED!!" Q
 D ALLER^BPXRMAL1(PSODFN,CHECK,.TEST,.TEXT)
 Q
ALLARB(PSODFN,TEST,DATE,VALUE,TEXT) ;Return TEST=1 if allergy to  ARBS
 S VALUE="",DATE=DT
 N CHECK,I S CHECK=""
 S I="CV805" S CHECK=CHECK_"^"_$$FIND1^DIC(50.605,"","MX",I)_"C"
 S CHECK=$E(CHECK,2,$L(CHECK))  ;GET RID OF FIRST '^'
 I $L(CHECK,"^")'=1 S TEST=0,TEXT="VA DRUG CLASS FOR CV100 NOT DEFINED!!" Q
 D ALLER^BPXRMAL1(PSODFN,CHECK,.TEST,.TEXT)
 Q
ALL(DFN,TEST,DATE,VALUE,TEXT) ;Return whether or not a patient has an allergy assessment
 ;
 ;1 Patient has known reaction
 ;0 Patient has NO known reaction
 ;null Paient has never been asked about reaction
 N AJEY
 S AJEY=$$NKA^GMRANKA(DFN)
 S TEST=1,DATE=DT
 I AJEY="" S TEST=0,DATE=""
 Q
