BCSVIN ;IHS/MSC/BWF - CSV Phase One Init ;28-Jul-2008 12:55;AA
 ;;1.0;BCSV;;APR 23, 2010
 ;=================================================================
ENV ;EP
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0  ; Suppress the Disable options and Move routine prompts
 S XPDABORT=0
 S XPDABORT='$D(^XCSV("DIC|81.3"))
 I XPDABORT D BMES^XPDUTL("IHS CSV XCSV GLOBAL 1.0 build MUST be installed to continue!") Q
 I $D(^XPD(9.6,"B","IHS CSV MAPPING 1.0")) S XPDABORT=1
 D:XPDABORT BMES^XPDUTL("IHS CSV MAPPING 1.0 has been installed before and can not be installed again!")
 D CPTMOD
 Q
CPTMOD ; Clean up the -1 entries in ^AUTTCMOD
 N LOOP,QUIT
 S QUIT=0
 S LOOP="B" F  S LOOP=$O(^AUTTCMOD(LOOP),-1) Q:LOOP=""!(LOOP'["-")!(QUIT)  D
 .I LOOP'["-" S QUIT=1 Q
 .K ^AUTTCMOD(LOOP)
 Q
 ;
POST ;EP
 D POST^BCSVMP
 Q
