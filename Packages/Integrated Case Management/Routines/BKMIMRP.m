BKMIMRP ;PRXM/HC/BWF - BKMV UTILITY PROGRAM; [ 1/12/2005  7:16 PM ] ; 13 Jun 2005  1:39 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
PAUSE ;EP - Utility to pause the print screen.
 D ^XBFMK
 S (BKMRTN,ENTER,QUITALL)=""
 I $E(IOST,1,2)="C-",$$PAUSE^BKMIXX3 S (BKMRTN,ENTER,QUITALL)="^"
 Q
 ;
GENFLTR(GENDER) ;EP - Gender Filter
 N DFN,VSIT,SEX
 S DFN=""
 I '$D(^TMP("BKMIMRP1",$J,"PTFLTR")) D BLDPTLST^BKMIMRP1
 F  S DFN=$O(^TMP("BKMIMRP1",$J,"PTFLTR",DFN)) Q:DFN=""  D
 .S SEX=$$GET1^DIQ(2,DFN_",",.02,"I","","")
 .I SEX=GENDER Q
 .S VSIT=0
 .F  S VSIT=$O(^TMP("BKMIMRP1",$J,"PTFLTR",DFN,VSIT)) Q:VSIT=""  D
 ..K ^TMP("BKMIMRP1",$J,"DTFLTR",VSIT)
 Q
CLINFLTR(CLINIC) ;EP - Filters out entries that do not have the same clinic that was selected by the user.
 N VSIT
 S VSIT=0
 F  S VSIT=$O(^TMP("BKMIMRP1",$J,"DTFLTR",VSIT)) Q:VSIT=""  D
 .S CLIN=$$GET1^DIQ(9000010,VSIT_",",.08,"I","","")
 .I CLIN="" K ^TMP("BKMIMRP1",$J,"DTFLTR",VSIT) Q
 .I CLIN'=CLINIC K ^TMP("BKMIMRP1",$J,"DTFLTR",VSIT)
 Q
PRINT(SRT1,SRT2) ;EP - Print the report data.
 N NODE1,DFN,VSIT,VSDATA,PTNM,PROV,HRN,CLIN,DOB,VSDT,NEXT,NXTDFN,NXTVSIT,QUITALL
 S QUITALL=0
 ; if there is no data in the temp global, inform user of no data and quit
 I '$D(^TMP("BKMIMRP1",$J,"PRINT")) D  Q
 .W !! D HDR3^BKMIMRP1 W "No Data to Display for Search Criteria",! D HDR3^BKMIMRP1,PAUSE,XIT
 ; initialize page number
 S PAGE=1
 K %ZIS,IOP,IOC,ZTIO S %ZIS="MQ" D ^%ZIS G:POP XIT
 I $D(IO("Q")) D
 . S ZTRTN="PRINT1^BKMIMRP",ZTSAVE("SRT*")="",ZTSAVE("PAGE")=""
 . S ZTSAVE("OPT1TXT")="",ZTSAVE("OPT2TXT")="",ZTDESC="HMS PATIENT VISIT REPORT"
 . S ZTSAVE("^TMP(""BKMIMRP1"",$J,")=""
 I $D(IO("Q")) K IO("Q") D ^%ZTLOAD W !,"REQUEST QUEUED" G XIT^BKMIMRP
 D PRINT1
 Q
 ;
PRINT1 ;
 U IO
 W @IOF
 S QUITALL=0
 D HDRINFO^BKMIMRP1(PAGE)
 ; depending on selections made by user, sort data
 ; single sort selection by user
 G:QUITALL XIT
 I SRT2="" D
 .I SRT1'="P" D  Q
 ..S NODE1=0
 ..F  S NODE1=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1)) Q:NODE1=""!(QUITALL)  D
 ...I SRT1TXT="GENDER" W $S(NODE1="F":"FEMALES",NODE1="M":"MALES"),!?1,"--------",!?1
 ...I SRT1TXT="REGISTER STATUS" W !?1,$S(NODE1="A":"ACTIVE",NODE1="I":"INACTIVE",NODE1="D":"DECEASED",NODE1="T":"TRANSIENT",1:"UNKNOWN"),!?1
 ...S PAT=0
 ...F  S PAT=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,PAT)) Q:PAT=""!(QUITALL)  D
 ....W !?1,$E(PAT,1,19)
 ....S DFN=0
 ....F  S DFN=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,PAT,DFN)) Q:DFN=""!(QUITALL)  D
 .....S VSIT=0,BKMIEN=$O(^BKM(90451,"B",DFN,0))
 .....S FLAG=0
 .....S (VSIT,QUITALL)=0
 .....F  S VSIT=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,PAT,DFN,VSIT)) Q:VSIT=""!(QUITALL)  D
 ......; get all applicable print data
 ......S VSDATA=$G(^TMP("BKMIMRP1",$J,"PRINT",NODE1,PAT,DFN,VSIT))
 ......S PTNM=$P(VSDATA,U,1),PROV=$P(VSDATA,U,2),HRN=$P(VSDATA,U,10)
 ......S CLIN=$P(VSDATA,U,3),DOB=$P(VSDATA,U,11),VSDT=$P(VSDATA,U,12)
 ......W ?21,HRN,?28,DOB,?39,$P(VSDT,"@"),?50,$E(CLIN,1,12),?63,$E(PROV,1,16),!?1
 ......I FLAG W ?39,$P(VSDT,"@"),?50,$E(CLIN,1,12),?63,$E(PROV,1,16),!?1
 ......I ($Y=(IOSL-2))!($Y>(IOSL-2)) D PAGEA I BKMRTN="^" S QUITALL=1
 ......Q:QUITALL
 ......; if this is the last patient, check to see if there are any more visits
 ......; if not, then pause the screen so the user does not have to scroll up for
 ......; the last page of data
 ......;S NEXT=NODE1
 ......;S NEXT=$O(^TMP("BKMIMRP1",$J,"PRINT",NEXT))
 ......;I NEXT="" S NEXT=NODE1 D
 ......;.S NXTDFN=DFN
 ......;.S NXTDFN=$O(^TMP("BKMIMRP1",$J,"PRINT",NEXT,PAT,NXTDFN))
 ......;.I NXTDFN="" S NXTDFN=DFN D
 ......;..S NXTVSIT=VSIT
 ......;..S NXTVSIT=$O(^TMP("BKMIMRP1",$J,"PRINT",NEXT,PAT,NXTDFN,NXTVSIT))
 ......;..I NXTVSIT="" D PAUSE G:BKMRTN="^" XIT
 .; multiple sort selection by user.
 .S NODE1=0
 .F  S NODE1=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1)) Q:NODE1=""!($G(QUITALL))  D
 ..W !?1,$E(NODE1,1,19)
 ..S DFN=0
 ..F  S DFN=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,"PH",DFN)) Q:DFN=""!($G(QUITALL))  D
 ...S VSIT=0,BKMIEN=$O(^BKM(90451,"B",DFN,0))
 ...S FLAG=0
 ...S (VSIT,QUITALL)=0
 ...Q:'$D(^TMP("BKMIMRP1",$J,"PRINT"))
 ...F  S VSIT=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,"PH",DFN,VSIT)) Q:$G(VSIT)=""!($G(QUITALL))  D
 ....; get all applicable print data
 ....S VSDATA=$G(^TMP("BKMIMRP1",$J,"PRINT",NODE1,"PH",DFN,VSIT))
 ....S PTNM=$P(VSDATA,U,1),PROV=$P(VSDATA,U,2),HRN=$P(VSDATA,U,10)
 ....S CLIN=$P(VSDATA,U,3),DOB=$P(VSDATA,U,11),VSDT=$P(VSDATA,U,12)
 ....;W $E(PTNM,1,19),?20,HRN,?27,DOB,?38,$P(VSDT,"@"),?49,$E(CLIN,1,12),?62,$E(PROV,1,16),!
 ....W ?21,HRN,?28,DOB,?39,$P(VSDT,"@"),?50,$E(CLIN,1,12),?63,$E(PROV,1,16),!?1
 ....I FLAG W ?39,$P(VSDT,"@"),?50,$E(CLIN,1,12),?63,$E(PROV,1,16),!?1
 ....I ($Y=(IOSL-2))!($Y>(IOSL-2)) D PAGEA I BKMRTN="^" S QUITALL=1
 ....Q:QUITALL
 ....; if this is the last patient, check to see if there are any more visits
 ....; if not, then pause the screen so the user does not have to scroll up for
 ....; the last page of data
 ....S NEXT=NODE1
 ....S NEXT=$O(^TMP("BKMIMRP1",$J,"PRINT",NEXT))
 ....I NEXT="" S NEXT=NODE1 D
 .....S NXTDFN=DFN
 .....S NXTDFN=$O(^TMP("BKMIMRP1",$J,"PRINT",NEXT,"PH",NXTDFN))
 .....I NXTDFN="" S NXTDFN=DFN D
 ......S NXTVSIT=VSIT
 ......S NXTVSIT=$O(^TMP("BKMIMRP1",$J,"PRINT",NEXT,"PH",NXTDFN,NXTVSIT))
 ......I NXTVSIT="" D PAUSE G:BKMRTN="^" XIT
 ;-----------------------------------------------------------------------------
 I SRT2'="" D
 .I SRT1="P" D
 ..S NODE1=0
 ..F  S NODE1=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1)) Q:NODE1=""!(QUITALL)  D
 ...W $E(NODE1,1,19)
 ...S NODE2=0
 ...F  S NODE2=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2)) Q:NODE2=""!(QUITALL)  D
 ....;W:SRT2TXT="GENDER" $S(NODE2="F":"FEMALES",NODE2="M":"MALES",1:""),!,"--------",!
 ....;I SRT2TXT="REGISTER STATUS" W $S(NODE2="A":"ACTIVE",NODE2="I":"INACTIVE",NODE1="D":"DECEASED",NODE1="T":"TRANSIENT",1:"UNKNOWN",1:"")
 ....S DFN=0
 ....F  S DFN=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,"PH",DFN)) Q:DFN=""!(QUITALL)  D
 .....S (VSIT,FLAG)=0
 .....F  S VSIT=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,"PH",DFN,VSIT)) Q:VSIT=""!(QUITALL)  D
 ......S VSDATA=$G(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,"PH",DFN,VSIT))
 ......S PTNM=$P(VSDATA,U,1),PROV=$P(VSDATA,U,2),HRN=$P(VSDATA,U,10)
 ......S PROV=$P(PROV,",",1)_","_$E($P(PROV,",",2),1,2)
 ......S CLIN=$P(VSDATA,U,3),DOB=$P(VSDATA,U,11),VSDT=$P(VSDATA,U,12)
 ......W ?21,HRN,?28,DOB,?39,$P(VSDT,"@"),?50,$E(CLIN,1,12),?63,$E(PROV,1,16),!?1 S FLAG=1
 ......I ($Y=(IOSL-2))!($Y>(IOSL-2)) D PAGEA G:BKMRTN="^" XIT
 .I SRT2="P" D
 ..S NODE1=0
 ..F  S NODE1=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1)) Q:NODE1=""!(QUITALL)  D
 ...W:SRT1TXT="GENDER" $S(NODE1="F":"FEMALES",NODE1="M":"MALES"),!?1,"--------",!?1
 ...I SRT1TXT="REGISTER STATUS" W $S(NODE1="A":"ACTIVE",NODE1="I":"INACTIVE",NODE1="D":"DECEASED",NODE1="T":"TRANSIENT",1:"UNKNOWN")
 ...S NODE2=0
 ...F  S NODE2=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2)) Q:NODE2=""!(QUITALL)  D
 ....W $E(NODE2,1,19)
 ....S DFN=0
 ....F  S DFN=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,"PH",DFN)) Q:DFN=""!(QUITALL)  D
 .....S (VSIT,FLAG)=0
 .....F  S VSIT=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,"PH",DFN,VSIT)) Q:VSIT=""!(QUITALL)  D
 ......S VSDATA=$G(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,"PH",DFN,VSIT))
 ......S PTNM=$P(VSDATA,U,1),PROV=$P(VSDATA,U,2),HRN=$P(VSDATA,U,10)
 ......S PROV=$P(PROV,",",1)_","_$E($P(PROV,",",2),1,2)
 ......S CLIN=$P(VSDATA,U,3),DOB=$P(VSDATA,U,11),VSDT=$P(VSDATA,U,12)
 ......W ?21,HRN,?28,DOB,?39,$P(VSDT,"@"),?50,$E(CLIN,1,12),?63,$E(PROV,1,16),!?1 S FLAG=1
 ......I ($Y=(IOSL-2))!($Y>(IOSL-2)) D PAGEA G:BKMRTN="^" XIT
 .;--------------------------------------------------------------------------------
 .S NODE1=0
 .F  S NODE1=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1)) Q:NODE1=""!(QUITALL)  D
 ..W:SRT1TXT="GENDER" $S(NODE1="F":"FEMALES",NODE1="M":"MALES"),!?1,"--------",!?1
 ..S NODE2=0
 ..F  S NODE2=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2)) Q:NODE2=""!(QUITALL)  D
 ...W:SRT1TXT="GENDER" $S(NODE1="F":"FEMALES",NODE1="M":"MALES"),!?1,"--------",!?1
 ...S PAT=0
 ...W $E(PAT,1,19)
 ...F  S PAT=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,PAT)) Q:PAT=""!(QUITALL)  D
 ....S DFN=0
 ....F  S DFN=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,"PH",DFN)) Q:DFN=""!(QUITALL)  D
 .....S (VSIT,FLAG)=0
 .....F  S VSIT=$O(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,"PH",DFN,VSIT)) Q:VSIT=""!(QUITALL)  D
 ......S VSDATA=$G(^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,"PH",DFN,VSIT))
 ......S PTNM=$P(VSDATA,U,1),PROV=$P(VSDATA,U,2),HRN=$P(VSDATA,U,10)
 ......S PROV=$P(PROV,",",1)_","_$E($P(PROV,",",2),1,2)
 ......S CLIN=$P(VSDATA,U,3),DOB=$P(VSDATA,U,11),VSDT=$P(VSDATA,U,12)
 ......W ?21,HRN,?28,DOB,?39,$P(VSDT,"@"),?50,$E(CLIN,1,12),?63,$E(PROV,1,16),!?1 S FLAG=1
 ......I ($Y=(IOSL-2))!($Y>(IOSL-2)) D PAGEA G:BKMRTN="^" XIT
 ......; if this is the last patient, check to see if there are any more visits
 ......; if not, then pause the screen so the user does not have to scroll up for
 ......; the last page of data
 ......;S NEXT1=NODE1
 ......;S NEXT1=$O(^TMP("BKMIMRP1",$J,"PRINT",NEXT1))
 ......;I NEXT1="" S NEXT1=NODE1 D
 ......;.S NEXT2=NODE2
 ......;.S NEXT2=$O(^TMP("BKMIMRP1",$J,"PRINT",NEXT1,NEXT2))
 ......;.I NEXT2="" S NEXT2=NODE2 D
 ......;..S NXTDFN=DFN
 ......;..S NXTDFN=$O(^TMP("BKMIMRP1",$J,"PRINT",NEXT1,NEXT2,"PH",NXTDFN))
 ......;..I NXTDFN="" S NXTDFN=DFN D
 ......;...S NXTVSIT=VSIT
 ......;...S NXTVSIT=$O(^TMP("BKMIMRP1",$J,"PRINT",NEXT1,NEXT2,"PH",NXTDFN,NXTVSIT))
 ......;...I NXTVSIT="" D PAUSE G:BKMRTN="^"!QUITALL XIT
 D FOOT ;Display end confidentiality message
 D PAUSE
 I IOST["C-" W @IOF
 D ^%ZISC
 K ^TMP("BKMIMRP1",$J)
 Q
 ;
FOOT ;Print confidential message footer
 W !!,?16,"****  END CONFIDENTIAL PATIENT INFORMATION  ****",!
 Q
 ;
PAGEA ;
 D PAUSE I BKMRTN="^" S QUITALL=1
 ;I ENTER="^" S QUITALL=1 K ENTER Q
 W @IOF
 S PAGE=PAGE+1
 D HDRINFO^BKMIMRP1(PAGE)
 Q
DISPINFO ;EP - Call BLDPTLST^BKMIRMP1 to get the information for
 ; each patient that needs to be displayed
 ; Items to be displayed are Clinic,Patient Name,HRN,DOB,Visit Date,
 ; and Provider 
 ; 
 ; REG must be defined upon entry into this module
 ; 
 N DFN,VSIT,VPRV,FOUND,VPRVIEN
 D BLDPTLST^BKMIMRP1 ; setting up ^TMP("BKMIMRP1,$J,"PTFLTR",DFN,VSIT) global
 S DFN=0
 F  S DFN=$O(^TMP("BKMIMRP1",$J,"PTFLTR",DFN)) Q:DFN=""!QUITALL=1  D
 .;GET PATIENT NAME AND DOB
 .D GETS^DIQ(2,DFN_",",".01;.02;.03","IE","DATA","")
 .S PTNM=$G(DATA(2,DFN_",",.01,"E"))
 .S SEX=$G(DATA(2,DFN_",",.02,"I"))
 .S INDOB=$G(DATA(2,DFN_",",.03,"I"))
 .S EXDOB=$G(DATA(2,DFN_",",.03,"E"))
 .;GET INFORMATION FROM iCARE REGISTRY FILE
 .S REGIEN=$O(^BKM(90451,"B",DFN,0))
 .S REGLOC=$O(^BKM(90451,"D",REG,REGIEN,0))
 .S IEN=REGLOC_","_REGIEN_","
 .D GETS^DIQ(90451.01,IEN,".5;2;2.3;2.5;3","IE","REGDAT","")
 .S STAT=$G(REGDAT(90451.01,IEN,.5,"E"))
 .S ICDXIEN=$G(REGDAT(90451.01,IEN,2,"I"))
 .I $T(ICDDX^ICDCODE)'="" S ICDX=$$ICD9^BKMUL3(ICDXIEN,$G(REGDAT(90451.01,IEN,2.5,"I")),4) ; csv
 .I $T(ICDDX^ICDCODE)="" S ICDX=$$GET1^DIQ(80,ICDXIEN_",",3,"E","","")
 .S RGDX=$G(REGDAT(90451.01,IEN,2.3,"E"))
 .S CCLAS=$G(REGDAT(90451.01,IEN,3,"E"))
 .;GET PROVIDER
 .S VSIT=0,PCP=""
 .F  S VSIT=$O(^TMP("BKMIMRP1",$J,"PTFLTR",DFN,VSIT)) Q:VSIT=""!QUITALL=1  D
 ..S VPRVIEN=0,FOUND=0,PCP=""
 ..F  S VPRVIEN=$O(^AUPNVPRV("AD",VSIT,VPRVIEN)) Q:VPRVIEN=""!(FOUND)  D
 ...S VPRV=$$GET1^DIQ(9000010.06,VPRVIEN,.01,"I")
 ...S PCP=$$GET1^DIQ(200,VPRV,.01,"E"),FOUND=1
 ..;GET VISIT DATE (.01) AND CLINIC (.08)
 ..D GETS^DIQ(9000010,VSIT_",",".01;.08","IE","DATA3","")
 ..S HRNIEN=$G(DUZ(2))
 ..S INVSDT=$G(DATA3(9000010,VSIT_",",.01,"I"))
 ..S EXVSDT=$$DATE^BKMIDTF(INVSDT)
 ..S CLINIC=$G(DATA3(9000010,VSIT_",",.08,"E"))
 ..;GET HEALTH RECORD NUMBER
 ..D GETS^DIQ(9000001.41,HRNIEN_","_DFN_",",".02","I","DATA4","")
 ..S HRN=$G(DATA4(9000001.41,HRNIEN_","_DFN_",",.02,"I"))
 ..S VSTYP="NULL" ;THIS STILL NEEDS TO BE DEFINED BASED ON QUESTIONS
 ..S DATASTR=PTNM_U_PCP_U_CLINIC_U_STAT_U_ICDX_U_RGDX_U_CCLAS_U_VSTYP_U_SEX_U_HRN_U_EXDOB_U_EXVSDT
 .. ;THIS MAY NEED TO BE SET UP DIFFERENTLY FOR SORTING PURPOSES
 ..S ^TMP("BKMIMRP1",$J,"DATA",DFN,VSIT)=DATASTR
 ..K DATA,DATA2,DATA3,DATA4,REGDAT
 ;
 K ^TMP("BKMIMRP1",$J,"PTFLTR")
 Q
 ;
DTRNG() ;EP - Prompt for beginning date
 N %DT,X,Y,BDATE
 S BDATE=""
 S %DT="AE"
 S %DT("A")="Select beginning date: "
 D ^%DT
 I X="^" S BDATE="E"
 I BDATE="",Y=-1 S BDATE=0
 I Y'=-1 S BDATE=Y
 Q BDATE
DTRNG2(EXTDT,BDATE) ; EP - Prompt for ending date
 N %DT,X,Y,EDATE
 S EDATE=""
 S %DT="AE",%DT(0)=BDATE
 S %DT("A")="Select ending date: "
 S %DT("B")=EXTDT
 D ^%DT
 I X="^" S EDATE="E"
 I EDATE="",Y=-1 S EDATE=0
 I Y'=-1 S EDATE=Y
 Q EDATE
FORGETIT() ;EP - Prompt user to end program
 K DIR,X,Y
 S DIR("A")="Would you like to quit this option (Y/N) "
 S DIR("B")="NO"
 S DIR(0)="YO"
 D ^DIR
 ;PRXM/HC/BHS - 10/31/2005 - Added logic to treat timeout as '^'
 I $D(DTOUT)!$D(DUOUT) Q "^"
 Q Y
AA(TYPE) ;EP
 ; Input  TYPE - used to tell the programmer whether this is being asked during
 ;a search or sort
 ;1 = Search
 ;2 = Sort
 K DIR
 I TYPE=1 S DIR("A")="Select Another Search Parameter (Y/N)"
 I TYPE=2 S DIR("A")="Select Another Sort Parameter (Y/N)"
 S DIR("B")="NO"
 S DIR(0)="YO"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q "^"
 Q Y
XIT ;EP - Kill variables and quit.
 K BDATE,CCLAS,CLINIC,DATASTR,DIR,EDATE,EXDOB,EXTDT,EXVSDT,HRNIEN,ICDX,TAGERR
 K ICDXIEN,IEN,INDOB,INVSDT,NEXT1,NEXT2,NODE2,PAGE,PCP,REG,REGIEN,REGLOC,RGDX
 K SCRATCH,SEX,STAT,VSTYP,BDT,CATEGRY,CENTER,CLIN,CLINE,CS1RES,CS2RES,CS2STOP
 K DX,DTS1,DTS2,EDT,I,LEN,OPT1,OPT1TXT,OPT2TXT,PAT,POP,PRINT,PRV,PRVPAT,QUITALL
 K QUITTAG,REGDX,REGLOC,SEX,SRT1TXT,SRT2TXT,START,STAT,TODAY,XECUTE,X,Y,PROV,PRV
 K ^TMP("BKMIMRP1",$J)
 Q
