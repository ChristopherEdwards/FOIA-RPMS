BHSAAP1 ;IHS/MSC/MGH  - Health summmary for asthma action plan;06-May-2010 10:41;MGH
 ;;1.0;HEALTH SUMMARY COMONENTS;**4**;March 17, 2006;Build 13
 ;Copy of APCHAAP1 to print out an asthma action plan
EHR ; ;EP
 N BHSRELM,BHSRESM,BHSRZC,BHSRZY
 D CKP^GMTSUP Q:$D(GMTSQIT)
 W:$D(^AUPNPAT(DFN,41,DUZ(2),0)) !,"Patient's chart number is ",$P(^(0),U,2),! W !
RELMED ;
 S BHSRELM=$P($$REDZONE(DFN),U)  ;get last recorded red zone instructions
 I BHSRELM="" S BHSRZC="B" G RESMED
 E  S BHSRZC="E" G RESMED
RESMED ;
 S BHSRESM=$P($$YELZONE(DFN),U)  ;get last recorded YELLOW zone instructions
 I BHSRESM="" S BHSRZY="B"
 E  S BHSRZY="E"
PRINT ;Print out the health summary
 D PRINT^BHSAAP2
 Q
REDZONE(P) ;EP - get last recorded red zone instructions
 NEW R,D,I,S
 S R=""  ;instructions
 S D=""
 S S=""
 F  S D=$O(^AUPNVAST("AA",P,D)) Q:D'=+D!(R]"")  D
 .S I=0 F  S I=$O(^AUPNVAST("AA",P,D,I)) Q:I'=+I!(R]"")  D
 ..S R=$P($G(^AUPNVAST(I,13)),U,1),S=9999999-D
 ..Q
 .Q
 Q R_U_S
YELZONE(P) ;EP - get last recorded yellow zone instructions
 NEW R,D,I
 S R=""  ;instructions
 S D="",S=""
 F  S D=$O(^AUPNVAST("AA",P,D)) Q:D'=+D!(R]"")  D
 .S I=0 F  S I=$O(^AUPNVAST("AA",P,D,I)) Q:I'=+I!(R]"")  D
 ..S R=$P($G(^AUPNVAST(I,11)),U,1),S=9999999-D
 ..Q
 .Q
 Q R_U_S
HEAD ;
 ;I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQ=1 Q
HEAD1 ;
 ;W:$D(IOF) @IOF
 W !,$P(^DIC(4,DUZ(2),0),U),?53,"Today's Date: ",$$FMTE^XLFDT(DT),!
 W "Patient Name: ",$P(^DPT(DFN,0),U)
 W ?45,"Birth Date: ",$$DOB^AUPNPAT(DFN,"E")
 W ?71,"Age: ",$$AGE^AUPNPAT(DFN),!
 W $$REPEAT^XLFSTR("_",79),!!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
