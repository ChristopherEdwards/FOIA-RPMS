AMER31 ; IHS/ANMC/GIS -ISC - ENTER DIAGNOSES ;  
 ;;3.0;ER VISIT SYSTEM;**6,7,8**;MAR 03, 2009;Build 23
 ;
QD11 ; ENTRY POINT FROM AMER3
 ;
 NEW PVCNT,DLAYGO,AMERDUZ,AMERPOV,AMERIEN,AMERNCHK
 NEW APCDCAT,APCDVSIT,APCDPAT,APCDLOC,APCDTYPE,APCDMODE,APCDPARM
 NEW APCDMNE,APCDVLDT,APCDVLK,DIC,AMERPCC,VDT,ICD10,DIDEL,AMERPOV
 ;
 ;Make sure variables are set up properly to allow adds/deletes
 S (DLAYGO,DIDEL)=9000010.07
 I $G(DUZ("AG"))="I" S AMERDUZ=DUZ(0),DUZ(0)="@"
 ;
QD11E ;Get the visit IEN
 S AMERPCC=$$GET1^DIQ(9009081,DFN_",",1.1,"I") I AMERPCC="" G QD11X
 S VDT=$P($$GET1^DIQ(9000010,AMERPCC,.01,"I"),".")
 ;
 ;Determine if ICD-10 has been implemented
 S ICD10=0 I $$VERSION^XPDUTL("AICD")>3.51,$$IMP^ICDEXA(30)'>VDT S ICD10=1
 ;
 ;AMER*3.0*6;Display any POV information already on file
 S AMERPOV="" F PVCNT=1:1 S AMERPOV=$O(^AUPNVPOV("AD",AMERPCC,AMERPOV)) Q:AMERPOV=""  D
 . NEW ICDIEN,INFO,PS,PNARR
 . I PVCNT=1 D
 .. W $$S^AMERUTIL("RVN")
 .. W !!,"Current Purpose of Visit entries on file for this visit:",!
 .. W $$S^AMERUTIL("RVF")
 . ;
 . ;Display each entry
 . S ICDIEN=$$GET1^DIQ(9000010.07,AMERPOV,.01,"I")
 . S PS=$$GET1^DIQ(9000010.07,AMERPOV,.12,"I")
 . S INFO=$$ICDDX^AUPNVUTL(ICDIEN,VDT)
 . S PNARR=$$VAL^XBDIQ1(9000010.07,AMERPOV,.04)
 . W !,"Code: ",$P(INFO,U,2),?15,"P/S: ",PS,?23,"Description: ",$E($P(INFO,U,4),1,55)
 . I PNARR="" W $$S^AMERUTIL("RVN")
 . W !?3,"Prov Narrative: ",PNARR
 . I PNARR="" W $$S^AMERUTIL("RVF")
 ;
 ;Prompt for Edits
 S X=$G(X)
 I PVCNT>1 D  Q:X]""
 . ;
 . NEW DIR,Y,DTOUT,DUOUT,DIRUT,DIROUT
 . S DIR(0)="Y",DIR("B")="NO"
 . S DIR("A")="Edit Existing Purpose of Visit Information"
 . W !
 . D ^DIR
 . I $G(DTOUT)!$G(DUOUT)!$G(DIRUT)!$G(DIROUT) S X="^" Q
 . S X=$S(Y=1:"",Y=0:"",1:X)
 . I Y'=1 Q
 . ;
 . ;Perform Purpose of Visit Edit
 . W $$S^AMERUTIL("RVN")
 . W !!,"Select the Purpose of Visit Entry to Edit"
 . W $$S^AMERUTIL("RVF")
 . S X=$$AEPOV(AMERPCC,DFN,"M")
 ;
 ;Perform POV adds
 I PVCNT>1 W !!,"*Enter Additional Purpose of Visit Information"
 E  W !!,"*Enter Purpose of Visit Information"
 W !,"   Enter ",$$S^AMERUTIL("RVN"),$S(ICD10:"ZZZ.999",1:".9999"),$$S^AMERUTIL("RVF")," to log an uncoded diagnosis"
 S X=$$AEPOV(AMERPCC,DFN,"A")
 ;
 ;Make sure a POV entry was logged
 S AMERPOV=$$POV^AMERUTIL("",AMERPCC,.AMERPOV)
 I ($P(AMERPOV,U)<1) D  G QD11E:X="",QD11X:X]""
 . NEW DIR,Y,DTOUT,DUOUT,DIRUT,DIROUT
 . W !!,"This answer is mandatory."
 . S DIR(0)="SA^E:Enter POV now;P:Step to previous prompt",DIR("B")="E"
 . S DIR("A")="(E)nter Purpose of Visit now or return to (P)revious prompt: "
 . W !
 . D ^DIR
 . I Y'="E" S X="^",Y="^" Q
 . S X=""
 ;
 ;Make sure a primary POV entry was logged
 I ($P(AMERPOV,U,2)<1) D  G QD11E:X="",QD11X:X]""
 . NEW DIR,Y,DTOUT,DUOUT,DIRUT,DIROUT
 . W !!,"A primary Purpose of Visit is required."
 . S DIR(0)="SA^E:Enter POV now;P:Step to previous prompt",DIR("B")="E"
 . S DIR("A")="(E)nter Purpose of Visit now or return to (P)revious prompt: "
 . W !
 . D ^DIR
 . I Y'="E" S X="^" Q
 . S X=""
 ;
 ;Make sure only one primary POV entry was logged
 I ($P(AMERPOV,U,2)>1) D  G QD11E:X="",QD11X:X]""
 . NEW DIR,Y,DTOUT,DUOUT,DIRUT,DIROUT
 . W !!,"Only one primary POV is permitted."
 . S DIR(0)="SA^E:Enter POV now;P:Step to previous prompt",DIR("B")="E"
 . S DIR("A")="(E)nter Purpose of Visit now or return to (P)revious prompt: "
 . W !
 . D ^DIR
 . I Y'="E" S X="^" Q
 . S X=""
 ;
 ;AMER*3.0*8;Validate provider narrative
 S (AMERNCHK,AMERIEN)="" F  S AMERIEN=$O(AMERPOV(AMERIEN)) Q:AMERIEN=""  D  Q:+AMERNCHK
 . NEW DIR,Y,DTOUT,DUOUT,DIRUT,DIROUT
 . I $P(AMERPOV(AMERIEN),U,3)]"" Q
 . S AMERNCHK="1"
 . W $$S^AMERUTIL("RVN")
 . W !!,"**POV ",$P(AMERPOV(AMERIEN),U)," is missing a required PROVIDER NARRATIVE entry**",!
 . W $$S^AMERUTIL("RVF")
 I +AMERNCHK G QD11E
 ;
 ;Handle Injury Matching
 D INJURY(.AMERPOV,.X) I $G(X)="^" G QD11E
 ;
 ;Set DUZ(0) back to original value
 I $G(DUZ("AG"))="I" S DUZ(0)=$G(AMERDUZ)
 ;
 ;BEE;Fix for endless loop issue
 S Y=1
 ;  
QD11X S:$G(AMERDUZ)]"" DUZ(0)=AMERDUZ
 Q
 ;
AEPOV(AMERPCC,DFN,APCDMODE) ;EP - Add/Edit POV information
 NEW APCDCAT,APCDVSIT,APCDVLK,APCDPAT
 NEW APCDPARM,APCDDATE,APCDVLDT,APCDLOC,APCDTYPE
 NEW DIC,X,Y,DTOUT,DUOUT,APCDMNE,AMERGBL
 ;
 ;Verify that DUZ was passed in and set up
 D DUZ^XUP(DUZ)
 ;
 S APCDCAT="H",(APCDVSIT,APCDVLK)=AMERPCC,APCDPAT=DFN
 S APCDPARM=$G(^APCDSITE(DUZ(2),0))
 S (APCDDATE,APCDVLDT)=$$GET1^DIQ(9000010,AMERPCC,.01,"I")
 S APCDLOC=DUZ(2),APCDTYPE=$$GET1^DIQ(9000010,AMERPCC,.03,"I")
 ;
 ;Get the IEN for the 'PV' mnemonic
 S DIC=9001001,DIC(0)="",X="PV" D ^DIC
 I Y<1 Q "^"
 S APCDMNE=+Y,APCDMNE("NAME")=$P(Y,U,2)
 S AMERGBL="^AUPNVPOV"
 S Y=AMERGBL_"(""AD"","_AMERPCC_",0)" I '$O(@Y) S APCDMODE="A"
 ;
 ;Perform POV edit/entry
 D ^APCDEA3
 Q ""
 ;
INJURY(AMERPOV,X) ;Match Injury with V POV and update V POV record
 ;
 NEW POVCNT,VPOVIEN,CNT,Y,DTOUT,DUOUT,DIRUT,DIROUT,VAL,POVLST
 ;
 ;If no injury quit
 I '+$G(^TMP("AMER",$J,2,2)) Q
 ;
 ;Get the number of V POV entries
 S POVCNT=+$G(AMERPOV) Q:'POVCNT
 ;
 ;If only one V POV entry map to that one automatically
 I POVCNT=1 D  Q
 . S VPOVIEN=$P($G(AMERPOV(1)),U,6) Q:VPOVIEN=""
 . D UPDPOV(VPOVIEN)
 ;
 ;If more than one V POV entry, allow user to select entry or entries to map to
 W $$S^AMERUTIL("RVN")
 W !!,"Current POV information on file:"
 W $$S^AMERUTIL("RVF")
 W !!,"# ",?3,"P/S",?7,"Code",?18,"Description",?50,"Provider Narrative"
 F CNT=1:1:POVCNT D
 . Q:'$D(AMERPOV(CNT))
 . W !,CNT,?3,$P(AMERPOV(CNT),U,2),?7,$P(AMERPOV(CNT),U),?18,$E($P(AMERPOV(CNT),U,5),1,30),?50,$E($P(AMERPOV(CNT),U,3),1,29)
 ;
 ;Prompt user for which one(s) to match injury to
 S DIR(0)="L^1:"_POVCNT
 S DIR("A")="Select the POV entry or entries to match the injury information to"
 W !
 D ^DIR
 I $D(DIRUT) S X="^" Q
 S POVLST=Y
 ;
 ;Match selected entry or entries to the injury information
 F CNT=1:1:$L(POVLST,",") S VAL=$P(POVLST,",",CNT) I +VAL D
 . Q:'$D(AMERPOV(+VAL))
 . S VPOVIEN=$P($G(AMERPOV(+VAL)),U,6) Q:VPOVIEN=""
 . D UPDPOV(VPOVIEN)
 ;
 Q
 ;
UPDPOV(VPOVIEN) ;Update V POV entry with Injury Information
 ;
 NEW VPOVUPD,ERROR,INJDT,INJCS,INJPL,INJCVPL,%,AUPNVSIT
 ;
 ;Quit if no V POV IEN
 I $G(VPOVIEN)="" Q
 ;
 ;Get the visit IEN
 S AUPNVSIT=$$GET1^DIQ(9000010.07,VPOVIEN_",",.03,"I")
 ;
 ;Pull Injury Date
 S INJDT=$P($G(^TMP("AMER",$J,2,32)),".")
 ;
 ;Pull Injury Cause
 S INJCS=$G(^TMP("AMER",$J,2,33))
 ;I INJCS]"" S INJCS=$$GET1^DIQ(9009083,INJCS_",",7,"I")
 ;
 ;Place of Accident - Convert
 S INJPL=$G(^TMP("AMER",$J,2,34))
 I INJPL]"" S INJPL=$$GET1^DIQ(9009083,INJPL_",",.01,"E")
 ;
 ;Valid PCC values
 ;A:HOME-INSIDE;B:HOME-OUTSIDE;C:FARM;D:SCHOOL;E:INDUSTRIAL PREMISES;F:RECREATIONAL AREA;
 ;G:STREET/HIGHWAY;H:PUBLIC BUILDING;I:RESIDENT INSTITUTION;J:HUNTING/FISHING;K:OTHER;L:UNKNOWN
 S INJCVPL="L"
 I INJPL["HIGHWAY" S INJCVPL="G"
 E  I INJPL["HOME" S INJCVPL="A"
 E  I INJPL["INDUSTRIAL" S INJCVPL="E"
 E  I INJPL["MINE" S INJCVPL="K"
 E  I INJPL["OTHER" S INJCVPL="K"
 E  I INJPL["PUBLIC" S INJCVPL="H"
 E  I INJPL["FARM" S INJCVPL="C"
 E  I INJPL["RECREATION" S INJCVPL="F"
 E  I INJPL["RESIDENT" S INJCVPL="I"
 E  I INJPL["UNSPECIFIED" S INJCVPL="L"
 E  I INJPL["SCHOOL" S INJCVPL="D"
 E  I INJPL["HUNTING" S INJCVPL="J"
 E  I INJPL["FISHING" S INJCVPL="J"
 ;
 ;Save the injury date in the V POV entry
 D NOW^%DTC
 S VPOVUPD(9000010.07,VPOVIEN_",",.09)=INJCS
 S VPOVUPD(9000010.07,VPOVIEN_",",.11)=INJCVPL
 S VPOVUPD(9000010.07,VPOVIEN_",",.13)=INJDT
 S VPOVUPD(9000010.07,VPOVIEN_",",1218)=%
 S VPOVUPD(9000010.07,VPOVIEN_",",1219)=DUZ
 D FILE^DIE("","VPOVUPD","ERROR")
 ;
 ;Mark that the visit was modified
 D MOD^AUPNVSIT
 ;
 Q
