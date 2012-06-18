BTIULD ; IHS/ITSC/LJF - Admission related functions ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;Called by ^TIULD for IHS style display
 ;
CHEKDS(DATA) ;EP; Display/validate correct patient/treatment episode
 NEW Y
 I $G(DATA("AD#"))'>0!(DATA("EDT")="") D  G CHEKDSX
 . W !!,"Movement data doesn't exist for admission, can't create "
 . W "Summary",!
 I +$$ISA^USRLM(DUZ,"TRANSCRIPTIONIST")>0 S Y=1 G CHEKDSX
 W !!?1,"Patient: ",$$NAME^TIULS(DATA("PNM"),"LAST, FIRST MI"),?39,"HRCN: "
 W DATA("HRCN"),?62,"Sex: ",$S(DATA("SEX")]"":$P(DATA("SEX"),U,2),1:"UNKNOWN"),!
 W "Adm Date: ",$$DATE^TIULS($P(DATA("EDT"),U),"MM/DD/YY"),?39,"Ward: "
 W $P(DATA("WARD"),U,2),?62,"Age: ",$S(DATA("AGE")]"":DATA("AGE"),1:"UNKNOWN"),!
 W:DATA("LDT")]"" "Dis Date: ",$$DATE^TIULS(DATA("LDT"),"MM/DD/YY"),!
 W ?2,"Adm Dx: ",DATA("ADDX"),!,"Att Prov: ",$P(DATA("PMD"),U,2),!
 I $D(DATA("DICTDT")) D
 . W !,"A DISCHARGE SUMMARY is already on file:",!
 . W ?2,"Dict'd: ",DATA("DICTDT"),?41,"By: ",DATA("AUTHOR"),!
 . W ?2,"Signed: ",DATA("SIGDT"),?35,"Cosigned: ",DATA("COSDT"),!
 . S Y=1
 E  S Y=$$READ^TIUU("YO","Correct VISIT","YES")
 W !
CHEKDSX Q $G(Y)
 ;
 ;
CHEKPN(DATA,TIUBY) ;EP; Display/validate demographic/visit information
 NEW Y
 W !!,"Creating new ",$G(TIUTYPNM,"document"),"..."
 W !!?1,"Patient: ",$$NAME^TIULS(DATA("PNM"),"LAST, FIRST MI"),?39,"HRCN: "
 W DATA("HRCN"),?62,"Sex: ",$S(DATA("SEX")]"":$P(DATA("SEX"),U,2),1:"UNKNOWN")
 W !?4,"Date/time of ",$S($$HOSP:"Admission:  ",1:"Visit:  ")
 W $S(+$P($G(DATA("VSTR")),";",2):$$DATE^TIULS($P(DATA("VSTR"),";",2),"MM/DD/YY HR:MIN"),1:"UNKNOWN")
 W "  ",$E($$GET1^DIQ(9000010,+DATA("VISIT"),.06),1,12)  ;facility
 I '$$HOSP W ?55,$E($$GET1^DIQ(9000010,+DATA("VISIT"),.08),1,20) I 1
 E  W ?61,"Ward:  ",$P(DATA("LOC"),U,2)
 ;
 S Y=$$READ^TIUU("YO","Correct VISIT","YES")
 I $S($D(DIROUT):1,$D(DUOUT):1,$D(DTOUT):1,1:0) Q 0
 I +Y'>0 D
 . K X D MAIN^TIUVSIT(.X,DFN,"","","","",1)
 . S Y=$S($D(X)>9:$$CHEKPN(.X,.TIUBY),1:0)
 Q Y
 ;
HOSP() ; -- returns 1 if visit is hospitalization
 Q $S($P($G(DATA("CAT")),U)="H":1,1:0)
