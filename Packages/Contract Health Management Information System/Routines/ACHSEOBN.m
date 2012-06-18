ACHSEOBN ; IHS/ITSC/PMF - PROCESS EOBRS extention of ACHSEOB3 ;    [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;
VNDR    ;EP - Attempt to match Vendor 
 ;GET RID OF HYPEN IN 'EIN NO.'_"-"_'EIN SUFFIX'
 S ACHSPROV=$E(ACHSEOBR("C",16),1,10)_$E(ACHSEOBR("C",16),12,13)
 S ACHSPROV=$P(ACHSPROV," ")      ;?????
 ;
 ;TRY TO FIND VENDOR IN 'EIN NO' AND 'EIN SUFFIX' X-REF
 I $O(^AUTTVNDR("E",ACHSPROV,0)) S ACHSPROV=$O(^(0)) Q
 S ACHSPROV=$E(ACHSPROV,1,10)   ;'EIN NO'
 ;
 ;TRY TO FIND VENDOR IN 'EIN NO' X-REF
 I $O(^AUTTVNDR("C",ACHSPROV,0)) S ACHSPROV=$O(^(0)) Q
 ;
 S ACHSPROV=ACHSEOBR("D",8)             ;VENDOR NAME
 ;TAKE OFF SPACE AT END OF NAME
 F  Q:$E(ACHSPROV,$L(ACHSPROV))'=" "  S ACHSPROV=$E(ACHSPROV,1,$L(ACHSPROV)-1)
 ;USE VENDOR NAME TO FIND VENDOR PTR IN B X-REF
 I $O(^AUTTVNDR("B",ACHSPROV,0)) S ACHSPROV=$O(^(0)) Q
 S ACHSPROV=0
 Q
 ;
CHKOCC ;EP from ACHSEOB3
 ;check the object class code
 ; the object class code that we store and the object class code
 ; that we send in and get back are NOT necessarily the same.
 ; when the code is going out, a "crosswalk" is done to translate
 ; it to a newer code.  This means that to check the code coming in,
 ; we want to crosswalk it backwards to the old code.
 ;
 ;if the code coming back is not of the right pattern, write
 ;  warning and quit
 I ACHSEOBR("C",9)'?4AN D CHKOCC0 Q
 ;
 ;if the code returned with the EOBR matches the SCC, quit 
 I ACHSEOBR("C",9)=$P(^ACHS(3,DUZ(2),1,$P(ACHSDOCR,U,7),0),U) Q
 ;
 ;or, if the code returned with the EOBR matches the OCC, quit
 N OCC
 S OCC=$P(ACHSDOCR,U,10) I OCC'="" S OCC=$P($G(^ACHSOCC(OCC,0)),U,1) I ACHSEOBR("C",9)=OCC Q
 ;
 ;now do the crosswalk. convert the SCC on file to an OCC, and see
 ;if that OCC matches the code returned with the EOBR
 N %,T
 S OCC=$P(^ACHS(3,DUZ(2),1,$P(ACHSDOCR,U,7),0),U)
 F %=1:1 S T=$P($T(CRSWLK+%),";",3) Q:T="END"  I $P(T,U)=OCC S OCC=$P(T,U,2) Q
 I ACHSEOBR("C",9)'=OCC D CHKOCC0
 Q
 ;
CHKOCC0 ;
 ;mismatch - record warning and go on
 S ACHSERRE=10,ACHSEDAT=ACHSEOBR("C",9) D ^ACHSEOBG
 Q
CRSWLK ;
 ;;2185^2185
 ;;252A^256Q
 ;;252B^256Q
 ;;252H^256Q
 ;;252J^256Q
 ;;252D^256R
 ;;252G^256R
 ;;252L^256R
 ;;252M^256R
 ;;252Q^256R
 ;;252S^256R
 ;;254B^256R
 ;;254D^256R
 ;;254E^256R
 ;;254G^256R
 ;;254J^256R
 ;;254L^256R
 ;;254A^256T
 ;;254C^256T
 ;;252Z^256Z
 ;;252F^256W
 ;;254V^256W
 ;;2611^2611
 ;;263A^263A
 ;;263L^263A
 ;;263G^263G
 ;;263K^263K
 ;;4319^4319
 ;;8116^8116
 ;;END;END
 ;
SENDMSG ;EP from ACHSEOB3
 N X,Y,Z
 K ^TMP("ACHSEOB3")
 F X=1:1 S Y=$P($T(TXT+X),";;",2) Q:Y="###"  S Z="" X:$L($P(Y,";",2)) $P(Y,";",2) S ^TMP("ACHSEOB3",$J,X)=$P(Y,";",1)_Z
 K X,Y,Z
 N XMSUB,XMDUZ,XMTEXT,XMY
 S XMB="ACHS EOBR PROCESSING"
 S XMDUZ="CHS EOBR Automatic Processing",XMSUB="3P Pay on EOBR, no Insurance in Reg."
 S XMTEXT="^TMP(""ACHSEOB3"",$J,"
 S XMY(1)=""
 D ^XMB,KILL^XM
 K ^TMP("ACHSEOB3")
 Q
 ;
TXT ;
 ;;During automatic processing of CHS EOBRs, an EOBR was found
 ;;to have a payment from a Third Party Source, and no insurance
 ;;for the patient was effective for the patient on the DOS, in
 ;;your local Patient Registration files.  Specific info:
 ;;       EOBR Control Number :  ;S Z=ACHSEOBR("A",13)_"-"_ACHSEOBR("A",5)
 ;;     Purchase Order Number :  ;S Z=ACHSEOBR("A",12)
 ;;              Patient Name :  ;S Z=ACHSEOBR("B",8)
 ;;                       HRN :  ;S Z=ACHSEOBR("B",9)
 ;;Amount Paid by Third Party :  $;S Z=$FN($E(ACHSEOBR("D",11),1,7)_"."_$E(ACHSEOBR("D",11),8,9),",",2)
 ;; 
 ;;The current EOBR data does not include the Third Party source.
 ;;If you want that information, contact the Fiscal Intemediary.
 ;;Your area CHS Officer can provide you with contacts at the FI.
 ;;###
 ;
