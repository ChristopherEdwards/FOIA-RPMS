BIXTCH ;IHS/CMI/MWR - XCALL TO TCH FORECASTER; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**9**;OCT 01,2014
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  XCALL TO TCH FOR FORCASTING IMMUNIZATIONS.
 ;;  Called from ^BIPATUP.
 ;;  PATCH 8: New routine to accommodate new TCH Forecaster   RUN+0
 ;;  PATCH 9: Add DUZ2 to retrieve IP address for call to TCH. RUN+0
 ;
SAMPLE ;
 ;---> Sample Cache Device handling code to interact with TCH Java Forecaster.
 ;---> 6708 is the TCH Forecaster default port (can change in the OS command).
 O "|TCP|4":("127.0.0.1":6708::):10
 U "|TCP|4"
 W "Bonjour, Monsier le Monde",!
 U "|TCP|4" R X:1
 C "|TCP|4"
 U 0 W !,X
 Q
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Add DUZ2 so that BIXTCH can retrieve IP address for TCH.
 ;----------
RUN(BIHX,BIDUZ2,BIRPT,BIDATA,BIERR) ;EP
 ;---> Entry point for XCALL to Immserve Forecast Library.
 ;---> Patient's Immunization History is supplied; ImmServe Forecast
 ;---> is returned as text profile (BIRPT) and as data string (BIDATA).
 ;---> Parameters:
 ;     1 - BIHX   (req) String containing Patient's Immunization History.
 ;     2 - BIDUZ2 (req) User's DUZ(2) to indicate IP address for TCH.
 ;     3 - BIRPT  (ret) String returning text version of forcast.
 ;     4 - BIDATA (ret) String returning data version of forcast.
 ;     5 - BIERR  (ret) String returning text of error code.
 ;
 ;---> Quit if Patient IMM Hx not provided.
 I $G(BIHX)="" S (BIRPT,BIDATA,BIERR)=$$ERROR(999) Q
 ;
 ;---> Uncomment to see Patient History sent to TCH Forecaster.
 ;W !,"Full Input String: ",BIHX R ZZZ
 ;
 S BIERR="",BIRPT="",BIDATA=""
 S BIHX=BIHX_$C(10)
 N BIRESULT
 ;
 ;---> SAC Exemption from 2.2.3.3.2
 ;---> Purpose: Cache proprietary call to check/set Immserve directory.
 ;---> SAC Exemption Memo dated Feb 2004.
 S $ZT="ERRTRAP^BIXTCH"
 ;
 ;---> Preserve the current Device to return to after using TCP.
 N BIDEVICE S BIDEVICE=$IO
 ;
 ;---> Open TCP in Streaming Mode (to accommodate greater data length.).
 ;
 ;---> Get IP address for TCH Forecaster.
 I '$G(BIDUZ2) S (BIRPT,BIDATA,BIERR)=$$ERROR(124) Q
 N BIIP S BIIP=$$IPTCH^BIUTL8(BIDUZ2)
 I BIIP="" S (BIRPT,BIDATA,BIERR)=$$ERROR(125) Q
 ;
 ;O "|TCP|4":("127.0.0.1":6708:"S":):3
 O "|TCP|4":(BIIP:6708:"S":):3
 ;**********
 ;
 U "|TCP|4"
 W BIHX,!
 U "|TCP|4" R BIRESULT:1
 C "|TCP|4"
 ;
 ;---> Return to using previous Device.
 U BIDEVICE
 ;
 ;---> For Testing, uncomment next line to see the raw data returned from TCH:
 ;W !,$L(BIRESULT) R ZZZ
 ;W !!!,"Result directly back from forecaster (in BIXTCH): ",!,BIRESULT,!! R ZZZ
 ;
 S BIERR=$P(BIRESULT,"&&&",1)
 I BIERR]"" S (BIRPT,BIDATA,BIERR)=BIERR Q
 ;I BIERR]"" S (BIRPT,BIDATA,BIERR)=$$ERROR^BIXTCH(BIERR) Q
 S BIDATA=$P(BIRESULT,"&&&",2)
 S BIRPT=$P(BIRESULT,"&&&",3)
 S:BIERR=0 BIERR=""
 ;
 Q
 ;
 ;
 ;----------
ERROR(BIERRNUM) ;EP
 ;---> Return text of error, based on number passed.
 ;---> Parameters:
 ;     1 - BIERRNUM (req) Numeric value of error.
 ;
 Q "BIXTCH Error: "_$$ERRMSG(BIERRNUM)
 ;
 ;
 ;----------
ERRMSG(X) ;EP
 ;---> Error messages.
 Q:X=1 "1;Some cases could not be processed."
 Q "99999;Unknown error"
 ;
 ;
 ;----------
ERRTRAP ;EP
 ;---> Error trap for Invalid ImmServe Path.
 ;---> Attempt to open Host File Server.
 ;---> SAC Exemption from 2.4.3.1, 2.4.9.1, 2.4.11.1.
 ;---> Purpose: to address HFS for forecasting without changing
 ;---> the current display/print Device and its IO characteristics.
 ;---> SAC Exemption Memo dated 1 Nov 99.
 ;
 D ERRCD^BIUTL2(123,.BIERR)
 Q
