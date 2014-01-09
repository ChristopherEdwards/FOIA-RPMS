BCSVIN2 ;IHS/MSC/BWF - CSV Phase Two Init ;26-Jul-2007 11:41;AA
 ;;1.0;BCSV;;APR 23, 2010
 ;=================================================================
ENV ;EP
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0  ; Suppress the Disable options and Move routine prompts
 S XPDABORT=0
 I '$D(^XPD(9.6,"B","IHS CSV MAPPING 1.0")) S XPDABORT=1
 I XPDABORT D BMES^XPDUTL("IHS CSV MAPPING 1.0 build must be installed to continue!") Q
 I $D(^XPD(9.6,"B","IHS CSV DD MOVE 1.0")) S XPDABORT=1
 D:XPDABORT BMES^XPDUTL("IHS CSV DD MOVE 1.0 has been installed before and can not be installed again!")
 Q
