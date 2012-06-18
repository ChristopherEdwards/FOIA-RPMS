APCDBAN ; IHS/CMI/LAB - Banner routine for Data Entry ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
V ; GET VERSION
 S APCD("VERSION")="2.0"
 I $G(APCDTEXT)="" S APCDTEXT="TEXT",APCDLINE=3 G PRINT
 S APCDTEXT="TEXT"_APCDTEXT
 F APCDJ=1:1 S APCDX=$T(@APCDTEXT+APCDJ),APCDX=$P(APCDX,";;",2) Q:APCDX="QUIT"!(APCDX="")  S APCDLINE=APCDJ
PRINT W:$D(IOF) @IOF
 ;W !,$$CTR("INDIAN HEALTH SERVICE",80)
 F APCDJ=1:1:APCDLINE S APCDX=$T(@APCDTEXT+APCDJ),APCDX=$P(APCDX,";;",2) W !?80-$L(APCDX)\2,APCDX K APCDX
 W !?80-(22+$L(APCD("VERSION")))/2,"IHS PCC Suite Version ",APCD("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S APCD("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !?80-$L(APCD("SITE"))\2,APCD("SITE")
 D ^APCDVAR
XIT ;
 K DIC,DA,X,Y,%Y,%,APCDJ,APCDX,APCDTEXT,APCDLINE
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
TEXT ;
 ;;*********************************
 ;;**    PCC Data Entry Module    **
 ;;*********************************
 ;;QUIT
TEXTA ;accept command menu text
 ;;************************************
 ;;**      PCC Data Entry Module     **
 ;;**     Process ACCEPT Commands    **
 ;;************************************
 ;;QUIT
TEXTF ;forms tracking menu text
 ;;************************************
 ;;**     PCC Data Entry Module      **
 ;;** Data Entry Forms Tracking Menu **
 ;;************************************
 ;;QUIT
TEXTI ;fix uncoded dx/proc menu text
 ;;*************************************************
 ;;**             PCC Data Entry Module           **
 ;;**  Fix UNCODED ICD9 Diagnoses/Operation Codes **
 ;;*************************************************
 ;;QUIT
TEXTS ;supervisor menu text
 ;;*************************************************
 ;;**            PCC Data Entry Module            **
 ;;** Data Entry SUPERVISOR Options and Utilities **
 ;;*************************************************
 ;;QUIT
TEXTU ;date entry utilities menu text
 ;;*********************************
 ;;**    PCC Data Entry Module    **
 ;;**  Data Entry Utilities Menu  **
 ;;*********************************
 ;;QUIT
TEXTB ;date entry utilities menu text
 ;;*********************************
 ;;**    PCC Data Entry Module    **
 ;;**  Enter/Edit Suicide Forms   **
 ;;*********************************
 ;;QUIT
TEXTV ;visit review report menu text
 ;;*********************************
 ;;**    PCC Data Entry Module    **
 ;;**    Visit Review Reports     **
 ;;*********************************
 ;;QUIT
TEXTE ;error code menu
 ;;*********************************
 ;;**    PCC Data Entry Module    **
 ;;**    Visit Review Reports     **
 ;;**                             **
 ;;**       Error Code Menu       **
 ;;*********************************
 ;;QUIT
TEXTL ;link in-hospital menu
 ;;*************************************************
 ;;**            PCC Data Entry Module            **
 ;;** Data Entry SUPERVISOR Options and Utilities **
 ;;**            In-Hospital Link Menu            **
 ;;*************************************************
 ;;QUIT
TEXTP ;fix uncoded operations menu
 ;;*************************************************
 ;;**             PCC Data Entry Module           **
 ;;**      Fix UNCODED ICD9 Operation Codes       **
 ;;*************************************************
 ;;QUIT
TEXTC ;LOG ENTRY
 ;;************************************
 ;;**      PCC Data Entry Module     **
 ;;**       PCC LOG Data Entry       **
 ;;************************************
 ;;QUIT
TEXTT ;;local table maintenance
 ;;****************************************
 ;;**        PCC Data Entry Module       **
 ;;**     PCC Local Table Maintenance    **
 ;;****************************************
 ;;QUIT
TEXTM ;;print table maintenance
 ;;**************************************************
 ;;**           PCC Data Entry Module              **
 ;;**    PCC Local Table Maintenance Print Menu    **
 ;;**************************************************
 ;;QUIT
TEXTW ;;update patient related data
 ;;************************************************
 ;;**          PCC Data Entry Module             **
 ;;**      Update Patient-Related Data           **
 ;;************************************************
 ;;QUIT
TEXTX ;;edit site parameters
 ;;**************************************************
 ;;**          PCC Data Entry Module               **
 ;;**    PCC Data Entry Site Parameters Edit       **
 ;;**************************************************
 ;;QUIT
TEXTY ;;display site parameters
 ;;**************************************************
 ;;**         PCC Data Entry Module                **
 ;;**    PCC Data Entry Site Parameters Display    **
 ;;**************************************************
 ;;QUIT
TEXTZ ;;enter date menu
 ;;*********************************************
 ;;**        PCC Data Entry Module            **
 ;;**      Enter PCC Data Menu Options        **
 ;;*********************************************
 ;;QUIT
TEXTJ ;;modify data
 ;;*********************************************
 ;;**        PCC Data Entry Module            **
 ;;**      Modify PCC Data Menu Options       **
 ;;*********************************************
 ;;QUIT
TEXTH ;;modify data
 ;;******************************************
 ;;**        PCC Data Entry Module         **
 ;;**      EHR/PCC Coding Audit Menu       **
 ;;******************************************
 ;;QUIT
