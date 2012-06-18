ZIBNSSV ; IHS/ADC/GTH - NONSTANDARD SPECIAL VARIABLES ; [ 10/29/2002   7:42 AM ]
 ;;3.0;IHS/VA UTILITIES;**8,9**;FEB 07, 1997
 ; XB*3*8 - IHS/ASDST/GTH - Correct parsing for MSM Windows.
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; Return Non-Standard ($Z) Special Variables.
 ;
 ; E.g.:
 ;           W $$Z^ZIBNSSV("ERROR")
 ; will write the contents of the error message most recently
 ; produced by the OS.
 ;
 ; These are the variables supported:
 ;
 ;    ERROR : Text of error message most recently produced.
 ;    LEVEL : Number of the current nesting level.
 ;     NAME : Name of routine currently loaded in memory.
 ;    ORDER : Data value of the next global node that follows
 ;                the current global reference.
 ;     TRAP : Line label and routine name of the program that
 ;                is to receive control when an error occurs.
 ;  VERSION : Name and release of M implementation.
 ;
Z(NSSV) ;PEP - Return Non-Standard ($Z) Special Variables.
 I '$L($G(NSSV)) Q "NONSTANDARD SPECIAL VAR NOT SPECIFIED."
 I '$F("ERROR^LEVEL^NAME^ORDER^TRAP^VERSION",NSSV) Q "NONSTANDARD SPECIAL VAR '"_NSSV_"' NOT SUPPORTED."
 NEW O
 ; S O=$P($G(^%ZOSF("OS")),"-",1) ; XB*3*8 - IHS/ASDST/GTH
 ;S O=$S($P($G(^%ZOSF("OS")),"^",1)["MSM":"MSM",1:"") ; XB*3*8 - IHS/ASDST/GTH;IHS/SET/GTH XB*3*9 10/29/2002
 S O=$S($P($G(^%ZOSF("OS")),"^",1)["MSM":"MSM",^%ZOSF("OS")["OpenM":"CACHE",1:"") ; XB*3*8 - IHS/ASDST/GTH ;IHS/SET/GTH XB*3*9 10/29/2002
 ;I '$L($T(@(O))) Q "OPERATING SYSTEM '"_O_"' NOT SUPPORTED." ;IHS/SET/GTH XB*3*9 10/29/2002
 I '$L(O) Q "OPERATING SYSTEM '"_^%ZOSF("OS")_"' NOT SUPPORTED." ;IHS/SET/GTH XB*3*9 10/29/2002
 G @(O)
 ;
MSM ; Micronetics specific Non-Standard Special Variables.
 NEW MSMSV
 S MSMSV="MSMZ"_$E(NSSV)
 I '$L($T(@MSMSV)) Q "Micronetics VALUE FOR '"_NSSV_"' NOT SUPPORTED."
 G @(MSMSV)
 ;
MSMZE Q $ZE
MSMZL Q $ZL
MSMZN Q $ZN
MSMZO Q $ZO
MSMZR() ;PEP - MSM's last global reference.
 ;  Going thru the "Z" entry point will re-set the global reference!
 Q $ZR
MSMZT Q $ZT
MSMZV Q $ZV
 ;
 ;Begin New Code;IHS/SET/GTH XB*3*9 10/29/2002
CACHE ;
 NEW %
 S %="CACHEZ"_$E(NSSV)
 I '$L($T(@%)) Q "Cache' VALUE FOR '"_NSSV_"' NOT SUPPORTED."
 G @(%)
 ;
CACHEZE Q $ZE
CACHEZN Q $ZN
CACHEZO Q $ZO
CACHEZT Q $ZT
CACHEZV Q $ZV
 ;End New Code;IHS/SET/GTH XB*3*9 10/29/2002
