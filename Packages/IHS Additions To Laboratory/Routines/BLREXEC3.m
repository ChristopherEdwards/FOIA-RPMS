BLREXEC3 ;IHS/OIT/MKK - IHS Implementation of the Chronic Kidney Disease Epidemiology Collaboration (CKD-EPI) eGFR equation ; 21-Dec-2015 07:15 ; MKK
 ;;5.2;IHS LABORATORY;**1038**;NOV 01, 1997;Build 6
 ;
 ; Equation and Warning are from the National Kidney Disease web-page (as of 12/21/2015):
 ;      http://nkdep.nih.gov/lab-evaluation/gfr/estimating.shtml
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ;
CKDEPI(CRET) ; EP - Creatinine value is passed in
 ;
 Q:(AGE<18) "N/A"    ; Cannot calculate if AGE < 18.
 Q:(SEX="U") "N/A"   ; Cannot calculate if SEX is Undetermined/Unknown.
 ;
 S SEXFACTR=$S(SEX="F":1.018,1:1)
 ;
 S:$D(BLRTFLAG)<1 RACE=$$RACE(DFN)
 ;
 S RACEFACT=$S(RACE="B":1.159,1:1)
 ;
 S K=$S(SEX="F":.7,1:.9)
 S ALPHA=$S(SEX="F":-.329,1:-.411)
 ;
 S CHKEPI=141*(($$MIN(CRET/K,1))**ALPHA)*(($$MAX(CRET/K,1))**-1.209)*(.993**AGE)*SEXFACTR*RACEFACT
 ;
 Q $FN(CHKEPI,"",2)  ; Round Result to 2 decimal places
 ;
MIN(VALUE,MIN) ; EP
 Q $S(VALUE<MIN:VALUE,1:MIN)
 ;
MAX(VALUE,MAX) ; EP
 Q $S(VALUE>MAX:VALUE,1:MAX)
 ;
RACE(DFN) ; EP - Race of patient: defined as black or non-black
 NEW RACEPTR,RACEENT
 ;
 S RACEPTR=$P($G(^DPT(+$G(DFN),0)),U,6)
 Q:RACEPTR="" "N"             ; If no entry, consider non-black
 ;
 S RACEENT=$P($G(^DIC(10,RACEPTR,0)),U)
 Q:RACEENT[("BLACK") "B"      ; If RACEENT contains BLACK it implies race = Black
 ;
 Q "N"                        ; Default is non-black
 ;
TESTEQUA ; EP - Debug -- Allows user to TEST the equation
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S (BLRTFLAG,ONGO)="YES"
 S TAB=$J("",5),TAB2=TAB_TAB,TAB3=TAB_TAB_TAB
 S HEADER(1)="IHS LAB"
 S HEADER(2)="CKD-EPI Equation Testing"
 ;
 F  Q:ONGO'="YES"  D
 . Q:$$GETSEX(.SEX)="Q"
 . Q:$$GETAGE(.AGE)="Q"
 . Q:$$GETRACE(.RACE,.FULLRACE)="Q"
 . Q:$$GETCREAT(.CREATININE)="Q"
 . ;
 . D HEADERDT^BLRGMENU
 . W !!,?9,"For SEX:",SEX,"; AGE:",AGE,"; RACE:",FULLRACE,!
 . W ?13,"Creatinine:",CREATININE_" mg/dL"
 . W !!,?14,"CKD-EPI Equation's Estimated GFR = ",$$CKDEPI(CREATININE),!!
 . ;
 . D ^XBFMK
 . S DIR(0)="YO"
 . S DIR("A")=TAB3_"Again"
 . S DIR("B")="NO"
 . D ^DIR
 . S ONGO=$S(Y=1:"YES",1:"NO")
 ;
 Q
 ;
GETSEX(SEX) ; EP - Get Sex function
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR(0)="SO^1:F;2:M;3:U"
 S DIR("L",1)=TAB_"Select Sex:"
 S DIR("L",2)=TAB2_"1: FEMALE"
 S DIR("L",3)=TAB2_"2: MALE"
 S DIR("L",4)=TAB2_"3: UNKNOWN"
 S DIR("L")=""
 S DIR("A")=TAB3_"SEX"
 D ^DIR
 ;
 I Y<1!(+$G(DIRUT)) D GQMFDIRR  S ONGO="NO"  Q "Q"
 ;
 I +X S SEX=$S(X=1:"F",X=2:"M",1:"U")
 E  S SEX=$$UP^XLFSTR($E(X))
 Q "OK"
 ;
GETAGE(AGE) ; EP - Age Function
 D HEADERDT^BLRGMENU
 D ^XBFMK
 W TAB,"Select Age:"
 S DIR(0)="NO^18:150"
 S DIR("A")=TAB3_"AGE"
 D ^DIR
 ;
 I Y<1!(+$G(DIRUT)) D GQMFDIRR  S ONGO="NO"  Q "Q"
 ;
 S AGE=Y
 Q "OK"
 ;
GETRACE(RACE,FULLRACE) ; EP - Race Function
 D HEADERDT^BLRGMENU
 D ^XBFMK
 W TAB,"Select Race:"
 S DIR(0)="PO^10:EMZ"
 S DIR("A")=TAB3_"RACE"
 D ^DIR
 ;
 I Y<1!(+$G(DIRUT)) D GQMFDIRR  S ONGO="NO"  Q "Q"
 ;
 S FULLRACE=$P(Y,"^",2)
 S RACE=$$UP^XLFSTR($E(FULLRACE))
 Q "OK"
 ;
GETCREAT(CREATININE) ; EP - Creatinine function
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR(0)="NO^::2"
 S DIR("A")=TAB3_"Enter Creatinine Value (mg/dL Units)"
 D ^DIR
 ;
 I X=""!(+$G(DIRUT)) D GQMFDIRR  S ONGO="NO"  Q "Q"
 ;
 S CREATININE=+Y
 Q "OK"
 ;
 ;
NEWDELTA ; EP - Allows users to create new Delta Check utilizing the CKD-EPI function
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS("NEWDELTA")
 ;
 S HEADER(1)="IHS LAB"
 S HEADER(2)="CKD-EPI Delta Check Creation"
 D HEADERDT^BLRGMENU
 ;
 D ^XBFMK
 S DIR(0)="PO^60:EMZ"
 S DIR("A")="Test to hold CKD-EPI Results"
 D ^DIR
 I +$G(DIRUT) D GQMFDIRR  Q
 ;
 S F60PTR=+Y
 S CKDEPI60=$P(Y,"^",2)
 S CKDEPIDN=$$GET1^DIQ(60,F60PTR,"DATA NAME")
 I $L(CKDEPIDN)<1 D BADSTUFF("Test "_CKDEPIDN_" has no DataName.")  Q
 ;
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR(0)="PO^60:EMZ"
 S DIR("A")="Creatinine Test to use for CKD-EPI calculation"
 D ^DIR
 I +$G(DIRUT) D GQMFDIRR  Q
 ;
 S F60PTR=+Y
 S CREAT60=$P(Y,"^",2)
 S CREATDN=$$GET1^DIQ(60,F60PTR,"DATA NAME")
 I $L(CREATDN)<1 D BADSTUFF("Test "_CREAT60_" has no DataName.")  Q
 ;
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR(0)="FO"
 S DIR("A")="Name of the Delta Check"
 D ^DIR
 I +$G(DIRUT) D GQMFDIRR  Q
 ;
 S NAME=$G(X)
 ;
 ; Make sure it's not a duplicate Delta Check Name
 I +$O(^LAB(62.1,"B",NAME,0)) D BADSTUFF(NAME_" is a duplicate Delta Check Name.")  Q
 ;
 S XCODE="S %X="""" X:$D(LRDEL(1)) LRDEL(1) W:$G(%X)'="""" ""  CKD-EPI Calculated GFR:"",%X S:LRVRM>10 LRSB($$GETDNAM^BLREXEC2("""_CKDEPIDN_"""))=%X K %,%X,%Y,%Z,%ZZ"
 S OVER1STR="S %ZZ=$$GETDNAM^BLREXEC2("""_CREAT60_""") X:LRVRM>10 ""F %=%ZZ S %X(%)=$S(%=LRSB:X,$D(LRSB(%)):+LRSB(%),1:0)"" X:LRVRM>10 ""F %=%ZZ S %X(%)=$S($D(LRSB(%)):LRSB(%),1:0)"""
 S OVER1=OVER1STR_" S %X=$$CKDEPI^BLREXEC3(X)"
 ;
 S DESC(1)="This delta check, when added to a test named "
 S DESC(2)="     "_$$LJ^XLFSTR(CREAT60,75)
 S DESC(3)="will calculate an estimated Glomerular Filtration Rate (GFR)"
 S DESC(4)="using the CKD-EPI equation."
 S DESC(5)=" "
 S DESC(6)="The CKD-EPI Equation's result will be stuffed into the test called"
 S DESC(7)="     "_CKDEPI60
 S DESC(8)=" "
 ;
 ; Warning
 S DESC(9)="Creatinine-based estimating equations are not recommended for use with:"
 S DESC(10)=" "
 S DESC(11)="     Individuals with unstable creatinine concentrations. This includes"
 S DESC(12)="     pregnant women; patients with serious co-morbid conditions; and"
 S DESC(13)="     hospitalized patients, particularly those with acute renal failure."
 S DESC(14)="     Creatinine-based estimating equations should be used only for"
 S DESC(15)="     patients with stable creatinine concentrations."
 S DESC(16)=" "
 S DESC(17)="     Persons with extremes in muscle mass and diet. This includes, but"
 S DESC(18)="     is not limited to, individuals who are amputees, paraplegics, body"
 S DESC(19)="     builders, or obese; patients who have a muscle-wasting disease or"
 S DESC(20)="     a neuromuscular disorder; and those suffering from malnutrition,"
 S DESC(21)="     eating a vegetarian or low-meat diet, or taking creatine dietary"
 S DESC(22)="     supplements."
 ;
 ;
 D HEADERDT^BLRGMENU
 ;
 D DLTADICA(NAME,XCODE,OVER1,.DESC)
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
DLTADICA(NAME,XCODE,OVER1,DESC) ; EP
 NEW DICT0,DICT1,FDA,ERRS,PTR
 NEW HEREYAGO
 ;
 W !!,"Adding "_NAME_" to Delta Check Dictionary.",!
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
 . D BADSTUFF("Error in adding "_NAME_" to the Delta Check Dictionary.")
 ;
 W !,?5,NAME_" Delta Check added to Delta Check Dictionary.",!
 ;
 ; Now, add the Description
 K ERRS
 S PTR=$$FIND1^DIC(62.1,,,NAME)
 M WPARRAY("WP")=DESC
 D WP^DIE(62.1,PTR_",",30,"K","WPARRAY(""WP"")","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . W !!,"Error in adding DESCRIPTION to "_NAME_" Delta Check in the Delta Check Dictionary."
 . D BADSTUFF("")
 ;
 W !,?5,NAME_" Delta Check DESCRIPTION added to Delta Check Dictionary.",!
 ;
 ; Now, add the SITE NOTES DATE
 K ERRS,FDA
 S FDA(62.131,"?+1,"_PTR_",",.01)=$P($$NOW^XLFDT,".",1)
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . W !!,"Error in adding SITES NOTES DATE to "_NAME_" Delta Check in the Delta Check Dictionary."
 . D BADSTUFF("")
 ;
 ; Now, add the TEXT
 K ERRS,WPARRAY
 S WPARRAY("WP",1)="Created by "_$$GET1^DIQ(200,DUZ,"NAME")_"     DUZ:"_DUZ
 D WP^DIE(62.131,"1,"_PTR_",",1,"K","WPARRAY(""WP"")","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . W !!,"Error in adding TEXT to "_NAME_" Delta Check in the Delta Check Dictionary."
 . D BADSTUFF("")
 ;
 W !,?5,NAME_" Delta Check TEXT added to Delta Check Dictionary."
 Q
 ;
 ; ============================= UTILITIES =============================
 ;
JUSTNEW ; EP - Generic RPMS EXCLUSIVE NEW
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q
 ;
SETBLRVS(TWO) ; EP - Set the BLRVERN variable(s)
 K BLRVERN,BLRVERN2
 ;
 S BLRVERN=$P($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=$G(TWO)
 Q
 ;
GQMFDIRR ; Generic "Quit" message for D ^DIR response
 D BADSTUFF("No/Invalid/Quit Entry.")
 Q
 ;
BADSTUFF(MSG,TAB) ; EP - Simple Message
 S:+$G(TAB)<1 TAB=4
 W !!,?TAB,$$TRIM^XLFSTR(MSG,"LR"," "),"  Routine Ends."
 D PRESSKEY^BLRGMENU(TAB+5)
 Q
