ABSPOSMH ; IHS/SD/RLT - POS Insurers with Missing Tax IDs ;     [ 09/11/07  02:00 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**22**;SEP 11, 2007
 Q
 ;----------------------------------------------------------
 ;
EN ;EP
 ;
 K ^TMP("ABSPOSMH",$J)
 W @IOF
 W "POS Insurers with Missing Tax IDs",!
 W !
 N POP D ^%ZIS Q:$G(POP)
 D GETDATA
 U IO
 D DISDATA
 D ^%ZISC
 K ^TMP("ABSPOSMH",$J)
 Q
 ;
GETDATA ;
 N ABSPIIEN,ABSPRXST,ABSPTXID,ABSPFMT,ABSPINS
 N ABSPIA,ABSPIC,ABSPISI,ABSPISA,ABSPIZ,ABSPIP
 S ABSPIIEN=0
 F  S ABSPIIEN=$O(^ABSPEI(ABSPIIEN)) Q:'+ABSPIIEN  D
 . S ABSPRXST=$$GET1^DIQ(9999999.18,ABSPIIEN_",",.23,"I")   ;rx status
 . Q:ABSPRXST'="P"             ;quit if rx status is not P - BILLED POS
 . S ABSPTXID=$$GET1^DIQ(9999999.18,ABSPIIEN,.11)
 . Q:ABSPTXID'=""&(ABSPTXID?9N)             ;don't report ins w/tax ids
 . S ABSPFMT=$$GET1^DIQ(9002313.4,ABSPIIEN_",",100.01)      ;format
 . Q:ABSPFMT=""
 . S ABSPINS=$$GET1^DIQ(9999999.18,ABSPIIEN_",",.01)        ;name
 . S ABSPIA=$$GET1^DIQ(9999999.18,ABSPIIEN_",",.02)         ;address
 . S ABSPIC=$$GET1^DIQ(9999999.18,ABSPIIEN_",",.03)         ;city
 . S ABSPISI=$$GET1^DIQ(9999999.18,ABSPIIEN_",",.04,"I")    ;state ien
 . S ABSPISA=$$GET1^DIQ(5,ABSPISI_",",1)                    ;state abbr
 . S ABSPIZ=$$GET1^DIQ(9999999.18,ABSPIIEN_",",.05)         ;zip
 . S ABSPIP=$$GET1^DIQ(9999999.18,ABSPIIEN_",",.06)         ;phone
 . S ^TMP("ABSPOSMH",$J,ABSPINS,ABSPIIEN)=ABSPIA_"^"_ABSPIC_"^"_ABSPISA_"^"_ABSPIZ_"^"_ABSPIP_"^"_ABSPTXID
 Q
DISDATA ;
 N DASHES
 S $P(DASHES,"-",81)=""
 N ABSPINS,ABSPIIEN,ABSPIREC,ABSPIA,ABSPIC,ABSPISA,ABSPIZ,ABSPIP
 D HEADING
 I '$D(^TMP("ABSPOSMH",$J)) D  Q
 . W !,"No POS insurers with missing tax ids found!"
 . D ENDRPT^ABSPOSU5()
 S ABSPINS=""
 F  S ABSPINS=$O(^TMP("ABSPOSMH",$J,ABSPINS)) Q:ABSPINS=""  D
 . S ABSPIIEN=0
 . F  S ABSPIIEN=$O(^TMP("ABSPOSMH",$J,ABSPINS,ABSPIIEN)) Q:'+ABSPIIEN  D
 .. S ABSPIREC=$G(^TMP("ABSPOSMH",$J,ABSPINS,ABSPIIEN))
 .. S ABSPIA=$P(ABSPIREC,U)                                ;address
 .. S ABSPIC=$P(ABSPIREC,U,2)                              ;city
 .. S ABSPISA=$P(ABSPIREC,U,3)                             ;state abbr
 .. S ABSPIZ=$P(ABSPIREC,U,4)                              ;zip
 .. S ABSPIP=$P(ABSPIREC,U,5)                              ;phone
 .. S ABSPTXID=$P(ABSPIREC,U,6)                            ;invalid tax if not blank
 .. W !!,ABSPINS," (`",ABSPIIEN,")",?60,ABSPTXID
 .. W !,ABSPIA
 .. W !,ABSPIC,",",ABSPISA,"  ",ABSPIZ
 .. W !,ABSPIP
 .. I $$EOPQ^ABSPOSU8(3,,"D HEADING^"_$T(+0)) S ABSPINS="ZZZZZ"
 D ENDRPT^ABSPOSU5()
 W @IOF
 Q
HEADING ;
 W @IOF
 N RPTDATE S RPTDATE=$$NOWEXT^ABSPOSU1
 W "POS Insurers with Missing Tax IDs (",$T(+0),")",?60,RPTDATE
 W !,DASHES
 Q
