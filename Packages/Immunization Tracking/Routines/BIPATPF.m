BIPATPF ;IHS/CMI/MWR - VIEW PATIENT PROFILE; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  DISPLAY PATIENT'S IMMUNIZATION IMM/SERVE PROFILE.
 ;
 ;
 ;----------
START ;EP
 ;---> Lookup patients and display their Immunization Profiles.
 ;---> NOT CALLED BY ANY MENU OPTION AT THIS TIME.
 D SETVARS^BIUTL5 N BIDFN
 F  D  Q:$G(BIDFN)<1
 .D TITLE^BIUTL5("PATIENT IMMUNIZATION PROFILE")
 .D PATLKUP^BIUTL8(.BIDFN)
 .Q:$G(BIDFN)<1
 .D EN(BIDFN)
 D EXIT
 Q
 ;
 ;
 ;----------
HAVEPAT(BIDFN,BIFDT,BIDUZ2) ;EP
 ;---> Entry point when patient already known.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIFDT  (opt) Forecast Date (date used for forecast).
 ;     3 - BIDUZ2 (opt) User's DUZ(2) to indicate Immserve Forecasting
 ;                      Rules in Patient History data string.
 ;
 ;---> Check for BIDFN.
 Q:$$DFNCHECK^BIUTL2()
 ;---> If no Forecast Date passed, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 ;---> If no Site passed, set equal to user's site.
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 I '$G(BIDUZ2) D ERRCD^BIUTL2(105,,1) Q
 ;
 D SETVARS^BIUTL5
 K ^BITMP($J),^TMP("BILMPF",$J)
 S ^BITMP($J,1,BIDFN)=""
 D EN(BIDFN,BIFDT,BIDUZ2)
 D EXIT
 Q
 ;
 ;
 ;----------
EN(BIDFN,BIFDT,BIDUZ2) ;EP
 ;---> Main entry point for BI PATIENT PROFILE VIEW.
 I '$G(BIDFN) D EN^DDIOL("No Patient selected.") Q
 S:'$G(BIFDT) BIFDT=DT
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 I '$G(BIDUZ2) D ERRCD^BIUTL2(105,,1) Q
 N DFN S DFN=BIDFN  ;For now with Linda's view reg templates.
 D EN^VALM("BI PATIENT PROFILE VIEW")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code.
 Q:'$D(BIDFN)
 N BICRT,X,Y
 S BICRT=$S(($E($G(IOST))="C")!(IOST["BROWSER"):1,1:0)
 S VALMHDR(1)=""
 S Y=$E($$NAME^BIUTL1(BIDFN),1,25)
 S X=" Patient: "
 S:BICRT X=X_IORVON
 S X=X_Y
 S:BICRT X=X_IOINORM
 S X=X_$$SP^BIUTL5(27-$L(Y))_"DOB: "
 S:BICRT X=X_IORVON
 S X=X_$$DOBF^BIUTL1(BIDFN)
 S:BICRT X=X_IOINORM
 S VALMHDR(2)=X
 S X="  Chart#: "
 S:BICRT X=X_IORVON
 S X=X_$$HRCN^BIUTL1(BIDFN)
 S Y=$E($$INSTTX^BIUTL6($G(DUZ(2))),1,17)
 S X=X_" at "_Y
 S:BICRT X=X_IOINORM
 S X=X_$$SP^BIUTL5(20-$L(Y))_$$ACTIVE^BIUTL1(BIDFN)
 S X=X_"     "_$$SEXW^BIUTL1(BIDFN)
 S VALMHDR(3)=X
 ;
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;
 ;---> If BIDFN not supplied, set Error Code and quit.
 I '$G(BIDFN) D ERRCD^BIUTL2(201,,1) Q
 ;
 ;---> Initialize RPC variables.
 ;     BI31     - Delimiter between return value and return error.
 ;     BIRETVAL - Return value of valid data from RPC.
 ;     BIRETERR - Return value (text string) of error from RPC.
 N BI30,BI31,BIRETVAL,BIRETERR
 S BI30=$C(30),BI31=$C(31)_$C(31),BIRETVAL=""
 ;
 ;---> RPC to gather Immunization History.
 D IMMPROF^BIRPC(.BIRETVAL,BIDFN,$G(BIFDT),$G(BIDUZ2))
 ;
 ;---> Set BIGBL=to global where Immserve Profile is stored
 ;---> (returned from RPC).
 N BIGBL S BIGBL=$P($P(BIRETVAL,BI31,1),")")_","
 ;---> BIGBL is ^BITEMP($J,"PROF",
 ;
 ;---> If error was returned in ^BITEMP($J,"PROF",1),
 ;---> set BIRETERR=error text, display it and quit.
 S BIRETERR=$P(@(BIGBL_1_")"),BI31,2)
 I BIRETERR]"" D  Q
 .D EN^DDIOL("* "_BIRETERR,"","!!?5"),DIRZ^BIUTL3()
 .S VALMQUIT=""
 ;
 ;---> Build Listmanager array from BIGBL global array.
 K ^TMP("BILMPF",$J)
 N BILINE,N S N=0
 F  S N=$O(@(BIGBL_N_")")) Q:'N  D
 .S ^TMP("BILMPF",$J,N,0)="   "_$P(@(BIGBL_N_")"),BI30)
 .S BILINE=N
 ;
 ;---> Overwrite BI31 node and set final VALM line count.
 S ^TMP("BILMPF",$J,BILINE,0)=" "
 S VALMCNT=BILINE
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Use arrow keys to scroll up and down through the report, or"
 W !?5,"type ""??"" for more actions, such as Search and Print List."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> EOJ Cleanup.
 K ^TMP("BILMPF",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
