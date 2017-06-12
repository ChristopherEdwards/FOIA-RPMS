BISITE1 ;IHS/CMI/MWR - EDIT SITE PARAMETERS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**13**;AUG 01,2016
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  INIT FOR EDIT SITE PARAMETERS.
 ;   PATCH 2: Fix display of default Low Supply Alert.  INIT+72
 ;            Provide call to retrieve Site's Low Alert default.  LOTSDEF
 ;;  PATCH 8: Changes to accommodate new TCH Forecaster   INIT+55,+66,+92,+132
 ;;  PATCH 9: Return the IP Address used for the TCH Forecaster.  INIT+139
 ;;           Update display of selected High Risk parameters.  INIT+165
 ;;  PATCH 13: Add Flu Season Date Range parameter. INIT+197
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;---> If BISITE not supplied, set Error Code and quit.
 I '$G(BISITE) D ERRCD^BIUTL2(109,,1) S VALMQUIT="" Q
 I '$D(^BISITE(BISITE,0)) D ERRCD^BIUTL2(110,,1) S VALMQUIT="" Q
 ;
 K ^TMP("BISITE",$J)
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 N BILINE,X,Y S BILINE=0
 ;
 ;---> Default Case Manager.
 D WRITE(.BILINE)
 S X="   1) Default Case Manager.........: "_$$CMGRDEF^BIUTL2(BISITE,1)
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Other Location.
 N BIOTH S BIOTH=$$OTHERLOC^BIUTL6(BISITE),X=""
 D:BIOTH
 .S X=$P(^AUTTLOC(BIOTH,0),U,4)
 .I $G(X) S:$D(^AUTTAREA(X,0)) X=$P(^(0),U)
 .S X=$$INSTTX^BIUTL6(BIOTH)_"   "_X
 S X=$E("   2) Other Location...............: "_X,1,79)
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Standard Immunizations Due Letter.
 S X="   3) Standard Imm Due Letter .....: "_$$DEFLET^BIUTL2(BISITE,1)
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Official Immunization Record.
 S X="   4) Official Imm Record Letter...: "_$$DEFLET^BIUTL2(BISITE,1,1)
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Facility Record/Report Header.
 S X="   5) Facility Report Header.......: "_$$REPHDR^BIUTL6(BISITE)
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Host File Server Path.
 S X="   6) Host File Server Path........: "_$$HFSPATH^BIUTL8(BISITE)
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Minimum Days Last Letter.
 S X=$$MINDAYS^BIUTL2(BISITE)_" day" S:+X'=1 X=X_"s"
 S X="   7) Minimum Days Last Letter.....: "_X
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Forecast Minimum Age vs Recommended Age.
 S X=$$MINAGE^BIUTL2(BISITE)
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Change parameter prompt to just Min vs Rec.
 S X=$S(X=1:"Minimum Acceptable Age",1:"Recommended Age")
 ;**********
 S X="   8) Minimum vs Recommended Age...: "_X
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> ImmServe Forecasting Option.
 D
 .N G,H,Y,Z S Z=$G(^BISITE(BISITE,0))
 .;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 .;---> Change parameter prompt to just Grace Period.
 .;S Y=$P(Z,U,8),G=$P(Z,U,21),H=$P(Z,U,24)
 .;S X="#"_Y_", "_$S(G:"WITH",1:"NO")_" 4-Day Grace"
 .;S X=X_", HPV through "_$S(H=2:26,1:18)
 .S Y=$P($G(^BISITE(BISITE,0)),U,21)
 .S X="4-Day Grace Period "_$S(Y=1:"",1:"NOT ")_"Used"
 S X="   9) 4-Day Grace Period option....: "_X
 ;**********
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Lot Numbers required.
 S X=$S($$LOTREQ^BIUTL2(BISITE):"Required",1:"NOT Required")
 ;
 ;********** PATCH 2, v8.5, MAY 15,2012, IHS/CMI/MWR
 ;---> Fix display of default Low Supply Alert.
 ;S X=X_", Default Low Supply Alert="_$$LOTLOW^BIUTL2(BISITE)
 S X=X_", Default Low Supply Alert="_$$LOTSDEF(BISITE)
 ;**********
 ;
 S X="  10) Lot Number Options...........: "_X
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Pneumo, Flu, Zostervax Site Parameters. v8.5
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Change parameter prompt to just Pneumo.
 D
 .N Y,Z
 .S Y=$$PNMAGE^BIPATUP2(BISITE)
 .;S Y=$P(X,U),Z=$P(X,U,2)
 .;S X=Y_" years old, "_$S(Z:"every 6 years.",1:"one time only.")
 .S X="Begin Pneumo at "_Y_" years"
 .;S Y=$$FLUALL^BIPATUP2(BISITE)
 .;S X=X_$S(Y:"All ages",1:"6m-18y,50y+")
 .;S X=X_"  Zoster: "
 .;S Y=$$ZOSTER^BIPATUP2(BISITE)
 .;S X=X_$S(Y:"Yes",1:"No")
 ;S X="  11) Pneumo, Flu, Zoster Options..: "_X
 S X="  11) Pneumo routine age to begin..: "_X
 ;**********
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Forecasting enabled.
 S X=$S($$FORECAS^BIUTL2(BISITE):"Enabled",1:"Disabled")
 S X="  12) Forecasting (Imms Due).......: "_X
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Include dashes in Chart# display.
 D
 .I $$DASH^BIUTL1(BISITE) S X="Dashes Included (12-34-56)" Q
 .S X="No Dashes (123456)"
 S X="  13) Chart# with dashes...........: "_X
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> User as Default Provider.
 S X=$S($$DEFPROV^BIUTL6(BISITE):"Yes",1:"No")
 S X="  14) User as Default Provider.....: "_X
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> ImmServe Directory.
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Leave parameter place keeper on menu, but disable.
 ;S X=$$IMMSVDIR^BIUTL8(BISITE)
 ;S:($L(X)>39) X=$E(X,1,39)_"..."
 ;S X="  15) ImmServe Directory...........: "_X
 ;**********
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> IP Address for TCH Forecaster.
 S X=$$IPTCH^BIUTL8(BISITE)
 S X="  15) IP Address for TCH Forecaster: "_X
 ;**********
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> GPRA Communities.
 D
 .N BIGPRA D GETGPRA^BISITE4(.BIGPRA,BISITE)
 .I '$O(BIGPRA(0)) S X="No" Q
 .N N S (N,X)=0 F  S N=$O(BIGPRA(N)) Q:'N  S X=X+1
 S X=X_" Communities selected for GPRA."
 S X="  16) GPRA Communities.............: "_X
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Inpatient Check enabled.
 S X=$S($$INPTCHK^BIUTL2(BISITE):"Enabled",1:"Disabled")
 S X="  17) Inpatient Visit Check........: "_X
 D WRITE(.BILINE,X)
 K X
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Update display of selected High Risk parameters.
 ;---> Risk Check enabled.
 N Z S Z=$$RISKP^BIUTL2(BISITE)
 D
 .I 'Z S X="Disabled" Q
 .I Z=1 S X="Enabled: Hep B Only" Q
 .I Z=2 S X="Enabled: Pneumo Only" Q
 .I Z=12 S X="Enabled: Hep B and Pneumo" Q
 .I Z=23 S X="Enabled: Pneumo Only (+Smoking)" Q
 .I Z=123 S X="Enabled: Hep B and Pneumo (+Smoking)" Q
 .S X="ERROR: Unable to determine."
 ;**********
 ;
 S X="  18) High Risk Factor Check.......: "_X
 D WRITE(.BILINE,X)
 K X,Z
 ;
 ;---> CPT-coded Visits enabled.
 S X=$S($$IMPCPT^BIUTL2(BISITE):"Enabled",1:"Disabled")
 S X="  19) Import CPT-coded Visits......: "_X
 D WRITE(.BILINE,X)
 K X
 ;
 ;---> Visit Selection Menu enabled.
 D
 .I $$VISMNU^BIUTL2(BISITE) S X="Enabled (Display Visit Selection Menu)" Q
 .S X="Disabled (Link Visits automatically)"
 S X="  20) Visit Selection Menu.........: "_X
 D WRITE(.BILINE,X)
 K X
 ;
 ;
 ;********** PATCH 13, v8.5, AUG 01,2016, IHS/CMI/MWR
 ;---> Flu Season Date Range.
 S X=$$FLUDATS^BIUTL8(BISITE)
 S X="  21) Flu Season Start & End Dates.: "_$P(X,"%")_" to "_$P(X,"%",2)
 D WRITE(.BILINE,X)
 K X
 ;**********
 ;
 S VALMSG="Scroll down to view more Parameters."
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BISITE",$G(BIVAL),$G(BIBLNK))
 Q
 ;
 ;
 ;********** PATCH 2, v8.5, MAY 15,2012, IHS/CMI/MWR
 ;----------
LOTSDEF(BIDUZ2) ;EP
 ;---> Return Site's Default Low Alert for Lot Numbers.
 ;---> Parameters:
 ;     1 - BIDUZ2 (req) User's DUZ(2)
 ;
 Q:'$D(^BISITE(+$G(BIDUZ2),0)) 50
 Q:($P($G(^BISITE(+$G(BIDUZ2),0)),U,25)="") 50
 Q $P($G(^BISITE(+$G(BIDUZ2),0)),U,25)
 ;**********
