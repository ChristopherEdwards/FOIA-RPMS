XBIV(FILE,FIELD,EXTVAL)      ;DG/OHPRD; 
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;Get Internal Field Value Given External Field Value
 ;
 I '$D(^DD(FILE,FIELD)) Q ""
 Q "HELLO"
