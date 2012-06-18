ABSPOSMI ; IHS/SD/RLT - POS Claims not Passed to 3PB ;     [ 09/18/07  02:00 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**22,28**;SEP 18, 2007
 ;----------------------------------------------------------
 ;IHS/OIT/SCR - 09/24/08 patch 28 - commented out to remove HOLD functionality introduced 
 ;                                  by patch 22
 ;----------------------------------------------------------
 Q
 ;----------------------------------------------------------
 ;
 ;EN ;EP
 ;
 ;K ^TMP("ABSPOSMI",$J)
 ;W @IOF
 ;W "Count of POS Claims not Passed to 3PB by Insurer",!
 ;W !
 ;N POP D ^%ZIS Q:$G(POP)
 ;D GETDATA
 ;U IO
 ;D DISDATA
 ;D ^%ZISC
 ;K ^TMP("ABSPOSMI",$J)
 ;Q
 ;
 ;GETDATA ;
 ;N ABSPLOG,ABSPTYPE,ABSPIIEN,ABSPINS
 ;S ABSPLOG=0
 ;F  S ABSPLOG=$O(^ABSPHOLD(ABSPLOG)) Q:'+ABSPLOG  D
 ;. S ABSPTYPE=$P($G(^ABSPHOLD(ABSPLOG,0)),U,2)
 ;. S ABSPIIEN=""
 ;. I ABSPTYPE="P" S ABSPIIEN=$P($G(^ABSPHOLD(ABSPLOG,"P")),U,8)
 ;. I ABSPTYPE="R" S ABSPIIEN=$P($G(^ABSPHOLD(ABSPLOG,"R")),U,3)
 ;. Q:ABSPIIEN=""
 ;. S ABSPINS=$$GET1^DIQ(9999999.18,ABSPIIEN_",",.01)        ;name
 ;. S $P(^TMP("ABSPOSMI",$J,ABSPINS,ABSPIIEN),U)=+$P($G(^TMP("ABSPOSMI",$J,ABSPINS,ABSPIIEN)),U)+1
 ;. S $P(^TMP("ABSPOSMI",$J,"ZZZTOTAL",1),U)=+$P($G(^TMP("ABSPOSMI",$J,"ZZZTOTAL",1)),U)+1
 ;Q
 ;DISDATA ;
 ;N DASHES
 ;S $P(DASHES,"-",81)=""
 ;N ABSPINS,ABSPIIEN,ABSPICNT
 ;D HEADING
 ;I '$D(^TMP("ABSPOSMI",$J)) D  Q
 ;. W !,"No held 3PB claims found!"
 ;. D ENDRPT^ABSPOSU5()
 ;S ABSPINS=""
 ;F  S ABSPINS=$O(^TMP("ABSPOSMI",$J,ABSPINS)) Q:ABSPINS=""  D
 ;. S ABSPIIEN=0
 ;. F  S ABSPIIEN=$O(^TMP("ABSPOSMI",$J,ABSPINS,ABSPIIEN)) Q:'+ABSPIIEN  D
 ;.. S ABSPICNT=$G(^TMP("ABSPOSMI",$J,ABSPINS,ABSPIIEN))
 ;.. I ABSPINS="ZZZTOTAL" D
 ;... W !,?60,"=========="
 ;... W !,"TOTAL",?60,$J(ABSPICNT,10)
 ;.. E  W !,ABSPINS," (`",ABSPIIEN,")",?60,$J(ABSPICNT,10)
 ;.. I $$EOPQ^ABSPOSU8(3,,"D HEADING^"_$T(+0)) S ABSPINS="ZZZZZ"
 ;D ENDRPT^ABSPOSU5()
 ;W @IOF
 ;Q
 ;HEADING ;
 ;W @IOF
 ;N RPTDATE S RPTDATE=$$NOWEXT^ABSPOSU1
 ;W "Count of POS Claims not Passed to 3PB by Insurer (",$T(+0),")",?60,RPTDATE
 ;W !!,"Insurer",?60,"Count"
 ;W !,DASHES
 ;Q
