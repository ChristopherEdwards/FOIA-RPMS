BKMSTID2 ;PRXM/HC/ALA-STI Display ; 20 Mar 2007  2:23 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
PAT ; Get patient
 NEW DIR,RPSDT,RPEDT,Y,X,DTOUT,DUOUT,DFN,SEX,SSN,PTNAME,AGE,AUPNDAYS,AUPNDOB
 NEW AUPNDOD,AUPNPAT,AUPNSEX,BKARRAY,SIEN,STINM,STI,NIN,DDATA,RSTI,NSTI,RSTINM
 NEW RSTNM,RSIEN,NSIEN,NRSCR,HVDFL,BKTYPE,NCT,NSCR,RFL,SCREEN,LR,NTSCR,QFL,SSCREEN
 NEW TOT,BKIN,BKN,HSCR,POP,INC,SDAT,STYP,BKBDT,BKEDT,CT,BKMARRAY
 W !!
 D PLK^BKMPLKP
 I $G(AUPNPAT)="" Q
 S DIR("A")="Enter Report Start Date"
 S DIR("B")=$$FMTE^XLFDT(3060101,1)
 S DIR(0)="D"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q
 S RPSDT=Y
 ;
 S DIR("A")="Enter Report End Date"
 S DIR("B")=$$FMTE^XLFDT($$FMADD^XLFDT(RPSDT,365),1)
 S DIR(0)="D"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q
 S RPEDT=Y
 ;
 K DIR
 S DIR("A")="Enter STI type"
 S DIR(0)="S^K:KEY;O:OTHER;A:ALL"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q
 ;
PRT K %ZIS,IOP,IOC,ZTIO
 S %ZIS="M" D ^%ZIS Q:POP  ; ask device
 I $D(IO("Q")) D EN^DDIOL("Cannot queue this") G PRT
 ;
 U IO
 ;
 I IOST'["C-" W !,?10,"HRN: "_$$HRN^AUPNPAT3(AUPNPAT,DUZ(2)),?40,"Date Range: "_$$FMTE^XLFDT(RPSDT,"2Z")_" - "_$$FMTE^XLFDT(RPEDT,"2Z")
 S X=$$UP^XLFSTR(X)
 S BKTYPE=$S(X="K":"KEY",X="O":"OTHER",1:""),HVDFL=0
 K BKARRAY S QFL=0
 ;  Set beginning date to 2 months (60 days) prior to CRS report period begin date
 ;  through the first 300 days of the CRS report period
 S BKBDT=$$FMADD^XLFDT(RPSDT,-60),BKEDT=$$FMADD^XLFDT(RPSDT,300)
 D EN^BKMSTI(AUPNPAT,BKBDT,BKEDT,BKTYPE,.BKARRAY,.HVDFL)
 I '$D(BKARRAY) W !,"Patient has no STI diagnoses" D ^%ZISC G PAT
 I $D(BKARRAY) D
 . NEW STI
 . S STI=""
 . F  S STI=$O(BKARRAY(STI)) Q:STI=""  D  Q:QFL
 .. I $G(BKARRAY(STI,"DEN"))'=0 S QFL=1 Q
 I 'QFL W !!!,"Patient has no STI diagnoses" D ^%ZISC G PAT
 D INC
 ;  clean up extras
 S INC=0
 F  S INC=$O(BKSTIY(INC)) Q:INC=""  D
 . S STYP=""
 . F  S STYP=$O(BKSTIY(INC,STYP)) Q:STYP=""  D
 .. S SDAT="",CT=0
 .. F  S SDAT=$O(BKSTIY(INC,STYP,"DEN",SDAT)) Q:SDAT=""  D
 ... S CT=CT+1
 ... I CT>1 K BKSTIY(INC,STYP,"DEN",SDAT)
 ;
 S INC=0
 F  S INC=$O(BKSTIY(INC)) Q:INC=""  D
 . W !!,?5,"Diagnosis Incident: ",INC
 . K REC,NBREC,NREC
 . S TYP="" F  S TYP=$O(BKSTIY(INC,TYP)) Q:TYP=""  D
 .. S DAT=""
 .. F  S DAT=$O(BKSTIY(INC,TYP,"DEN",DAT)) Q:DAT=""  D
 ... W !,?10,$$FMTE^XLFDT(DAT,"2Z"),"  ",TYP,"  ",BKSTIY(INC,TYP,"DEN",DAT)
 ... S RC=""
 ... F  S RC=$O(BKARRAY(TYP,"NUM",RC)) Q:RC=""  D
 .... I $G(REC(RC))="" S REC(RC)=$P($G(BKARRAY(TYP,"NUM",RC,DAT)),U,2),NREC(RC)=""
 .... I RC="HIV" D
 ..... NEW HKDATE,HEDATE
 ..... S HKDATE="",HEDATE=DAT
 ..... S HVDFL=$$HIVS^BKMRMDR(AUPNPAT,.HKDATE,.HEDATE)
 ..... ; HIV Diagnosis takes precedence over HIV screening
 ..... I +HVDFL=0 S NREC(RC)=$P($G(BKARRAY(TYP,"NUM",RC)),U,2) Q
 ..... I +HVDFL=1 S NREC(RC)=$P(HVDFL,U,2)
 .... ;I HVDFL,RC="HIV" S NREC(RC)=$P(BKARRAY(TYP,"NUM",RC),U,2)
 .... I $G(NREC(RC))="" D
 ..... I $G(BKARRAY(RC,"DEN",DAT))'="" S NREC(RC)=$$FMTE^XLFDT(DAT,"2Z")_" "_$G(BKARRAY(RC,"DEN",DAT)) Q
 ..... NEW BDATE,EDATE,DDT,QFL
 ..... S EDATE=$$FMADD^XLFDT(DAT,60),BDATE=$$FMADD^XLFDT(DAT,-30)
 ..... S DDT="",QFL=0
 ..... F  S DDT=$O(BKARRAY(RC,"DEN",DDT)) Q:DDT=""  D  Q:QFL
 ...... I DDT'<BDATE,DDT'>EDATE S NREC(RC)=$$FMTE^XLFDT(DDT,"2Z")_" "_$G(BKARRAY(RC,"DEN",DDT)),QFL=1
 ..... I $G(BKMARRAY(RC,"DEN"))="" D
 ...... D EN^BKMSTI(DFN,BDATE,EDATE,RC,.BKDXN,.HVDFL)
 ...... I $P(BKDXN(RC,"DEN"),U,1)'=0 S NREC(RC)=$P($P(BKDXN(RC,"DEN"),U,2),";",1)
 ...... K BKDXN
 .... I $G(NREC(RC))="",$G(BKARRAY(TYP,"REF",RC,DAT))'="" S REC(RC)=$P($G(BKARRAY(TYP,"REF",RC,DAT)),U,1)
 . W !,?5,"Recommended Screenings: "
 . S RC="" F  S RC=$O(REC(RC)) Q:RC=""  W !,?10,"1 "_RC
 . W !,?5,"Needed Screenings: "
 . S RC="" F  S RC=$O(NREC(RC)) Q:RC=""  D
 .. S NUM=$S(NREC(RC)="":1,1:0)
 .. S SUMNREC(RC)=$G(SUMNREC(RC))+NUM
 .. I NREC(RC)="" W !,?10,NUM_" "_RC Q
 .. W !,?10,NUM_" "_RC_" "_NREC(RC)
 . W !,?5,"Need-based Screenings Performed: "
 . S RC="" F  S RC=$O(REC(RC)) Q:RC=""  D
 .. I $G(NREC(RC))'="" Q
 .. S NUM=$S($G(REC(RC))="":0,1:1)
 .. S SUMNBRC(RC)=$G(SUMNBRC(RC))+NUM
 .. I $G(REC(RC))="" W !,?10,NUM_" "_RC Q
 .. W !,?10,NUM_" "_RC_" "_REC(RC)
 W !!,?5,"Summary",!
 W !,?5,"Needed Screenings: "
 S RC=""
 F  S RC=$O(SUMNREC(RC)) Q:RC=""  W !,?10,SUMNREC(RC)_" "_RC
 ;
 W !,?5,"Need-Based Screenings Performed: "
 S RC=""
 F  S RC=$O(SUMNBRC(RC)) Q:RC=""  D
 . S NUM=SUMNBRC(RC),NPR=SUMNREC(RC)
 . I NPR'=0 S PER=$J((NUM/NPR)*100,3,0)
 . I NPR=0 S PER=0
 . W !,?10,SUMNBRC(RC)_" "_RC_"   "_PER_"%"
 D ^%ZISC
 K REC,NREC,NBREC,SUMNBRC,SUMNREC,MBKARAY,BKSTIY,DAT,INC,NPR,NUM,PER,RC,TYP
 G PAT
 ;
INC ;EP - Determine multiple incidences
 NEW TYP,DAT,INC,PDAT,NXDT,NTYP,DTDIF
 K MBKARAY,BKSTIY
 S TYP=""
 F  S TYP=$O(BKARRAY(TYP)) Q:TYP=""  D
 . S DAT=""
 . F  S DAT=$O(BKARRAY(TYP,"DEN",DAT)) Q:DAT=""  D
 .. S MBKARAY(DAT,TYP)=BKARRAY(TYP,"DEN",DAT)
 S INC=0,DAT="",PDAT=""
 F  S DAT=$O(MBKARAY(DAT)) Q:DAT=""  D
 . S INC=INC+1 D SDT(DAT) K MBKARAY(DAT)
 . S DTDIF=$$FMADD^XLFDT(DAT,60)
 . S NXDT=DAT F  S NXDT=$O(MBKARAY(NXDT)) Q:NXDT=""  D
 .. I NXDT<DTDIF D
 ... D SDT(NXDT)
 ... K MBKARAY(NXDT)
 Q
 ;
SDT(VDT) ;EP - Same date, multiple types
 S TYP=""
 F  S TYP=$O(MBKARAY(VDT,TYP)) Q:TYP=""  D
 . S BKSTIY(INC,TYP,"DEN",VDT)=MBKARAY(VDT,TYP)
 Q
