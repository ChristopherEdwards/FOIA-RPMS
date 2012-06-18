APCLBAN ; IHS/CMI/LAB - Banner routine for Management RPTS ;
 ;;2.0;IHS PCC SUITE;**5,6**;MAY 14, 2009;Build 11
V ; GET VERSION
 S APCL("VERSION")="",APCL("VERSION")=$O(^DIC(9.4,"C","BJPC",APCL("VERSION"))),APCL("VERSION")=^DIC(9.4,APCL("VERSION"),"VERSION")
 I $G(APCLTEXT)="" S APCLTEXT="TEXT",APCLLINE=3 G PRINT
 S APCLTEXT="TEXT"_APCLTEXT
 F APCLJ=1:1 S APCLX=$T(@APCLTEXT+APCLJ),APCLX=$P(APCLX,";;",2) Q:APCLX="QUIT"!(APCLX="")  S APCLLINE=APCLJ
PRINT W:$D(IOF) @IOF
 F APCLJ=1:1:APCLLINE S APCLX=$T(@APCLTEXT+APCLJ),APCLX=$P(APCLX,";;",2) W !?80-$L(APCLX)\2,APCLX K APCLX
 W !?80-(22+$L(APCL("VERSION")))/2,"IHS PCC Suite Version ",APCL("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S APCL("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(APCL("SITE"))\2,APCL("SITE")
XIT ;
 K DIC,DA,X,Y,%Y,%,APCLJ,APCLX,APCLTEXT,APCLLINE,APCL
 Q
TEXT ;
 ;;*********************************
 ;;**   PCC Management Reports    **
 ;;*********************************
 ;;QUIT
TEXTA ;apc reports
 ;;************************************
 ;;**     PCC Management Reports     **
 ;;**           APC Reports          **
 ;;************************************
 ;;QUIT
TEXTQ ;quality assurance reports
 ;;************************************
 ;;**     PCC Management Reports     **
 ;;**    Quality Assurance Reports   **
 ;;************************************
 ;;QUIT
TEXTR ;resource allocation/workload reports
 ;;********************************************
 ;;**         PCC Management Reports         **
 ;;**  Resource Allocation/Workload Reports  **
 ;;********************************************
 ;;QUIT
TEXTC ;activity reports by discipline group
 ;;************************************************
 ;;**           PCC Management Reports           **
 ;;**     Activity Reports by Discipline Group   **
 ;;************************************************
 ;;QUIT
TEXTV ;Ambulatory visit counts
 ;;**************************************
 ;;**       PCC Management Reports     **
 ;;**    PCC Ambulatory Visit Counts   **
 ;;**************************************
 ;;QUIT
TEXTI ;inpatient reports
 ;;***********************************
 ;;**    PCC Management Reports     **
 ;;**      Inpatient Reports        **
 ;;***********************************
 ;;QUIT
TEXTB ;billing reports
 ;;**********************************
 ;;**    PCC Management Reports    **
 ;;**        Billing Reports       **
 ;;**********************************
 ;;QUIT
TEXTP ;patient listings
 ;;********************************
 ;;**   PCC Management Reports   **
 ;;**      Patient Listings      **
 ;;********************************
 ;;QUIT
TEXTO ;EP
 ;;********************************
 ;;**   PCC Management Reports   **
 ;;**   Operations Summary Menu  **
 ;;********************************
 ;;QUIT
TEXTN ;EP
 ;;***********************************
 ;;**     PCC Management Reports    **
 ;;**     Body Mass Index Reports   **
 ;;***********************************
 ;;QUIT
TEXTM ;EP
 ;;********************************
 ;;**   PCC Management Reports   **
 ;;**      Report Template       **
 ;;********************************
 ;;QUIT
TEXTD ;EP
 ;;***********************************
 ;;**     PCC Management Reports    **
 ;;**   Diabetes Audit Report Menu  **
 ;;***********************************
 ;;QUIT
TEXTE ;;EP
 ;;***********************************
 ;;**     PCC Management Reports    **
 ;;**   Immunization Report Menu    **
 ;;***********************************
 ;;QUIT
TEXTF ;EP
 ;;***********************************
 ;;**     PCC Management Reports    **
 ;;**       Count Summary Menu      **
 ;;***********************************
 ;;QUIT
TEXTG ;EP
 ;;***********************************
 ;;**     PCC Management Reports    **
 ;;**   Patient Single Visit Menu   **
 ;;***********************************
 ;;
TEXTS ;EP
 ;;************************************
 ;;**     PCC Management Reports     **
 ;;** Suicide Form Data Reports Menu **
 ;;************************************
 ;;QUIT
TEXTJ ;;EP
 ;;*******************************************
 ;;**        PCC Management Reports         **
 ;;**   Breastfeeding Statistical Reports   **
 ;;*******************************************
 ;;QUIT
TEXTH ;
 ;;*******************************************
 ;;**        PCC Management Reports         **
 ;;**        EPI Program HL7 Exports        **
 ;;*******************************************
 ;;QUIT
TEXTK ;
 ;;********************************************
 ;;**         PCC Management Reports         **
 ;;**   Meaningful Use Performance Reports   **
 ;;********************************************
 ;;QUIT
