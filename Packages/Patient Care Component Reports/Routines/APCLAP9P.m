APCLAP9P ; IHS/CMI/LAB - print apc report ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
START ;
 S (APCLTOT,APCLPG)=0 D HEAD
 K APCLQUIT
 D PRINT
 ;
DONE ;
 D DONE^APCLOSUT
 K ^XTMP("APCLAP9",APCLJOB,APCLBT)
 Q
PRINT ;
 W !,"FACILITY:  ",$P(^DIC(4,APCLLOC,0),U)," - ",$P(^AUTTLOC(APCLLOC,0),U,10)
 W !,"VISIT DATE RANGE:  ",$$FMTE^XLFDT(APCLBD)," - ",$$FMTE^XLFDT(APCLED)
 W !!,"Total Visits Processed in PCC:  ",APCLGRAN
 W !!,?45,"as of the Date the report was run:",!,?45,"# complete",?60,"# incomplete",!?45,"----------",?60,"------------",!
TYPE ;
 S APCLX="",C=0 F  S APCLX=$O(^XTMP("APCLAP9",APCLJOB,APCLBT,"TYPE",APCLX)) Q:APCLX=""!($D(APCLQUIT))  S C=C+1 D
 .I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 .W ! W:C=1 "TYPE:  " W ?19,APCLX,?45,$J($P(^XTMP("APCLAP9",APCLJOB,APCLBT,"TYPE",APCLX),U),6),?60,$J($P(^XTMP("APCLAP9",APCLJOB,APCLBT,"TYPE",APCLX),U,2),6)
 W !! S APCLX="",C=0 F  S APCLX=$O(^XTMP("APCLAP9",APCLJOB,APCLBT,"SC",APCLX)) Q:APCLX=""!($D(APCLQUIT))  S C=C+1 D
 .I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 .W ! W:C=1 "SERVICE CATEGORY:  " W ?19,$E(APCLX,1,24),?45,$J($P(^XTMP("APCLAP9",APCLJOB,APCLBT,"SC",APCLX),U),6),?60,$J($P(^XTMP("APCLAP9",APCLJOB,APCLBT,"SC",APCLX),U,2),6)
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !!,"APC Acceptable Visits based on Headquarters Definition:  ",$J(APCLAPC,7)
EXCL ;
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !!,"Exclusions from APC System:",!
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !?10,"Dental Clinic w/o Medication",?60,$J($S($G(^XTMP("APCLAP9",APCLJOB,APCLBT,"DENTAL NO MED")):^XTMP("APCLAP9",APCLJOB,APCLBT,"DENTAL NO MED"),1:0),6)
 W !?10,"Other Excluded Clinic Type",?60,$J($S($G(^XTMP("APCLAP9",APCLJOB,APCLBT,"NONAPCCLN")):^XTMP("APCLAP9",APCLJOB,APCLBT,"NONAPCCLN"),1:0),6)
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !?10,"Incomplete A, O or S",?60,$J($S($G(^XTMP("APCLAP9",APCLJOB,APCLBT,"AOS INCOMPLETE")):^XTMP("APCLAP9",APCLJOB,APCLBT,"AOS INCOMPLETE"),1:0),6)
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !?10,"Non APC Service Category",?60,$J($S($G(^XTMP("APCLAP9",APCLJOB,APCLBT,"NONAPCSC")):^XTMP("APCLAP9",APCLJOB,APCLBT,"NONAPCSC"),1:0),6)
 W !?10,"Non APC Visit Type",?60,$J($S($G(^XTMP("APCLAP9",APCLJOB,APCLBT,"NONAPCTYPE")):^XTMP("APCLAP9",APCLJOB,APCLBT,"NONAPCTYPE"),1:0),6)
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 ;W !?10,"Mult Visits same patient, same day, same clinic",?60,$J($S($G(^XTMP("APCLAP9",APCLJOB,APCLBT,"DUPLICATE")):^XTMP("APCLAP9",APCLJOB,APCLBT,"DUPLICATE"),1:0),6)
 ;I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !!?3,"Of the acceptable APC visits, ",$J($S($G(^XTMP("APCLAP9",APCLJOB,APCLBT,"IN XREF")):^XTMP("APCLAP9",APCLJOB,APCLBT,"IN XREF"),1:0),6)," were posted or modified after",!
 W ?3,"the last NDW export and would not be reflected in reports from ",!,"the National Data Warehouse."
 I $Y>(IOSL-5) D HEAD Q:$D(APCLQUIT)
 W !?3,"Of the acceptable APC visits, ",$J($S($G(^XTMP("APCLAP9",APCLJOB,APCLBT,"NO EXPORT - ?")):^XTMP("APCLAP9",APCLJOB,APCLBT,"NO EXPORT - ?"),1:0),6)," were not exported due to an error."
 W !?3,"These can be reviewed using other PCC reports.",!
 Q
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^DIC(4,DUZ(2),0),U),?58,$$FMTE^XLFDT(DT),?72,"Page ",APCLPG,!
 W ?28,"PCC DATA ANALYSIS REPORT",!
 W $TR($J("",80)," ","*"),!
 Q
