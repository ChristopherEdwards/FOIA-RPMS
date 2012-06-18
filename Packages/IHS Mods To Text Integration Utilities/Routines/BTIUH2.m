BTIUH2 ; IHS/ITSC/LJF - MISC HELP TEXT ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
DELHELP ;EP; -- help for deleting garbage filing entries
 ;       called by TIURE,TIUPEVNT
 D MSG("Enter either 'Y' or 'N'",1,0,0)
 D MSG("If the report could not be uploaded because the document",1,0,0)
 D MSG("is not a valid report type, then by answering YES you",1,0,0)
 D MSG("will be deleting this document completely.",1,0,0)
 Q
MSG(DATA,A1,A2,A3) ; -- calls write utility
 D MSG^BTIUU(DATA,A1,A2,A3) Q
