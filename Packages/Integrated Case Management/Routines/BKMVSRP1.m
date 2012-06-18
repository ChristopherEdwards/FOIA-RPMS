BKMVSRP1 ;PRXM/HC/CJS - Continuation of BKMVSRP BKMV, State Reporting Report; [ 1/19/2005  7:16 PM ] ; 17 Jul 2005  1:09 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;PRXM/HC/CJS 07/07/2005 -- In addition to the explicit changes described below,
 ;variables have been NEWed or KILLed as needed to prevent strays.
 ;07/14/2005 -- Added Patient Name function for new sort criterion
 ;07/17/2005 -- Fixed use of correct piece of BKMIEN throughout
 Q
PATNAME(BKMIEN) ;return patient name
 N PATNAME
 S PATNAME=$$GET1^DIQ(9000001,$P(BKMIEN,U,2)_",",.01)
 Q PATNAME
HRECNO(BKMIEN) ;return patient's HREC Number
 Q $$HRN^BKMVA1($P(BKMIEN,U,2))
GET(BKMIEN) ;EP - BKMIEN=HMS Registry IEN^Patient IEN, i.e., a result returned from a FileMan ^DIC lookup
 ;iCARE REGISTRY FILE
 N DA,DIC,DIQ,DR,REGISTER,REGIEN,SRSIENS,X,Y
 S REGISTER=$$HIVIEN^BKMIXX3()
 S DA=+BKMIEN
 S REGIEN=$O(^BKM(90451,DA,1,"B",REGISTER,""))
 ; VA PATIENT FILE from HMS REGISTRY
 S DIC="^BKM(90451,",DR=".02",DIQ="LOCAL",DIQ(0)="IE" D EN^DIQ1
 ; DIAGNOSIS, STATE REPORTING STATUS and STATE REPORTING DATE from iCARE REGISTRY FILE <--
 ; STATE CONFIRMATION STATUS and STATE CONFIRMATION DATE from iCARE REGISTRY FILE <--
 D GETS^DIQ(90451.01,REGIEN_","_BKMIEN_",","2.3;.5;5;5.5;4;4.1;4.2;4.3;4.5;4.51;4.52;4.53","IE","LOCAL")
 ; get PATIENT NAME,SEX,DOB from VA PATIENT FILE
 S DA=DFN
 S DIC="^DPT(",DR=".01",DIQ="LOCAL" D EN^DIQ1
 S DIC="^DPT(",DR=".02;.03",DIQ="LOCAL",DIQ(0)="I" D EN^DIQ1
 ;get HEALTH RECORD NUMBER from PATIENT FILE
 S LOCAL("HRECNO")=$$HRN^BKMVA1(DFN)
 ; AGE and Community
 S DIC="^AUPNPAT(",DA=DFN,DR="1102.98;1118",DIQ="LOCAL",DIQ(0)="" D EN^DIQ1
 D GETS^DIQ(90451.01,REGIEN_","_BKMIEN_",",".015","IE","LOCAL")
 Q
PRINT(PAGE,LINES,BKMIEN) ;EP - Print Report
 N BKMSTAT,SRSIENS,REGCAT,ASR,HSR
 I '$D(PAGE) S PAGE=1
 I '$D(LINES) S LINES=0
 S BKMSTAT=$P($G(^BKM(90451,BKMIEN,1,1,0)),U,7)
 N A,BKMRDIAG,DPTIEN,DTOUT,AGE
 ; dashed lines
 S $P(A,"-",79)=""
 S DPTIEN=DFN
 ;
 ; Array LOCAL must be set up with the following subscripts
 ;LOCAL(2,DPTIEN,.01)=name
 ;LOCAL(2,DPTIEN,.01,"E")=name
 ;LOCAL(2,DPTIEN,.02,"I")=sex...not a Yes/No
 ;LOCAL(2,DPTIEN,.03,"I")=date of birth in internal format
 ;LOCAL(9000001,BKMIEN,1102.98)=age
 ;LOCAL(9000001,BKMIEN,1118)=community
 ;LOCAL(90451.01,"1,"_BKMIEN_",",.015,"E")=FACILITY(WHERE FOLLOWS)
 ;LOCAL(90451.01,"1,"_BKMIEN_",",2.3,"E")=DIAGNOSIS CATEGORY
 ;LOCAL(90451.01,"1,"_BKMIEN_",",5,"I")=INITIAL HIV DX DATE
 ;LOCAL(90451.01,"1,"_BKMIEN_",",5.5,"I")=INITIAL AIDS DX DATE
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4.3,"I")=STATE HIV REPORT STATUS
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4,"I")=STATE HIV REPORT DATE
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4.1,"E")=STATE HIV CONFIRMATION STATUS
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4.2,"E")=STATE HIV CONFIRMATION DATE
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4.51,"E")=STATE AIDS ACKNOWLEDGEMENT STATUS
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4.52,"E")=STATE AIDS ACKNOWLEDGEMENT DATE
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4.53,"I")=STATE AIDS REPORT STATUS
 ;LOCAL(90451.01,"1,"_BKMIEN_",",4.5,"I")=STATE AIDS REPORT DATE
 ;LOCAL("HRECNO")=HEALTH RECORD NUMBER
 ;
 I PAGE=1!(LINES=0) D HEADER
 W ?1,$E($G(LOCAL(2,DPTIEN,.01,"E")),1,20),?23,$E($G(LOCAL("HRECNO")),1,9)
 ;The following 3 ";" lines will change age look-up since 1102.98 does not take date of death into account
 ;S AGE=$$UP^XLFSTR($$AGE^BKMIMRP1(DPTIEN))
 ;W ?30,$E($G(LOCAL(9000001,DPTIEN,1118)),1,12),?43,AGE I AGE?1.N W "Y"
 ;W ?48,$G(LOCAL(2,DPTIEN,.02,"I"))
 W ?30,$E($G(LOCAL(9000001,DPTIEN,1118)),1,12),?43,$E($P($G(LOCAL(9000001,DPTIEN,1102.98))," "),1,3)
 W $E($P($G(LOCAL(9000001,DPTIEN,1102.98))," ",2),1),?48,$G(LOCAL(2,DPTIEN,.02,"I"))
 W ?51,$G(LOCAL(90451.01,"1,"_BKMIEN_",",2.3,"E"))
 I $G(LOCAL(90451.01,"1,"_BKMIEN_",",2.3,"I"))="H",$G(LOCAL(90451.01,"1,"_BKMIEN_",",5,"I")) D
 . W ?57,$P($$FMTE^XLFDT(LOCAL(90451.01,"1,"_BKMIEN_",",5,"I"),"2Z"),"@")
 I $G(LOCAL(90451.01,"1,"_BKMIEN_",",2.3,"I"))="A",$G(LOCAL(90451.01,"1,"_BKMIEN_",",5.5,"I")) D
 . W ?57,$P($$FMTE^XLFDT(LOCAL(90451.01,"1,"_BKMIEN_",",5.5,"I"),"2Z"),"@")
 W ?67,$E(LOCAL(90451.01,"1,"_BKMIEN_",",.015,"E"),1,12)
 I STHIV'=0 D
 . W !?5,"HIV Report:  "
 . I $G(LOCAL(90451.01,"1,"_BKMIEN_",","4.3","I"))="" W "Not documented" Q
 . W ?8,$G(LOCAL(90451.01,"1,"_BKMIEN_",","4.3","E"))," "
 . I $G(LOCAL(90451.01,"1,"_BKMIEN_",",4,"I")) D
 . . W $P($$FMTE^XLFDT(LOCAL(90451.01,"1,"_BKMIEN_",",4,"I"),"2Z"),"@")
 . W ?43,"Receipt Confirmed: "
 . I $G(LOCAL(90451.01,"1,"_BKMIEN_",","4.1","I"))="" W "Not documented" Q
 . W $G(LOCAL(90451.01,"1,"_BKMIEN_",","4.1","E"))," "
 . I $G(LOCAL(90451.01,"1,"_BKMIEN_",","4.2","I")) D
 . . W $P($$FMTE^XLFDT(LOCAL(90451.01,"1,"_BKMIEN_",","4.2","I"),"2Z"),"@")
 I STHIV'=0 D
 . W !?5,"AIDS Report: "
 . I $G(LOCAL(90451.01,"1,"_BKMIEN_",",4.53,"I"))="" W "Not documented" Q
 . W ?8,$G(LOCAL(90451.01,"1,"_BKMIEN_",",4.53,"E"))," "
 . I $G(LOCAL(90451.01,"1,"_BKMIEN_",",4.5,"I")) D
 . . W $P($$FMTE^XLFDT(LOCAL(90451.01,"1,"_BKMIEN_",",4.5,"I"),"2Z"),"@")
 . W ?43,"Receipt Confirmed: "
 . I $G(LOCAL(90451.01,"1,"_BKMIEN_",","4.51","I"))="" W "Not documented" Q
 . W $G(LOCAL(90451.01,"1,"_BKMIEN_",",4.51,"E"))," "
 . I $G(LOCAL(90451.01,"1,"_BKMIEN_",",4.52,"I")) D
 . . W $P($$FMTE^XLFDT(LOCAL(90451.01,"1,"_BKMIEN_",",4.52,"I"),"2Z"),"@")
 W !!
 S LINES=LINES+3
 G:$Y<(IOSL-5) AR
 S QUIT=$$PAUSE^BKMIXX3() I QUIT S QUITALL=1 Q
 S LINES=0
 Q
 ;
AR Q
HEADER ;
 ;PRINT HEADER
 N BKMLOC,X,NAME
 I $G(NOW)="" S NOW=$$FMTE^XLFDT(DT)
 W:PAGE>1 @IOF
 S BKMLOC=$P(^AUTTSITE(1,0),U,1),BKMLOC=$P(^DIC(4,BKMLOC,0),U,1)
 W !?1,$P(^VA(200,DUZ,0),U,2)
 W ?IOM-$L(NOW)\2,NOW,?IOM-10,"Page: ",PAGE
 W !?IOM-$L(BKMLOC)\2,BKMLOC
 W !?IOM-41\2,"*** HMS State Reporting Status Report ***"
 S NAME="HMS Active Patients: ["_$S(CAT="A":"All",CAT="N":"Not Reported",1:"Reported")_"]"
 W !?IOM-$L(NAME)\2,NAME
 W !?18,"***  CONFIDENTIAL PATIENT INFORMATION  ***"
 W !?68,"Where"
 W !?1,"Patient Name",?24,"HRN",?30,"Community",?43,"Age",?47,"Sex",?52,"DX"
 W ?60,"Date",?67,"Followed"
 W !?1,A,!
 S LINES=10,PAGE=PAGE+1
 Q
FOOTER ;EP - Confidentiality notice
 N QUIT
 W !!?16,"*** END CONFIDENTIAL PATIENT INFORMATION ***",!
 I IOST["C-" S QUIT=$$PAUSE^BKMIXX3()
 Q
XIT ;EXIT ROUTINE
 Q
