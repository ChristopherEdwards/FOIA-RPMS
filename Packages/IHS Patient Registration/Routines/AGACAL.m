AGACAL ; IHS/OIT/NKD - PRINT AN IHS ELIGIBILITY LETTER ; OCTOBER 2013
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005;Build 1
EN ;EP
 N AGTEXT,AGCNT
 F AGCNT=1:1 S AGTEXT=$P($T(HDR+AGCNT^AGACAL),";;",2) Q:AGTEXT="END"  D
 . W !,AGTEXT
 I '$$KEYCHK() D EXIT Q
SELPT ;SELECT PATIENT
 N AGDFN,AGDUZ,AGDUZ2
 D PTLK^AG
 I '$D(DFN)!'$D(DUZ(2)) D EXIT Q
 I '$$ELCHK(DFN) D EXIT Q
 S AGDFN=DFN,AGDUZ=DUZ,AGDUZ2=DUZ(2)
 D ZIS
 D EXIT
 Q
 ;
KEYCHK() ;EP - CHECK AGZACA SIGN KEY
 N AGSIGN
 S AGSIGN=$O(^XUSEC("AGZACA SIGN",""))
 I AGSIGN']"" W !,"<AG SIGN SECURITY KEY NOT ASSIGNED>" K DIR S DIR(0)="EO",DIR("A")="Press Enter to continue." D ^DIR K DIR Q 0
 I $O(^XUSEC("AGZACA SIGN",AGSIGN))]"" W !,"<AG SIGN SECURITY KEY ASSIGNED TO MORE THAN ONE USER>" K DIR S DIR(0)="EO",DIR("A")="Press Enter to continue." D ^DIR K DIR Q 0
 Q 1
 ;
ELCHK(AGDFN) ;EP - CHECK PT ELIGIBILITY
 Q:'$D(AGDFN)
 N AGBEN,AGELIG,AGRES
 S AGBEN=$S("INDIAN/ALASKA NATIVE"=$$BEN^AUPNPAT(AGDFN,"E"):1,1:0)
 S AGELIG=$S("DC"[$$ELIGSTAT^AUPNPAT(AGDFN,"I"):1,1:0)
 S AGRES=$S(AGBEN+AGELIG=2:1,1:0)
 I 'AGBEN,AGELIG D
 . W !!,">>> Warning the patient you have selected is a NON-INDIAN BENEFICIARY,"
 . W !,">>> but listed as eligible for services."
 . W !,">>> Are you sure you want to continue to print?"
 . K DIR S DIR(0)="Y",DIR("B")="NO",DIR("A")="PROCEED TO PRINT LETTER ANYWAY (Y/N)" D ^DIR
 . S:Y=1 AGRES=1
 I 'AGBEN,'AGELIG D
 . W !!,">>> Warning the patient you have selected is not eligible based on the following information:"
 . W !,"  CLASSIFICATION/BENEFICIARY : "_$$BEN^AUPNPAT(AGDFN,"E")
 . W !,"          ELIGIBILITY STATUS : "_$$ELIGSTAT^AUPNPAT(AGDFN,"E"),!
 K DIR S DIR(0)="EO",DIR("A")="Press Enter to continue." D ^DIR K DIR
 Q AGRES
 ;
ZIS ;DEVICE
 S XBRP="PRINT^AGACAL",XBRC="",XBRX="EXIT^AGACAL",XBNS="AGDFN;AGDUZ;AGDUZ2"
 D ^XBDBQUE
 D EXIT
 Q
 ;
EXIT ;EP
 K DFN,AGDFN,AGDUZ,AGDUZ2,AUPNDAYS,AUPNDOB,AUPNDOD,AUPNPAT,AUPNSEX,AGOVER
 D ^XBFMK
 Q
 ;
PRINT ;EP - PRINT ACA LETTER
 Q:'$D(AGDFN)!'$D(AGDUZ)!'$D(AGDUZ2)
 Q:'$D(^DPT(AGDFN,0))!'$D(^AUPNPAT(AGDFN,0))
 ; CREATE LOG ENTRY
 N FDA,NEWIEN,DINUM,AGCNT,AGCNT2,AGTEXT,AGTMP
 N AGDT,AGLI,AGDTE,AGNAME,AGADD1,AGADD2,AGDOB,AGSSN,AGDUZN,AGDUZAN,AGDUZPH,AGSIGN,AGUID
 S AGDT=$$DT^XLFDT()
 F DINUM=+$P(^AGACAL(0),"^",3):1 Q:DINUM>0&'$D(^AGACAL(DINUM,0))
 S NEWIEN(1)=DINUM
 S FDA(9009063.5,"+1,",.01)=AGDFN
 S FDA(9009063.5,"+1,",.03)=AGDUZ
 S FDA(9009063.5,"+1,",.04)=AGDT
 S FDA(9009063.5,"+1,",.05)=$$NOW^XLFDT()
 S FDA(9009063.5,"+1,",.06)=AGDUZ2
 D UPDATE^DIE(,"FDA","NEWIEN")
 S AGLI=NEWIEN(1)
 ; SETUP LETTER PRINTING VARIABLES
 S AGDTE=$$FMTE^XLFDT(AGDT) ;"<Date>"
 S AGNAME=$$NAMEFMT^XLFNAME($$GET1^DIQ(2,AGDFN,.01),"G","M") ;"<First Middle Last Name>"
 S AGADD1=$$GET1^DIQ(2,AGDFN,.111) ;"<Address line 1>"
 S AGADD2=$$GET1^DIQ(2,AGDFN,.114)_", "_$$GET1^DIQ(5,$$GET1^DIQ(2,AGDFN,.115,"I"),1)_"  "_$$GET1^DIQ(2,AGDFN,.116) ;"<City, State  Zip>"
 S AGDOB=$$GET1^DIQ(2,AGDFN,.03,"E") ;"<Date of Birth>"
 S AGSSN=$$GET1^DIQ(9000001,AGDFN,1107.3) ;"<Last 4 of SSN>"
 S AGDUZN=$$TITLE^XLFSTR($$GET1^DIQ(4,AGDUZ2,.01)) ;"<Facility Name>"
 S AGDUZAN=$$TITLE^XLFSTR($$GET1^DIQ(9999999.21,$$GET1^DIQ(9999999.06,AGDUZ2,.04,"I"),.03)) ;"<Area Prefix/Region>"
 S AGDUZPH=$$GET1^DIQ(9999999.06,AGDUZ2,.13) ;"<Facility Phone Number>"
 S AGSIGN=$O(^XUSEC("AGZACA SIGN","")),AGSIGN=$$NAMEFMT^XLFNAME($$GET1^DIQ(200,AGSIGN,.01),"G","M")_", "_$$GET1^DIQ(200,AGSIGN,8) ;"<Signing User, Title>"
 S AGUID=$$ENC^AGACALV(AGDUZ,AGDT,AGDFN,AGLI) ;"<Unique Identifier>"
 ; PRINT LETTER
 F AGCNT=1:1 S AGTEXT=$P($T(BODY+AGCNT^AGACAL),";;",2) Q:AGTEXT="END"  D
 . W !
 . F AGCNT2=1:1:$L(AGTEXT,"^") S AGTMP=$P(AGTEXT,"^",AGCNT2) D
 . . I $E(AGTMP,1,1)'="@" W AGTMP
 . . E  W @($P(AGTMP,"@",2))
 ; UPDATE LOG ENTRY WITH UID
 K FDA
 S FDA(9009063.5,AGLI_",",.02)=AGUID
 D UPDATE^DIE(,"FDA")
 ; END
 I $E(IOST)="C",IO=IO(0) W ! K DIR S DIR(0)="EO",DIR("A")="End of Report.  Press Enter." D ^DIR K DIR
 D EOJ
 Q
EOJ ;
 D ^XBFMK
 K AUPNDAYS,AUPNDOB,AUPNDOD,AUPNPAT,AUPNSEX
 K FDA,NEWIEN,DINUM,AGCNT,AGCNT2,AGTEXT,AGTMP
 K AGDT,AGLI,AGDTE,AGNAME,AGADD1,AGADD2,AGDOB,AGSSN,AGDUZN,AGDUZAN,AGDUZPH,AGSIGN,AGUID
 K N,%,T,F,X,Y,B,C,E,F,H,J,L,N,P,T,W
 Q
HDR ;HEADER TEXT
 ;;
 ;;Printing of this letter is restricted to Individuals who are eligible for
 ;;services through an Indian health care provider as defined in 42 CFR 447.50
 ;;or is eligible for services through the Indian Health Service in accordance
 ;;with 25 USC 1680c(a), (b), or (d)(3).
 ;;
 ;;END
BODY ;BODY TEXT
 ;;@AGDTE
 ;;
 ;;RE:       ^@AGNAME
 ;;          ^@AGADD1
 ;;          ^@AGADD2
 ;;
 ;;Dear Federal or State Marketplace,
 ;;
 ;;We have received a request to verify eligibility for Indian
 ;;Health Service (IHS) coverage for ^@AGNAME^.
 ;;
 ;;Upon review of our local facility data, we confirm that this
 ;;individual is an Indian eligible for services through an
 ;;Indian health care provider as defined by 42 CFR 447.50 or is
 ;;eligible for services through the Indian Health Service in
 ;;accordance with 25 USC 1680c(a), (b), or (d)(3). Eligibility
 ;;for such services under 42 CFR Part 136 has been verified at
 ;;the ^@AGDUZN
 ;;within the Indian Health Service ^@AGDUZAN^ Area.
 ;;
 ;;If you have any questions, please contact us at: ^@AGDUZPH
 ;;
 ;;Sincerely,
 ;;
 ;;
 ;;
 ;;
 ;;@AGSIGN
 ;;@AGDUZN
 ;;@AGDUZAN^ Area
 ;;
 ;;
 ;;
 ;;UNIQUE IDENTIFIERS:
 ;;DOB: ^@AGDOB
 ;;SSN: ^@AGSSN
 ;;@AGUID
 ;;END
