ADEPQA3A ; IHS/HQT/MJL - CODE SEARCH PARAMS ;08:37 PM [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;**12**;APRIL 1999
 ;
ADA() ;ENTRY POINT
 ; - Returns "1/0^Code DFN^Followed-by Code^NOT flag^Relative Date
 ;         ^Same Opsite(Y/N)^Particular Opsite" (Codes and Opsite DFN)
 ;Check that opsite required for codes before prompting for opsite&same
 N ADECOD,ADEJ,ADEY,ADEK,ADEFLG,ADERSP,ADEBEG,ADEND,DIR
 ;
ADACTRL ;Control Sequence
ADAC1 ;FHL 9/9/98
 D ADAS1 Q:$$HAT^ADEPQA() 0
 Q:ADECOD="" 0
 S $P(ADERSP,U)="1^"_ADECOD
ADAC2 D ADAS2 G:$$HAT^ADEPQA() ADAC1 S $P(ADERSP,U,7)=ADECOD
ADAC3 N ADENOT D ADAS3 G:$$HAT^ADEPQA() ADAC2 S $P(ADERSP,U,3)=ADECOD S:ADENOT $P(ADERSP,U,4)=1
 ;
ADAC4 I $P(ADERSP,U,3)]"" D ADAS4 G:$$HAT^ADEPQA() ADAC3 S $P(ADERSP,U,5)=ADECOD
ADAC5 I $P(ADERSP,U,3)]"" D ADAS5 G:$$HAT^ADEPQA() ADAC3 S $P(ADERSP,U,6)=ADECOD
ADAC6 I $P(ADERSP,U,3)]"" D ADAS6 G:$$HAT^ADEPQA() ADAC3 S $P(ADERSP,U,8)=ADECOD
 Q ADERSP
 K ADERSP ;*NE
ADAS6 S ADECOD=""
 W ! S DIR("A")="Do you want to include codes on the SAME VISIT as 'FOLLOWED BY' codes?"
 S DIR(0)="Y"
 S DIR("B")="N"
 D ^DIR
 Q:$$HAT^ADEPQA()
 S:Y=1 ADECOD="Y"
 Q
ADAS5 S ADECOD=""
 W ! S DIR("A")="Do you want the 'FOLLOWED BY' codes to apply to the SAME OPSITE"
 S DIR(0)="Y"
 S DIR("B")="N"
 D ^DIR
 Q:$$HAT^ADEPQA()
 S:Y=1 ADECOD="Y"
 Q
ADAS4 S ADECOD="" K DIR
 W ! S DIR("A")="What time limit (in days) should apply to the 'FOLLOWED BY' codes? "
 S DIR(0)="NOA^0:10000:0"
 D ^DIR
 Q:$$HAT^ADEPQA()
 S ADECOD=Y
 Q
ADAS1 S ADECOD="" K DIR
 W ! S DIR("A")="Limit the search to a particular ADA Code or set of Codes"
 S DIR("B")="YES"
 S DIR(0)="Y" D ^DIR
 I $$HAT^ADEPQA() Q
 I Y=0 Q
 D ADAS1B G:$$HAT^ADEPQA() ADAS1
 Q
ADAS3 S ADECOD="" K DIR S ADENOT=0
 W ! S DIR("A")="Limit the search to ADA Codes which are FOLLOWED BY a particular code"
 S DIR("B")="YES"
 S DIR(0)="Y" D ^DIR
 I $$HAT^ADEPQA() Q
 I Y=0 Q
 D ADAS1B G:$$HAT^ADEPQA() ADAS3
 Q
ADAS1B N DIC
 N ADEX,ADEXSEL S ADEX="7110^7120^7130^7140",ADEXSEL=0 ;IHS/SET/HMW 2-6-2003 **12**
 F  D  Q:X=""  Q:$$HAT^ADEPQA()  S ADEY=$P(Y,U) D ADA2
 . S DIC="^AUTTADA(",DIC(0)="E",D="BA"
 . R !,"Select ADA CODE: ",X:DTIME S:'$T!(X[U) DTOUT=1 Q:X=""  S X=X_" "
 . D IX^DIC
 . I ADEX[$P(Y,U,2),ADEXSEL=0 D CDT4REM^ADECD49 S ADEXSEL=1 ;IHS/SET/HMW 2-6-2003 **12**
 Q
ADAS2 S ADECOD=""
 W ! S DIR("A")="Do you want these ADA Codes to apply to a particular Opsite or Opsites"
 S DIR("B")="YES",DIR(0)="Y" D ^DIR
 I $$HAT^ADEPQA() Q
 I Y=0 Q
 K DIR
 S DIR(0)="PO^ADEOPS(:EM"
 F  D ^DIR Q:X=""  Q:$$HAT^ADEPQA()  S ADEY=$P(Y,U) D ADA4
 I $$HAT^ADEPQA() K DIR G ADAS2
 Q
ADA2 I ADEY'=-1 D ADA3 Q
 I ADEY=-1,X="NOT " D  Q
 . I '$D(ADENOT) W "   --",X," ??" Q
 . W !,"OK. I will look for procedures NOT followed by these codes."
 . S ADENOT=1
 I ADEY=-1,X'["-" W "   --",X," ??" Q
 I ADEY=-1 S ADEBEG=$P(X,"-",1)_" ",ADEND=$P(X,"-",2) D
 . I ADEBEG'?4N1" " W "   --",ADEBEG," ??" Q
 . I ADEND'?4N1" " W "   --",ADEND," ??" Q
 . ;IHS/SET/HMW Replaced next 4 lines with line following **12**
 . ;D
 . ;. N ADEJ
 . ;. S ADEJ=0
 . ;. F  S ADEJ=$O(^AUTTADA("BA",ADEJ)) Q:'+ADEJ  I $O(^AUTTADA("BA",ADEJ))>ADEBEG S ADEBEG=ADEJ Q
 . S ADEBEG=$O(^AUTTADA("BA",ADEBEG),-1)
 . F  S ADEBEG=$O(^AUTTADA("BA",ADEBEG)) Q:ADEBEG=""  Q:ADEBEG>ADEND  S ADEY=$O(^AUTTADA("BA",ADEBEG,0)) W !,?5,ADEBEG,?15,$P(^AUTTADA(ADEY,0),U,2) D ADA3
 Q
ADA4 I ADEY'=-1 D ADA3 Q
 I ADEY=-1,X'["-" W !,?5," -- Enter a single operative site or a range of PERMANENT TOOTH NUMBERS",!,?5,"separated by a dash, e.g. 6-9" Q
 I ADEY=-1 S ADEBEG=$P(X,"-",1),ADEND=$P(X,"-",2) D
 . I ADEBEG'?1.2N W ?20,"--",ADEBEG,"?? Ranges can apply only to permanent tooth numbers." Q
 . I ADEND'?1.2N W ?20,"--",ADEND,"?? Ranges can apply only to permanent tooth numbers." Q
 . S ADEBEG=ADEBEG-1 F  S ADEBEG=$O(^ADEOPS("B",ADEBEG)) Q:ADEBEG=""  Q:ADEBEG>ADEND  Q:ADEBEG'?1.2N  S ADEY=$O(^ADEOPS("B",ADEBEG,0)) W !,?5,ADEBEG,?15,$P(^ADEOPS(ADEY,0),U) D ADA3
 Q
ADA3 S ADEFLG=0 F ADEK=1:1:$L(ADECOD,",") I $P(ADECOD,",",ADEK)=ADEY S ADEFLG=1 Q
 I 'ADEFLG,ADECOD="" S ADECOD=ADEY Q
 S:'ADEFLG $P(ADECOD,",",$L(ADECOD,",")+1)=ADEY
 Q
