APCL2A ; IHS/CMI/LAB - APC visits by primary provider ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;CMI/TUCSON/LAB - fixed FY patch 3
START ; 
 D INFORM
 K DUOUT,DTOUT
FY D ^APCLFY
 ;beginning Y2K
 ;I $D(DTOUT)!(Y=-1) G EOJ ;Y2000
 I $D(DTOUT)!(APCL("FY")=-1) G EOJ ;Y2000
 ;I $G(APCL("FY"))=$E(DT,2,3)&(DT'>APCL("FY END DATE")) W !!?6,"Current FISCAL Year date range:  ",APCL("FY PRINTABLE BDATE")," - ",APCL("FY TODAY") ;Y2000
 ;E  W !!?6,"FISCAL Year date range:  ",APCL("FY PRINTABLE BDATE")," - ",APCL("FY PRINTABLE EDATE") ;Y2000
 I APCL("FY BEG DATE")>DT W $C(7),$C(7),!!?6,"You have selected a FY with a beginning date that is in the future!!",!,?6,$$FMTE^XLFDT(APCL("FY BEG DATE")),"  Select again!",! G FY ;Y2000
 W !!?6,"FISCAL Year date range: ",$$FMTE^XLFDT(APCL("FY BEG DATE"))," - ",$S(APCL("FY END DATE")>DT:$$FMTE^XLFDT(DT),1:$$FMTE^XLFDT(APCL("FY END DATE"))) ;Y2000
 S APCLFY=APCL("FY BEG DATE")
 S APCLFYE=APCL("FY END DATE")
 S APCLSD=$P(APCL("FY WORKING DT"),".",1)
 W !
 ;S:$G(APCL("FY"))=$E(DT,2,3)&(DT'>APCL("FY END DATE")) %DT("B")=APCL("FY TODAY") ;Y2000
 ;E  S %DT("B")=APCL("FY PRINTABLE EDATE") ;Y2000
 ;end Y2K
F ;
 ;S X=$O(^DIC(7,0)) I $P($G(^DIC(7,X,9999999)),U,5)="" W !!,"Your provider class file does not contain the 1A workload reportable flags.",!,"This report cannot be run accurately until AUM Patch 6 is installed.",!! H 2
 ;W !!
 ;S DIC("A")="Run for which Facility of Encounter: ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 FY
 ;S APCLLOC=+Y
FAC ;
 K APCLQ
 W !!,$G(IORVON)_"Please enter which FACILITY visits will be included in the list."_$G(IORVOFF),!
 S APCLLOCT=""
 K APCLLOCS
 S DIR(0)="S^S:Selected set or Taxonomy of Locations;O:ONE Location/Facility",DIR("A")="Include Visits to Which Location/Facilities",DIR("B")="A"
 S DIR("A")="Enter a code indicating what LOCATIONS/FACILITIES are of interest",DIR("B")="O" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) FY
 S APCLLOCT=Y
 D @(APCLLOCT_"LOC")
 G:$D(APCLQ) FAC
 W !!,$C(7),$C(7),"THIS REPORT MUST BE PRINTED ON 132 COLUMN PAPER OR ON A PRINTER THAT IS",!,"SET UP FOR CONDENSED PRINT!!!",!,"IF YOU DO NOT HAVE SUCH A PRINTER AVAILABLE - SEE YOUR SITE MANAGER.",!
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G FY
ZIS ;
 S XBRP="^APCL2AP",XBRC="^APCL2A1",XBRX="EOJ^APCL2A",XBNS="APCL"
 D ^XBDBQUE
 D EOJ
 Q
ERR W $C(7),$C(7),!,"Must be a valid Year.  Enter a year only!!" Q
EOJ K APCLFY,APCLLOC,APCLSD,APCLVDFN,APCLVREC,APCLSKIP,APCLCLIN,APCL1,APCL2,APCLDISC,APCLAP,APCLPPOV,APCLX,APCLDPTR,APCLVLOC,APCLMOL,APCLFYD,APCLMOS,APCLBT,APCLJOB
 K APCLDT,APCLAREA,APCLLOCP,APCLLOC,APCLAREC,APCLSU,APCLSUC,APCLGRAN,APCLPG,APCLQUIT,APCLMON,APCLTAB,APCLJ,APCLDISN,APCLPRIM,APCLP,APCLT,APCLPRIT,APCL132,APCLFYE,APCLLOCC,DFN,APCLPDC,APCL
 K X,X1,X2,IO("Q"),%,Y,%DT,%Y,%W,%T,%H,DUOUT,DTOUT,POP,H,S,TS,M
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF
 W !,"**********  PCC/APC REPORT 1A  **********",!
 W !,"This report will print Year to Date Ambulatory Visit Counts for the Facility",!,"and Fiscal Year that you select.  The counts by month are for date of"
 W !,"service.  This report will resemble, but not duplicate exactly, the",!,"APC 1A report produced at the IHS Data Warehouse in Albuquerque.",!!
 Q
 ;
 ;
OLOC ;one location
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Which LOCATION: " D ^DIC K DIC
 I Y=-1 S APCLQ="" Q
 S APCLLOCS(+Y)=""
 Q
SLOC ;taxonomy of locations
 S X="LOCATION OF ENCOUNTER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" S APCLQ="" Q
 D PEP^AMQQGTX0(+Y,"APCLLOCS(")
 I '$D(APCLLOCS) S APCLQ="" Q
 I $D(APCLLOCS("*")) K APCLLOCS W !!,"**** all locations cannot be selected ****",! G SLOC
 Q
 ;
