BIXCALL ;IHS/CMI/MWR - XCALL TO IMMSERVE LIBRARY; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  XCALL TO IMMSERVE LIBRARY FOR FORCASTING IMMUNIZATIONS.
 ;;  Called from ^BIPATUP.
 ;;  PATCH 1: Change Immserve host file names to "02".  RUN+46
 ;
 ;
 ;----------
RUN(BIHX,BIRPT,BIDATA,BIERR) ;EP
 ;---> Entry point for XCALL to Immserve Forecast Library.
 ;---> Patient's Immunization History is supplied; ImmServe Forecast
 ;---> is returned as text profile (BIRPT) and as data string (BIDATA).
 ;---> Parameters:
 ;     1 - BIHX   (req) String containing Patient's Immunization History.
 ;     2 - BIRPT  (ret) String returning text version of forcast.
 ;     3 - BIDATA (ret) String returning data version of forcast.
 ;     4 - BIERR  (ret) String returning text of error code.
 ;
 ;---> Quit if Patient IMM Hx not provided.
 I $G(BIHX)="" S (BIRPT,BIDATA,BIERR)=$$ERROR(999) Q
 ;
 ;---> Uncomment to see Patient History sent to ImmServe.
 ;W !,"BIHX: ",BIHX R ZZZ
 ;
 S BIERR="",BIRPT="",BIDATA=""
 S BIHX=BIHX_$C(10)
 ;
 ;---> BIDLLPROG is special variable--stored locally, not passed--for speed.
 I $G(BIDLLPROG)="" D
 .S:'$D(BISITE) BISITE=+$G(DUZ(2))
 .N BIDLLPATH
 .S BIDLLPATH=$$IMMSVDIR^BIUTL8(BISITE)
 .I $G(BIDLLPATH)="" S BIERR=119 Q
 .;
 .;---> SAC Exemption from 2.2.3.3.2
 .;---> Purpose: Cache proprietary call to check/set Immserve directory.
 .;---> SAC Exemption Memo dated Feb 2004.
 .S $ZT="ERRTRAP^BIXCALL"
 .I $ZU(168,BIDLLPATH)
 .I $G(BIERR)]"" Q
 .;
 .;---> Set ImmServe Program call.
 .;W !!,"BUILDING CALL" R ZZZ  ;Uncomment for testing.
 .;
 .;---> Patch to flag whether system is 32-bit or 64-bit.
 .D
 ..N Y,BIT S Y=$$VERSION^%ZOSV(1)
 ..;
 ..;---> SAC Exemption from 2.2.6.2.3
 ..;---> This command from Intersystems is necessary to determine whether
 ..;---> the operating system is 32-bit or 64-bit. (Request made to VA
 ..;---> for future %ZOSV call.)  Returns 4 for 32-bit and 8 for 64-bit.
 ..S BIT=$ZU(40,0,4)
 ..;
 ..;********** VERSION 8.4, v8.4, APR 15,2010, IHS/CMI/MWR
 ..;---> Change to "02" for new Immserve, e.g., biwin3202 instead of biwin3201.
 ..;---> Change to "04" for new Immserve, e.g., biwin3204 instead of biwin3202.
 ..;********** VERSION 8.5, JUL 01,2011, IHS/CMI/MWR
 ..;---> Change to "05" for new Immserve, e.g., biwin3205 instead of biwin3204.
 ..;
 ..I ((Y["Windows")&(BIT=8)) S BIDLLPROG="biwin6405.dll" Q
 ..I Y["Windows" S BIDLLPROG="biwin3205.dll" Q
 ..I ((Y["Linux")&(BIT=8)) S BIDLLPROG="bilin6405.so" Q
 ..I Y["Linux" S BIDLLPROG="bilin3205.so" Q
 ..I ((Y["Solaris")&(BIT=8)) S BIDLLPROG="bisol6405.so" Q
 ..I ((Y["UNIX")&(BIT=8)) S BIDLLPROG="biaix6405.so" Q
 ..I Y["UNIX" S BIDLLPROG="biaix3205.so" Q
 ..;---> NEXT LINE: Good for calling a new version conditional upon Immserve path.
 ..;I ((Y["UNIX")&(BIT=8)) S BIDLLPROG="biaix6403.so" S:BIDLLPATH["84a" BIDLLPROG="biaix6404.so" Q
 ..;**********
 ..;
 ..I $G(BIDLLPROG)="" S BIERR=120 Q
 .;---> Now prepend the path.
 .S BIDLLPROG=BIDLLPATH_BIDLLPROG
 I $G(BIERR)]"" Q
 ;
 ;---> SAC Exemption from 2.2.3.3.2
 ;---> Purpose: To trap error during Cache proprietary call to Immserve library.
 ;---> SAC Exemption Memo dated Feb 2004.
 S $ZT="ERRTRAP1^BIXCALL"
 ;
 ;---> Load the DLL if it is not already in the partition.
 I '$G(BIDLLID)!('$G(BIDLLRUN)) D LOAD(BIDLLPROG,.BIDLLID,.BIDLLRUN,.BIERR)
 I BIERR S (BIRPT,BIDATA,BIERR)=$$ERROR^BIXCALL(BIERR) Q
 ;
 S BIHX=BIHX_$C(10)
 ;
 ;---> SAC Exemption from 2.2.6.2.3
 ;---> Purpose: Cache proprietary call to Immserve commercial forecasting
 ;---> software.  This applies to all $ZF calls in this routine.
 ;---> SAC Exemption Memo dated Feb 2004.
 ;---> Dimitri Fane's ZF call to Fred Sayward's library.
 S BIRESULT=$ZF(-5,BIDLLID,BIDLLRUN,"",BIHX,"",8192,"",8192)
 ;
 ;---> For Testing, uncomment next line to see the raw data returned
 ;---> from ImmServe:
 ;W !!!,BIRESULT R ZZZ
 ;
 S BIERR=$P(BIRESULT,"&&&,",1)
 I BIERR S (BIRPT,BIDATA,BIERR)=$$ERROR^BIXCALL(BIERR) Q
 S BIDATA=$P(BIRESULT,"&&&,",2)
 S BIRPT=$P(BIRESULT,"&&&,",3)
 S:BIERR=0 BIERR=""
 ;
 ;N X,Y
 ;S X=$P(BIDATA,"Female"),Y=$P(BIDATA,"Female",2)
 ;S BIDATA=X_"Female^"_Y
 ;
 Q
 ;
 ;
 ;----------
LOAD(BIDLLPROG,BIDLLID,BIDLLRUN,BIERR) ;EP
 ;W !,"LOADING..." R ZZZ  ;Uncomment for testing.
 ;---> Cache Load and initialize Immserve Forecast Library.
 ;---> This load may be run repeatedly in the same partition, however
 ;---> for the sake of performance it should only be called the
 ;---> first time.  Test for BIDLLID and BIDLLRUN determines whether
 ;---> this gets called or not.
 ;---> Parameters:
 ;     1 - BIDLLPROG (req) Path and name of ImmServe Program call.
 ;     2 - BIDLLID   (ret) Index number to the DLL.
 ;     3 - BIDLLRUN  (ret) Index number to the RUN function of the DLL.
 ;     4 - BIERR     (ret) Error code if DLL not loaded successfully.
 ;
 ;---> $ZF(-4,1,path) loads a DLL and returns the index number to the DLL.
 S BIDLLID=$ZF(-4,1,BIDLLPROG)
 I '$G(BIDLLID) S BIERR=997 Q
 ;
 ;---> $ZF(-4,3,BIDLLID,function) returns the index number of the function
 ;---> in the DLL described by BIDLLID.
 ;---> Next line: IMM_IHS (load and run in one call) not used.
 ;S BIDLLRUN=$ZF(-4,3,BIDLLID,"IMM_ASCII")
 N BILOAD
 S BILOAD=$ZF(-4,3,BIDLLID,"IMM_ASCII_LOAD")
 S BIDLLRUN=$ZF(-4,3,BIDLLID,"IMM_ASCII_RUN")
 I '$G(BIDLLRUN) S BIERR=996 Q
 S BIERR=$P($ZF(-5,BIDLLID,BILOAD,""),"&&&")
 Q
 ;
 ;
 ;----------
ERROR(BIERRNUM) ;EP
 ;---> Return text of error, based on number passed.
 ;---> Parameters:
 ;     1 - BIERRNUM (req) Numeric value of error.
 ;
 Q "BICALL Error: "_$$ERRMSG(BIERRNUM)
 ;
 ;
 ;----------
ERRMSG(X) ;EP
 ;---> Error messages.
 Q:X=1 "1;Some cases could not be processed."
 Q:X=-1 "-1;Cannot find, open, load the Versions/Variants file."
 Q:X=-2 "-2;Cannot find, open, load Imm/Def table file."
 Q:X=-3 "-3;Cannot find, open, load Screening table file."
 Q:X=-4 "-4;Cannot find, open, load Live Vaccine Table file."
 Q:X=-5 "-5;Cannot find, open, load Facts defining constants file."
 Q:X=-6 "-6;Cannot find, open, load VFC eligibility file."
 Q:X=-7 "-7;Cannot find, open, load Knowledge Base file."
 Q:X=-8 "-8;Cannot initialize time tables."
 Q:X=-9 "-9;Cannot initialize timeline."
 Q:X=-10 "-10;Input carot string is empty."
 Q:X=-11 "-11;Input case not terminated with new line."
 Q:X=-12 "-12;Cannot convert a carot notation input case."
 Q:X=-13 "-13;Cannot initialize global data structures."
 Q:X=-14 "-14;Internal report writer buffer overflow."
 Q:X=-15 "-15;Internal report writer fatal error."
 Q:X=-16 "-16;Interface report buffer overflow."
 Q:X=-17 "-17;Cannot convert to carot notation output."
 Q:X=-18 "-18;Interface output buffer overflow."
 Q:X=-19 "-19;Fatal runtime error."
 Q:X=-99 "-99;Immserve not loaded into memory.  D LOAD^BIXCALL."
 Q:X=100 "100;Report Buffer must be at least 80."
 Q:X=200 "200;Data Buffer must be at least 80."
 Q:X=101 "101;Report buffer too small for report."
 Q:X=201 "201;Data buffer too small for data."
 Q:X=996 "996;Failure to obtain Immserve DLL RUN number."
 Q:X=997 "997;Failure to obtain Immserve DLL ID number."
 Q:X=998 "998;Immserve path not provided."
 Q:X=999 "999;Patient Immunization History data not provided."
 Q:X=9999 "9999;XCALL Failure (Immserve file not loaded)."
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
 D ERRCD^BIUTL2(118,.BIERR)
 Q
 ;
 ;
 ;----------
ERRTRAP1 ;EP
 ;---> Error trap for Invalid ImmServe library call.
 D ERRCD^BIUTL2(122,.BIERR)
 Q
