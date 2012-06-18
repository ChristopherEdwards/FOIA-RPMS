APSPMDD ;IHS/DSD/KML/ENM - NDC XREF CREATE IN DRUG FILE  [ 08/25/1999  3:10 PM ]
 ;;6.1;IHS PHARMACY AWP;**1,2**;03/13/98
XREF ;EP
 ; callable subroutine executed by VA FILEMAN trigger when creating the
 ; ZNDC cross-reference for file # 50 
 ; dashes will be removed from the NDC string
 ;Q:'+X ;IHS/DSD/ENM 11/27/98
 S APSPNDC=$TR(X,"-")
 S APSPNDC=$TR(APSPNDC,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz") ;IHS/DSD/ENM 11/27/98
 S X=APSPNDC
 Q
